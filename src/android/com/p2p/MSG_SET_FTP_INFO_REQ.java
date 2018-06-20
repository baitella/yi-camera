package com.p2p;

import java.util.Arrays;

public class MSG_SET_FTP_INFO_REQ {
	public static final int MY_LEN = 332;
	int nPort;
	int nMode; // 0:port mode 1:passive mode
	int reserve;

	public static byte[] toBytes(String FTPSvr, String User, String Pwd,
			String Dir, int nPort, int nMode,int uploadInterval) {
		byte[] byts = new byte[MY_LEN];
		Arrays.fill(byts, (byte) 0);

		byte[] chFTPSvr = null;
		byte[] chUser = null;
		byte[] chPwd = null;
		byte[] chDir = null;
		byte[] byt_nport = null;
		byte[] byt_nmode = null;
		byte[] byt_uploadinterval = null;

		chFTPSvr = FTPSvr.getBytes();
		chUser = User.getBytes();
		chPwd = Pwd.getBytes();
		chDir = Dir.getBytes();
		byt_nport = Convert.intToByteArray_Little(nPort);
		byt_nmode = Convert.intToByteArray_Little(nMode);
		byt_uploadinterval =  Convert.intToByteArray_Little(uploadInterval);
		
		System.arraycopy(chFTPSvr, 0, byts, 0, chFTPSvr.length);
		System.arraycopy(chUser, 0, byts, 64, chUser.length);
		System.arraycopy(chPwd, 0, byts, 128, chPwd.length);
		System.arraycopy(chDir, 0, byts, 192, chDir.length);
		System.arraycopy(byt_nport, 0, byts, 320, byt_nport.length);
		System.arraycopy(byt_nmode, 0, byts, 324, byt_nmode.length);
		System.arraycopy(byt_uploadinterval, 0, byts, 328, byt_uploadinterval.length);

		return byts;
	}
}
