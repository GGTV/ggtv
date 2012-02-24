package org.gagia.demo;

import javax.net.ssl.HttpsURLConnection;
import java.net.*;
import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import org.gagia.core.dao.Stream;
//
import org.gagia.demo.facade.UserFacade;
import org.gagia.demo.facade.StreamFacade;

public class QueryVideo
{
	private boolean fDebug = true;
	//
	private static final Logger log = Logger.getLogger(QueryVideo.class);
	private static String access_token = "AAACZAtmArA28BAIvfzbmnvhjmAgKMOia6XE2s3SkZBdXzvmrvArSmjZA4qABRw3aGRI1hkZCm7kfHlZCtv2qABiu12o3udyAgmmdY9OTPBgZDZD";
	private static final String FACEBOOK_FQL = "https://graph.facebook.com/fql";
	private ArrayList list = new ArrayList();
	//
	public void query()
	{
		ArrayList list = UserFacade.getInstance().loadUserId();
		for(int i=0;list!=null && i<list.size();i++)
		{
			try
			{
				Thread.sleep(1200);
			}
			catch(Exception e){}
			HashMap hm = (HashMap)list.get(i);
			final String uid = hm.get("id").toString();
			new Thread(){
				public void run()
				{
					queryByUser(uid);
				}
			}.start();
			if(fDebug)
				break;
		}
	}
	private void queryByUser(String uid)
	{
		if(fDebug)
			uid = "133726183349444";
		String fql = "SELECT post_id, viewer_id, app_id, source_id, updated_time, created_time, attribution, actor_id, target_id, message, app_data, action_links, attachment, impressions, comments, likes, privacy, xid, tagged_ids, message_tags, description, description_tags FROM stream where source_id="+uid+" and attachment.caption='www.youtube.com'";
		StringBuffer sb = new StringBuffer();
		try
		{
			String params = "q=" + URLEncoder.encode(fql) + "&access_token="+access_token + "&format=json";
			String url = FACEBOOK_FQL + "?" + params;
			sb = getResponse(url);
			JSONObject response = new JSONObject(sb.toString());
			JSONArray data = response.getJSONArray("data");
			if(data!=null)
			{
				for(int i=0;i<data.length();i++)
				{
					Stream stream = new Stream(data.getJSONObject(i));
					log.debug(stream.toString());
					StreamFacade.getInstance().add(stream);
					list.add(stream);
				}
			}
			
		}
		catch(Exception e)
		{
//			e.printStackTrace();
			log.error("response " + sb);
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
		/*
		QueryVideo app = new QueryVideo();
		app.query();
		System.out.println("**************");
		*/
		//String access_token = "AAACZAtmArA28BAOzew56uWZCwK0V0ZCG7AOwaxMMHNUQ0VG1ZCw5ZBo34mnoBr6KjZBlHqMgkmIqAWM1mwzqAnFE0degXZBficZD";
		
		//String access_token = "AAACZAtmArA28BAChCX4mwfJprRVd7qtMMn2PO6k1yNbZAUwLm6ppZCWZCbcOkTDQCgfMoJUZBz2i8GqG6qSZAZBHNH0choaSdQZD";
		//String access_token = "AAACZAtmArA28BACYo74ed4aTIE2WLttm8VRZAu6qmKueMynayQUF9bRM3ekMME8rY3lzehaGrPOBG5WEvx0E9rn8nZAfqkZD";
		String access_token="AAAAAJgXcONwBAFH0zpsOHyvdtP7PSu8osncaId0tpK4PHcD6ACx8YuGZB6tfXTWU46E5zfydrRl7mUxftCnoNssKXdNIZD";
		QueryPost app = new QueryPost(access_token);
		long startTime = System.currentTimeMillis();
//		app.loadCurrentUser();
		long processTime = System.currentTimeMillis() - startTime;
		log.info("##loadCurrentUser() processTime: " + processTime + "(ms)");
		
		startTime = System.currentTimeMillis();
		//app.loadOtherUserPost();
		processTime = System.currentTimeMillis() - startTime;
		log.info("##loadOtherUserPost() processTime: " + processTime + "(ms)");
		String url = app.loadPublicPost("100000246843189");
		Vector v = new Vector();
		v.add(url);
		app.loadPublicPostByLevel(v, 1);
		
	}
}