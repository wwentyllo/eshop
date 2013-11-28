package com.cebul.jez.controllers;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cebul.jez.entity.Kategoria;
import com.cebul.jez.entity.Produkty;
import com.cebul.jez.entity.ProduktyKupTeraz;
import com.cebul.jez.entity.User;
import com.cebul.jez.entity.Zdjecie;
import com.cebul.jez.model.UserDao;
import com.cebul.jez.service.KategorieService;
import com.cebul.jez.service.ProduktyService;
import com.cebul.jez.service.TestDataBaseService;
import com.cebul.jez.service.UserService;
import com.cebul.jez.useful.Mail;

/**
 * 
 * @author Robert Hajdo
 * Klasa pelniaca zadanie kontrolera w modelu MVC
 * Jej zadaniem jest obsługa rządań z ścieżki /admin_home 
 * Wykorzystuje mechanizm DI do wstrzykiwania zależnosći
 */
@Controller
public class AdminController {
	
	@Autowired
	private KategorieService kategorieService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private TestDataBaseService dbService;
	
	@Autowired
	private ProduktyService produktyService;
	
	@Autowired
	private TestDataBaseService serv;
		
	/**
	 * 
	 * @param model jest to odniesienie do obiektu modelu
	 * @return zwraca logiczną nazwę widoku
	 */
	@RequestMapping(value = {"/admin_home"})
	public String admin_home(Model model, HttpSession session){
		
		//dbService.test1();
		//List<Produkty> r = produktyService.getProduktyLike("drug", 19);
		//System.out.println(r.size());
		//Produkty pro =  r.get(0);
		//System.out.println(pro.getNazwa());
		
		//serv.test1();
		
		//System.out.println(new Date().after(new Date()));
		
		List<Produkty> produkty = produktyService.getLastFourProdukt();
		//model.addAttribute("lastFourItems", produkty);
		session.setAttribute("lastFourItems", produkty);
		//request.setAttribute("lastFourItems", produkty);
		//System.out.println(produkty.size());
		
		
		List<Kategoria> kat = kategorieService.getMainKategory();
		model.addAttribute("kategoryListModel", kat);
		session.setAttribute("kategoryList", kat);
		
		
		HashMap<Integer, List<Kategoria>> podkategorie = new HashMap<Integer, List<Kategoria>>();
		for(Kategoria k : kat)
		{
			podkategorie.put(k.getId(), kategorieService.getPodKategory(k.getId()) );
		}
		
		
		//userService.saveUser();
		//System.out.println(kat.get(0).getParentKategory().);
		
		
		return "admin_home";
	}
	@ResponseBody
	@RequestMapping(value = "/admin_home/imag/{imageId}", method = RequestMethod.GET, produces="imag/*")
	public void getImage(@PathVariable Integer imageId, HttpServletResponse response, HttpServletRequest request, HttpSession session, Model model) throws IOException {
	    response.setContentType("image/jpeg");
	    //Zdjecie requestedImage = zdjecieService.getZdjecie(2);
	    //Zdjecie requestedImage = produktyService.getProdukt(imageId).getZdjecie();
	    List<Produkty> produkty = (List<Produkty>) session.getAttribute("lastFourItems");
	    //List<Produkty> produkty = (List<Produkty>) request.getAttribute("lastFourItems");
	    Zdjecie requestedImage = null;
	    for(Produkty p: produkty)
	    {
	    	if(p.getId().equals(imageId))
	    	{
	    		requestedImage = p.getZdjecie();
	    		break;
	    	}
	    }
	    if(requestedImage != null)
	    {
		    InputStream in= new ByteArrayInputStream(requestedImage.getZdjecie()); 
		    //System.out.println("input: "+in);
		    if (in != null) {
		        IOUtils.copy(in, response.getOutputStream());  
		    }
	    }
	}
	
}
