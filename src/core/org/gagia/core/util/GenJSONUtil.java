package org.gagia.core.util;
//
import java.io.PrintWriter;

import java.util.HashMap;
import java.util.Date;
import java.util.Set;
import java.text.SimpleDateFormat;
//
import org.apache.log4j.Logger;
//
public class  GenJSONUtil
{
	private static Logger log = Logger.getLogger(GenJSONUtil.class);
	//
	//not include []
	public static void genBaseJSON(PrintWriter pw, HashMap[] hms)
	{
		try
		{
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
			for (int i=0;i<hms.length ;i++ )
			{
				pw.print("{");
				//log.debug("{");
				HashMap hm = hms[i];
				Set keySet = hm.keySet();
				String[] key = (String[])keySet.toArray(new String[0]);
				for (int j=0;j<key.length ;j++ )
				{
					Object o = hm.get(key[j]);
					pw.print(key[j]);
					pw.print(":");
					//log.debug(key[j] + ":");
					if(o instanceof String)
					{
						String tmp = String.valueOf(o).replaceAll("'","&#39;");
						tmp = replaceAll(tmp, "\r\n", "<br>");
						tmp = replaceAll(tmp, "\n", "<br>");
						tmp = replaceAll(tmp, "\\", "&#92;");
						pw.print("'"+tmp +"'");
						//log.debug("'"+tmp +"'");
					}
					else if(o instanceof Date)
					{
						pw.print("'" + dateFormat.format((Date)o) + "'");
						//log.debug("'" + dateFormat.format((Date)o) + "'");
					}
					else
					{
						pw.print(o);
						//log.debug(o);
					}
					//
					if(j<key.length-1)
					{
						pw.print(",");
						//log.debug(",");
					}
				}
				pw.print("}");
				//log.debug("}");
				if(i<hms.length-1)
				{
					pw.println(",");
					//log.debug(",");
				}
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}
	public static String replaceAll(String text, String s, String t)
	{
		int cursor = 0;
		while(true)
		{
			int p = text.indexOf(s, cursor);
			if( p < 0 )
				return text;
			StringBuffer sb = new StringBuffer(text);
			//
			sb = sb.replace(p, p+s.length(), t);
			text = sb.toString();
			cursor = p+t.length();
		}
	}
}
