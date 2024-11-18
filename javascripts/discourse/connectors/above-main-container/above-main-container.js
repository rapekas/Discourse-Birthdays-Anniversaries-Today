import Component from "@glimmer/component";

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

export default class bdaysAnnsBanner extends Component {
      get getAnns() {
          // Grab anniversaries
          fetch("/cakeday/anniversaries/today.json")
              .then((response) => response.json())
              .then((json) => RunCheckAnns(json));
            
          function RunCheckAnns(resp) {
              let numberOfAnns = resp['total_rows_anniversaires'];
              let allAnns = resp['anniversaries']; // Is a list of dicts
              let allAnnsUsernames = [];
              for (vat annUserdata in allAnns) {
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
}
