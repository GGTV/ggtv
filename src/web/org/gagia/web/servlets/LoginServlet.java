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
import org.gagia.web.facade.UserFacade;
import org.gagia.web.query.QueryUser;

public class LoginServlet extends HttpServlet
{
	private static Logger log = Logger.getLogger(LoginServlet.class);
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
			final String user_id = request.getParameter("uid");
			final String access_token = request.getParameter("token");
			if(access_token!=null)
				request.getSession().setAttribute("access_token", access_token);
			//
			HashMap hm = new HashMap();
			boolean fExist = false;
			if(user_id!=null && !user_id.equals(""))
				fExist = UserFacade.getInstance().exists(user_id);
			else if(access_token!=null)
				fExist = UserFacade.getInstance().checkToken(access_token);
			hm.put("exist", fExist);
//			if(!fExist)
			{
				new Thread()
				{
					public void run()
					{
						if(access_token!=null)
						{
							QueryUser.getInstance().getAuthorizedUser(access_token);
						}
						else if(user_id!=null)
							QueryUser.getInstance().getPublicUser(user_id);
					}
				}.start();
			}
/*			
			else {
				if(access_token!=null)
					UserFacade.getInstance().update(user_id, access_token);
			}
*/
			JSONObject output = new JSONObject(hm);
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