import Component from "@glimmer/component";
import { apiInitializer } from "discourse/lib/api";


// Either works (fetch/XML)
/*
// Grab anniversaries
fetch("/cakeday/anniversaries/today.json")
    .then((response) => response.json())
    .then((json) => RunCheckAnns(json));

function RunCheckAnns(resp) {
    let numberOfAnns = resp['total_rows_anniversaires'];
    let allAnns = resp['anniversaries']; // Is a list of dicts
    console.log(allAnns);
    let allAnnsUsernames = [];
    for (var annUserdata in allAnns) {
        console.log(allAnns[annUserdata]['username']);
        allAnnsUsernames.push(allAnns[annUserdata]['username']);
    }
    var annsOfData = {'num_anns': numberOfAnns, 'anns_users': allAnnsUsernames};
    return annsOfData;
}
*/




export default apiInitializer("1.14.0", (api) => {
    //const banner_location = settings.banner_location
    api.renderInOutlet(
        'above-main-container',
        class bdaysAnnsBanner extends Component {
            get getAnns() {
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
