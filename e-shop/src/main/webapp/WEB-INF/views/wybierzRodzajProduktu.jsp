<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="sf"%>
<%@ page contentType="text/html;charset=UTF-8" %> 
<%@ page session="true"%>
<html>
<head>
<meta name="description" content="Portal aukcyjny" />
	<meta name="keywords" content="aukcja, kupic, sprzedac, licytacja, portal" />
	<meta name="author" content="Cebul, Jez" />
	<meta content="pl" http-equiv="Content-Language">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>e-shop</title>
<link href="${pageContext.request.contextPath}/resources/css/index.css" type="text/css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/reg.css" type="text/css" rel="stylesheet">
<script src="<c:url value='/resources/js/jquery.js' />" type="text/javascript" ></script>
<script src="<c:url value='/resources/js/mainJs.js' />" type="text/javascript" ></script>
<script>
function month()
{
var m = $("#miesiac").val();
var r = $("#rok").val();
var d = $("#dzien");
var str = "";
str = "<option value='null'>dzień:</option>";
if(m != 2 && (m % 2 == 0))
{
for(var i=1; i<=31; i++)
{
str += "<option value='"+i+"'> "+i+"</option>";
}
d.html(str);
}else if(m ==2 && (r % 4 == 0)){
for(var i=1; i<=29; i++)
{
str += "<option value='"+i+"'> "+i+"</option>";
}
d.html(str);
}else if(m ==2){
for(var i=1; i<=28; i++)
{
str += "<option value='"+i+"'> "+i+"</option>";
}
d.html(str);
}else if(m % 2 == 1){
for(var i=1; i<=30; i++)
{
str += "<option value='"+i+"'> "+i+"</option>";
}
d.html(str);
}
} 

function doAjaxPost() 
{
   //alert("sakdjlajla");
	// get the form values
    var username = $('#login').val();
    $.ajax({
	    type: "POST",
		    url: "/jez/register/ajax.do",
		    data: "username=" + username,
		    success: function(response)
		    {
		    	if(response != "")
		    	{
		    		$("#login_error").text("Taki użytkownik juz istnieje!");
		    	}else{
		    		$("#login_error").text("");
		    	}
				
	    	}
    });
}
</script>
</head>
<body>
<div id='contener'>
		<div id='top'>
			<div id="top-left">
				<ul type="square" style="margin-top: 25px; font: 700 12px/22px 'Lato',Arial,sans-serif; list-style-image: url(<c:url value='/resources/images/punktor.jpg' />)">
			        <li>Atrakcyjny ceny</li>
			        <li>Szeroki asortyment</li>
			        <li>Zakupy z Nami to przyjemność</li>
			    </ul>
			</div>
			
			<div id="top-mid">
				<div id='imgCont' align="center">
					<a href="<c:url value='/' />" style="border: none;">
						<img  style='height: 80px;' src="<c:url value='/resources/images/logo.jpg' />">
					</a>
				</div>
			</div>
			
			<div id="top-right">
				<div>
					<c:choose>
						<c:when test="${!empty sessionScope.sessionUser}">
							  	<span style='display: block; margin-top: 20px; margin-left: 120px;'>Witaj: <span style='color: red; font-size: 18px;'>${sessionScope.sessionUser.getLogin()}</span></span>
							  	<a href="/jez/j_spring_security_logout"> wyloguj</a>
						</c:when>
	  					<c:otherwise>
	  							<a style='margin-top: 40px;' href='/jez/logowanie'>Zaloguj</a>
								<a href='/jez/rejestracja'>Rejestracja</a>
	  					</c:otherwise>
  					</c:choose>
					
				</div>
			</div>
		</div>
		<div id='searchDiv'>
			
				<table>
					<tr>
						<form action="${pageContext.request.contextPath}/szukaj/szukajProd/" method="get">
							<td>
								<input id='szukanaFraza' name="szukanaFraza" type="text" autocomplete="off" style="padding: 2px; padding-left: 8px;height: 35px; width: 400px; margin-left: 10px; margin-top: 5px;"  value="Wpisz czego szuaksz..." onblur="ukryjPodpowiedzi();" onkeyup="sprawdzSlowo();" onfocus="searchFocus();" >	
							</td>
							<td>
								<select name='szukanaKat' id='szukanaKat' style="height: 35px; width: 160px; margin-top: 5px; background-color: #EDEDED;">
									<option value="0">WSZĘDZIE
									</option>
									<c:forEach items="${kategoryList}" var="element"> 
										<option value="${element.id}">
											${element.nazwa}
										</option>
										
									</c:forEach>
								</select>	
							</td>
							
							<td>
								<input type="submit" value="Szukaj" style="height: 35px; width: 100px; margin-top: 5px; background-image: linear-gradient(#6E6E6E 0%, #343434 100%); color: white;">	
							</td>
						</form>
						<td>
							<div style="border-left: 1px solid black; padding-left: 10px;">
								<a href="<c:url value='/mojekonto/' />" style="font-weight:bold; font-size: 16px;;text-decoration: none; border: none; color: black;">MOJE KONTO</a>
							</div>
						</td>
						<td>
							<div style="border-left: 1px solid black; padding-left: 10px; ">
								<a href="<c:url value='/koszyk/' />" style="font-weight:bold; font-size: 16px;;text-decoration: none; border: none; color: black;">KOSZYK</a>
							</div>
						</td>
						
					</tr>
				</table>
			
		</div>
		<div id='main'>
		<div id='main-left'>
				<a class="categorieLeft" href="<c:url value='/mojekonto/dodajProdukt' />">Dodaj Produkt</a>
				<a class="categorieLeft" href="<c:url value='/mojekonto/wystawioneProdukty' />">Wystawione Produkty</a>
				<a class="categorieLeft" href="<c:url value='/mojekonto/sprzedaneProdukty' />">Sprzedane Produkty</a>
				<a class="categorieLeft" href="<c:url value='/mojekonto/modyfikujKonto' />">Modyfikuj kontot</a>
								
		</div>
		<div id='main-right' align='center'>
		<p style="font-size: 16pt; color: #8AC74A;" ><b>Wybierz rodzaj produktu jaki chcesz dodać: </b></p>
		
		<sf:form method="POST" action="/jez/mojekonto/dodajProdukt/wybierzRodzajProd">
			<fieldset style='border: none;'>
			<table class='casualTab'>
			<tr>
				<td> <label><b><i>Produkt Kup Teraz</i></b></label> </td>
				<td>
					<input style='width: 50px;' type="radio" name='wyborProd' value="KupTeraz" checked="checked" />
				</td>	
			</tr>
			<tr>
				<td> <label><b><i>Produkt Licytuj</i></b></label> </td>
				<td>
				
					<input style='width: 50px;' type="radio" name='wyborProd' value="Licytuj" />
				</td>
			</tr>
			<tr>
				<td cols="2" align='center'>
					<input class="sub" style='margin-left: 50px;' type="submit" value="Kolejny krok" /> 
				</td>
			</tr>
			</table>
			</fieldset>
		</sf:form>
	<a class="zakoncz" href="<c:url value='/mojekonto/dodajProdukt/zakoncz/' />" >  >>>Zakończ dodawanie produktu <<< </a>
	</div>
</div>
</body>
</html>