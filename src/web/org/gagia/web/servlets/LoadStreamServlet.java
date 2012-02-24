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

public class LoadStreamServlet extends HttpServlet
{
	private static Logger log = Logger.getLogger(LoadStreamServlet.class);
	private final int PAGING_SIZE = 50;
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
			String video_id = request.getParameter("vid");
			//
			ArrayList list = VideoFacade.getInstance().listStream(video_id);
			//System.out.println(list);
			JSONObject output = new JSONObject();
			JSONArray jsa = new JSONArray((HashMap[])list.toArray(new HashMap[0]));
			output.put("stream", jsa);
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