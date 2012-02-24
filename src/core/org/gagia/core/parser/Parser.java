package org.gagia.core.parser;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
//
public abstract class Parser<V>
{
	private ArrayList<V> list = new ArrayList();
	private String nextPage;
	//
	public void parse(String response)
	{
		if(response == null || response.length()<=0)
			return;
		try {
			JSONObject obj = new JSONObject(response);
			if(obj.has("data"))
			{
				JSONArray jsa = obj.getJSONArray("data");
				for(int i=0;i<jsa.length();i++)
				{
					list.add(toDAO(jsa.getJSONObject(i)));
				}
			}
			if(obj.has("paging") && obj.getJSONObject("paging").has("next"))
			{
				nextPage = obj.getJSONObject("paging").getString("next");
			}			
		}
		catch(JSONException je)
		{
			je.printStackTrace();
			System.out.println("================" + response);
			System.exit(0);
		}
	}
	public V toDAO(JSONObject jso)
	{
		return null;
	}
	public ArrayList<V> get()
	{
		return list;
	}
	public String getNextPageURL()
	{
		return nextPage;
	}
}