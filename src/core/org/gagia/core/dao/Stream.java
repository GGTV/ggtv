package org.gagia.core.dao;

import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Stream
{
	private String post_id;
	private long viewer_id;
	private long app_id;
	private long source_id;	//The ID of the user, page, group, or event whose wall the post is on
	private long updated_time;	//The time the post was last updated, which occurs when a user comments on the post, expressed as a Unix timestamp
	private long created_time;	//The time the post was published, expressed as a Unix timestamp
	private String filter_key;
	private String attribution;	//For posts published by apps, the full name of that app
	private String actor_id;	//The ID of the user, page, group, or event that published the post
	private String target_id;	//The user, page, group, or event to whom the post was directed
	private String message;	//The message written in the post
	private String app_data;	//An array of app specific information optionally supplied to create the attachment to the post
	private String action_links;	//An array containing the text and URL for each action link
	private String attachment;	//An array of information about the attachment to the post. This is the attachment that Facebook returns
	private int impressions;
	private String comments;	//An array containing the following information about comments for a post
	private String likes;	//An array containing the following information about likes for the post
	private String privacy;	//The privacy settings for a post
	private String permalink;	//A link to the stream post on Facebook
	private int xid;	//When querying for the feed of a live stream box, this is the xid associated with the Live Stream box (you can provide 'default' if one is not available)
	private String description;
	//
	private String media_alt;
	private String media_thumb;
	private String media_url;
	private String media_source_url;
	private String media_source_type;
	private String media_name;
	private String media_desc;
	private String media_icon;
	//
	private String createdDateTime;
	private String updatedDateTime;
	//
	public Stream()
	{
	}
	public Stream(JSONObject jso)
	{
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try
		{
			post_id = jso.optString("post_id");
			viewer_id = jso.optLong("viewer_id");
			app_id = jso.optLong("app_id");
			source_id = jso.optLong("source_id");
			updated_time = jso.optLong("updated_time");
			created_time = jso.optLong("created_time");
			ParsePosition pp = new ParsePosition(0);
			updatedDateTime = formatter.format(new Date(updated_time*1000));
			createdDateTime = formatter.format(new Date(created_time*1000));
			filter_key = jso.optString("filter_key");
			attribution = jso.optString("attribution");
			actor_id = jso.optString("actor_id");
			target_id = jso.optString("target_id");
			message = jso.optString("message");
			app_data = jso.optString("app_data");
			action_links = jso.optString("action_links");
			JSONObject atta = jso.getJSONObject("attachment");
			if(atta!=null)
			{
				JSONArray media = atta.getJSONArray("media");
				if(media!=null && media.length()>0)
				{
					media_alt = media.getJSONObject(0).optString("alt");
					media_thumb = media.getJSONObject(0).optString("src");
					JSONObject video = media.getJSONObject(0).getJSONObject("video");
					if(video!=null)
					{
						media_url = video.optString("display_url");
						media_source_url = video.optString("source_url");
						media_source_type = video.optString("source_type");
					}
				}
				media_name = atta.optString("name");
				media_desc = atta.optString("description");
				media_icon = atta.optString("icon");
			}
			impressions = jso.optInt("impressions");
			comments = jso.optString("comments");
			//
			likes = jso.optString("likes");
			privacy = jso.optString("privacy");
			permalink = jso.optString("permalink");
			xid = jso.optInt("xid");
			description = jso.optString("description");
		}
		catch(JSONException je)
		{
			je.printStackTrace();
		}
	}
	public void setPost_id(String post_id)
	{
		this.post_id = post_id;
	}
	public String getPost_id()
	{
		return post_id;
	}
	public void setViewer_id(long viewer_id)
	{
		this.viewer_id = viewer_id;
	}
	public long getViewer_id()
	{
		return viewer_id;
	}
	public void setApp_id(long app_id)
	{
		this.app_id = app_id;
	}
	public long getApp_id()
	{
		return app_id;
	}
	public void setSource_id(long sourceId)
	{
		source_id = sourceId;
	}
	public long getSource_id()
	{
		return source_id;
	}
	public void setUpdated_time(long time)
	{
		this.updated_time = time;
	}
	public long getUpdated_time()
	{
		return updated_time;
	}
	public void setCreated_time(long time)
	{
		created_time = time;
	}
	public long getCreated_time()
	{
		return created_time;
	}
	public void setFilter_key(String filter_key)
	{
		this.filter_key = filter_key;
	}
	public String getFilter_key()
	{
		return filter_key;
	}
	public void setAttribute(String attr)
	{
		this.attribution = attr;
	}
	public String getAttribution()
	{
		return attribution;
	}
	public void setActor_id(String id)
	{
		actor_id = id;
	}
	public String getActor_id()
	{
		return actor_id;
	}
	public void setTarget_id(String target_id)
	{
		this.target_id = target_id;
	}
	public String getTarget_id()
	{
		return target_id;
	}
	public void setMessage(String message)
	{
		this.message = message;
	}
	public String getMessage()
	{
		return message;
	}
	public void setApp_data(String app_data)
	{
		this.app_data = app_data;
	}
	public String getApp_data()
	{
		return app_data;
	}
	public void setAction_links(String action_links)
	{
		this.action_links = action_links;
	}
	public String getAction_links()
	{
		return action_links;
	}
	public void setAttachment(String attachment)
	{
		this.attachment = attachment;
	}
	public String getAttachment()
	{
		return attachment;
	}
	public void setImpressions(int impressions)
	{
		this.impressions = impressions;
	}
	public int getImpressions()
	{
		return impressions;
	}
	public void setComments(String comments)
	{
		this.comments = comments;
	}
	public String getComments()
	{
		return comments;
	}
	public void setLikes(String likes)
	{
		this.likes = likes;
	}
	public String getLikes()
	{
		return likes;
	}
	public void setPrivacy(String privacy)
	{
		this.privacy = privacy;
	}
	public String getPrivacy()
	{
		return privacy;
	}
	public void setPermalink(String permalink)
	{
		this.permalink = permalink;
	}
	public String getPermalink()
	{
		return permalink;
	}
	public void setXid(int xid)
	{
		this.xid = xid;
	}
	public int getXid()
	{
		return xid;
	}
	public void setDescription(String desc)
	{
		description = desc;
	}
	public String getDescription()
	{
		return description;
	}
	//
	/*
	 private String media_alt;
	 private String media_thumb;
	 private String media_url;
	 private String media_source_url;
	 private String media_source_type;
	 private String media_name;
	 private String media_desc;
	 private String media_icon;
	 */
	public void setMedia_alt(String alt)
	{
		media_alt = alt;
	}
	public String getMedia_alt()
	{
		return media_alt;
	}
	public void setMedia_thumb(String thumb)
	{
		media_thumb = thumb;
	}
	public String getMedia_thumb()
	{
		return media_thumb;
	}
	public void setMedia_url(String url)
	{
		media_url = url;
	}
	public String getMedia_url()
	{
		return media_url;
	}
	public void setMedia_source_url(String url)
	{
		media_source_url = url;
	}
	public String getMedia_source_url()
	{
		return media_source_url;
	}
	public void setMedia_source_type(String type)
	{
		media_source_type = type;
	}
	public String getMedia_source_type()
	{
		return media_source_type;
	}
	public void setMedia_name(String name)
	{
		media_name = name;
	}
	public String getMedia_name()
	{
		return media_name;
	}
	public void setMedia_desc(String desc)
	{
		media_desc = desc;
	}
	public String getMedia_desc()
	{
		return media_desc;
	}
	public void setMedia_icon(String icon)
	{
		media_icon = icon;
	}
	public String getMedia_icon()
	{
		return media_icon;
	}
	//	
	public String toString()
	{
		StringBuffer sb = new StringBuffer();
		sb.append("***********************************");
		sb.append(System.getProperty("line.separator"));				
		sb.append("post_id=" + post_id);
		sb.append(System.getProperty("line.separator"));		
		sb.append("viewer_id=" + viewer_id);
		sb.append(System.getProperty("line.separator"));
		sb.append("app_id=" + app_id);
		sb.append(System.getProperty("line.separator"));
		sb.append("source_id=" + source_id);
		sb.append(System.getProperty("line.separator"));
		sb.append("updatedDateTime=" + updatedDateTime);
		sb.append(System.getProperty("line.separator"));
		sb.append("createdDateTime=" + createdDateTime);
		sb.append(System.getProperty("line.separator"));
		sb.append("filter_key=" + filter_key);
		sb.append(System.getProperty("line.separator"));
		sb.append("attribution=" + attribution);
		sb.append(System.getProperty("line.separator"));
		sb.append("actor_id=" + actor_id);
		sb.append(System.getProperty("line.separator"));
		sb.append("target_id=" + target_id);
		sb.append(System.getProperty("line.separator"));
		sb.append("app_data=" + app_data);
		sb.append(System.getProperty("line.separator"));
		sb.append("action_links=" + action_links);
		sb.append(System.getProperty("line.separator"));
		sb.append("attachment=" + attachment);
		sb.append(System.getProperty("line.separator"));
		sb.append("impressions=" + impressions);
		sb.append(System.getProperty("line.separator"));
		sb.append("comments=" + comments);
		sb.append(System.getProperty("line.separator"));
		sb.append("likes=" + likes);
		sb.append(System.getProperty("line.separator"));
		sb.append("privacy=" + privacy);
		sb.append(System.getProperty("line.separator"));
		sb.append("permalink=" + permalink);
		sb.append(System.getProperty("line.separator"));
		sb.append("xid=" + xid);
		sb.append(System.getProperty("line.separator"));
		sb.append("description=" + description);
		sb.append(System.getProperty("line.separator"));
		//
		sb.append("media_alt=" + media_alt);
		sb.append(System.getProperty("line.separator"));
		sb.append("media_name=" + media_name);
		sb.append(System.getProperty("line.separator"));
		sb.append("media_thumb=" + media_thumb);
		sb.append(System.getProperty("line.separator"));
		sb.append("media_url=" + media_url);
		sb.append(System.getProperty("line.separator"));
		sb.append("media_source_url=" + media_source_url);
		sb.append(System.getProperty("line.separator"));
		sb.append("media_source_type=" + media_source_type);
		sb.append(System.getProperty("line.separator"));
		sb.append("media_desc=" + media_desc);
		sb.append(System.getProperty("line.separator"));
		sb.append("media_icon=" + media_icon);
		sb.append(System.getProperty("line.separator"));
		
		return sb.toString();
	}
}