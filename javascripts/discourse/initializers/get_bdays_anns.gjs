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

// Use fetch for simplicity

// Grab anniversaries
fetch("/cakeday/anniversaries/today.json")
    .then((response) => response.json())
    .then((json) => RunCheckAnn(json));
    
function RunCheckAnn(resp) {
    numberOfAnns = resp['total_rows_anniversaires']
    allAnns = resp['anniversaries'] // Is a list of dicts
    allAnnsUsernames = []
    for (AnnUserdata in allAnns) {
        allAnnsUsernames.push(allAnns[AnnUserdata]['username'])
    }
    console.log(allAnnsUsernames);
}
