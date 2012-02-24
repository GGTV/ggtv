package org.gagia.demo;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Set;
import java.util.Vector;

import org.apache.log4j.Logger;

import org.gagia.core.dao.Post;
import org.gagia.core.dao.User;
import org.gagia.core.dao.Stream;
import org.gagia.core.parser.PostParser;
import org.gagia.core.parser.UserParser;
import org.gagia.core.net.URLConnect;
import org.gagia.demo.facade.UserFacade;
import org.gagia.demo.facade.StreamFacade;

public class QueryPost
{
	private static final Logger log = Logger.getLogger(QueryPost.class);
	private static final String FACEBOOK_GRAPH_API = "https://graph.facebook.com";
	private static final String FACEBOOK_FQL = "https://graph.facebook.com/fql";
	private static int MAX_LEVEL = 3;
	private HashMap mapUser = new HashMap();
	//
	private String access_token;
	//
	public QueryPost(String access_token)
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
				else if(mapUser.get(s)!=null && mapUser.get(s).toString().equals("-1"))
					vOther.remove(i);
				else {
					mapUser.put(s, s);
				}

			}
		}
		return vOther;
	}
	public int loadOtherUserPost()
	{
		Set set = mapUser.keySet();
		String[] key  = (String[])set.toArray(new String[0]);
		Vector vURL = new Vector();
		Vector vUID = new Vector();
		String uidList = "";
		for(int j=0;key!=null && j<key.length;j++)
		{
			String user = mapUser.get(key[j]).toString();
			if(user.equals("-1"))
				continue;
			QueryUser.getInstance().getPublicUser(user);
			if(uidList.equals(""))
				uidList += "'" + user + "'";
			else
				uidList += "," + "'" + user + "'";
			String postUrl = loadPublicPost(user);
			if(postUrl!=null)
			{
				vURL.add(postUrl);
				vUID.add(user);
			}
		}
		HashMap hmNeedSyncUser = UserFacade.getInstance().loadNeedSyncUser(uidList);
		for(int i=vURL.size()-1;i>=0;i--)
		{
			String uid = vUID.get(i).toString();
			if(hmNeedSyncUser.get(uid)==null)
			{
				vURL.remove(i);
				vUID.remove(i);
			}
		}		
		log.info("##LoadOtherUserPost..." + vURL.size());
		loadPublicPostByLevel(vUID, vURL, 0);
		return -1;
	}
	public void loadPublicPostByLevel(Vector vURL, int level)
	{
		loadPublicPostByLevel(null, vURL, level);
	}
	public void loadPublicPostByLevel(Vector vUID, Vector vURL, int level)
	{
		log.debug("**loadPublicPost@Level("+level+")");
		if(vURL==null || level>MAX_LEVEL)
			return;
		Vector v = new Vector();
		for(int i=0;i<vURL.size();i++)
		{
			if(vUID!=null)
			{
				String uid = vUID.get(i).toString();
				UserFacade.getInstance().refreshSyncTime(uid);
			}
			String url = (String)vURL.get(i);
			String nextPage = loadPublicPostByPaging(url);
			if(nextPage!=null)
				v.add(nextPage);
		}
		loadPublicPostByLevel(v, level+1);
	}
	public int loadCurrentUser()
	{
		String fql = "SELECT uid, username, name, pic_small, pic_big, pic_square, pic, birthday_date, sex, hometown_location, current_location, is_app_user, locale, email FROM user WHERE uid =me() or uid in ("+getFQL_Friends()+")";
		String url = FACEBOOK_FQL + buildParam(true, "access_token", access_token) + buildParam("q", fql);
		String response = URLConnect.response(url).toString();
		UserParser parser = new UserParser();
		parser.parse(response);
		ArrayList<User> list = parser.get();
		System.out.println("total size of User: " + list.size());
		Vector vURL = new Vector();
		Vector vUID = new Vector();
		String uidList = "";
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
			if(uidList.equals(""))
				uidList += "'" + list.get(i).getUid() + "'";
			else
				uidList += "," + "'" + list.get(i).getUid() + "'";
			String postUrl = loadPublicPost(s);
			if(postUrl!=null)
			{
				vURL.add(postUrl);
				vUID.add(""+list.get(i).getUid());
			}			
		}
		HashMap hmNeedSyncUser = UserFacade.getInstance().loadNeedSyncUser(uidList);
		for(int i=vURL.size()-1;i>=0;i--)
		{
			String uid = vUID.get(i).toString();
			if(hmNeedSyncUser.get(uid)==null)
			{
				vURL.remove(i);
				vUID.remove(i);
			}
		}
		log.info("@loadCurrentUser.vURL.size()=" + vURL.size());
		loadPublicPostByLevel(vUID, vURL, 0);
		return -1;
	}
	public String loadPublicPostByPaging(String url)
	{
		try
		{
//			Thread.sleep(700);
		}
		catch(Exception e){}
		String response = URLConnect.response(url).toString();	
		final PostParser parser = new PostParser();
		parser.parse(response);
		//
		/*
		if(parser.getNextPageURL()!=null)
		{
//			synchronized(lock)
			{
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
		*/
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
				System.out.println("####" + type);
				if(!isActiveUser(list.get(i).getCreated_time()))
				{
					//TODO: set as non-activeUser
					System.out.println("Not activeUser");
					return null;
//					break;
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
				{
					System.out.println("Old....");
					return null;
//					break;
				}
				Stream stream = list.get(i).getStream();
				StreamFacade.getInstance().add(stream);
			}
		}
		if(list.size()<200)
			return null;
		return parser.getNextPageURL();
	}
	public String loadPublicPost(String objectId)
	{
		String url = FACEBOOK_GRAPH_API + "/" + objectId + "/posts" + buildParam(true, "access_token", access_token) + buildParam("limit", "200");
		return url;
//		loadPublicPostByPaging(url);
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
//		cal.add(Calendar.YEAR, -1);
		cal.add(Calendar.YEAR, -1);
		if(cal.getTimeInMillis()>created_time)
			return true;
		return false;
	}
	public static void main(String args[])
	{
		System.out.println("##########################args.length: " + args.length);
		if(args.length>0)
			MAX_LEVEL = Integer.parseInt(args[0]);
		ArrayList alAccessToken = new ArrayList();
		boolean fDoOthers = false;
		if(args.length>1)
			fDoOthers = (new Boolean(args[1])).booleanValue();
		if(args.length>2)
		{
			HashMap hm = new HashMap();
			hm.put("access_token", args[2]);
			alAccessToken.add(hm);
		}
		if(args.length<=2)
		{
			alAccessToken = UserFacade.getInstance().loadAppUser();
			for(int i=0;i<alAccessToken.size();i++)
			{
				HashMap hm = (HashMap)alAccessToken.get(i);
				String access_token = (String)hm.get("access_token");
				QueryPost qp = new QueryPost(access_token);
				long startTime = System.currentTimeMillis();
				qp.loadCurrentUser();
				long processTime = System.currentTimeMillis() - startTime;
				log.info("##loadCurrentUser() processTime: " + processTime + "(ms)");				
				if(fDoOthers)
				{
					startTime = System.currentTimeMillis();
					qp.loadOtherUserPost();
					processTime = System.currentTimeMillis() - startTime;
					log.info("##loadOtherUserPost() processTime: " + processTime + "(ms)");
				}
			}
		}
	}
}