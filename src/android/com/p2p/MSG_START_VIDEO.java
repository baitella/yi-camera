package com.p2p;

import java.util.Arrays;

public class MSG_START_VIDEO {
	
/*	public static final int MY_LEN=16;
	public static byte[] toBytes(int nAudioCodecID,byte nChannel){
		byte[] byts=new byte[MY_LEN];
		Arrays.fill(byts, (byte)0);
		Convert.intToByteArray_Little(nAudioCodecID);
		//5-4 add new code
		byts[5]=nChannel;
		return byts;
	}*/
	
	//INT32 nVideoCodecID; //refer to SEP2P_ENUM_AV_CODECID
	//SEP2P_ENUM_VIDEO_RESO eVideoReso;
	//INT eVideoReso;
	//UCHAR nChannel;
	//CHAR  reserve[7];

	public static final int MY_LEN = 16;
	public static byte[] toBytes(int nVideoCodecID,int eVideoReso,int nChannel){
		byte[] byts = new byte[MY_LEN];
		byte[] byt_chnVideoCodecID	= null;
		byte[] byt_cheVideoReso  = null; 
		Arrays.fill(byts,(byte)0);
		byt_cheVideoReso=Convert.intToByteArray_Little(nVideoCodecID);
		byt_chnVideoCodecID=Convert.intToByteArray_Little(eVideoReso);
		System.arraycopy(byt_chnVideoCodecID, 0, byts, 0, byt_chnVideoCodecID.length);
		System.arraycopy(byt_cheVideoReso, 0, byts, 4, byt_cheVideoReso.length);
		byts[8] = (byte)nChannel;
		return byts;
	}
}
