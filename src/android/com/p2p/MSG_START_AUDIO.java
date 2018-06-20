package com.p2p;

import java.util.Arrays;

public class MSG_START_AUDIO {
	public static final int MY_LEN=16;
	public static byte[] toBytes(int nAudioCodecID,int nChannel){
		byte[] byts=new byte[MY_LEN];
		byte[] byt_chnAudioCodecID	= null;
		Arrays.fill(byts, (byte)0);
		byt_chnAudioCodecID=Convert.intToByteArray_Little(nAudioCodecID);
		System.arraycopy(byt_chnAudioCodecID, 0, byts, 0, byt_chnAudioCodecID.length);
		//5-4 add new code
		byts[4]=(byte)nChannel;
		return byts;
	}
}
