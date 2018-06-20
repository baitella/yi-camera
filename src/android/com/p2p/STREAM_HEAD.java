package com.p2p;

import java.util.Arrays;

public class STREAM_HEAD {
	public static final int MY_LEN=24;
	
	//SEP2P_ENUM_AV_CODECID
	public static final int AV_CODECID_VIDEO_MJPEG	=0x01;
	public static final int AV_CODECID_VIDEO_H264	=0x02;
	public static final int AV_CODECID_AUDIO_ADPCM	=0x100;
	public static final int AV_CODECID_AUDIO_G726	=0x101;
	public static final int AV_CODECID_AUDIO_G711A	=0x102;
	public static final int AV_CODECID_AUDIO_AAC	=0x103;
	
	//SEP2P_ENUM_VIDEO_FRAME
	public static final int VIDEO_FRAME_FLAG_I	= 0x00;	// VideoDecoder I Frame
	public static final int VIDEO_FRAME_FLAG_P	= 0x01;	// VideoDecoder P Frame
	public static final int VIDEO_FRAME_FLAG_B	= 0x02;	// VideoDecoder B Frame
	
	
	//SEP2P_ENUM_VIDEO_RESO
	public static final int VIDEO_RESO_QQVGA	= 0x00;  //160*120 
	public static final int VIDEO_RESO_QVGA		= 0x01;  //320*240
	public static final int VIDEO_RESO_VGA1		= 0x02;  //640*480
	public static final int VIDEO_RESO_VGA2     = 0x03;  //640*360
	public static final int VIDEO_RESO_720P     = 0x04;  //1280*720
	public static final int VIDEO_RESO_960P     = 0x05;  //1280*960  
	public static final int VIDEO_RESO_1080P    = 0x06;  // 3��31���������� 1920*1080  1080p
	public static final int VIDEO_RESO_1296P = 0x07; //6��8���������� 
	public static final int VIDEO_RESO_UNKNOWN  = 0xFF;
	
	//SEP2P_ENUM_AUDIO_SAMPLERATE
	public static final int AUDIO_SAMPLE_8K		= 0x00;
	public static final int AUDIO_SAMPLE_11K	= 0x01;
	public static final int AUDIO_SAMPLE_12K	= 0x02;
	public static final int AUDIO_SAMPLE_16K	= 0x03;
	public static final int AUDIO_SAMPLE_22K	= 0x04;
	public static final int AUDIO_SAMPLE_24K	= 0x05;
	public static final int AUDIO_SAMPLE_32K	= 0x06;
	public static final int AUDIO_SAMPLE_44K	= 0x07;
	public static final int AUDIO_SAMPLE_48K	= 0x08;
	
	//SEP2P_ENUM_AUDIO_DATABITS
	public static final int AUDIO_DATABITS_8	= 0;
	public static final int AUDIO_DATABITS_16	= 1;
	
	//SEP2P_ENUM_AUDIO_CHANNEL
	public static final int AUDIO_CHANNEL_MONO	= 0;
	public static final int AUDIO_CHANNEL_STERO	= 1;
	
	public static final int DEV_TYPE_IPC = 0;
	public static final int DEV_TYPE_NVR = 1;
	
	int  nCodecID=0;		//refer to SEP2P_ENUM_AV_CODECID
	byte nParameter=0;		//VideoDecoder: refer to SEP2P_ENUM_VIDEO_FRAME.   Audio:(samplerate << 2) | (databits << 1) | (channel)
	byte nLivePlayback=0;	//VideoDecoder: 0:live videoThread or audio;  1:playback videoThread or audio
	int  nStreamDataLen=0;	//Stream data size after following struct 'STREAM_HEAD'
	long nTimestamp=0L;		//Timestamp of the frame, in milliseconds
	int  nPlaybackID=0; 	//for playback, added on 20141201
	
	//5-4 add new code 
	byte nChannel =0;
	
	public STREAM_HEAD(){}
	public STREAM_HEAD(byte[] data) { setData(data);}
	public STREAM_HEAD(int nCodecID, byte nParameter, byte nLivePlayback, int nStreamDataLen, long nTimestamp) { 
		this.nCodecID=nCodecID;
		this.nParameter=nParameter;
		this.nLivePlayback=nLivePlayback;
		this.nStreamDataLen=nStreamDataLen;
		this.nTimestamp=nTimestamp;
	}
	
	private void reset(){
		nCodecID=0;
		nParameter=0;
		nLivePlayback=0;
		//5-4 add new code 
		nChannel = 0;
		nStreamDataLen=0;
		nTimestamp=0L;
	}
	
	public void setData(byte[] byts)
	{
		if(byts==null || byts.length<MY_LEN) reset();
		else {
			nCodecID  =Convert.byteArrayToInt_Little(byts, 0);
			nParameter=byts[4];
			nLivePlayback	=byts[5];
			//5-4 add new code 
			nChannel = byts[6];
			nStreamDataLen	=Convert.byteArrayToInt_Little(byts, 8);
			nTimestamp =Convert.byteArrayToInt_Little(byts, 12)&0xFFFFFFFF;
			nPlaybackID=Convert.byteArrayToInt_Little(byts, 20);
		}
	}
	
	public byte[] toBytes(){
		byte[] byt=new byte[MY_LEN], bytTmp=null;
		Arrays.fill(byt, (byte)0);
		bytTmp=Convert.intToByteArray_Little(nCodecID);
		System.arraycopy(bytTmp, 0, byt, 0, 4);
		byt[4]=nParameter;
		byt[5]=nLivePlayback;
		//5-4 add new code 
		byt[6] = nChannel;
		
		bytTmp=Convert.intToByteArray_Little(nStreamDataLen);
		System.arraycopy(bytTmp, 0, byt, 8, 4);
		
		bytTmp=Convert.intToByteArray_Little((int)nTimestamp);
		System.arraycopy(bytTmp, 0, byt, 12, 4);
		
		return byt;
	}
	
	public int getCodecID() 	 { return nCodecID;			}
	public byte getParameter()	 { return nParameter;		}
	public boolean isLiveData()	 { return (nLivePlayback==0) ? true : false; 	 }
	public int getStreamDataLen(){ return nStreamDataLen;	}
	public long getTimestamp()	 { return (long)(nTimestamp&0x0FFFFFFFFFFFFFFFL);}
	public int getFlagPlayback() { return nLivePlayback&0xFF;}
	public int getPlaybackID()	 { return nPlaybackID;		 }
	
	//5-4 add new code 
	public byte getnChannel()    {return nChannel;}
    
}
