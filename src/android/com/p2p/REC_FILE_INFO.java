package com.p2p;

import java.util.Arrays;

//CHAR  chStartTime[32];
//CHAR  chEndTime[32];
//CHAR  nRecType;
//CHAR  reserve[7];
//INT32 nTimeLen_sec;		//unit: second, record file playback time
//INT32 nFileSize_KB;		//unit: KBytes, record file size in byte
//CHAR  chFilePath[120];

public class REC_FILE_INFO {
	public static int MY_LEN =200;

	byte[]	byt_chStartTime= new byte[32];
	byte[]	byt_chEndTime  = new byte[32];
	byte	byt_nRecType   = (byte)0;
	//reserve[7]
	byte[] byt_nTimeLen_sec = new byte[4];
	byte[] byt_nFileSize_KB = new byte[4];
	byte[] byt_chFilePath = new byte[120];
	
	public REC_FILE_INFO(byte[] data, int nOffset) {
		reset();
		if(data.length<MY_LEN) return;

		System.arraycopy(data, nOffset, byt_chStartTime, 0, byt_chStartTime.length);
		System.arraycopy(data, nOffset+32, byt_chEndTime , 0, byt_chEndTime.length);
		byt_nRecType=data[nOffset+64];
		System.arraycopy(data, nOffset+72, byt_nTimeLen_sec , 0,byt_nTimeLen_sec.length);
		System.arraycopy(data, nOffset+76, byt_nFileSize_KB, 0, byt_nFileSize_KB.length);
		System.arraycopy(data, nOffset+80, byt_chFilePath, 0, byt_chFilePath.length);
	}
	
	private void reset(){
		Arrays.fill(byt_chStartTime,(byte)0);
		Arrays.fill(byt_chEndTime,	(byte)0);
		Arrays.fill(byt_nTimeLen_sec, (byte)0);
		Arrays.fill(byt_nFileSize_KB, (byte)0);
		Arrays.fill(byt_chFilePath,	  (byte)0);
	}

	public String getchStartTime() {
		if(byt_chStartTime[0] == (byte)0) return "";
		else return Convert.bytesToString(byt_chStartTime);
	}
	public String getchEndTime() {
		if(byt_chEndTime[0] == (byte)0) return "";
		else return Convert.bytesToString(byt_chEndTime);
	}
	
	public int getchnRecType(){
		return byt_nRecType&0xFF;
	}
	public int getnTimeLen_sec(){
		return Convert.byteArrayToInt_Little(byt_nTimeLen_sec);
	}
	public int getnFileSize_KB(){
		return Convert.byteArrayToInt_Little(byt_nFileSize_KB);
	}
	public String getchFilePath(){
		if(byt_chFilePath[0] == (byte)0) return "";
		else return Convert.bytesToString(byt_chFilePath);
	}
}
