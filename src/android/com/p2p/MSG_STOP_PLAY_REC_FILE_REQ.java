package com.p2p;

import java.util.Arrays;


//CHAR  reserve[16];
//CHAR  chFilePath[120];
public class MSG_STOP_PLAY_REC_FILE_REQ {
	public static final int MY_LEN = 136;

	public static byte[] toBytes(String chFilePath) {
		byte [] byts = new byte[MY_LEN];
		byte[] byt_chFilePath = chFilePath.getBytes();
		Arrays.fill(byts, (byte)0);
		System.arraycopy(byt_chFilePath, 0, byts, 16, byt_chFilePath.length);
		return byts;
	}
}
