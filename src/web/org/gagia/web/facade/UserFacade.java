package org.gagia.web.facade;

import java.util.ArrayList;
import java.util.HashMap;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import tw.qing.lwdba.DBFacade;
import tw.qing.sys.StringManager;
import tw.qing.lwdba.SQLString;

import org.gagia.core.util.SQLOrder;
import org.gagia.core.dao.User;

public class UserFacade extends DBFacade
{
	private static Logger log = Logger.getLogger(UserFacade.class);
	private static UserFacade instance = null;

	public static synchronized UserFacade getInstance()
	{
		if(instance==null)
		{
			try
			{
				instance = new UserFacade();
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
		}
		return instance;
	}
	private UserFacade() throws SQLException, ClassNotFoundException
	{
		super(StringManager.getManager("system").getString("mode"));
	}
	//
	public boolean exists(String user_id)
	{
		boolean fExist = false;
		try
		{
			String sql = sqlManager.getSQL("user.exist", user_id);
			ArrayList list = sqlQueryRows(sql);
			if(list!=null && list.size()>0)
				fExist = true;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return fExist;
	}
	public boolean checkToken(String access_token)
	{
		boolean fExist = false;
		try
		{
			String sql = sqlManager.getSQL("user.getByToken", access_token);
			ArrayList list = sqlQueryRows(sql);
			if(list!=null && list.size()>0)
				fExist = true;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return fExist;
	}
	public ArrayList loadUserId()
	{
		ArrayList list = new ArrayList();
		try
		{
			String sql = sqlManager.getSQL("user.loadId");
			list = sqlQueryRows(sql);
			return list;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return list;
	}
	
	public boolean add(User user)
	{
		boolean fSuccess = add(new Object[]{user.getUid(), user.getName(), user.getFirst_name(), user.getMiddle_name(), user.getLast_name(), user.getGender(), user.getLocale(), user.getLink()});
		if(fSuccess)
		{
			if(user.getCountry()!=null)
			{
				try
				{
					String sql = sqlManager.getSQL("user.update", user.getUid(), new SQLString("country='"+user.getCountry()+"'"));
					sqlUpdate(sql);
				}
				catch(Exception e)
				{
					e.printStackTrace();
				}
			}
		}
		return fSuccess;
	}
	public boolean add(Object[] param)
	{
		boolean fSuccess = false;
		try
		{
			String sql = sqlManager.getSQL("user.add", param);
			sqlUpdate(sql);
			fSuccess = true;
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return fSuccess;
	}		
	public boolean update(String user_id, String access_token)
	{
		boolean fSuccess = false;
		try
		{
			ArrayList list = new ArrayList();
			String sql = sqlManager.getSQL("user.updateToken", user_id, access_token);
			sqlUpdate(sql);
			fSuccess = true;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}		
		return fSuccess;
	}
	public boolean addFriends(String user_id, String friendList)
	{
		boolean fSuccess = false;
		try
		{
			String sql = sqlManager.getSQL("user.addFriends", user_id, friendList);
			sqlUpdate(sql);
			fSuccess = true;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return fSuccess;
	}
	public String getMeAndFriends(String access_token)
	{
		String user_ids = "";
		try
		{
			String sql = sqlManager.getSQL("user.getFriends", access_token);
			ArrayList list = sqlQueryRows(sql);
			if(list!=null && list.size()>0)
			{
				HashMap hm = (HashMap)list.get(0);
				String uid = hm.get("user_id").toString();
				String friends = hm.get("friend_id_list").toString();
				user_ids = uid + "," + friends;
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return user_ids;
	}
}