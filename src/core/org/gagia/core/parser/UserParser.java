package org.gagia.core.parser;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import org.gagia.core.dao.User;

public class UserParser extends Parser<org.gagia.core.dao.User>
{
	public User toDAO(JSONObject jso)
	{
		User user = new User(jso);
		return user;
	}
}