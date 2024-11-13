/*
// Either works

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

fetch("/cakeday/anniversaries/today.json")
    .then((response) => response.json())
    .then((json) => RunCheck(json));
    
function RunCheck(resp) {
    numberOfBdays = resp['total_rows_birthdays']
    allBdays = resp['anniversaries'] // Is a list of dicts
    allBdaysUsernames = []
    for (bdayUserdata in allBdays) {
        allBdaysUsernames.push(allBdays[bdayUserdata]['username'])
    }
    console.log(allBdaysUsernames);
}
