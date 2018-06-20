package com.p2p;

import java.util.Arrays;

public class MSG_STOP_VIDEO {
	//UCHAR nChannel;
	//CHAR  reserve[15];
	public static final int MY_LEN = 16;
	public static byte[] toBytes(byte nChannel){
		byte[] byts = new byte[MY_LEN];
		Arrays.fill(byts,(byte)0);
		byts[0] = nChannel;
		return byts;
	}
	
}
