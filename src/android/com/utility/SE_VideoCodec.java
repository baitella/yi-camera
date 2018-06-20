package com.utility;

public class SE_VideoCodec {
	static {
		try {
			System.loadLibrary("ffmpeg");
			System.loadLibrary("SE_VideoCodec");
		} catch (UnsatisfiedLinkError ule) {
			System.out.println("loadLibrary(ffmpeg,SE_VideoCodec),"
					+ ule.getMessage());
		}
	}

	public static final short VIDEO_CODE_TYPE_H264 = 1;

	public native static int SEVideo_GetSdkVer(byte[] chDesc, int nDescMaxSize);

	public native static int SEVideo_Create(short code_type, int[] ppHandle);

	public native static void SEVideo_Destroy(int[] ppHandle);

	public native static int SEVideo_Decode2YUV(int pHandle, byte[] inRawData,
			int inLen, byte[] outYUV420, int[] in_outLen, int[] videoWidth,
			int[] videoHeight);

	public native static int SEVideo_Decode2RGB565(int pHandle,
			byte[] inRawData, int inLen, byte[] outRGB565, int[] in_outLen,
			int[] videoWidth, int[] videoHeight);
}
