package org.gagia.demo;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Set;
import java.util.Vector;

import org.apache.log4j.Logger;
//
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;
//
import org.gagia.core.net.URLConnect;
import org.gagia.demo.facade.StreamFacade;

public class GetVideoInfo
{
	private static final Logger log = Logger.getLogger(GetVideoInfo.class);
	private static final String YOUTUBE_DATA_API = "https://gdata.youtube.com/feeds/api";
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
	public void getVideo(String video_id)
	{
		try
		{
			String url = YOUTUBE_DATA_API + "/videos/" + video_id + buildParam(true, "v", "2") + buildParam("alt", "json");
			String response = URLConnect.response(url).toString();
			JSONObject jso = new JSONObject(response);
			if(jso.has("entry"))
			{
				String label = null;
				int duration = -1;
				jso = jso.getJSONObject("entry");
				if(jso.has("category"))
				{
					JSONArray jsa = jso.getJSONArray("category");
					for(int i=0;i<jsa.length();i++)
					{
						JSONObject jsoCate = jsa.optJSONObject(i);
						if(jsoCate!=null)
						{
							if(jsoCate.has("label"))
							{
								label = jsoCate.optString("label");
								break;
							}
						}
					}
				}
				//
				if(jso.has("media$group"))
				{
					jso = jso.getJSONObject("media$group");
					if(jso.has("yt$duration"))
					{
						jso = jso.getJSONObject("yt$duration");
						if(jso.has("seconds"))
							duration = jso.optInt("seconds");
					}
				}
				System.out.println("label: "+ label + ", duration: " + duration);
				StreamFacade.getInstance().updateVideoInfo(video_id, label, duration);
			}
		}
		catch(JSONException jse)
		{
			jse.printStackTrace();
			StreamFacade.getInstance().updateVideoStatus(video_id, -1);
		}
		catch(Exception e)
		{
			e.printStackTrace();
			StreamFacade.getInstance().updateVideoStatus(video_id, 0);
		}
	}
	public static void main(String args[])
	{
		final GetVideoInfo vi = new GetVideoInfo();
		if(args.length>0)
		{
			vi.getVideo(args[0]);
		}
		else
		{
			ArrayList list = StreamFacade.getInstance().loadVideoIds(false);
			for(int i=0;list!=null && i<list.size();i++)
			{
				HashMap hm = (HashMap)list.get(i);
				final String vid = hm.get("key").toString();
				try
				{
					Thread.sleep((int)Math.random()*500*6);
				}
				catch(Exception e){}
				vi.getVideo(vid);
			}
		}
	}
}