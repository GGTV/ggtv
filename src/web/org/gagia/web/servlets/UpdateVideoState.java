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

public class UpdateVideoState extends HttpServlet
{
	private static Logger log = Logger.getLogger(LoadVideoServlet.class);
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
//		pw.println("{total:50,totalPage: 10,pagingSize:50, currentPage:1, offset:0, video:[{id:1, thumb:'http://xxx.jpg', title:'1234', url:'aaaa', streamCount:1}]");
//		pw.println("[]");
		response.setContentType("application/json;charset=utf-8");
		PrintWriter pw = response.getWriter();
		try
		{
            String vid = request.getParameter("videoId");
            String valid = request.getParameter("valid");
            String errorCode = request.getParameter("errorCode");
			//
            VideoFacade.getInstance().updateVideoState(vid, valid, errorCode);
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