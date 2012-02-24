package org.gagia.demo.facade;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

import org.apache.log4j.Logger;

import tw.qing.lwdba.DBFacade;
import tw.qing.lwdba.SQLString;
import tw.qing.sys.StringManager;

import org.gagia.core.dao.User;

public class UserFacade extends DBFacade
{
	private static Logger log = Logger.getLogger(UserFacade.class);
	private static UserFacade instance = null;
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

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
	public boolean add(User user)
	{
		return add(new Object[]{user.getUid(), user.getName(), user.getFirst_name(), user.getMiddle_name(), user.getLast_name(), user.getGender(), user.getLocale(), user.getLink()});
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
	public HashMap loadNeedSyncUser(String uidList)
	{
		HashMap hm = new HashMap();
		try
		{
			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.HOUR, -1);
			String sql = sqlManager.getSQL("user.needSync", new SQLString(uidList), sdf.format(cal.getTime()));
			ArrayList list = sqlQueryRows(sql);
			for(int i=0;list!=null && i<list.size();i++)
			{
				HashMap user = (HashMap)list.get(i);
				hm.put(user.get("id").toString(), user.get("id").toString());
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return hm;
	}
	public boolean refreshSyncTime(String uid)
	{
		boolean fSuccess = false;
		try
		{
			String sql = sqlManager.getSQL("user.refreshSyncTime", uid);
			sqlUpdate(sql);
			fSuccess = true;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return fSuccess;
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
	public ArrayList loadAppUser()
	{
		ArrayList list = new ArrayList();
		try
		{
			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.HOUR, -1);
			String sql = sqlManager.getSQL("user.loadAppUser", sdf.format(cal.getTime()));
			list = sqlQueryRows(sql);
			return list;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return list;
	}
}