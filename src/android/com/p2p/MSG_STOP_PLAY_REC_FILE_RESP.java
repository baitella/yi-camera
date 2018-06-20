package com.p2p;

import java.util.Arrays;

//CHAR  nResult;		//0:OK; 
//CHAR  reserve[15];
//CHAR  chFilePath[120];

public class MSG_STOP_PLAY_REC_FILE_RESP {
	public static final int MY_LEN = 136;

	byte  byt_nResult = (byte)1;
	byte[] byt_chFilePath = new byte[120];
	public MSG_STOP_PLAY_REC_FILE_RESP(byte[]data){
		reset();
		byt_nResult=data[0];
		System.arraycopy(data, 16, byt_chFilePath, 0, byt_chFilePath.length);
	}
	private void reset(){
		Arrays.fill(byt_chFilePath, (byte)0);
	}
	public int getnResult() {
		return (int)(byt_nResult&0xFF);
	}
	public String getStr_chFilePath() {
		if(byt_chFilePath[0] == (byte)0) return "";
		else return Convert.bytesToString(byt_chFilePath);
	}
}
