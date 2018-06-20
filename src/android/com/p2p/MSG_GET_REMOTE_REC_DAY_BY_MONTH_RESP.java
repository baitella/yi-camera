package com.p2p;

import java.util.Arrays;

//INT32	nYearMon;	//e.g:201412
//INT32	nRecType;	//1:plan record; 2:alarm record; 3:all
//CHAR	chDay[128];	//e.g: "01,02" means that there is record file on the 20141201 and the 20141202
//CHAR    reserve[8];
public class MSG_GET_REMOTE_REC_DAY_BY_MONTH_RESP {
	public static int MY_LEN = 144;

	byte[] byt_nYearMon = new byte[4];
    byte[] byt_nRecType = new byte[4];
    byte[] byt_chDay = new byte[128];
    
	public MSG_GET_REMOTE_REC_DAY_BY_MONTH_RESP(byte[] data) {
	   reset();
	   if(data.length<MY_LEN) return;
       System.arraycopy(data, 0, byt_nYearMon, 0, byt_nYearMon.length);
       System.arraycopy(data, 4, byt_nRecType, 0, byt_nRecType.length);
       System.arraycopy(data, 8, byt_chDay, 0, byt_chDay.length);
	}
	public void reset() {
		Arrays.fill(byt_nYearMon, (byte)0);
		Arrays.fill(byt_nRecType, (byte)0);
		Arrays.fill(byt_chDay, (byte)0);
	}
	public int getnYearMon() {
		return Convert.byteArrayToInt_Little(byt_nYearMon);
	}
	public int getnRecType(){
		return Convert.byteArrayToInt_Little(byt_nRecType);
	}
	public String getnChDay(){
		if(byt_chDay[0] == (byte)0) return "";
		else return Convert.bytesToString(byt_chDay);
	}
}
