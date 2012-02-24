package org.gagia.web.facade;

import java.util.ArrayList;
import java.util.HashMap;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import tw.qing.lwdba.DBFacade;
import tw.qing.lwdba.SQLString;
import tw.qing.sys.StringManager;

import org.gagia.core.util.SQLOrder;
import org.gagia.web.util.CountryLookup;

public class VideoFacade extends DBFacade
{
	private static Logger log = Logger.getLogger(VideoFacade.class);
	private static VideoFacade instance = null;

	public static synchronized VideoFacade getInstance()
	{
		if(instance==null)
		{
			try
			{
				instance = new VideoFacade();
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
		}
		return instance;
	}
	private VideoFacade() throws SQLException, ClassNotFoundException
	{
		super(StringManager.getManager("system").getString("mode"));
	}
	//
	public long getTotalSize(String category)
	{
		try
		{
			ArrayList list = new ArrayList();
			String sql = sqlManager.getSQL("video.count");
			if(category!=null)
				sql = sqlManager.getSQL("video.countByCategory", category);
			list = sqlQueryRows(sql);
			if(list!=null && list.size()>0)
			{
				HashMap hm = (HashMap)list.get(0);
				return Long.parseLong(hm.get("n").toString());
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			return -1;
		}		
		return 0;
	}
	public long getPersonalTotalSize(String access_token, String category)
	{
		try
		{
			ArrayList list = new ArrayList();
			String user_id_list = UserFacade.getInstance().getMeAndFriends(access_token);
			if(user_id_list.equals(""))
				return 0;
			String sql = sqlManager.getSQL("video.personal.count", new SQLString(user_id_list));
			if(category!=null)
				sql = sqlManager.getSQL("video.personal.countByCategory", new SQLString(user_id_list), category);
			list = sqlQueryRows(sql);
			if(list!=null && list.size()>0)
			{
				HashMap hm = (HashMap)list.get(0);
				return Long.parseLong(hm.get("n").toString());
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			return -1;
		}
		return 0;
	}
	public long getRegionalTotalSize(String ip, String category)
	{
		try
		{
			ArrayList list = new ArrayList();
			String countryName = CountryLookup.getInstance().getCountryName(ip);
			countryName = countryName==null||countryName.equals("N/A")?"United States":countryName;
			String sql = sqlManager.getSQL("video.regional.count", countryName);
			if(category!=null)
				sql = sqlManager.getSQL("video.regional.countByCategory", countryName, category);
			list = sqlQueryRows(sql);
			if(list!=null && list.size()>0)
			{
				HashMap hm = (HashMap)list.get(0);
				return Long.parseLong(hm.get("n").toString());
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			return -1;
		}
		return 0;
	}
	public ArrayList listVideo(String orderColumn, SQLOrder.Sort orderType)
	{
		ArrayList list = new ArrayList();
		try
		{
			String sql = sqlManager.getSQL("video.list", new SQLOrder(orderColumn, orderType).toSQLString());
			list = sqlQueryRows(sql);
			return list;			
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return new ArrayList();
	}
	public ArrayList listVideo(String orderColumn, SQLOrder.Sort orderType, int offset)
	{
		ArrayList list = new ArrayList();
		try
		{
			String sql = sqlManager.getSQL("video.listByPaging", new SQLOrder(orderColumn, orderType).toSQLString(), new Integer(offset));
			list = sqlQueryRows(sql);
			return list;			
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return new ArrayList();
	}
	public ArrayList listVideo(String orderColumn, SQLOrder.Sort orderType, int offset, long timestamp, String category)
	{
		ArrayList list = new ArrayList();
		try
		{
			String operator = ">=";
			if(offset<0)
				operator = "<=";
			String sql = sqlManager.getSQL("video.listByPagingAndTime", new SQLString(" and max_created_time " + operator + " " + timestamp), new SQLOrder(orderColumn, orderType).toSQLString(), new Integer(Math.abs(offset)));
			if(category!=null)
				sql = sqlManager.getSQL("video.listByPagingTimeAndCategory", new Object[]{new SQLString(" and max_created_time " + operator + " " + timestamp), new SQLOrder(orderColumn, orderType).toSQLString(), new Integer(Math.abs(offset)), category});
			list = sqlQueryRows(sql);
			if(list!=null)
				return list;	
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return new ArrayList();
	}
	public ArrayList listRegionalVideo(String orderColumn, SQLOrder.Sort orderType, int offset, long timestamp, String ip, String category)
	{
		ArrayList list = new ArrayList();
		try
		{
			String operator = ">=";
			if(offset<0)
				operator = "<=";
			String countryName = CountryLookup.getInstance().getCountryName(ip);
			countryName = countryName==null||countryName.equals("N/A")?"United States":countryName;
			//
			String sql = sqlManager.getSQL("video.regional.listByPagingAndTime", new Object[]{new SQLString(" and max_created_time " + operator + " " + timestamp), new SQLOrder(orderColumn, orderType).toSQLString(), new Integer(Math.abs(offset)), countryName});
			if(category!=null)
				sql = sqlManager.getSQL("video.regional.listByPagingTimeAndCategory", new Object[]{new SQLString(" and max_created_time " + operator + " " + timestamp), new SQLOrder(orderColumn, orderType).toSQLString(), new Integer(Math.abs(offset)), countryName, category});
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
	public ArrayList listPersonalVideo(String orderColumn, SQLOrder.Sort orderType, int offset, long timestamp, String access_token, String category)
	{
		ArrayList list = new ArrayList();
		try
		{
			String user_id_list = UserFacade.getInstance().getMeAndFriends(access_token);
			if(user_id_list.equals(""))
				return list;
			//
			String operator = ">=";
			if(offset<0)
				operator = "<=";
			String sql = sqlManager.getSQL("video.personal.listByPagingAndTime", new Object[]{new SQLString(" and max_created_time " + operator + " " + timestamp), new SQLOrder(orderColumn, orderType).toSQLString(), new Integer(Math.abs(offset)), new SQLString(user_id_list)});
			if(category!=null)
				sql = sqlManager.getSQL("video.personal.listByPagingTimeAndCategory", new Object[]{new SQLString(" and max_created_time " + operator + " " + timestamp), new SQLOrder(orderColumn, orderType).toSQLString(), new Integer(Math.abs(offset)), new SQLString(user_id_list), category});
			list = sqlQueryRows(sql);
			if(list!=null)
				return list;	
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return new ArrayList();
	}
	public ArrayList listStream(String video_id)
	{
		ArrayList list = new ArrayList();
		try
		{
			String sql = sqlManager.getSQL("stream.list", video_id);
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
	public ArrayList listCategory()
	{
		ArrayList list = new ArrayList();
		try
		{
			String sql = sqlManager.getSQL("category.list");
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
	public ArrayList listCategoryAtPersonal(String access_token)
	{
		ArrayList list = new ArrayList();
		try
		{
			String user_id_list = UserFacade.getInstance().getMeAndFriends(access_token);
			if(user_id_list.equals(""))
				return list;			
			String sql = sqlManager.getSQL("category.personal.list", new SQLString(user_id_list));
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
	public ArrayList listCategoryAtRegional(String ip)
	{
		ArrayList list = new ArrayList();
		try
		{
			String countryName = CountryLookup.getInstance().getCountryName(ip);
			countryName = countryName==null||countryName.equals("N/A")?"United States":countryName;
			String sql = sqlManager.getSQL("category.regional.list", countryName);
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
}