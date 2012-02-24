package org.gagia.core.parser;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import org.gagia.core.dao.Post;

public class PostParser extends Parser<org.gagia.core.dao.Post>
{
	public Post toDAO(JSONObject jso)
	{
		Post dao = new Post(jso);
		return dao;
	}
}