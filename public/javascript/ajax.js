<script>
function createXMLHttpRequest() {
try { return new XMLHttpRequest(); } catch(e) {}
try { return new ActiveXObject("Msxml2.XMLHTTP"); } catch (e) {}
return null;
}
function mobileToken() {
document.getElementById('mobile_token').innerHTML='Mobile Token wird angefordert...';
xmlhttp=createXMLHttpRequest();
xmlhttp.onreadystatechange=function() {
if (xmlhttp.readyState==4 && xmlhttp.status==200) {
document.getElementById('mobile_token').innerHTML=xmlhttp.responseText;
}
}
user=document.forms[0].USER_ID.value;
pwd=encodeURIComponent(document.forms[0].PASSWORD.value);
xmlhttp.open("POST","request_mobile_token.html",true);
xmlhttp.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
xmlhttp.send("USER_ID="+user+"&PASSWORD="+pwd);
document.forms[0].TOKEN.focus();
}
</script>
