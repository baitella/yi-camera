package com.utility;

public class SE_MP4 {
	static {
		try {
			System.loadLibrary("ffmpeg");
			System.loadLibrary("SE_MP4");
		} catch (UnsatisfiedLinkError ule) {
			System.out.println("loadLibrary(SE_MP4)," + ule.getMessage());
		}
	}
	
	public static final int MP4_AV_CODECID_UNKNOWN		= 0x00;
	public static final int MP4_AV_CODECID_VIDEO_MJPEG	= 0x01;
	public static final int MP4_AV_CODECID_VIDEO_H264	= 0x02;

	public static final int MP4_AV_CODECID_AUDIO_ADPCM	= 0x100;
	public static final int MP4_AV_CODECID_AUDIO_G726	= 0x101;
	public static final int MP4_AV_CODECID_AUDIO_G711A	= 0x102;
	public static final int MP4_AV_CODECID_AUDIO_AAC	= 0x103;


	public native static int SEMP4_GetSdkVer(byte[] chDesc, int nDescMaxSize);
	
	public native static int SEMP4_Open(int[] ppHandle, String filename, int nWidth, int nHeigh, int nVideoType, 
									int nAudioSampleRate, int nAudioChannel, int nAudioType);
	public native static int SEMP4_Close(int[] ppHandle);
	public native static int SEMP4_AddVideoFrame(int pHandle, byte[] pData, int nDataLen, long nTimestamp, int keyframe);
	public native static int SEMP4_AddAudioFrame(int pHandle, byte[] pData, int nDataLen, long nTimestamp);
}
