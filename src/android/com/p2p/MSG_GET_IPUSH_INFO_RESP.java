package com.p2p;

import java.util.Arrays;

public class MSG_GET_IPUSH_INFO_RESP {
	public static final int MY_LEN = 104;
	
	byte[] byte_bEnable=new byte[1];
	byte[] byte_nResult= new byte[1];
	
	public MSG_GET_IPUSH_INFO_RESP(byte[]data){
		Arrays.fill(byte_bEnable, (byte)0);
		Arrays.fill(byte_nResult, (byte)0);
		
		if(data.length<MY_LEN) return;
	}

	public int getByte_bEnable() {
		if(byte_bEnable == null) return 0;
		else return Convert.byteArrayToInt_Little(byte_bEnable);
	}
	public void setByte_bEnable(byte[] byte_bEnable) {
		this.byte_bEnable = byte_bEnable;
	}
	public int getByte_nResult() {
		if(byte_nResult == null) return 0;
		else return Convert.byteArrayToInt_Little(byte_nResult);
	}
	public void setByte_nResult(byte[] byte_nResult) {
		this.byte_nResult = byte_nResult;
	}

}
