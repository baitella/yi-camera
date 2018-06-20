package com.p2p;

import java.util.Arrays;

//CHAR  bOnlyPlayIFrame;
//CHAR  reserve1[3];
//INT32 nBeginPos_sec;	//unit: second
//CHAR  chFilePath[120];
//CHAR  reserve2[8];

public class MSG_START_PLAY_REC_FILE_REQ {
	public static final int MY_LEN = 136;

	public static byte[] toBytes(int bonlyPlayIFrame, int nBeginPos_sec, String chFilePath){
		byte[] byts = new byte[MY_LEN];
		byte[] byt_chFilePath	  = null;
		byte[] byt_nbeginpos_sec  = null;
		Arrays.fill(byts, (byte)0);
		byt_nbeginpos_sec = Convert.intToByteArray_Little(nBeginPos_sec);
		byt_chFilePath = chFilePath.getBytes();
		byts[0] = (byte)bonlyPlayIFrame;
		System.arraycopy(byt_nbeginpos_sec, 0, byts, 4, byt_nbeginpos_sec.length);
		System.arraycopy(byt_chFilePath, 0, byts, 8, byt_chFilePath.length);

		return byts;
	}
}
