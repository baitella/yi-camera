package com.p2p;

import java.util.Arrays;

public class MSG_GET_EMAIL_INFO_RESP {
	byte[] chSMTPSvr = new byte[64];
	byte[] chUser = new byte[64];
	byte[] chPwd = new byte[64];
	byte[] chSender = new byte[64];
	byte[] chReceiver1 = new byte[64];
	byte[] chReceiver2 = new byte[64];
	byte[] chReceiver3 = new byte[64];
	byte[] chReceiver4 = new byte[64];
	byte[] chSubject = new byte[64];
	byte[] byt_nsmtpport = new byte[4];
	byte[] byt_nsslauth = new byte[4];
	byte[] chText=new byte[64];

	// mylen --648
	public MSG_GET_EMAIL_INFO_RESP(byte[] data) {
		Arrays.fill(chSMTPSvr, 	(byte)0);
		Arrays.fill(chUser, 	(byte)0);
		Arrays.fill(chPwd, 		(byte)0);
		Arrays.fill(chSender, 	(byte)0);
		Arrays.fill(chReceiver1, (byte)0);
		Arrays.fill(chReceiver2, (byte)0);
		Arrays.fill(chReceiver3, (byte)0);
		Arrays.fill(chReceiver4, (byte)0);
		Arrays.fill(chSubject, 	 (byte)0);
		Arrays.fill(byt_nsmtpport, (byte)0);
		Arrays.fill(byt_nsslauth,  (byte)0);
		Arrays.fill(chText, (byte)0);
		
		System.arraycopy(data, 0, chSMTPSvr, 	0, chSMTPSvr.length);
		System.arraycopy(data, 64, chUser, 		0, chUser.length);
		System.arraycopy(data, 128, chPwd, 		0, chPwd.length);
		System.arraycopy(data, 192, chSender, 	0, chSender.length);
		System.arraycopy(data, 256, chReceiver1,0, chReceiver1.length);
		System.arraycopy(data, 320, chReceiver2,0, chReceiver2.length);
		System.arraycopy(data, 384, chReceiver3,0, chReceiver3.length);
		System.arraycopy(data, 448, chReceiver4,0, chReceiver4.length);
		System.arraycopy(data, 512, chSubject,  0, chSubject.length);
		System.arraycopy(data, 576, byt_nsmtpport, 0, byt_nsmtpport.length);
		System.arraycopy(data, 580, byt_nsslauth,  0, byt_nsslauth.length);
		System.arraycopy(data, 584, chText, 0, chText.length);
	}

	public String getSMTPSvr() {
		if (chSMTPSvr == null) return "";
		else return Convert.bytesToString(chSMTPSvr);
	}
	
	public String getSMTPUser(){
		if(chUser == null) return "";
		else return Convert.bytesToString(chUser);
	}
	
	public String getPwd(){
		if(chPwd == null) return "";
		else return Convert.bytesToString(chPwd);
	}
	
	public String getSender(){
		if(chSender == null) return "";
		else return Convert.bytesToString(chSender);
	}
	
	public String getReceiver1(){
		if(chReceiver1 == null) return "";
		else return Convert.bytesToString(chReceiver1);
	}
	
	public String getReceiver2(){
		if(chReceiver2 == null) return "";
		else return Convert.bytesToString(chReceiver2);
	}
	
	public String getReceiver3(){
		if(chReceiver3 == null) return "";
		else return Convert.bytesToString(chReceiver3);
	}
	
	public String getReceiver4(){
		if(chReceiver4 == null) return "";
		else return Convert.bytesToString(chReceiver4);
	}
	
	public String getSubject(){
		if(chSubject == null) return "";
		else return Convert.bytesToString(chSubject);
	}
	
	public int getnSMTPPort(){
		if(byt_nsmtpport == null) return 0;
		else return Convert.byteArrayToInt_Little(byt_nsmtpport);
	}
	
	public int getSSlAuth(){
		if(byt_nsslauth == null) return 0;
		else return Convert.byteArrayToInt_Little(byt_nsslauth);
	}
	
	public String getchText(){
		if(chText == null) return "";
		else return Convert.bytesToString(chText);
	}
}
