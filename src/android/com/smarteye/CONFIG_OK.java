package com.smarteye;

import java.util.Arrays;

public class CONFIG_OK {
	/*
	typedef struct tag_ConfigOK{//added on v0.1.0.14
		CHAR szDID[32];  	    //device DID
		CHAR szWiFi_bss[32];    //MAC address of wireless router e.g: 00:26:f2:24:7e:c4
		CHAR szWiFi_ssid[64];   //Wi-Fi SSID
		CHAR szSysFirmVer[24];  //system firmware version
	}CONFIG_OK;
	*/
	public static final int MY_LEN=152;
	
	byte[] bytDID=new byte[32];
	byte[] bytWiFi_bss=new byte[32];
	byte[] bytWiFi_ssid=new byte[64];
	byte[] bytSysFirmVer=new byte[24];
	
	public CONFIG_OK(byte[] bytData){
		reset();
		setData(bytData);
	}
	
	public static final String bytesToString(byte[] byts)
    {
    	String str="";
		int iLen=0;
		if(byts==null||byts.length==0) return str;
		for(iLen=0; iLen<byts.length; iLen++){
			if(byts[iLen]==(byte)0) break;
		}		
		if(iLen==0) str="";
		else str=new String(byts,0,iLen);
		return str;
    }
	
	private void reset(){
		Arrays.fill(bytDID, (byte)0);
		Arrays.fill(bytWiFi_bss, (byte)0);
		Arrays.fill(bytWiFi_ssid, (byte)0);
		Arrays.fill(bytSysFirmVer, (byte)0);
	}
	private void setData(byte[] bytData){
		if(bytData==null || bytData.length<MY_LEN) return;
		int nPos=0;
		System.arraycopy(bytData, nPos, bytDID, 0, bytDID.length); 				nPos+=bytDID.length;
		System.arraycopy(bytData, nPos, bytWiFi_bss, 0, bytWiFi_bss.length); 	nPos+=bytWiFi_bss.length;
		System.arraycopy(bytData, nPos, bytWiFi_ssid, 0, bytWiFi_ssid.length); 	nPos+=bytWiFi_ssid.length;
		System.arraycopy(bytData, nPos, bytSysFirmVer, 0, bytSysFirmVer.length);nPos+=bytSysFirmVer.length;
	}
	
	public String getDID()  	 { return bytesToString(bytDID); 		}
	public String getWiFi_bss()  { return bytesToString(bytWiFi_bss); 	}
	public String getWiFi_ssid() { return bytesToString(bytWiFi_ssid); 	}
	public String getSysFirmVer(){ return bytesToString(bytSysFirmVer); }
	
}
