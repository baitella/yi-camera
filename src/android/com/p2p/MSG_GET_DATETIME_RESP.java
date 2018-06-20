package com.p2p;

import java.util.Arrays;

public class MSG_GET_DATETIME_RESP {
	//int nSecToNow; //[date timeIntervalSince1970], To MSG_SET_DATETIME_REQ: it used to calibrate the device time if its value is NOT zero. 
    //int nSecTimeZone; //time interval from GMT in second, e.g.:28800 seconds is GMT+08; -28800 seconds is GMT-08 
    //int bEnableNTP; //0->disable; 1->enable 

    byte[] byt_nsecTonow 	= new byte[4];
    byte[] byt_nsecTimezone = new byte[4];
    byte[] byt_benablentp 	= new byte[4];
    byte[] chNTPServer 		= new byte[64];
    byte[] byt_nIndexTimeZoneTable=new byte[4];
	
    public MSG_GET_DATETIME_RESP (byte[] data) {
    	
    	Arrays.fill(byt_nsecTonow, (byte)0);
    	Arrays.fill(byt_nsecTimezone, (byte)0);
    	Arrays.fill(byt_benablentp, (byte)0);
    	Arrays.fill(chNTPServer, (byte)0);
    	Arrays.fill(byt_nIndexTimeZoneTable, (byte)0);
    	
    	System.arraycopy(data, 0, byt_nsecTonow, 0, byt_nsecTonow.length);
		System.arraycopy(data, 4, byt_nsecTimezone, 0, byt_nsecTimezone.length);
		System.arraycopy(data, 8, byt_benablentp, 0, byt_benablentp.length);
		System.arraycopy(data, 12, chNTPServer, 0, chNTPServer.length);
		System.arraycopy(data, 76, byt_nIndexTimeZoneTable, 0, byt_nIndexTimeZoneTable.length);
    }
    
    public int getnSecToNow(){
    	if(byt_nsecTonow == null)  return 0;
    	else return Convert.byteArrayToInt_Little(byt_nsecTonow);
    }
    
    public int getnSecTimeZone(){
    	if(byt_nsecTimezone == null)  return 0;
    	else return Convert.byteArrayToInt_Little(byt_nsecTimezone);
    }
    
    public int getbEnableNTP(){
    	if(byt_benablentp == null)  return 0;
    	else return Convert.byteArrayToInt_Little(byt_benablentp);
    }
    
    public String getntpServer(){
    	if(chNTPServer == null) return "";
    	else return Convert.bytesToString(chNTPServer);
    }
    
    public int getIndexTimeZoneTable(){
    	if(byt_nIndexTimeZoneTable== null) return -1;
    	else return Convert.byteArrayToInt_Little(byt_nIndexTimeZoneTable);
    }
}
