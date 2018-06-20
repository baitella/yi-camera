package com.p2p;

import java.util.Arrays;

public class MSG_GET_FTP_INFO_RESP {
	byte[] chFTPSvr = new byte[64]; 
    byte[] chUser = new byte[64]; 
    byte[] chPwd = new byte[64]; 
    byte[] chDir = new byte[128]; 
    int nPort; 
    int nMode; //0:port mode 1:passive mode 
    int reserve; 
    
    byte[] byt_nport = new byte[4];
    byte[] byt_nmode = new byte[4];
    //byte[] byt_reserve = new byte[4];
    
    public MSG_GET_FTP_INFO_RESP(byte[] data) {
    	Arrays.fill(chFTPSvr, (byte)0);
    	Arrays.fill(chUser, (byte)0);
    	Arrays.fill(chPwd, (byte)0);
    	Arrays.fill(chDir, (byte)0);
    	Arrays.fill(byt_nport, (byte)0);
    	Arrays.fill(byt_nmode, (byte)0);
    	if(data==null) return;
    	
		System.arraycopy(data, 0, chFTPSvr, 0, chFTPSvr.length);
		System.arraycopy(data, 64, chUser, 0, chUser.length);
		System.arraycopy(data, 128, chPwd, 0, chPwd.length);
		System.arraycopy(data, 192, chDir, 0, chDir.length);
		System.arraycopy(data, 320, byt_nport, 0, byt_nport.length);
		System.arraycopy(data, 324, byt_nmode, 0, byt_nmode.length);
	}
    public String getFTPSvr(){
    	if(chFTPSvr == null) return ""; 
    	else return Convert.bytesToString(chFTPSvr);
    }
    public String getUser(){
      if(chUser == null) return "";
      else return Convert.bytesToString(chUser);
    }
    public String getPwd(){
    	if(chPwd == null) return "";
    	else return Convert.bytesToString(chPwd);
    }
    
    public String getDir(){
    	if(chDir == null) return "";
    	else return Convert.bytesToString(chDir);
    }
    
    public int getnPort(){
    	if(byt_nport == null) return 0;
    	else return Convert.byteArrayToInt_Little(byt_nport);
    }
    
    public int getnMode(){
    if(byt_nmode == null) return 0;
    else return Convert.byteArrayToInt_Little(byt_nmode);
    }
    
}
