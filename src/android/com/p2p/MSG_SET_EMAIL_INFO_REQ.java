package com.p2p;

import java.util.Arrays;

public class MSG_SET_EMAIL_INFO_REQ {
	public static final int MY_LEN = 648;

	byte[] chSMTPSvr 	= null;
	byte[] chUser 		= null;
	byte[] chPwd 		= null;
	byte[] chSender 	= null;
	byte[] chReceiver1 	= null;
	byte[] chReceiver2 	= null;
	byte[] chReceiver3 	= null;
	byte[] chReceiver4 	= null;
	byte[] chSubject 	= null;
	int nSMTPPort	=0;
	int nSSLAuth	=0;

	byte[] byt_nsmtpport= null;
	byte[] byt_nsslauth = null;
	byte[] byt_chText=null;
	
	public byte[] toBytes(String SMTPSvr, String User, String Pwd,
			String Sender, String Receiver1, String Receiver2,
			String Receiver3, String Receiver4, String Subject,int smtpPort,int sslAuth, String emailContent) {
		byte[] byts = new byte[MY_LEN];
		Arrays.fill(byts, (byte)0);
		
		chSMTPSvr= SMTPSvr.getBytes();
		chUser 	 = User.getBytes();
		chPwd 	 = Pwd.getBytes();
		chSender = Sender.getBytes();
		chReceiver1 = Receiver1.getBytes();
		chReceiver2 = Receiver2.getBytes();
		chReceiver3 = Receiver3.getBytes();
		chReceiver4 = Receiver4.getBytes();
		
		chSubject = Subject.getBytes();
		byt_nsmtpport = Convert.intToByteArray_Little(smtpPort);
		byt_nsslauth = Convert.intToByteArray_Little(sslAuth);
		byt_chText=emailContent.getBytes();
		
		System.arraycopy(chSMTPSvr, 0, byts, 0, chSMTPSvr.length);
		System.arraycopy(chUser, 0, byts, 64, chUser.length);
		System.arraycopy(chPwd, 0, byts, 128, chPwd.length);
		System.arraycopy(chSender, 0, byts, 192, chSender.length);
		System.arraycopy(chReceiver1, 0, byts, 256, chReceiver1.length);
		System.arraycopy(chReceiver2, 0, byts, 320, chReceiver2.length);
		System.arraycopy(chReceiver3, 0, byts, 384, chReceiver3.length);
		System.arraycopy(chReceiver4, 0, byts, 448, chReceiver4.length);
		System.arraycopy(chSubject, 0, byts, 512, chSubject.length);
		System.arraycopy(byt_nsmtpport, 0, byts, 576, byt_nsmtpport.length);
		System.arraycopy(byt_nsslauth, 0, byts, 580, byt_nsslauth.length);
		System.arraycopy(byt_chText, 0, byts, 584, byt_chText.length);
		
		return byts;
	}
}
