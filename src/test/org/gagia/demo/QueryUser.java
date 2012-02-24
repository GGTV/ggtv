package org.gagia.demo;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.log4j.Logger;

import org.gagia.core.dao.User;
import org.gagia.core.parser.UserParser;
import org.gagia.core.net.URLConnect;
import org.gagia.demo.facade.UserFacade;
import org.gagia.demo.facade.StreamFacade;

public class QueryUser
{
	private static final Logger log = Logger.getLogger(QueryUser.class);
	private static QueryUser instance = null;
	
	private static final String FACEBOOK_GRAPH_API = "https://graph.facebook.com";
	private static final String FACEBOOK_FQL = "https://graph.facebook.com/fql";
	
	private HashMap hmUserInDB = new HashMap();

	public synchronized static QueryUser getInstance()
	{
		if(instance == null)
			instance = new QueryUser();
		return instance;
	}
	private QueryUser()
	{
		ArrayList list = UserFacade.getInstance().loadUserId();
		for(int i=0;list!=null && i<list.size();i++)
		{
			HashMap hm = (HashMap)list.get(i);
			String uid = hm.get("id").toString();
			hmUserInDB.put(uid, uid);
		}
	}
	private boolean isUserExist(String uid)
	{
		if(hmUserInDB.get(uid)!=null)
			return true;
		return false;
	}
	public void getAuthorizedUser(String uid, String token)
	{
		String fql = "SELECT uid, username, name, first_name, middle_name, last_name, pic_small, pic_big, pic_square, pic, birthday_date, sex, hometown_location, current_location, is_app_user, locale, email FROM user WHERE uid =me() or uid in (select uid2 from friend where uid1=me())";
		String url = FACEBOOK_FQL + "?" + "access_token=" + token;
		String response = URLConnect.response(url).toString();	
		//System.out.println(response);
		UserParser parser = new UserParser();
		parser.parse(response);			
		ArrayList<User> list = parser.get();
		for(int i=0;i<list.size();i++)
		{
			UserFacade.getInstance().add(list.get(i));
			hmUserInDB.put(uid, uid);
		}		
	}
	public void getPublicUser(String uid)
	{
		if(isUserExist(uid))
			return;
		String url = FACEBOOK_GRAPH_API + "/" + uid;		
		String response = URLConnect.response(url).toString();	
//		System.out.println(response);
		UserParser parser = new UserParser();
		parser.parse("{data:[" + response + "]}");			
		ArrayList<User> list = parser.get();
		for(int i=0;i<list.size();i++)
		{
			UserFacade.getInstance().add(list.get(i));
			hmUserInDB.put(uid, uid);
		}
	}
	public void addUserBatch()
	{
		ArrayList list = StreamFacade.getInstance().loadUserFromStream();
		for(int i=0;i<list.size();i++)
		{
			try
			{
				HashMap hm = (HashMap)list.get(i);
				String uid = hm.get("source_id").toString();
				getPublicUser(uid);
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}
	}
	public static void main(String[] args)
	{
		QueryUser.getInstance().getPublicUser("1001827220");
		//QueryUser.getInstance().addUserBatch();
	}
}