package com.p2p;

import java.util.Arrays;

public class MSG_SET_CAMERA_PARAM_REQ {
	public static final int MY_LEN = 56;
	public static byte[] getBytes(int nResolution, int nBright, int nContrast,
			int nSaturation, int bOSD, int nMode, int nFlip, int nIRLed, int nBitMaskToSet) {
		byte[] byts = new byte[MY_LEN];
		Arrays.fill(byts, (byte) 0);
		byte[] nResolution_byte = Convert.intToByteArray_Little(nResolution);
		System.out.println("nResolution_byte length----"+nResolution_byte.length);
		System.arraycopy(nResolution_byte, 0, byts, 0, nResolution_byte.length);
		byte[] nBright_byte = Convert.intToByteArray_Little(nBright);
		System.arraycopy(nBright_byte, 0, byts, 4, nBright_byte.length);
		byte[] nContrast_byte = Convert.intToByteArray_Little(nContrast);
		System.arraycopy(nContrast_byte, 0, byts, 8, nContrast_byte.length);
		byte[] nSaturation_byte = Convert.intToByteArray_Little(nContrast);
		System.arraycopy(nSaturation_byte, 0, byts, 16, nSaturation_byte.length);
		byte[] bOSD_byte = Convert.intToByteArray_Little(bOSD);
		System.arraycopy(bOSD_byte, 0, byts, 20, bOSD_byte.length);
		byte[] nMode_byte = Convert.intToByteArray_Little(nMode);
		System.arraycopy(nMode_byte, 0, byts, 24, nMode_byte.length);
		byte[] nFlip_byte = Convert.intToByteArray_Little(nFlip);
		System.arraycopy(nFlip_byte, 0, byts, 28, nFlip_byte.length);
		byte[] byt_nIRLed = Convert.intToByteArray_Little(nIRLed);
		System.arraycopy(byt_nIRLed, 0, byts, 40,byt_nIRLed.length);
		byte[] nBitMaskToSet_byte = Convert.intToByteArray_Little(nBitMaskToSet);
		System.arraycopy(nBitMaskToSet_byte, 0, byts, 52, nBitMaskToSet_byte.length);
		return byts;
	}
}
