package org.gagia.demo;

import javax.net.ssl.HttpsURLConnection;
import java.net.*;
import java.io.*;
import java.util.ArrayList;

import org.apache.log4j.Logger;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import org.gagia.core.dao.User;
import org.gagia.core.dao.Post;
//
import org.gagia.demo.facade.UserFacade;

public class Demo
{
	private static final Logger log = Logger.getLogger(Demo.class);
	//private static String access_token = "AAACZAtmArA28BAIvfzbmnvhjmAgKMOia6XE2s3SkZBdXzvmrvArSmjZA4qABRw3aGRI1hkZCm7kfHlZCtv2qABiu12o3udyAgmmdY9OTPBgZDZD";
	private static String access_token = "AAACZAtmArA28BAGC6Tw2RWrX3TEGCcZALhmIbmW4wOi9a1tXz0K75G7ZASf8ll0ttIj7VjMXBaSxydgwJ7gP9QEXIG97twZD";
	private static final String FACEBOOK_GRAPH_API = "https://graph.facebook.com";
	private ArrayList list = new ArrayList();
	//
	public void loadPublicUserData(String last_name)
	{
		try
		{
			searchPublicObjects(last_name, "user", "id,name,first_name,middle_name,last_name,locale,link,username,gender", "yesterday", 300);
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	public void loadPublicPostData()
	{
		try
		{
			searchPublicObjects("http", "post", "id,from,to,message,picture,link,name,caption,description,source,properties,icon,actions,type,likes", "today", 20); 
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	public void loadPublicUserDataByPaging(String url)
	{
		StringBuffer sb = getResponse(url);
		try
		{
			JSONObject response = new JSONObject(sb.toString());
			JSONArray data = response.optJSONArray("data");
			parseUser(data);
			//
			JSONObject paging = response.optJSONObject("paging");
			if(paging == null)
				return;
			String nextUrl = paging.optString("next");
			if(nextUrl!=null)
			{
				if(nextUrl.startsWith("http"))
				{
					Thread.sleep(1200);
					loadPublicUserDataByPaging(nextUrl);
				}
				else {
					log.debug("NextPageURL=" + nextUrl);
				}

			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			log.debug("url["+url+"] response: " + sb.toString());
		}		
	}
	public void loadPublicPostDataByPaging(String url)
	{
		StringBuffer sb = getResponse(url);
		try
		{
			JSONObject response = new JSONObject(sb.toString());
			JSONArray data = response.optJSONArray("data");
			parsePost(data);
			//
			JSONObject paging = response.optJSONObject("paging");
			if(paging == null)
				return;
			String nextUrl = paging.optString("next");
			if(nextUrl!=null)
			{
				if(nextUrl.startsWith("http"))
				{
					Thread.sleep(1200);
					loadPublicPostDataByPaging(nextUrl);
				}
				else {
					log.debug("NextPageURL=" + nextUrl);
				}
				
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			log.debug("url["+url+"] response: " + sb.toString());
		}		
	}
	private void searchPublicObjects(String query, final String objectType, String fields, String until, int limit)
	{
		String params = "q=" + query + "&type=" + objectType + "&access_token=" + access_token + "&since="+until + "&limit="+limit;
		if(fields!=null &&!"".equals(fields))
			params += "&fields=" + fields;
		String url = FACEBOOK_GRAPH_API + "/search?" + params;
		try
		{
			JSONObject response = new JSONObject(getResponse(url).toString());
			JSONArray data = response.getJSONArray("data");
			if(objectType.equals("user"))
				parseUser(data);
			else if(objectType.equals("post"))
				parsePost(data);
			//
			JSONObject paging = response.getJSONObject("paging");
			if(paging == null)
				return;
			final String nextUrl = paging.optString("next");
			if(nextUrl!=null)
			{
				Thread t = new Thread(){
					private boolean isDone = false;
					public void run()
					{
						if(nextUrl.startsWith("http"))
						{
							try{
								Thread.sleep(1200);
							}
							catch(Exception e){}
							if(objectType.equals("user"))
								loadPublicUserDataByPaging(nextUrl);			
							else if(objectType.equals("post"))
								loadPublicPostDataByPaging(nextUrl);
						}
						else
							log.debug("NextPageURL=" + nextUrl);
						isDone = true;
					}
					public String toString()
					{
						return "" + isDone;
					}
				};
				t.start();
				while(true)
				{
					Thread.sleep(5000);
					if(t.toString().equals("true"))
					{
						System.out.println("total size: " + list.size());
						break;
					}
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	private void parseUser(JSONArray data)
	{
		for(int i=0;data!=null && i<data.length();i++)
		{
			try
			{
				JSONObject jso = data.getJSONObject(i);
				User user = new User(jso);
				list.add(user);
				Object[] o = new Object[]{user.getUid(), user.getName(), user.getFirst_name(), user.getMiddle_name(), user.getLast_name(), user.getGender(), user.getLocale(), user.getLink()};
				UserFacade.getInstance().add(o);
			}
			catch(JSONException je)
			{
				je.printStackTrace();
			}
		}		
	}
	private void parsePost(JSONArray data)
	{
		for(int i=0;data!=null && i<data.length();i++)
		{
			try
			{
				JSONObject jso = data.getJSONObject(i);
				Post post = new Post(jso);
				list.add(post);
				/*
				Object[] o = new Object[]{user.getUid(), user.getName(), user.getFirst_name(), user.getMiddle_name(), user.getLast_name(), user.getGender(), user.getLocale(), user.getLink()};
				UserFacade.getInstance().add(o);
				*/
			}
			catch(JSONException je)
			{
				je.printStackTrace();
			}
		}		
	}
	private StringBuffer getResponse(String _url)
	{
		StringBuffer sb = new StringBuffer();
		try
		{
			InputStream is = null;
			InputStreamReader isr = null;
			BufferedReader br = null;
			try
			{
				log.info("URL - " + _url);
				URL url = new URL(_url);
				HttpsURLConnection uc = (HttpsURLConnection)url.openConnection();
				//			
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
			try
			{
				Thread.sleep(1500);
				return getResponse(_url);
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
			log.error(me.getMessage());
		}
		catch(Exception e)
		{
			e.printStackTrace();
			log.error(e.getMessage());
		}
		return sb;
	}
	public static void main(String[] args)
	{
		Demo app = new Demo();
		String[] last_name = new String[]{"陳", "林", "黃", "張", "李", "王", "吳", "劉", "蔡", "楊", " 許", "鄭", "謝", "郭", "洪", "邱", "曾", "廖", "賴", "徐", " 周", "葉", "蘇", "莊", "江", "呂", "何", "羅", "高", "蕭", " 潘", "朱", "簡", "鍾", "彭", "游", "詹", "胡", "施", "沈", " 余", "趙", "盧", "梁", "顏", "柯", "孫", "魏", "翁", "戴", " 范", "宋", "方", "鄧", "杜", "傅", "侯", "曹", "溫", "薛", " 丁", "馬", "蔣", "唐", "卓", "藍", "馮", "姚", "石", "董", " 紀", "歐", "程", "連", "古", "汪", "湯", "姜", "田", "康", " 鄒", "白", "涂", "尤", "巫", "韓", "龔", "嚴", "袁", "鐘", " 黎", "金", "阮", "陸", "倪", "夏", "童", "邵", "柳", "錢"};
		for(int i=0;i<last_name.length;i++)
			app.loadPublicUserData(last_name[i]);
		System.out.println("**************");
	}
}