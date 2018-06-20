package com.p2p;

import java.util.Arrays;

public class MSG_GET_CUSTOM_PARAM_REQ {
	public static final int MY_LEN = 40;
	
	public static byte[] toBytes(String chParamName)
	{
		int nLen=0;
		byte[] bytsTmp=null;
		byte[] byts = new byte[MY_LEN];
		Arrays.fill(byts, (byte)0);
		if(chParamName!=null) {
			bytsTmp=chParamName.getBytes();
			nLen=(bytsTmp.length > 32) ? 32 : bytsTmp.length;
			System.arraycopy(bytsTmp, 0, byts, 8, nLen);
		}
		return byts;
	}
}
