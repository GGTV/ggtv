package org.gagia.web.util;

/* Only works with GeoIP Country Edition */
/* For Geoip City Edition, use CityLookupTest.java */

import com.maxmind.geoip.*;
import java.io.IOException;

import tw.qing.sys.StringManager;

public class CountryLookup {
	private static CountryLookup instance = null;
	private LookupService cl = null;
	public synchronized static CountryLookup getInstance()
	{
		if(instance == null)
			instance = new CountryLookup();
		return instance;
	}
	public CountryLookup()
	{
		String mode = StringManager.getManager("system").getString("mode");
		String dbfile = StringManager.getManager("system").getString(mode + ".GEOIP.DBFILE");
		try
		{
			cl = new LookupService(dbfile,LookupService.GEOIP_MEMORY_CACHE);
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	public String getCountryCode(String ip)
	{
		try
		{
			if(cl!=null)
			{
				String countryCode = cl.getCountry(ip).getCode();
				System.out.println("countryCode>>"+countryCode);
				return countryCode;
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return null;
	}
	public String getCountryName(String ip)
	{
		try
		{
			if(cl!=null)
			{
				String countryName = cl.getCountry(ip).getName();
				System.out.println("countryName>>" + countryName);
				return countryName;
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return "N/A";
	}
    public static void main(String[] args) {
	try {
	    String sep = System.getProperty("file.separator");

	    // Uncomment for windows
	    // String dir = System.getProperty("user.dir"); 

	    // Uncomment for Linux
	    String dir = "/usr/local/share/GeoIP";

	    String dbfile = dir + sep + "GeoIPv6.dat"; 
	    // You should only call LookupService once, especially if you use
	    // GEOIP_MEMORY_CACHE mode, since the LookupService constructor takes up
	    // resources to load the GeoIP.dat file into memory
	    //LookupService cl = new LookupService(dbfile,LookupService.GEOIP_STANDARD);
	    LookupService cl = new LookupService(dbfile,LookupService.GEOIP_MEMORY_CACHE);

	    System.out.println(cl.getCountryV6("ipv6.google.com").getCode());
	    System.out.println(cl.getCountryV6("::127.0.0.1").getName());
	    System.out.println(cl.getCountryV6("::151.38.39.114").getName());
	    System.out.println(cl.getCountryV6("2001:4860:0:1001::68").getName());

	    cl.close();
	}
	catch (IOException e) {
	    System.out.println("IO Exception");
	}
    }
}