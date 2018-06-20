package com.p2p;

import java.util.Arrays;

public class MSG_SET_IPUSH_INFO_REQ {
	public static final int MY_LEN = 104;
	
	byte bEnable=0;
	byte nResult=1;
	//CHAR reserve[102];
	
	public static byte[] toBytes(int bEnable){
		byte[] byts=new byte[MY_LEN];
		Arrays.fill(byts, (byte)0);
		byts[0]=(byte)bEnable;
		return byts;
	}
}
