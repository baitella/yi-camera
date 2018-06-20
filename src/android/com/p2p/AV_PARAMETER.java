package com.p2p;

public class AV_PARAMETER {
	int nVideoCodecID=0;	  	// refer to SEP2P_ENUM_AV_CODECID
	int nAudioCodecID=0;	  	// refer to SEP2P_ENUM_AV_CODECID
	byte[]nVideoParameter=new byte[7];	// VideoDecoder: refer to SEP2P_ENUM_VIDEO_RESO
	byte  nAudioParameter=0;	// Audio:(samplerate << 2) | (databits << 1) | (channel)
	byte  nDeviceType=0;		//0=DEVICE_TYPE_IPC, 1=DEVICE_TYPE_NVR, ...
	byte  nMaxChannel=0;
	
	public AV_PARAMETER(){}
	public int getVideoCodecID()	 { return nVideoCodecID;	}
	public int getAudioCodecID()	 { return nAudioCodecID;	}
	public byte[] getVideoParameter(){ return nVideoParameter;	}
	public int getAudioParameter()	 { return nAudioParameter;	}
	public int getDeviceType()		 { return (int)nDeviceType;	}
	public int getMaxChannel()		 { return (int)nMaxChannel; }
}
