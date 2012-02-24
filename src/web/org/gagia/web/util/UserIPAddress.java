package org.gagia.web.util;
//
import java.net.InetAddress;
import java.net.UnknownHostException;
import javax.servlet.http.HttpServletRequest;
//
import org.apache.log4j.Logger;
//
public class  UserIPAddress
{
	private static Logger log = Logger.getLogger(UserIPAddress.class);
	//
	public static String get(HttpServletRequest request) throws UnknownHostException
	{
		String ip = request.getHeader("x-forwarded-for");
		log.info("request.getHeader('x-forwarded-for')>>" + ip);
		if (ip == null || ip.length()==0 || "unknown".equalsIgnoreCase(ip)) 
		{
			ip = request.getHeader("Proxy-Client-IP");
			log.info("request.getHeader('Proxy-Client-IP')>>" + ip);
		}
		if (ip == null || ip.length()==0 || "unknown".equalsIgnoreCase(ip)) 
		{
			ip = request.getHeader("WL-Proxy-Client-IP");
			log.info("request.getHeader('WL-Proxy-Client-IP')>>" + ip);
		}
		if (ip == null || ip.length()==0 || "unknown".equalsIgnoreCase(ip)) 
		{
			ip = request.getRemoteAddr();
			log.info("request.getRemoteAddr()>>" + ip);
		}
		//
		if(ip!=null)
		{
			int p = ip.indexOf(",");
			if( p >= 0 )
				ip = ip.substring(0, p).trim();
			return InetAddress.getByName(ip).getHostAddress();
		}
		return "";
	}
}