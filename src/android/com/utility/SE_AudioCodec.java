package com.utility;

public class SE_AudioCodec {
	static {
		try {
			System.loadLibrary("SE_AudioCodec");
		} catch (UnsatisfiedLinkError ule) {
			System.out.println("loadLibrary(SE_AudioCodec)," + ule.getMessage());
		}
	}

	public static final short AUDIO_CODE_TYPE_ADPCM = 1;
	public static final short AUDIO_CODE_TYPE_G726  = 2;
	public static final short AUDIO_CODE_TYPE_G711A	= 3;
	public static final short AUDIO_CODE_TYPE_AAC	= 4;

	public native static int SEAudio_GetSdkVer(byte[] chDesc, int nDescMaxSize);

	public native static int SEAudio_Create(short code_type, int[] ppHandle);

	public native static void SEAudio_Destroy(int[] ppHandle);

	public native static int SEAudio_Encode(int pHandle, byte[] inPCMData,
			int inLen, byte[] outBuf, int[] outLen);

	public native static int SEAudio_Decode(int pHandle, byte[] inBuf,
			int inLen, byte[] outPCMData, int[] outLen);

}
