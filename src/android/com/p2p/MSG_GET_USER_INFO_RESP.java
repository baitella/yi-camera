package com.p2p;

import java.util.Arrays;

public class MSG_GET_USER_INFO_RESP {
	public static int MY_LEN = 392;
	
	byte[] chVisitor = new byte[64]; // visitor
	byte[] chVisitorPwd = new byte[64];
	//byte[] reserve = new byte[128];
	byte[] chAdmin = new byte[64]; // admin
	byte[] chAdminPwd = new byte[64];
	byte   nCurUserRoleID=(byte)0; //only get it for X series, 2015-04-16
	
	public MSG_GET_USER_INFO_RESP(byte[] data) {
		reset();
		if(data==null || data.length<MY_LEN) return;
		
		System.arraycopy(data, 0, chVisitor, 0, chVisitor.length);
		System.arraycopy(data, 64, chVisitorPwd, 0, chVisitorPwd.length);
		System.arraycopy(data, 256, chAdmin, 0, chAdmin.length);
		System.arraycopy(data, 320, chAdminPwd, 0, chAdminPwd.length);
		nCurUserRoleID=data[384];
	}
	
	private void reset(){
		Arrays.fill(chVisitor, (byte)0);
		Arrays.fill(chVisitorPwd, (byte)0);
		Arrays.fill(chAdmin, (byte)0);
		Arrays.fill(chAdminPwd, (byte)0);
		nCurUserRoleID=(byte)0;
	}
	
	public String getchVisitorPwd() { return Convert.bytesToString(chVisitorPwd);	}
	public String getchVisitor() 	{ return Convert.bytesToString(chVisitor); 		}
	public String getchAdmin() 		{ return Convert.bytesToString(chAdmin); 		}
	public String getchAdminPwd()	{ return Convert.bytesToString(chAdminPwd); 	}
	public int get_nCurUserRoleID() { return (int)(nCurUserRoleID&0xFF); 			}
}
