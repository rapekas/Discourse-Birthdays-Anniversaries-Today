import Component from "@glimmer/component";
import { apiInitializer } from "discourse/lib/api";


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
        class bdaysAnnsBanner extends Component {
            get getAnns() {
                const annsData = await getAnnsFetch();
                console.log(annsData);
                return annsData;
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


            <template>
<p>Hi</p>
                      <p>{{this.getAnns.anns_users}}</p>
            </template>

        }
    );
});
