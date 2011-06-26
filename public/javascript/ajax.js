function createXMLHttpRequest() {
  try { return new XMLHttpRequest(); } catch(e) {}
  try { return new ActiveXObject("Msxml2.XMLHTTP"); } catch (e) {}
  return null;
}

function imageChange(_present) {
  //alert("Hallo");
  document.getElementById('state').innerHTML='search new image...';
  xmlhttp=createXMLHttpRequest();
  xmlhttp.onreadystatechange=function() {
	document.getElementById('state').innerHTML="State "+xmlhttp.readyState+" / status "+xmlhttp.status+" / "+xmlhttp.responseText;
    if (xmlhttp.readyState==4 && xmlhttp.status==200) {
      document.getElementById('present').innerHTML="<img src='"+xmlhttp.responseText+"' />";
      document.getElementById('state').innerHTML='Image Set';
      setTimeout("imageChange('"+_present+"')", 2000);
    }
    else if (xmlhttp.readyState==4 && xmlhttp.status==0) {
	  document.getElementById('state').innerHTML='Error to load';
	  setTimeout("imageChange('"+_present+"')", 5000);
	}
  }
  xmlhttp.open("GET","/active/"+_present,true);
  xmlhttp.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
  xmlhttp.send("ACTIVATE");
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
