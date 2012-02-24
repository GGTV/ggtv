package org.gagia.demo;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Set;
import java.util.Vector;

import org.gagia.core.dao.Post;
import org.gagia.core.dao.User;
import org.gagia.core.dao.Stream;
import org.gagia.core.parser.PostParser;
import org.gagia.core.parser.UserParser;
import org.gagia.core.net.URLConnect;
import org.gagia.demo.facade.UserFacade;
import org.gagia.demo.facade.StreamFacade;

public class Query
{
	private static Object lock = new Object();
	private static boolean poolFull = false;
	private int current_thread_size = 0;
	private final int MAX_THREAD_SIZE = 600;
	private static final String FACEBOOK_GRAPH_API = "https://graph.facebook.com";
	private static final String FACEBOOK_FQL = "https://graph.facebook.com/fql";
	private HashMap mapUser = new HashMap();
	//
	private String access_token;
	//
	public Query(String access_token)
	{
		this.access_token = access_token;
	}
	private String buildParam(String paramName, String paramValue)
	{
		return buildParam(false, paramName, paramValue);
	}
	private String buildParam(boolean fFirstParam, String paramName, String paramValue)
	{
		String conj = fFirstParam?"?":"&";
		try
		{
			return conj + paramName + "=" + URLEncoder.encode(paramValue, "UTF-8");
		}
		catch(Exception e)
		{
			e.printStackTrace();
			return conj + paramName + "=" + paramValue;
		}
	}
	private String getFQL_Friends()
	{
		return "select uid2 from friend where uid1=me()";
	}
	public Vector filterUser(Vector vOther)
	{
		if(vOther!=null)
		{
			for(int i=vOther.size()-1;i>=0;i--)
			{
				String s = vOther.get(i).toString();
				if(mapUser.get(s)!=null)
					vOther.remove(i);
				else if(mapUser.get(s)!=null && mapUser.get(s).toString().equals("-1"));
				else {
					mapUser.put(s, s);
				}

			}
		}
		return vOther;
	}
	private final void wait2()
	{
		try
		{
			Thread.sleep(1500);
		}
		catch(Exception e){}		
	}
	public int loadOtherUserPost()
	{
		Set set = mapUser.keySet();
		String[] key  = (String[])set.toArray(new String[0]);
		for(int j=0;key!=null && j<key.length;j++)
		{
			String user = mapUser.get(key[j]).toString();
			if(user.equals("-1"))
				continue;
			final String uid = user;
			synchronized(lock)
			{
				if(current_thread_size>=MAX_THREAD_SIZE)
				{
					wait2();
				}
//				else current_thread_size++;
				//
				mapUser.put(user, "-1");
				new Thread(){
					public void run()
					{
						try
						{
							Thread.sleep(1500);
						}
						catch(Exception e){}
						loadPublicPost(uid);
					}
				}.start();
			}
		}
		return -1;
	}
	public int loadCurrentUser()
	{
		String fql = "SELECT uid, username, name, pic_small, pic_big, pic_square, pic, birthday_date, sex, hometown_location, current_location, is_app_user, locale, email FROM user WHERE uid =me() or uid in ("+getFQL_Friends()+")";
		String url = FACEBOOK_FQL + buildParam(true, "access_token", access_token) + buildParam("q", fql);
		current_thread_size++;
		String response = URLConnect.response(url).toString();
		current_thread_size--;
		UserParser parser = new UserParser();
		parser.parse(response);
		ArrayList<User> list = parser.get();
		System.out.println("total size of User: " + list.size());
		for(int i=0;list!=null && i<list.size();i++)
		{
			long user_id = list.get(i).getUid();
			String s = new String(user_id+"");
			if(mapUser.containsKey(s) || mapUser.get(s)!=null)
			{
				continue;
			}
			mapUser.put(s, s);
			UserFacade.getInstance().add(list.get(i));
			final String uid = s;
			synchronized(lock)
			{
				mapUser.put(s, "-1");
				if(current_thread_size>=MAX_THREAD_SIZE)
				{
					wait2();
				}
				else current_thread_size++;
				new Thread(){
					public void run()
					{
						try
						{
							Thread.sleep(1200);
						}
						catch(Exception e){}
						loadPublicPost(uid);
					}
				}.start();
			}
		}
		return -1;
	}
	public void loadPublicPostByPaging(String url)
	{
		current_thread_size++;
		String response = URLConnect.response(url).toString();	
		current_thread_size--;
		final PostParser parser = new PostParser();
		parser.parse(response);
		//
		if(parser.getNextPageURL()!=null)
		{
			synchronized(lock)
			{
				if(current_thread_size>=MAX_THREAD_SIZE)
				{
					wait2();
				}
//				else current_thread_size++;
				try
				{
					Thread.sleep(2000);
				}
				catch(Exception e){}
				new Thread(){
					public void run()
					{
						loadPublicPostByPaging(parser.getNextPageURL());
					}
				}.start();
			}
		}
		ArrayList<Post> list = parser.get();
		System.out.println("total size of Post: " + list.size());
		if(list!=null)
		{
			for(int i=list.size()-1;i>=0;i--)
			{
				//process likes and comments user
				filterUser(list.get(i).getOtherUser());
				//
				String type = list.get(i).getType();
				if(!isActiveUser(list.get(i).getCreated_time()))
				{
					//TODO: set as non-activeUser
					break;
				}
				if(!type.equals("video"))
				{
					list.remove(i);
					continue;
				}
				if(!list.get(i).isYouTubeVideo())
				{
					list.remove(i);
					continue;
				}
				//System.out.println(list.get(i).toString());
				if(isOld(list.get(i).getCreated_time()))
					break;
				Stream stream = list.get(i).getStream();
				StreamFacade.getInstance().add(stream);
			}
		}
	}
	public void loadPublicPost(String objectId)
	{
		String url = FACEBOOK_GRAPH_API + "/" + objectId + "/posts" + buildParam(true, "access_token", access_token) + buildParam("limit", "100");
		loadPublicPostByPaging(url);
	}
	private boolean isActiveUser(long created_time)
	{
		//if latestPostTime< (now - 1 month) return false; otherwise true
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.YEAR, -1);
		if(cal.getTimeInMillis()>created_time)
			return false;
		return true;
	}
	private boolean isOld(long created_time)
	{
		//if postTime< (now - 1 month) return true; otherwise false
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.YEAR, -1);
		if(cal.getTimeInMillis()>created_time)
			return true;
		return false;
	}
}