import Component from "@glimmer/component";
import { apiInitializer } from "discourse/lib/api";
import { htmlSafe } from "@ember/template";

// Either works (fetch/XML)

/*
const xhr = new XMLHttpRequest();
xhr.open("GET", "/cakeday/anniversaries/today.json");
xhr.send();
xhr.responseType = "json";
xhr.onload = () => {
  if (xhr.readyState == 4 && xhr.status == 200) {
    resp = xhr.response;
    numberOfBdays = resp['total_rows_birthdays']
    allBdays = resp['anniversaries'] // Is a list of dicts
    console.log(allBdays);
    allBdaysUsernames = []
    for (bdayUserdata in allBdays) {
        allBdaysUsernames.push(allBdays[bdayUserdata]['username'])
    }
  }
};
*/

export default apiInitializer("1.14.0", (api) => {
    const banner_location = settings.banner_location
    api.renderInOutlet(
        'before-main-container',
        class bdaysAnnsBanner extends Component {
            get getAnns() {
                // Grab anniversaries
                fetch("/cakeday/anniversaries/today.json")
                    .then((response) => response.json())
                    .then((json) => RunCheckAnns(json));
                  
                function RunCheckAnns(resp) {
                    let numberOfAnns = resp['total_rows_anniversaires'];
                    let allAnns = resp['anniversaries']; // Is a list of dicts
                    let allAnnsUsernames = [];
                    for (var annUserdata in allAnns) {
                        allAnnsUsernames.push(allAnns[annUserdata]['username']);
                    }
                    return {'num_anns': numberOfAnns, 'anns_users': allAnnsUsernames};
                }
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
                        allBdaysUsernames.push(allBdays[bdayUserdata]['username'])
                    }
                    return {'num_bdays': numberOfBdays, 'bdays_users': allBdaysUsernames};
                }
            }


            <template>
                <div class='bd-anns-banner'>
                    <div class='birthdays'>
      <p>{{this.getBdays}}</p>
                        <!--<p>
                            {{this.getBdays[0]}} users celebrated their birthdays today.
                            <br>
                            {{#each this.getBdays[1]}}
                                <a class='mention'>{{this}}</a>
                            {{/each}}
                        </p>-->
                    </div>
                     <div class='anniversaries'>
                        <!--<p>
                            {{this.getAnns[0]}} users celebrated their anniversaries today.
                            <br/>
                            {{#each this.getAnns[1]}}
                                <a class='mention'>{{this}}</a>
                            {{/each}}
                        </p>-->
                    </div>
                </div>
            </template>

        }
    );
});
