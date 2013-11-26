package com.cebul.jez.controllers;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.cebul.jez.entity.Produkty;
import com.cebul.jez.entity.ProduktyKupTeraz;
import com.cebul.jez.service.ProduktyService;
import com.cebul.jez.useful.ShoppingCart;

@Controller
@SessionAttributes("shoppingCart")
public class KoszykController 
{
	@Autowired
	private ProduktyService produktyService;
	
	@Autowired
	private ShoppingCart shoppingCart;
	
	@RequestMapping(value = "/koszyk")
	public String regForm(Model model,  HttpSession session) 
	{
		//System.out.println(shoppingCart.getItems().size());
		model.addAttribute("shoppingCart", shoppingCart);
		
		List<Boolean> czyKupTeraz = new ArrayList<Boolean>();
		
		for(Produkty p : shoppingCart.getItems())
		{
			if(p instanceof ProduktyKupTeraz)
			{
				czyKupTeraz.add(true);
				//System.out.println("kup teraz");
			}
			else
				czyKupTeraz.add(false);
		}
		model.addAttribute("czyKupTeraz", czyKupTeraz);
		
		return "koszyk";
	}
	@RequestMapping(value = "/koszyk/usun/{produktId}/", method = RequestMethod.GET)
	public String usunZKoszyka(@PathVariable Integer produktId, Model model,  HttpSession session) 
	{
		
		for(Produkty p : shoppingCart.getItems())
		{
			if(p.getId().equals(produktId))
			{
				//shoppingCart.subFromSum(p.getCena());
				shoppingCart.removeItem(p);
				break;
			}
			
		}
		
		return "koszyk";
	}
}
