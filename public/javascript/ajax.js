function createXMLHttpRequest() {
  try { return new XMLHttpRequest(); } catch(e) {}
  try { return new ActiveXObject("Msxml2.XMLHTTP"); } catch (e) {}
  return null;
}

function imageChange(_present) {
  document.getElementById('state').innerHTML='search new image...';
  xmlhttp=createXMLHttpRequest();
  xmlhttp.onreadystatechange=function() {
    if (xmlhttp.readyState==4 && xmlhttp.status==200) {
      document.getElementById('present').src=xmlhttp.responseText;
    }
  }
  xmlhttp.open("GET","/active/"+_present,true);
  xmlhttp.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
  xmlhttp.send("AKTIVATE");
  setTimeout(imageChange(_present), 10);
  document.getElementById('state').innerHTML='waitung...';
}

function activatePresent(_present) {
  document.getElementById('present').innerHTML=_present+' wird aktiviert...';
  xmlhttp=createXMLHttpRequest();
  xmlhttp.onreadystatechange=function() {
    if (xmlhttp.readyState==4 && xmlhttp.status==200) {
      document.getElementById('present').innerHTML=xmlhttp.responseText;
    }
  }
  xmlhttp.open("POST",_present,true);
  xmlhttp.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
  xmlhttp.send("ACTIVATE");
}
