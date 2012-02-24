package org.gagia.core.dao;

import org.json.JSONArray;
import org.json.JSONObject;

public class User
{
	private long uid;
	private String first_name;
	private String middle_name;
	private String last_name;
	private String username;
	private String name;
	private String link;
	private String gender;	//M/F
	private String pic_small;
	private String pic_big;
	private String pic_square;
	private String pic;
	private String birthday_date;	//MM/DD/YYYY
	private String sex;
	private String hometown_location;
	private String current_location;
	private String country;
	private boolean is_app_user;
	private String locale;
	private String email;
	//
	public User(JSONObject jso)
	{
		uid = jso.optLong("id", -1);
		if(uid==-1)
			uid = jso.optLong("uid");
		name = jso.optString("name");
		first_name = jso.optString("first_name");
		middle_name = jso.optString("middle_name");
		last_name = jso.optString("last_name");
		link = jso.optString("link");
		if(jso.optString("gender", "").equals(""))
		   setSex(jso.optString("sex"));
		else
			setSex(jso.optString("gender"));
		locale = jso.optString("locale");
		//
		username = jso.optString("username");
		name = jso.optString("name");
		pic_small = jso.optString("pic_small");
		pic_big = jso.optString("pic_big");
		pic_square = jso.optString("pic_square");
		pic = jso.optString("pic");
		birthday_date = jso.optString("birthday_date");
		hometown_location = jso.optString("hometown_location");
		if(jso.has("hometown_location"))
		{
			try
			{
				Object oLocation = jso.get("hometown_location");
				if(oLocation instanceof JSONObject)
				{
					JSONObject jsoLocation = (JSONObject)oLocation;
					country = jsoLocation.optString("country");
				}
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}
		if(jso.has("current_location"))
		{
			try
			{
				Object oLocation = jso.get("current_location");
				if(oLocation instanceof JSONObject)
				{
					if(country ==null || "".equals(country))
					{
						JSONObject jsoLocation = (JSONObject)oLocation;
						country = jsoLocation.optString("country");
					}
				}
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}
		current_location = jso.optString("current_location");
		is_app_user = jso.optBoolean("is_app_user");
		email = jso.optString("email");
		
	}
	public void setUid(long uid)
	{
		this.uid = uid;
	}
	public long getUid()
	{
		return uid;
	}
	public void setFirst_name(String first_name)
	{
		this.first_name = first_name;
	}
	public String getFirst_name()
	{
		return first_name;
	}
	public void setMiddle_name(String middle_name)
	{
		this.middle_name = middle_name;
	}
	public String getMiddle_name()
	{
		return middle_name;
	}
	public void setLast_name(String last_name)
	{
		this.last_name = last_name;
	}
	public String getLast_name()
	{
		return last_name;
	}
	public void setUsername(String username)
	{
		this.username = username;
	}
	public String getUsername()
	{
		return username;
	}
	public void setName(String name)
	{
		this.name = name;
	}
	public String getName()
	{
		return name;
	}
	public void setLink(String link)
	{
		this.link = link;
	}
	public String getLink()
	{
		return link;
	}
	public void setPic_small(String pic_small)
	{
		this.pic_small = pic_small;
	}
	public String getPic_small()
	{
		return pic_small;
	}
	public void setPic_big(String pic_big)
	{
		this.pic_big = pic_big;
	}
	public String getPic_big()
	{
		return pic_big;
	}
	public void setPic_square(String pic_square)
	{
		this.pic_square = pic_square;
	}
	public String getPic_square()
	{
		return pic_square;
	}
	public void setPic(String pic)
	{
		this.pic = pic;
	}
	public String getPic()
	{
		return pic;
	}
	public void setBirthday_date(String date)
	{
		birthday_date = date;
	}
	public String getBirthday_date()
	{
		return birthday_date;
	}
	public void setSex(String gender)
	{
		sex = gender;
		if(sex.equals("male"))
			this.gender = "M";
		else if(sex.equals("female"))
			this.gender = "F";
		else {
			this.gender = "";
		}

	}
	public String getSex()
	{
		return sex;
	}
	public String getGender()
	{
		return this.gender;
	}
	public void setHometown_location(String location)
	{
		this.hometown_location = location;
	}
	public String getHometown_location()
	{
		return hometown_location;
	}
	public void setCurrent_location(String current_location)
	{
		this.current_location = current_location;
	}
	public String getCurrent_location()
	{
		return current_location;
	}
	public void setIsAppUser(boolean isAppUser)
	{
		is_app_user = isAppUser;
	}
	public boolean isAppUser()
	{
		return is_app_user;
	}
	public void setLocale(String locale)
	{
		this.locale = locale;
	}
	public String getLocale()
	{
		return locale;
	}
	public void setEmail(String email)
	{
		this.email = email;
	}
	public String getEmail()
	{
		return email;
	}
	public String getCountry()
	{
		return country;
	}
	
	public String toString()
	{
		StringBuffer sb = new StringBuffer();
		sb.append("uid=" + uid);
		sb.append(System.getProperty("line.separator"));		
		sb.append("username=" + username);
		sb.append(System.getProperty("line.separator"));
		sb.append("name=" + name);
		sb.append(System.getProperty("line.separator"));
		sb.append("pic_small=" + pic_small);
		sb.append(System.getProperty("line.separator"));
		sb.append("pic_big=" + pic_big);
		sb.append(System.getProperty("line.separator"));
		sb.append("pic_squre=" + pic_square);
		sb.append(System.getProperty("line.separator"));
		sb.append("pic=" + pic);
		sb.append(System.getProperty("line.separator"));
		sb.append("birthday_date=" + birthday_date);
		sb.append(System.getProperty("line.separator"));
		sb.append("sex=" + sex);
		sb.append(System.getProperty("line.separator"));
		sb.append("hometown_location=" + hometown_location);
		sb.append(System.getProperty("line.separator"));
		sb.append("current_location=" + current_location);
		sb.append(System.getProperty("line.separator"));
		sb.append("country=" + country);
		sb.append(System.getProperty("line.separator"));
		sb.append("is_app_user=" + is_app_user);
		sb.append(System.getProperty("line.separator"));
		sb.append("locale=" + locale);
		sb.append(System.getProperty("line.separator"));
		sb.append("email=" + email);
		sb.append(System.getProperty("line.separator"));
		return sb.toString();
	}
}