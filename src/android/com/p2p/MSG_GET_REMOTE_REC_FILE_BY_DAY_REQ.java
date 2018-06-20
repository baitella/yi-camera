package com.p2p;

import java.util.Arrays;

//INT32	nYearMonDay;//e.g:20141201
//INT32	nRecType;	//1:plan record; 2:alarm record; 3:all
//INT32 nBeginNoOfThisTime;	//>=0; want to return the first file index in this time
//INT32 nEndNoOfThisTime;	//>=0 and >=nBeginNoOfThisTime; want to return the last file index in this time
//CHAR	reserve[8];	

public class MSG_GET_REMOTE_REC_FILE_BY_DAY_REQ {
	public static int MY_LEN = 24;

	public static byte[] toBytes(int nYearMonDay,int nRecType,int nBeignNoOfThisTime,int nEndNoOfThisTime){
		byte[] byts = new byte[MY_LEN];
		Arrays.fill(byts, (byte)0);
		byte[] byt_nYearMonDay = null;
		byte[] byt_nRecType = null;
		byte[] byt_nBeginNoOfThisTime = null;
		byte[] byt_nEndNoOfThisTime = null;
		
		byt_nYearMonDay = Convert.intToByteArray_Little(nYearMonDay);
		byt_nRecType	= Convert.intToByteArray_Little(nRecType);
		byt_nBeginNoOfThisTime = Convert.intToByteArray_Little(nBeignNoOfThisTime);
		byt_nEndNoOfThisTime = Convert.intToByteArray_Little(nEndNoOfThisTime);
		
		System.arraycopy(byt_nYearMonDay, 0,byts, 0, byt_nYearMonDay.length);
		System.arraycopy(byt_nRecType, 0,	byts, 4, byt_nRecType.length);
		System.arraycopy(byt_nBeginNoOfThisTime, 0, byts, 8,	byt_nBeginNoOfThisTime.length);
		System.arraycopy(byt_nEndNoOfThisTime,	 0, byts, 12,	byt_nEndNoOfThisTime.length);
		
		return byts;
	}
}
