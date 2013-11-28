package com.cebul.jez.controllers;

import java.awt.image.BufferedImage;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Blob;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.imageio.ImageIO;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.apache.commons.io.IOUtils;
import org.apache.tools.ant.util.FileUtils;
import org.aspectj.util.FileUtil;
import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.cebul.jez.entity.Kategoria;
import com.cebul.jez.entity.Produkty;
import com.cebul.jez.entity.ProduktyKupTeraz;
import com.cebul.jez.entity.ProduktyLicytuj;
import com.cebul.jez.entity.User;
import com.cebul.jez.entity.Zdjecie;
import com.cebul.jez.service.KategorieService;
import com.cebul.jez.service.ProduktyService;
import com.cebul.jez.service.UserService;
import com.cebul.jez.service.ZdjecieService;

@Controller("MojeKontoController")
public class MojeKontoController 
{

	@Autowired
	ServletContext context;
	
	@Autowired
	private KategorieService kategorieService;
	
	@Autowired
	private ProduktyService produktyService;
	
	@Autowired
	private ZdjecieService zdjecieService;
	
	
	@RequestMapping(value = "/mojekonto/")
	public String getGlownyWidok()
	{
		return "mojekonto";
	}
	@RequestMapping(value = "/mojekonto/dodajProdukt")
	public String dodajProduktForm()
	{
		return "wybierzRodzajProduktu";
	}
	@RequestMapping(value = "/mojekonto/dodajProdukt/wybierzRodzajProd" , method=RequestMethod.POST)
	public String wybranyRodzakProd(Model model, @RequestParam(value="wyborProd") String wybor, HttpSession session)
	{
		List<Kategoria> kat = kategorieService.getMainKategory();
		model.addAttribute("MainKat", kat);
		if(wybor.equals("KupTeraz"))
		{
			model.addAttribute("produkt", new ProduktyKupTeraz());
			return "dodajProduktKupTeraz";
			//return "redirect:/mojekonto/dodajProdukt/generateFormKup";
		}else if(wybor.equals("Licytuj"))
		{
			model.addAttribute("produkt", new ProduktyLicytuj());
			return "dodajProduktLicytuj";
		}
		return "redirect:/mojekonto/";
	}
	
	@RequestMapping(value = "/mojekonto/dodajProdukt/generateFormKup")
	public String generateUserForm(Model model)
	{
		model.addAttribute("produkt", new ProduktyKupTeraz());
		return "dodajProduktKupTeraz";
	}
	@RequestMapping(value = "/mojekonto/dodajProdukt/dodajKupTeraz", method=RequestMethod.POST)
	public String addProduktForForm(@Valid ProduktyKupTeraz pk, BindingResult bindingResult, Model model,  HttpSession session, HttpServletRequest request) throws Exception
	{
		if(bindingResult.hasErrors())
		{
			model.addAttribute("produkt", pk);
			model.addAttribute(bindingResult);
			bindingResult.reject("zleeeeee");
			System.out.println(bindingResult.getAllErrors());
			//model.addAttribute("produkt", new ProduktyKupTeraz());
			//return "redirect:/mojekonto/dodajProdukt/generateFormKup";
			return "dodajProduktKupTeraz";
		}
		User u = (User) session.getAttribute("sessionUser");
		pk.setUser(u);
		boolean itsDone = produktyService.saveProduktKupTeraz(pk);
		if(!itsDone)
		{
			
			return "/mojekonto/dodajProdukt/";
		}
		session.setAttribute("prod", pk);
		session.setAttribute("firstAdd", "yes");
		return "dodajZdjecie";
	}
	@RequestMapping(value = "/mojekonto/dodajProdukt/dodajLicytuj", method=RequestMethod.POST)
	public String addProduktForFormLicytuj(@Valid ProduktyLicytuj pl, BindingResult bindingResult, Model model,  HttpSession session, HttpServletRequest request) throws Exception
	{
		//pl.setDataZakonczenia(new Date());
		if(bindingResult.hasErrors())
		{
			model.addAttribute("produkt", pl);
			model.addAttribute(bindingResult);
			bindingResult.reject("zleeeeee");
			System.out.println(bindingResult.getAllErrors());
			//model.addAttribute("produkt", new ProduktyKupTeraz());
			//return "redirect:/mojekonto/dodajProdukt/generateFormKup";
			return "dodajProduktLicytuj";
		}
		if(!pl.getDataZakonczenia().after(new Date()))
		{
			pl.setDataZakonczenia(null);
			model.addAttribute("produkt", pl);
			return "dodajProduktLicytuj";
		}

		User u = (User) session.getAttribute("sessionUser");
		pl.setUser(u);
		boolean itsDone = produktyService.saveProduktLicytuj(pl);
		if(!itsDone)
		{
			return "/mojekonto/dodajProdukt/";
		}
		session.setAttribute("prod", pl);
		session.setAttribute("firstAdd", "yes");
		return "dodajZdjecie";
	}
	
	@ResponseBody
	@RequestMapping(value = "/images/{imageId}", method = RequestMethod.GET, produces="image/*")
	public void getImage(@PathVariable Integer imageId, HttpServletResponse response) throws IOException {
	    response.setContentType("image/jpeg");
	    //Zdjecie requestedImage = zdjecieService.getZdjecie(2);
	    Zdjecie requestedImage = produktyService.getProdukt(imageId).getZdjecie();
	    
	    InputStream in= new ByteArrayInputStream(requestedImage.getZdjecie()); 
	    System.out.println("input: "+in);
	    if (in != null) {
	        IOUtils.copy(in, response.getOutputStream());  
	    }
	}
	@RequestMapping(value = "/mojekonto/dodajProdukt/dodajZdjecie", method=RequestMethod.POST)
	public String dodajZdjecie(@RequestParam(value="image", required=false) MultipartFile image, 
			@RequestParam(value="mainImage", required=false) String mainImage, Model model,  HttpSession session, HttpServletRequest request) throws Exception
	{
		
		if(session.getAttribute("prod") != null)
		{
			Produkty p = (Produkty) session.getAttribute("prod");
			try{
				if(!image.isEmpty())
				{
					validateImage(image);
					//saveImage(image);
					//saveImageOnHardDrive(image, "H:\\");
					Zdjecie z = returnImage(image);
					p.addZdjecie(z);
					if(session.getAttribute("firstAdd") != null || mainImage.equals("main") )
					{
						session.removeAttribute("firstAdd");
						p.setZdjecie(z);
					}
					produktyService.updateProdukt(p);
					
				}
			}catch(Exception e){
					System.out.println("przed dodaniem sie wykladam");
					//System.out.println(e.getMessage());
					return "dodajZdjecie";
			}
				
			return "dodajZdjecie";
		}
		return "redirect:/mojekonto/";
	}
	public void validateImage(MultipartFile image) throws Exception 
	{
		if(!image.getContentType().equals("image/jpeg") && !image.getContentType().equals("image/png") && !image.getContentType().equals("image/x-png"))
		{
			throw new Exception("Plik nie ejst plikiem JPG. mam nontent= "+image.getContentType());
		}
	}
	public void saveImageOnHardDrive(MultipartFile image, String path)
	{
		try
		{
			System.out.println("path= "+path);
			File file = new File(path+image.getName());
			org.apache.commons.io.FileUtils.writeByteArrayToFile(file, image.getBytes());
		}catch(Exception e){
			System.out.println("nie moge zapisac na dysku");
		}
	}
	public void saveImage(MultipartFile image)
	{
		try{
			Zdjecie zdj = new Zdjecie();
			byte[] bFile  = image.getBytes();
			zdj.setZdjecie(bFile);
			zdjecieService.saveZdjecie(zdj);
			
		}catch(Exception e)
		{
			System.out.println(e.getMessage());
			System.out.println("nie udalo sie, przykro mi");
		}
	}
	public Zdjecie returnImage(MultipartFile image)
	{
		Zdjecie zdj = new Zdjecie();
		try{
			byte[] bFile  = image.getBytes();
			zdj.setZdjecie(bFile);
			//zdjecieService.saveZdjecie(zdj);
		}catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
		return zdj;
	}
	@RequestMapping(value = "/mojekonto/dodajProdukt/zakoncz/")
	public String zakonczaDodawanieZdj(HttpSession session)
	{
		session.removeAttribute("prod");
		return "redirect:/mojekonto/";
	}
	@InitBinder
    public void initBinder(WebDataBinder binder) {
        CustomDateEditor editor = new CustomDateEditor(new SimpleDateFormat("yyyy-MM-dd"), true);
        binder.registerCustomEditor(Date.class, editor);
    }
}
