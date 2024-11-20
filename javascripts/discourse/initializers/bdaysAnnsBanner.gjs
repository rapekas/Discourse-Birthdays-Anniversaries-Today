import Component from "@glimmer/component";
import { apiInitializer } from "discourse/lib/api";
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { inject as service } from "@ember/service";
import { defaultHomepage } from "discourse/lib/utilities";


/*
const xhr = new XMLHttpRequest();
xhr.open("GET", "/cakeday/anniversaries/today.json");
xhr.send();
xhr.responseType = "json";
xhr.onload = () => {
    if (xhr.readyState == 4 && xhr.status == 200) {
        let resp = xhr.response;
        let numberOfAnns = resp['total_rows_anniversaires'];
        let allAnns = resp['anniversaries']; // Is a list of dicts
        console.log(allAnns);
        let allAnnsUsernames = [];
        for (var annUserdata in allAnns) {
            console.log(allAnns[annUserdata]['username']);
            allAnnsUsernames.push(allAnns[annUserdata]['username']);
        }
        var annsOfData = {'num_anns': numberOfAnns, 'anns_users': allAnnsUsernames};
        
    }
};
return annsOfData;
*/


// Either works (fetch/XML)
async function getAnnsFetch() {
    // Declare annsDataFinal here
    let annsDataFinal;

    // Fetch anniversaries data
    const response = await fetch("/cakeday/anniversaries/today.json");
    const json = await response.json();

    // Run the logic to process the data
    let numberOfAnns = parseInt(json['total_rows_anniversaries']);
    let allAnns = json['anniversaries']; // Is a list of dicts
    let allAnnsUsernames = [];

    for (let annUserdata of allAnns) {
        allAnnsUsernames.push(annUserdata['username']);
    }

    annsDataFinal = {'num_anns': numberOfAnns, 'anns_users': allAnnsUsernames};
    //console.log(annsDataFinal);  // Just to verify the result

    return annsDataFinal; // Now return the data
}





export default apiInitializer("1.14.0", (api) => {
    //const banner_location = settings.banner_location
    api.renderInOutlet(
        'above-main-container',
        class BdaysAnnsBanner extends Component {
            @tracked annsDataFinal = null;
            @service router;

            constructor() {
                super(...arguments);
                this.fetchAnnsData(); // Automatically fetch on initialization
            }
        
            // Asynchronously fetch the data and update tracked property
            @action
            async fetchAnnsData() {
                const response = await fetch("/cakeday/anniversaries/today.json");
                const json = await response.json();
        
                let numberOfAnns = parseInt(json['total_rows_anniversaries']);
                let allAnns = json['anniversaries']; // Is a list of dicts
                let allAnnsUsernames = [];
        
                for (let annUserdata of allAnns) {
                    allAnnsUsernames.push(annUserdata['username']);
                }
        
                this.annsDataFinal = {'num_anns': numberOfAnns, 'anns_users': allAnnsUsernames};
            }
        
            // Getter for the data
            get annsData() {
                // If the data is not loaded yet, return null or any default value
                return this.annsDataFinal;
            }
        
            get getBdays() {
               fetch("/cakeday/birthdays/today.json")
                   .then((response) => response.json())
                   .then((json) => RunCheckBdays(json));
                
                function RunCheckBdays(resp) {
                    let numberOfBdays = resp['total_rows_birthdays'];
                    let allBdays = resp['birthdays']; // Is a list of dicts
                    let allBdaysUsernames = [];
                    for (var bdayUserdata in allBdays) {
                        allBdaysUsernames.push(bdayUserdata['username'])
                    }
                    console.log({'num_bdays': numberOfBdays, 'bdays_users': allBdaysUsernames});
                    return {'num_bdays': numberOfBdays, 'bdays_users': allBdaysUsernames};
                }
            }

            get isHomepage() {
                const { currentRouteName } = this.router;
                return currentRouteName === `discovery.${defaultHomepage()}`;
            }

            <template>
                {{#if this.isHomepage}}
                    <div class='bdaysannsbanner' id='bdaysannsbanner'>
                        {{#if this.annsData}}
                          <p>{{this.annsData.num_anns}} users celebrating their anniversary!</p>
                          <!-- Display the anniversaries data -->
                            {{#each this.annsData.anns_users as |username|}}
                                <span><a class='mention'>{{username}}</a></span>
                            {{/each}}
                        {{else}}
                          <p>No one has their anniversary today!</p>
                        {{/if}}
                    </div>
                {{/if}}
            </template>

        }
    );
});
