package org.gagia.core.util;

import tw.qing.lwdba.SQLString;

public class SQLOrder
{
	public static enum Sort {ASC, DESC};
	//
	private String orderColumn;
	private String orderType;
	//
	public SQLOrder(String column, Sort sort)
	{
		orderColumn = column;
		orderType = sort.toString();
	}
	public static SQLOrder.Sort sort(String sort)
	{
		if(sort == null || (!sort.toLowerCase().equals("asc") && !sort.toLowerCase().equals("desc")))
			return SQLOrder.Sort.ASC;
		if(sort.toLowerCase().equals("asc"))
			return SQLOrder.Sort.ASC;
		else
			return SQLOrder.Sort.DESC;
	}
	public SQLString toSQLString()
	{
		return new SQLString(toString());
	}
	public String toString()
	{
		return " order by " + orderColumn + " " + orderType;
	}
}