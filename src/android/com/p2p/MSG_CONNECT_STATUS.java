package com.p2p;

public class MSG_CONNECT_STATUS {
	//CONNECT_STATUS
	public static final int CONNECT_STATUS_CONNECTING		=0x00;
	public static final int CONNECT_STATUS_INITIALING		=0x01;
	public static final int CONNECT_STATUS_ONLINE			=0x02;
	public static final int CONNECT_STATUS_CONNECT_FAILED	=0x03;
	public static final int CONNECT_STATUS_DISCONNECT		=0x04;
	public static final int CONNECT_STATUS_INVALID_ID		=0x05;
	public static final int CONNECT_STATUS_DEVICE_NOT_ONLINE=0x06;
	public static final int CONNECT_STATUS_CONNECT_TIMEOUT	=0x07;
	public static final int CONNECT_STATUS_WRONG_USER_PWD	=0x08;
	public static final int CONNECT_STATUS_INVALID_REQ		=0x09;
	public static final int CONNECT_STATUS_EXCEED_MAX_USER	=0x0A;// exceed the max user
	public static final int CONNECT_STATUS_CONNECTED		=0x0B;
	public static final int CONNECT_STATUS_UNKNOWN			=0xFFFFFF;	
	
	int nConnectStatus=CONNECT_STATUS_UNKNOWN;
	
	public MSG_CONNECT_STATUS(byte[] data){
		if(data==null || data.length<4) return;
		nConnectStatus=Convert.byteArrayToInt_Little(data);
	}
	
	public int getConnectStatus() { return nConnectStatus; }
}
