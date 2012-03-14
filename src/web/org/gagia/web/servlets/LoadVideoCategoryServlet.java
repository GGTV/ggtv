package org.gagia.web.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
//
import org.apache.log4j.Logger;
//
import org.json.JSONArray;
import org.json.JSONObject;
//
import org.gagia.core.util.SQLOrder;
import org.gagia.web.facade.VideoFacade;

public class LoadVideoCategoryServlet extends HttpServlet
{
	private static Logger log = Logger.getLogger(LoadVideoCategoryServlet.class);
	//
	public void init(ServletConfig config) throws ServletException
	{
		super.init(config);
	}
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		doPost(request, response);
	}
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		response.setContentType("application/json;charset=utf-8");
		PrintWriter pw = response.getWriter();
		try
		{
			String type = request.getParameter("type")==null?"0":request.getParameter("type");
			//
			String access_token = request.getParameter("token")==null?(String)request.getSession().getAttribute("access_token"):request.getParameter("token");
			//
			if(!("0".equals(type) || "1".equals(type) || "2".equals(type)|| "3".equals(type)))
			{
				JSONObject jso = new JSONObject("{error: Invalid type value:" + type + "}");
				pw.println(jso.toString());
				pw.flush();
				return;
			}
			//
			ArrayList list = new ArrayList();
			if("0".equals(type))
				list = VideoFacade.getInstance().listCategory();
			else if("1".equals(type))
			{
			}
			else if("2".equals(type))
				list = VideoFacade.getInstance().listCategoryAtPersonal(access_token);
			else if("3".equals(type))
				list = VideoFacade.getInstance().listCategoryAtMe(access_token);

			JSONObject output = new JSONObject();
			JSONArray jsa = new JSONArray((HashMap[])list.toArray(new HashMap[0]));
			long total = list.size();
			output.put("total", total);
			output.put("category", jsa);
			//
			pw.println("" + output);
			pw.flush();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		finally {
			pw.close();
		}
	}
}