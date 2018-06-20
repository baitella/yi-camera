package com.p2p;

import java.util.Arrays;

//CHAR  nResult;	//0:OK; 1:playback end;    Error:[11:already playback; 12:failed to open file; 13:playback fail;]
//CHAR  nAudioParam; //-1 no audio; >=0 with audio:(samplerate << 2) | (databits << 1) | (channel), samplerate refer to SEP2P_ENUM_AUDIO_SAMPLERATE; databits refer to SEP2P_ENUM_AUDIO_DATABITS; channel refer to SEP2P_ENUM_AUDIO_CHANNEL
//CHAR  reserve1[2];
//INT32 nBeginPos_sec;	//unit: second
//CHAR  chFilePath[120];
//INT32 nTimeLen_sec;		//unit: second, record file playback time
//INT32 nFileSize_KB;		//unit: KBytes, record file size in byte
//UINT32 nPlaybackID;		//this id will assign to STREAM_HEAD.reserve2[2] ~ STREAM_HEAD.reserve2[5]
//CHAR   reserve2[4];

public class MSG_START_PLAY_REC_FILE_RESP {
	public static final int MY_LEN = 144;

	byte nResult = (byte)13;
	byte nAudioParam = (byte)(-1);
	int  nBeignPos_sec=0;
	byte[] byt_nBeignPos_sec = new byte[4];
	byte[] byt_chFilePath  = new byte[120];
	byte[] byt_nTimeLen_sec= new byte[4];
	byte[] byt_nFileSize_KB= new byte[4];
	byte[] byt_nPlaybackID = new byte[4];
	
	public MSG_START_PLAY_REC_FILE_RESP(byte[]data){
		reset();
		nResult=data[0];
		nAudioParam=data[1];
		System.arraycopy(data, 4, byt_nBeignPos_sec, 0,	byt_nBeignPos_sec.length);
		System.arraycopy(data, 8, byt_chFilePath, 0,	byt_chFilePath.length);
		System.arraycopy(data, 128, byt_nTimeLen_sec, 0,byt_nTimeLen_sec.length);
		System.arraycopy(data, 132, byt_nFileSize_KB, 0,byt_nFileSize_KB.length);
		System.arraycopy(data, 136, byt_nPlaybackID, 0,	byt_nPlaybackID.length);
	}

	private void reset(){
	 Arrays.fill(byt_nBeignPos_sec, (byte)0);
	 Arrays.fill(byt_chFilePath, (byte)0);
	 Arrays.fill(byt_nTimeLen_sec, (byte)0);
	 Arrays.fill(byt_nFileSize_KB, (byte)0);
	 Arrays.fill(byt_nPlaybackID, (byte)0);
	}
	
	public int getnResult(){
		return (int)(nResult&0xFF);
	}
	public int getnAudioParam(){
		return (int)(nAudioParam&0xFF);
	}
	public int getnBeignPos_sec() {
		return Convert.byteArrayToInt_Little(byt_nBeignPos_sec);
	}
	public String getchFilePath()
	{
		if(byt_chFilePath[0]==(byte)0) return "";
		else return Convert.bytesToString(byt_chFilePath);
	}
	public int getnTimeLen_sec() {
		return Convert.byteArrayToInt_Little(byt_chFilePath);
	}
	public int getnFileSize_KB() {
		if(byt_nTimeLen_sec == null) return 0;
		else return Convert.byteArrayToInt_Little(byt_nTimeLen_sec);
	}
	
	public int getnPlaybackID() {
		if(byt_nPlaybackID == null) return 0;
		else return Convert.byteArrayToInt_Little(byt_nPlaybackID);
	}
	

}
