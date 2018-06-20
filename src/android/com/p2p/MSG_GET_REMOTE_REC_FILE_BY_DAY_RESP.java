package com.p2p;

import java.util.Arrays;

public class MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP {
	public static int MY_LEN =24;

	byte[] byt_nResult = new byte[4];
	byte[] byt_nFileTotalNum = new byte[4];
	byte[] byt_nBeginNoOfThisTime = new byte[4];
	byte[] byt_nEndNoOfThisTime = new byte[4];
	
	public MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP(byte[] data){
		reset();
		if(data.length<MY_LEN) return;
		System.arraycopy(data, 0, byt_nResult, 0, byt_nResult.length);
		System.arraycopy(data, 4, byt_nFileTotalNum, 0, byt_nFileTotalNum.length);
		System.arraycopy(data, 8, byt_nBeginNoOfThisTime, 0, byt_nBeginNoOfThisTime.length);
		System.arraycopy(data, 12,byt_nEndNoOfThisTime, 0, byt_nEndNoOfThisTime.length);
	}
	
	public void reset(){
		Arrays.fill(byt_nResult, (byte)0);
		Arrays.fill(byt_nFileTotalNum, (byte)0);
		Arrays.fill(byt_nBeginNoOfThisTime, (byte)0);
		Arrays.fill(byt_nEndNoOfThisTime, (byte)0);
	}

	public int getnEndNoOfThisTime(){
		return Convert.byteArrayToInt_Little(byt_nEndNoOfThisTime);
	}
	
	public int getnBeginNoOfThisTime(){
		return Convert.byteArrayToInt_Little(byt_nBeginNoOfThisTime);
	}
	
	public int getnFileTotalNum(){
		return Convert.byteArrayToInt_Little(byt_nFileTotalNum);
	}
	
	public int getnResult(){
		return Convert.byteArrayToInt_Little(byt_nResult);
	}
}
