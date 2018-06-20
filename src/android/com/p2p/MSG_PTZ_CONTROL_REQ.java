package com.p2p;

import java.util.Arrays;

public class MSG_PTZ_CONTROL_REQ {
	public static int MY_LEN = 16;
	byte nCtrlCmd;
	byte nCtrlParam;
	byte nChannel;
	byte[] reserve = new byte[13];
	
	public static byte[] toBytes(byte nCtrlCmd, byte nCtrlParam,byte nChannel) {
		byte[] byts = new byte[MY_LEN];
		Arrays.fill(byts, (byte) 0);
		byts[0] = nCtrlCmd;
		byts[1] = nCtrlParam;
		byts[2] = nChannel;
		return byts;
	}
}
