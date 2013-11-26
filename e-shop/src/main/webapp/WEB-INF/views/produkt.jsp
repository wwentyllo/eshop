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
					<a href="<c:url value='/' />" style="border: 0 px solid black; text-decoration: none;">
						<img  style='border: 0 px solid black; height: 80px;' src="<c:url value='/resources/images/logo.jpg' />">
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
			<c:forEach items="${podkategorie}" var="element"> 
				<a href="<c:url value='/kategoria/${element.id}' />" class="categorieLeft" onmouseover="showPodkategorie()">
					${element.nazwa}
				</a>
			</c:forEach>
								
			</div>
			<div id='main-right' style='padding-left: 10px; padding-top: 10px;'>
				<div  style='margin-left: 75px;'>
					<span style="font-size: 12pt; display: block; color: gray; margin-bottom: 5px;">${path}</span>
					
						<div style='margin-right: 20px; margin-right: 10px; float: left; padding: 5px; border: 1px solid gray; width: 200px;'>
								<c:choose>
								<c:when test="${!empty produkt.zdjecie}">
										<img style="width: 200px; height: 200px;" src="${pageContext.request.contextPath}/imag/${produkt.id}" />
								</c:when>
									<c:otherwise>
										<img style="width: 200px; height: 200px;" src="<c:url value='/resources/images/unknownItem.png' />" />
									</c:otherwise>
								</c:choose>
						</div>
						
						</br>
						<div style='padding: 3px;'><span style="font-size: 14pt; color: #8AC74A;">Nazwa: </span> <span>${produkt.nazwa}</span></div>
						</br>
						<div style='padding: 3px;'><span style="font-size: 14pt; color: #8AC74A;">Cena: </span> <span>${produkt.cena} zł</span></div>
						</br>
						<div style='padding: 3px;'><span style="font-size: 14pt; color: #8AC74A;">Sprzedający:</span> <span>${produkt.user.login} zł</span></div>
						</br>
						<div style='padding: 3px;'>
							
								<c:choose>
									<c:when test="${czyKupTeraz}">
										<sf:form modelAttribute="produkt" action="/jez/produkty/addToCart/" method="POST">
											<sf:input type="hidden" path="id" value="${produkt.id}" />
											<input style="margin-left: 5px;" class="sub" type="submit" value="Kup teraz" />
										</sf:form>
									</c:when>
									<c:otherwise>
										<sf:form  modelAttribute="produkt" action="" method="POST">
											<sf:input type="hidden" path="id" value="${produkt.id}" />
											<input style="margin-left: 5px;" class="sub" type="submit" value="Licytuj" />
										</sf:form>
									</c:otherwise>
								</c:choose>
						</div>
						
				
				</div>
				</br>
				</br>
				<div style='display:block; margin-left: 75px; padding: 3px;'><span style="font-size: 14pt; color: #8AC74A;">Opis: </span> </br><span >${produkt.opis}</span></div>
				</br>
				<div style="display:block; margin-left: 75px;">
					<span style="font-size: 14pt; color: #8AC74A;" >Zdjecia produktu:</span></br>
					<c:choose>
						<c:when test="${!empty zdjecia}">
								<c:forEach items="${zdjecia}" var="zdj"> 
									<img style="margin: 5px; width: 200px; height: 200px;" src="${pageContext.request.contextPath}/images/13" />
								</c:forEach>
						</c:when>
						<c:otherwise>
								<span style="margin-left: 20px; font-size: 14pt;" >brak zdjęć produktu</span>
						</c:otherwise>
					</c:choose>
					
					
				</div>
			</div>
		</div>
		<div id='bottom'>
			<span align="center" style="color: #578921; display: block;"><b>Copyright Ⓒ Cebul & Jeżyk</b></span>
			
		</div>
	</div>
	<div id='podpowiedzi' >
		
	</div>
</body>
</html>
