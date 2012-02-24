package org.gagia.demo.facade;

import java.util.ArrayList;
import java.util.HashMap;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import tw.qing.lwdba.DBFacade;
import tw.qing.sys.StringManager;

import org.gagia.core.dao.Stream;

public class StreamFacade extends DBFacade
{
	private static Logger log = Logger.getLogger(StreamFacade.class);
	private static StreamFacade instance = null;

	public static synchronized StreamFacade getInstance()
	{
		if(instance==null)
		{
			try
			{
				instance = new StreamFacade();
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
		}
		return instance;
	}
	private StreamFacade() throws SQLException, ClassNotFoundException
	{
		super(StringManager.getManager("system").getString("mode"));
	}
	//
	public synchronized boolean add(Stream stream)
	{
		boolean fSuccess = false;
		try
		{
			int vid = addVideo(stream);
			if(vid>0)
			{
				Object[] param = new Object[]{stream.getPost_id(), stream.getViewer_id(), stream.getApp_id(), stream.getSource_id(), stream.getActor_id(), stream.getTarget_id(), stream.getMessage(), stream.getDescription(), vid, stream.getCreated_time(), stream.getUpdated_time()};
				String sql = sqlManager.getSQL("stream.add", param);
				sqlUpdate(sql);
			}
			fSuccess = true;
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return fSuccess;
	}
	public synchronized int addVideo(Stream stream)
	{
		try
		{
			//http://www.youtube.com/v/B5ss0JX9tA0?version=3&autohide=1&autoplay=1
			String source_url = stream.getMedia_source_url();
			if(source_url==null || source_url.trim().equals(""))
			   return -1;
			//
			String prefix = "http://www.youtube.com/v/";
			String videoId = source_url.substring(source_url.indexOf(prefix) + prefix.length(), source_url.indexOf("?"));
			String sql = sqlManager.getSQL("video.getId", videoId);
			ArrayList al = sqlQueryRows(sql);
			if(al!=null && al.size()>0)
			{
				return Integer.parseInt(((HashMap)al.get(0)).get("id").toString());
			}
			else
			{
				Object[] param = new Object[]{stream.getMedia_url(), stream.getMedia_source_url(), stream.getMedia_name(), stream.getMedia_thumb(), stream.getMedia_source_type(), stream.getMedia_alt(), stream.getMedia_desc(), stream.getMedia_icon(), videoId};
				sql = sqlManager.getSQL("video.add", param);
				sqlUpdate(sql);
				return addVideo(stream);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return -1;
	}
	public ArrayList loadUserFromStream()
	{
		ArrayList list = new ArrayList();
		try
		{
			String sql = sqlManager.getSQL("stream.loadSourceId");
			list = sqlQueryRows(sql);
			if(list!=null)
				return list;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return list;
	}
	public ArrayList loadVideoIds(boolean qHasCategory)
	{
		return loadVideoIds(qHasCategory, 1);
	}
	public ArrayList loadVideoIds(boolean qHasCategory, int valid)
	{
		ArrayList list = new ArrayList();
		try
		{
			String sql = sqlManager.getSQL("video.loadVideoIds_no_cate", valid);
			if(qHasCategory)
				sqlManager.getSQL("video.loadVideoIds_has_cate", valid);
			list = sqlQueryRows(sql);
			if(list!=null)
				return list;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return list;
	}
	public boolean updateVideoStatus(String video_id, int valid)
	{
		boolean fSuccess = false;
		try
		{
			String sql = sqlManager.getSQL("video.updateStatus", video_id, valid);
			sqlUpdate(sql);
			fSuccess = true;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return fSuccess;
	}
	public boolean updateVideoInfo(String video_id, String category, int duration)
	{
		boolean fSuccess = false;
		try
		{
			String sql = sqlManager.getSQL("video.updateInfo", video_id, category, duration);
			sqlUpdate(sql);
			fSuccess = true;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return fSuccess;
	}
}