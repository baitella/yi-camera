package com.p2p;

import java.util.Arrays;

//INT32	nYearMon;	//e.g:201412
//INT32	nRecType;	//1:plan record; 2:alarm record; 3:all
//CHAR	reserve[136];
public class MSG_GET_REMOTE_REC_DAY_BY_MONTH_REQ {
	public static int MY_LEN =144;
	public static byte[] toBytes(int nYearMonDay, int nRecType){
		byte[] byt_nYearMonDay = null;
		byte[] byt_nRecType = null;
		byte[] byts = new byte[MY_LEN];
		Arrays.fill(byts, (byte)0);
		byt_nYearMonDay= Convert.intToByteArray_Little(nYearMonDay);
		byt_nRecType   = Convert.intToByteArray_Little(nRecType);
		System.arraycopy(byt_nYearMonDay, 0, byts, 0, byt_nYearMonDay.length);
		System.arraycopy(byt_nRecType, 0, byts, 4, byt_nRecType.length);
		return byts;
	}
	
}
