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
				${sessionScope.test}
				<div>
					<a style='margin-top: 40px;' href='<c:url value='/logowanie' />'>Zaloguj</a>
					<a href='<c:url value='/rejestracja' />'>Rejestracja</a>
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
		<div id='main-cenetr' align='center'>
				
	
		<sf:form method="POST" modelAttribute="user">
			<fieldset style='border: none;'>
			<c:if test="${error == 1}">
		   <p class="error">Taki użytkonik już isnieje. Wybierz inną nazwę.</p>
			</c:if>
			<p id="login_error" class="error"></p>
			<table id='tabReg'>
				<tr>
							<td>
								<label for="login">Login:</label>
							</td>
							<td>
								<sf:input  id="login" path="login"  onfocusout="doAjaxPost();"/>
								<sf:errors  path="login" cssClass="error" />
							</td>
						</tr>
						<tr>
							<td>
								<label for="haslo"> Hasło:</label>
							</td>
							<td>
								<sf:password  id="pass" path="pass"  />
								<sf:errors path="pass" cssClass="error" />
							</td>
							
						</tr>
						<tr>
							<td>
								<label for="imie"> Imie:</label>
							</td>
							<td>
								<sf:input  id="imie" path="imie" />
								<sf:errors path="imie" cssClass="error" />
							</td>
							
						</tr>
						<tr>
							<td>
								<label for="nazwisko"> Nazwisko:</label>
							</td>
							<td>
								<sf:input  id="nazwisko" path="nazwisko" />
								<sf:errors path="nazwisko" cssClass="error" />
							</td>
							
						</tr>
						<tr>
							<td>
								<label for="email"> Email:</label>
							</td>
							<td>
								<sf:input  id="email" path="email" />
								<sf:errors path="email" cssClass="error" />
							</td>
							
						</tr>
						<tr>
							<td>
								<label for="adres.miejscowosc"> Miejsce zamieszkania:</label>
							</td>
							<td>
								<sf:input id="miejscowosc" path="adres.miejscowosc" />
								<sf:errors path="adres.miejscowosc" cssClass="error" />
							</td>
							
						</tr>
						<tr>
							<td>
								<label for="adres.kod_pocztowy"> Kod Pocztowy:</label>
							</td>
							<td>
								<sf:input  id="kod_pocztowy" path="adres.kod_pocztowy" />
								<sf:errors path="adres.kod_pocztowy" cssClass="error" />
							</td>
							
						</tr>
						<tr>
							<td>
								<label for="plec"> Płeć:</label>
							</td>
							<td>
								
								<sf:select id="plec" path="plec">
									<sf:option value="null">wybież płeć:</sf:option>
									<sf:option value="m">mężczyzna</sf:option>
									<sf:option value="k">kobieta</sf:option>
								</sf:select>
								<sf:errors path="plec" cssClass="error" />
							</td>
						</tr>
						<tr>
							<td>
								<label> Data urodzenia:</label>
							</td>
							<td>
								
								<sf:select id="rok" path="rok" onchange="month();">
									<sf:option value="">rok:</sf:option>
									<c:forEach var="j" begin="1960" end="2013">
										<sf:option value="${j}"></sf:option>
									</c:forEach>
								</sf:select>
								<sf:select id="miesiac" path="miesiac" onchange="month();">
									<sf:option value="">miesiąć:</sf:option>
									<c:forEach var="i" begin="1" end="12">
										<sf:option value="${i}"></sf:option>
									</c:forEach>
								</sf:select>
								<sf:select id="dzien" path="dzien">
									<sf:option value="">dzień:</sf:option>
									
								</sf:select>
								<sf:errors path="dzien" cssClass="error" />
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<input align='center' type="submit" value="Dalej" class="sub" id="sub" >	
							</td>
						</tr>
			</table>
			</fieldset>
		</sf:form>

	</div>
</div>
</body>
</html>