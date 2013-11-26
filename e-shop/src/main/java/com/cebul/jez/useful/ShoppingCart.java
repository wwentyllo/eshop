package com.cebul.jez.useful;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;

import com.cebul.jez.entity.Produkty;

@Component
@Scope(value="session", proxyMode=ScopedProxyMode.TARGET_CLASS)
public class ShoppingCart implements Serializable
{
	private List<Produkty> items;
	private Double suma;
	
	public ShoppingCart()
	{
		this.items = new ArrayList<Produkty>();
		this.suma = 0.0;
	}
	
	public void addItem(Produkty i)
	{
		items.add(i);
		addToSum(i.getCena());
	}
	public Object removeItem(Produkty p)
	{
		subFromSum(p.getCena());
		return items.remove(p);
	}
	public List<Produkty> getItems() {
		return items;
	}

	public void setItems(List<Produkty> items) {
		this.items = items;
	}
	public void addToSum(Double cena)
	{
		this.suma += cena;
	}
	public void subFromSum(Double cena)
	{
		this.suma -= cena;
	}

	public Double getSuma() {
		return suma;
	}

	public void setSuma(Double suma) {
		this.suma = suma;
	}
	
	
}
