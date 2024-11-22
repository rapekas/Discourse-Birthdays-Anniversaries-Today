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

// For anns
/*
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

// For bdays
async function getBdaysFetch() {
    // Declare bdaysDataFinal here
    let bdaysDataFinal;

    // Fetch birthdays data
    const response = await fetch("/cakeday/birthdays/today.json");
    const json = await response.json();

    // Run the logic to process the data
    let numberOfBdays = parseInt(json['total_rows_birthdays']);
    let allBdays = json['birthdays']; // Is a list of dicts
    let allBdaysUsernames = [];

    for (let bdayUserdata of allBdays) {
        allBdaysUsernames.push(bdayUserdata['username']);
    }

    bdaysDataFinal = {'num_bdays': numberOfBdays, 'bdays_users': allBdaysUsernames};
    //console.log(annsDataFinal);  // Just to verify the result

    return bdaysDataFinal; // Now return the data
}
*/




export default apiInitializer("1.14.0", (api) => {
    //const banner_location = settings.banner_location
    api.renderInOutlet(
        settings.banner_location,
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

            // Asynchronously fetch the data and update tracked property
            @action
            async fetchBdaysData() {
                 // Declare bdaysDataFinal here
                let bdaysDataFinal;
            
                // Fetch birthdays data
                const response = await fetch("/cakeday/birthdays/today.json");
                const json = await response.json();
            
                // Run the logic to process the data
                let numberOfBdays = parseInt(json['total_rows_birthdays']);
                let allBdays = json['birthdays']; // Is a list of dicts
                let allBdaysUsernames = [];
            
                for (let bdayUserdata of allBdays) {
                    allBdaysUsernames.push(bdayUserdata['username']);
                }
            
                this.bdaysDataFinal = {'num_bdays': numberOfBdays, 'bdays_users': allBdaysUsernames};
                //console.log(annsDataFinal);  // Just to verify the result
            }


            
            // Getter for the data
            get annsData() {
                // If the data is not loaded yet, return null or any default value
                return this.annsDataFinal;
            }
        
            get bdaysData() {
               return this.bdaysDataFinal;
            }

            get isHomepage() {
                const { currentRouteName } = this.router;
                return currentRouteName === `discovery.${defaultHomepage()}`;
            }
/*
            get isAnnsFull() {
                if (annsData.num_users == 0) {
                    if (settings.hide_unused_data) {
                        return false;
                    else {
                        return true;
                    }
                } else {
                    return true;
                }
            }

            get isBdaysFull() {
                if (bdaysData.num_users == 0) {
                    if (settings.hide_unused_data) {
                        return false;
                    else {
                        return true;
                    }
                } else {
                    return true;
                }
            }
*/
            <template>
                    {{#if this.isHomepage}}
                        <div class='bdaysannsbanner' id='bdaysannsbanner'>
                            
                                <div class='anns'>
                                    {{#if this.annsData}}
                                        <p>{{this.annsData.keys()}}</p>
                                        <p>{{this.annsData.num_anns}} users are celebrating their anniversary!</p>
                                        <!-- Display the anniversaries data -->
                                        {{#each this.annsData.anns_users as |username|}}
                                            <span><a class='mention'>{{username}}</a></span>
                                        {{/each}}
                                    {{else}}
                                        <p>No one has their anniversary today!</p>
                                    {{/if}}
                                </div>
                                
                                <div class='bdays'>
                                    {{#if this.bdaysData}}
                                        <p>{{this.bdaysData.num_anns}} users are celebrating their birthday!</p>
                                        <!-- Display the birthday data -->
                                        {{#each this.bdaysData.bdays_users as |username|}}
                                            <span><a class='mention'>{{username}}</a></span>
                                        {{/each}}
                                    {{else}}
                                        
                                        <p>No one has their birthday today!</p>
                                    {{/if}}
                                </div>
                        </div>
                    {{/if}}
            </template>

        }
    );
});
