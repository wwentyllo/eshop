package com.cebul.jez.controllers;



import java.security.Principal;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.cebul.jez.entity.User;
import com.cebul.jez.flows.UserShortInfo;
import com.cebul.jez.model.UserDao;

/**
 * 
 * @author Mateusz
 *	Klasa działa jako kontroler w modelu MVC
 *	używa mechanizmu DI do wstrzykiwania zależnosći
 *	obsługuje żądania z ścieżki "/logowanie/*"
 */

@Controller
public class LogController
{

	@Autowired
	private UserDao userDao;
	
	@Autowired
	private UserShortInfo usinfo;
	
	/**
	 * obsługuje żądanie dostępu do "/logowanie"
	 * @param model zawiera referencje do obiektu modelu
	 * @param session zawiera referencję do obiektu sesji
	 * @return zwraca logiczną nazwę widoku
	 */
	@RequestMapping(value = "/logowanie")
	public String home(Model model, HttpSession session) 
	{
		if(isUserLogged(session))
			return "redirect:/home";
		
		return "logowanie";
	}
	/**
	 * obsługuje żądanie dostępu do "/logowanie/setUserSession"
	 * @param model  zawiera referencje do obiektu modelu
	 * @param session zawiera referencję do obiektu sesji
	 * @param request zawiera referencję do obiektu HttpServletRequest
	 * @return zwraca logiczną nazwę widoku
	 */
	@RequestMapping(value = "/logowanie/setUserSession")
	public String setSessionUser(Model model, HttpSession session, HttpServletRequest request) 
	{
		if(isUserLogged(session))
			return "redirect:/home";
		
		Principal principal = request.getUserPrincipal();
		String userName = principal.getName();
		User u = userDao.getUser(userName);
		String ranga = u.getRanga();
		session.setAttribute("sessionUser", u);
		
		// ustawienie komponentu zawierajacego dane usera, widocznego w web flow
		if(u != null)
		{
			usinfo.setId(u.getId());
			usinfo.setLogin(u.getLogin());
			usinfo.setEmail(u.getEmail());
			usinfo.setRanga(u.getRanga());
		}
		System.out.println("test uset login:"+usinfo.getLogin() );
		
		if(ranga.equals("admin"))
		{
			return "redirect:/admin_home";
		}
		else
			
		return "redirect:/home";
	}
	/**
	 * obsługuje żądanie dostępu do "/login"
	 * @param login_error parametr ten określa wystąpnienie błedu podczas logowania i
	 * 						umożliwia wyświetlenie strony błednego logowania
	 * @param session odnosi się do okiektu sesji
	 * @return zwraca logiczną nazwę widoku
	 */
	@RequestMapping(value = "/logowanie", method=RequestMethod.GET, params="login_error" )
	public String errorLogin(@RequestParam String login_error, HttpSession session)
	{
		if(isUserLogged(session))
			return "redirect:/home";
		
		return "loginError";
	}
	/**
	 * sprawdza czy uzytkownik jest już zalogowany do seystemu
	 * @param session odnosi się do obiektu sesji
	 * @return zwraca true lub false w zależnosci od tego czy użytkownik jest zalogowany czy nie
	 */
	public boolean isUserLogged(HttpSession session)
	{
		User u = (User) session.getAttribute("sessionUser");
		if(u != null)
			return true;
		return false;
	}
}
