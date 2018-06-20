package com.p2p;


public class MSG_PTZ_CONTROL_RESP {
	byte result;
	byte nChannel;
	byte[] reserved = new byte[14];
}