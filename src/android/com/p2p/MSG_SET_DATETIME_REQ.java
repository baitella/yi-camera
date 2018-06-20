package com.p2p;

import java.util.Arrays;

public class MSG_SET_DATETIME_REQ {
	public static final int MY_LEN = 80;

	//int nSecToNow; //[date timeIntervalSince1970], To MSG_SET_DATETIME_REQ: it used to calibrate the device time if its value is NOT zero. 
    //int nSecTimeZone; //time interval from GMT in second, e.g.:28800 seconds is GMT+08; -28800 seconds is GMT-08 
    //int bEnableNTP; //0->disable; 1->enable 
    //byte[] chNTPServer = new byte[64]; 
    //int nIndexTimeZoneTable=0;
   
    public static byte[] toBytes(int nSecToNow,int nSecTimeZone,int bEnableNTP,String chNTPServer, int nIndexTimeZoneTable){
		byte[] byts=new byte[MY_LEN];
		Arrays.fill(byts, (byte)0);
		
		byte[] byt_nsecTonow 	= Convert.intToByteArray_Little(nSecToNow);
		byte[] byt_nsecTimezone = Convert.intToByteArray_Little(nSecTimeZone);
		byte[] byt_benablentp 	= Convert.intToByteArray_Little(bEnableNTP);
		byte[] byt_chNTPServer 	= null;
		if(chNTPServer!=null) byt_chNTPServer=chNTPServer.getBytes();
		byte[] byt_nIndexTimeZoneTable 	= Convert.intToByteArray_Little(nIndexTimeZoneTable);
		
	    System.arraycopy(byt_nsecTonow, 0, byts, 0, byt_nsecTonow.length);
	    System.arraycopy(byt_nsecTimezone, 0, byts, 4, byt_nsecTimezone.length);
	    System.arraycopy(byt_benablentp, 0, byts, 8, byt_benablentp.length);
	    if(byt_chNTPServer!=null) System.arraycopy(byt_chNTPServer, 0, byts, 12, byt_chNTPServer.length);
	    System.arraycopy(byt_nIndexTimeZoneTable, 0, byts, 76, byt_nIndexTimeZoneTable.length);
	    
		return byts;
	}
}
