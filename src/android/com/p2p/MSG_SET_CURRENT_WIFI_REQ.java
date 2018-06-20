package com.p2p;
import java.util.Arrays;

public class MSG_SET_CURRENT_WIFI_REQ {
	public static final int MY_LEN = 812;

	public static byte[] toBytes(int bEnable, String strchSSID, int nMode,
			int nAuthtype, int nWEPEncrypt, int nWEPKeyFormat,
			int nWEPDefaultKey, String strchWEPKey1, String strchWEPKey2,
			String strchWEPKey3, String strchWEPKey4, int nWEPKey1_bits,
			int nWEPKey2_bits, int nWEPKey3_bits, int nWEPKey4_bits,
			String strchWPAPsk, byte bReqTestWifiResult) {
		byte[] byts = new byte[MY_LEN];
		Arrays.fill(byts, (byte)0);
		
		byte[] byt_bEnalbe 	= null;
		byte[] byt_nMode 	= null;
		byte[] byt_nAuthtype= null;
		byte[] byt_nWEPEncrypt 		= null;
		byte[] byt_nWEPKeyFormat	= null;
		byte[] byt_nWEPDefaultKey 	= null;
		
		byte[] byt_nWEPKey1_bits = null;
		byte[] byt_nWEPKey2_bits = null;
		byte[] byt_nWEPKey3_bits = null;
		byte[] byt_nWEPKey4_bits = null;
		byte[] chSSID	=null;
		byte[] chWEPKey1=null;
		byte[] chWEPKey2=null;
		byte[] chWEPKey3=null;
		byte[] chWEPKey4=null;
		byte[] chWPAPsk=null;
		
		byt_bEnalbe = Convert.intToByteArray_Little(bEnable);
		chSSID = strchSSID.getBytes();
		byt_nMode = Convert.intToByteArray_Little(nMode);
		byt_nAuthtype = Convert.intToByteArray_Little(nAuthtype);
		byt_nWEPEncrypt = Convert.intToByteArray_Little(nWEPEncrypt);
		byt_nWEPKeyFormat = Convert.intToByteArray_Little(nWEPKeyFormat);
		byt_nWEPDefaultKey = Convert.intToByteArray_Little(nWEPDefaultKey);
		chWEPKey1 = strchWEPKey1.getBytes();
		chWEPKey2 = strchWEPKey2.getBytes();
		chWEPKey3 = strchWEPKey3.getBytes();
		chWEPKey4 = strchWEPKey4.getBytes();
		
		byt_nWEPKey1_bits = Convert.intToByteArray_Little(nWEPKey1_bits);
		byt_nWEPKey2_bits = Convert.intToByteArray_Little(nWEPKey2_bits);
		byt_nWEPKey3_bits = Convert.intToByteArray_Little(nWEPKey3_bits);
		byt_nWEPKey4_bits = Convert.intToByteArray_Little(nWEPKey4_bits);
		chWPAPsk = strchWPAPsk.getBytes();

		System.arraycopy(byt_bEnalbe, 0, byts, 0, byt_bEnalbe.length);
		System.arraycopy(chSSID, 0, byts, 4, chSSID.length);
		//byts[132]=channel;
		byts[133]=bReqTestWifiResult;
		System.arraycopy(byt_nMode, 0, byts, 136, byt_nMode.length);
		System.arraycopy(byt_nAuthtype, 0, byts, 140, byt_nAuthtype.length);
		System.arraycopy(byt_nWEPEncrypt, 0, byts, 144, byt_nWEPEncrypt.length);
		System.arraycopy(byt_nWEPKeyFormat, 0, byts, 148, byt_nWEPKeyFormat.length);
		System.arraycopy(byt_nWEPDefaultKey, 0, byts, 152, byt_nWEPDefaultKey.length);
		
		System.arraycopy(chWEPKey1, 0, byts, 156, chWEPKey1.length);
		System.arraycopy(chWEPKey2, 0, byts, 284, chWEPKey2.length);
		System.arraycopy(chWEPKey3, 0, byts, 412, chWEPKey3.length);
		System.arraycopy(chWEPKey4, 0, byts, 540, chWEPKey4.length);

		System.arraycopy(byt_nWEPKey1_bits, 0, byts, 668, byt_nWEPKey1_bits.length);
		System.arraycopy(byt_nWEPKey2_bits, 0, byts, 672, byt_nWEPKey2_bits.length);
		System.arraycopy(byt_nWEPKey3_bits, 0, byts, 676, byt_nWEPKey3_bits.length);
		System.arraycopy(byt_nWEPKey4_bits, 0, byts, 680, byt_nWEPKey4_bits.length);
		System.arraycopy(chWPAPsk, 0, byts, 684,chWPAPsk.length);
		
		return byts;
	}
}
