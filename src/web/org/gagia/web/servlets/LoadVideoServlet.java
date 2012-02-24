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
import org.gagia.web.util.UserIPAddress;
import org.gagia.web.facade.VideoFacade;

public class LoadVideoServlet extends HttpServlet
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
			String type = request.getParameter("type")==null?"0":request.getParameter("type");
			String orderColumn = request.getParameter("column");
			String sortType = request.getParameter("order");
			String offsetStr = request.getParameter("offset");
			String timestamp = request.getParameter("timestamp");
			String fakeIP = request.getParameter("ip");
			//
			String category = request.getParameter("cate");
			String access_token = request.getParameter("token")==null?(String)request.getSession().getAttribute("access_token"):request.getParameter("token");
			//
			boolean fOffsetIn = false;
			int offset = -1;
			if(!("0".equals(type) || "1".equals(type) || "2".equals(type)))
			{
				JSONObject jso = new JSONObject("{error: Invalid type value:" + type + "}");
				pw.println(jso.toString());
				pw.flush();
				return;
			}
			if(offsetStr!=null)
			{
				fOffsetIn = true;
				try
				{
					offset = Integer.parseInt(offsetStr);
				}
				catch(NumberFormatException nfe)
				{
					log.debug(nfe.getMessage() + ">> offset=" + offsetStr);
				}
			}
			if(fOffsetIn && offset==-1 && timestamp==null)
			{
				JSONObject jso = new JSONObject("{error:'Invalid offset value:"+offsetStr+"'}");
				pw.println(jso.toString());
				pw.flush();
				return;
			}
			//
			ArrayList list = new ArrayList();
			long total = -1;
			if(timestamp == null)
				list = VideoFacade.getInstance().listVideo(orderColumn, SQLOrder.sort(sortType), offset);
			else {
				if("0".equals(type))
				{
					total = VideoFacade.getInstance().getTotalSize(category);
					list = VideoFacade.getInstance().listVideo(orderColumn, SQLOrder.sort(sortType), offset, Long.parseLong(timestamp), category);
				}
				else if("1".equals(type))
				{
					String userIP = fakeIP!=null?fakeIP:UserIPAddress.get(request);
					total = VideoFacade.getInstance().getRegionalTotalSize(userIP, category);
					list = VideoFacade.getInstance().listRegionalVideo(orderColumn, SQLOrder.sort(sortType), offset, Long.parseLong(timestamp), userIP, category);
				}
				else if("2".equals(type))
				{
					total = VideoFacade.getInstance().getPersonalTotalSize(access_token, category);
					list = VideoFacade.getInstance().listPersonalVideo(orderColumn, SQLOrder.sort(sortType), offset, Long.parseLong(timestamp), access_token, category);
				}
			}

			JSONObject output = new JSONObject();
			JSONArray jsa = new JSONArray((HashMap[])list.toArray(new HashMap[0]));
			if(total == -1)
				total = VideoFacade.getInstance().getTotalSize(category);
			long totalPage = (total % PAGING_SIZE)==0?total/PAGING_SIZE:(total/PAGING_SIZE)+1;
			output.put("total", total);
			output.put("totalPage", totalPage);
			output.put("pagingSize", PAGING_SIZE);
			output.put("offset", offset);
			if(timestamp!=null)
				output.put("timestamp", timestamp);
			output.put("video", jsa);
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