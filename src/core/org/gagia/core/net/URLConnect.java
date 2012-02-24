package org.gagia.core.net;

import java.io.*;
import java.net.*;
import javax.net.ssl.HttpsURLConnection;

import org.apache.log4j.Logger;

public class URLConnect
{
	private static final Logger log = Logger.getLogger(URLConnect.class);
	
	public static StringBuffer response(String _url)
	{
		StringBuffer sb = new StringBuffer();
		try
		{
			InputStream is = null;
			InputStreamReader isr = null;
			BufferedReader br = null;
			try
			{
				log.fatal("URL - " + _url);
				URL url = new URL(_url);
				HttpsURLConnection uc = (HttpsURLConnection)url.openConnection();
				//			
				uc.setConnectTimeout(3*60* 1000);
				uc.setReadTimeout(3*60*1000);
				is = uc.getInputStream();
				isr= new InputStreamReader(is, "UTF-8");
				br = new BufferedReader(isr);
				while(true)
				{
					String s = br.readLine();
					if( s == null )
						break;
					sb.append(s);
					sb.append(System.getProperty("line.separator"));
				}
				//System.out.println(sb.toString());
			}
			catch(IOException e)
			{
				e.printStackTrace();
				log.error(e.getMessage());
			}
			finally
			{
				if(br!=null)
					br.close();
				if(isr!=null)
					isr.close();
				if(is!=null)
					is.close();
			}
		}
		catch(java.net.MalformedURLException me)
		{
			log.error(me.getMessage());
		}
		catch(Exception e)
		{
			e.printStackTrace();
			log.error(e.getMessage());
		}
		return sb;
	}	
}