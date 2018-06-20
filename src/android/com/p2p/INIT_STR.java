package com.p2p;

public class INIT_STR {
//	c/c++ struct	
//	typedef struct stInitStr
//	{
//		CHAR chPrefix[8];
//		CHAR chInitStr[256];
//	}ST_InitStr;

	private String chPrefix =null;
	private String chInitStr=null;
	
	public INIT_STR(){}
	public INIT_STR(String chPrefix, String chInitStr)
	{
		this.chPrefix=chPrefix;
		this.chInitStr=chInitStr;
	}
	
	public String getChPrefix() {
		return chPrefix;
	}
	public void setChPrefix(String chPrefix) {
		this.chPrefix = chPrefix;
	}
	public String getChInitStr() {
		return chInitStr;
	}
	public void setChInitStr(String chInitStr) {
		this.chInitStr = chInitStr;
	}
}
