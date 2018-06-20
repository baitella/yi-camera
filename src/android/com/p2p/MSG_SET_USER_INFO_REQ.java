package com.p2p;

import java.util.Arrays;

public class MSG_SET_USER_INFO_REQ {
	public static int MY_LEN = 384;//392;
	
	byte[] chVisitor = new byte[64]; // visitor
	byte[] chVisitorPwd = new byte[64];
	byte[] reserve = new byte[128];
	byte[] chAdmin = new byte[64]; // admin
	byte[] chAdminPwd = new byte[64];
	
	public static byte[] toBytes(String visitor,String visitorPwd,String admin,String adminPwd){
		byte[] byts=new byte[MY_LEN];
		Arrays.fill(byts, (byte)0);
		
		byte[] str_chVisitor = visitor.getBytes();
		byte[] str_chVisitorPwd = visitorPwd.getBytes();
		byte[] str_chAdmin = admin.getBytes();
		byte[] str_chAdminPwd = adminPwd.getBytes();
		
	    System.arraycopy(str_chVisitor, 0, byts, 0, str_chVisitor.length);
	    System.arraycopy(str_chVisitorPwd, 0, byts, 64, str_chVisitorPwd.length);
	    System.arraycopy(str_chAdmin, 0, byts, 256, str_chAdmin.length);
	    System.arraycopy(str_chAdminPwd, 0, byts, 320, str_chAdminPwd.length);
	    
		return byts;
	}
}
