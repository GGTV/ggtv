package org.gagia.core.dao;

import java.util.ArrayList;
import java.util.Date;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Vector;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
//
public class Post
{
	//"id,from,to,message,picture,link,name,caption,description,source,properties,icon,actions,type,likes,object_id,created_time,updated_time
	private String id;	//The post ID
	private String post_uid;	//from.id
	private String post_uname;	//from.name
	private String message;	//The message
	private String picture;	//If available, a link to the picture included with this post
	private String link;	//The link attached to this post
	private String name;	//The name of the link
	private String caption;	//The caption of the link (appears beneath the link name)
	private String description;	//A description of the link (appears beneath the link caption)
	private String source;	//A URL to a Flash movie or video file to be embedded within the post
	private String icon;	//A link to an icon representing the type of this post
	private String actions;	//A list of available actions on the post (including commenting, liking, and an optional app-specified action)
	private String type;	//A string indicating the type for this post (including link, photo, video)
	private ArrayList likes;	// a data object and the number of total likes, with data containing an array of objects, each with the name and Facebook id of the user who liked the post
	private String object_id;
	private long created_time;
	private long updated_time;
	//	private String created_time;	//string containing ISO-8601 date-time
	//	private String updated_time;	//string containing ISO-8601 date-time
	//
	private boolean fYouTubeVideo = false;
	//
	private SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ssZ");
	private SimpleDateFormat formatterForDisplay = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	private Stream stream = new Stream();
	//
	private Vector vUserFromResponse = new Vector();
	//
	public Post(JSONObject jso)
	{
		try
		{
			id = jso.getString("id");
			JSONObject from = jso.getJSONObject("from");
			if(from!=null)
			{
				post_uid = from.getString("id");
				post_uname = from.getString("name");
			}
			message = jso.has("message")?jso.optString("message"):null;
			picture = jso.has("picture")?jso.optString("picture"):null;
			link = jso.has("link")?jso.optString("link", "N/A"):null;
			name = jso.optString("name");
			caption = jso.optString("caption");
			if(caption.equals("www.youtube.com"))
				fYouTubeVideo = true;
			description = jso.has("description")?jso.optString("description"):null;
			source = jso.optString("source");
			if(link==null)
				link = generateLink(source);
			icon = jso.optString("icon");
			actions = jso.has("actions")?jso.optString("actions"):null;
			type = jso.getString("type");
			object_id = jso.has("object_id")?jso.getString("object_id"):null;
			if(jso.getString("created_time")!=null)
			{
				created_time = formatter.parse(jso.getString("created_time"), new ParsePosition(0)).getTime();
			}
			if(jso.getString("updated_time")!=null)
			{
				updated_time  = formatter.parse(jso.getString("updated_time"), new ParsePosition(0)).getTime();
			}
			JSONObject jsoComment = jso.has("comments")?jso.getJSONObject("comments"):null;
			if(jsoComment !=null)
			{
				JSONArray jsa = jsoComment.has("data")?jsoComment.getJSONArray("data"):null;
				if(jsa!=null)
				{
					for(int i=0;i<jsa.length();i++)
					{
						try
						{
							String uidStr = jsa.getJSONObject(i).optString("id").replaceAll(id+"_", "");
//							System.out.println("from Post ID~~~~~~~~~~~~~" + id);
//							System.out.println("from Comment~~~~~~~~~~~~~" + uidStr);
							if(!vUserFromResponse.contains(uidStr))
								vUserFromResponse.add(uidStr);
						}
						catch(Exception e)
						{
							e.printStackTrace();
						}
					}
				}
			}
			//
			JSONObject jsolikes = jso.has("likes")?jso.getJSONObject("likes"):null;
			if(jsolikes !=null)
			{
				JSONArray jsa = jsolikes.has("data")?jsolikes.getJSONArray("data"):null;
				if(jsa!=null)
				{
					for(int i=0;i<jsa.length();i++)
					{
						String uidStr = jsa.getJSONObject(i).optString("id");
//						System.out.println("from Likes~~~~~~~~~~~~~" + uidStr);
						if(!vUserFromResponse.contains(uidStr))
							vUserFromResponse.add(uidStr);
					}
				}
			}
		}
		catch(JSONException e)
		{
			e.printStackTrace();
		}
		finally {
			try
			{
				stream.setPost_id(id);
				stream.setSource_id(Long.parseLong(post_uid));
				stream.setMessage(message);
				stream.setDescription(description);
				stream.setCreated_time(created_time/1000);
				stream.setUpdated_time(updated_time/1000);
				stream.setMedia_url(link);
				stream.setMedia_source_url(source);
				stream.setMedia_name(name);
				stream.setMedia_thumb(picture);
				stream.setMedia_icon(icon);			
				stream.setMedia_desc(description);
			}
			catch(Exception e)
			{
				e.printStackTrace();
//				System.exit(0);
			}
		}
	}
	private String generateLink(String url)
	{
		int from = url.indexOf("http://www.youtube.com/v/") + "http://www.youtube.com/v/".length();
		int to = url.indexOf("?");
		if(from!=-1 && to!=-1 && from<=to)
		{
			String video_id = url.substring(from, to);
//			System.out.println("video_id: " + video_id);
			String s = "http://www.youtube.com/watch?v=" + video_id;
			return s;
//			System.out.println(s);
		}
		return "N/A";
	}
	public void setId(String id)
	{
		this.id = id;
	}
	public String getId()
	{
		return id;
	}
	public void setPost_uid(String uid)
	{
		post_uid = uid;
	}
	public String getPost_uid()
	{
		return post_uid;
	}
	public void setPost_uname(String name)
	{
		post_uname = name;
	}
	public String getPost_uname()
	{
		return post_uname;
	}
	public void setMessage(String msg)
	{
		message = msg;
	}
	public String getMessage()
	{
		return message;
	}
	public void setPicture(String pic)
	{
		picture = pic;
	}
	public String getPicture()
	{
		return picture;
	}
	public void setLink(String link)
	{
		this.link = link;
	}
	public String getLink()
	{
		return link;
	}
	public void setName(String name)
	{
		this.name = name;
	}
	public String getName()
	{
		return name;
	}
	public void setCaption(String caption)
	{
		this.caption = caption;
	}
	public String getCaption()
	{
		return caption;
	}
	public void setDescription(String description)
	{
		this.description = description;
	}
	public String getDescription()
	{
		return description;
	}
	public void setSource(String source)
	{
		this.source = source;
	}
	public String getSource()
	{
		return source;
	}
	public void setIcon(String icon)
	{
		this.icon = icon;
	}
	public String getIcon()
	{
		return icon;
	}
	public void setActions(String actions)
	{
		this.actions = actions;
	}
	public String getActions()
	{
		return actions;
	}
	public void setType(String type)
	{
		this.type = type;
	}
	public String getType()
	{
		return type;
	}
	public ArrayList getLikes()
	{
		return likes;
	}
	public void setObject_id(String id)
	{
		object_id = id;
	}
	public String getObject_id()
	{
		return object_id;
	}
	public void setCreated_time(long time)
	{
		created_time = time;
	}
	public long getCreated_time()
	{
		return created_time;
	}
	public void setUpdated_time(long time)
	{
		updated_time = time;
	}
	public long getUpdated_time()
	{
		return updated_time;
	}
	public boolean isYouTubeVideo()
	{
		return fYouTubeVideo;
	}
	public Vector getOtherUser()
	{
		return vUserFromResponse;
	}
	public Stream getStream()
	{
		return stream;
	}
	public String toString()
	{
		StringBuffer sb = new StringBuffer();
		sb.append("***********************************");
		sb.append(System.getProperty("line.separator"));				
		sb.append("id=" + id);
		sb.append(System.getProperty("line.separator"));		
		sb.append("post_uid=" + post_uid);
		sb.append(System.getProperty("line.separator"));
		sb.append("post_uname=" + post_uname);
		sb.append(System.getProperty("line.separator"));
		sb.append("message=" + message);
		sb.append(System.getProperty("line.separator"));
		sb.append("picture=" + picture);
		sb.append(System.getProperty("line.separator"));
		sb.append("link=" + link);
		sb.append(System.getProperty("line.separator"));
		sb.append("name=" + name);
		sb.append(System.getProperty("line.separator"));
		sb.append("caption=" + caption);
		sb.append(System.getProperty("line.separator"));
		sb.append("description=" + description);
		sb.append(System.getProperty("line.separator"));
		sb.append("source=" + source);
		sb.append(System.getProperty("line.separator"));
		sb.append("icon=" + icon);
		sb.append(System.getProperty("line.separator"));
		sb.append("actions=" + actions);
		sb.append(System.getProperty("line.separator"));
		sb.append("type=" + type);
		sb.append(System.getProperty("line.separator"));
		sb.append("likes=" + likes);
		sb.append(System.getProperty("line.separator"));
		sb.append("object_id=" + object_id);
		sb.append(System.getProperty("line.separator"));
		sb.append("created_time=" + created_time);
		sb.append(System.getProperty("line.separator"));
		sb.append("updated_time=" + updated_time);
		sb.append(System.getProperty("line.separator"));
		return sb.toString();
	}
}