package com.p2p;

public class SEP2P_RESULT_WIFI_INFO {

	byte[] chSSID = new byte[64]; // Wi-Fi SSID name
	byte[] chMAC = new byte[64];
	int nAuthtype;// 0->WEP-NONE, 1->WEP, 2->WPA-PSK TKIP, 3->WPA-PSK AES,
					// 4->WPA2-PSK TKIP, 5->WPA2-PSK AES
	byte[] dbm0 = new byte[32];// '80' sign level.
	byte[] dbm1 = new byte[32];// '100'percent. it is always 100.
	int nMode; // 0->infra 1->adhoc
	int reserve;

	byte[] byt_nAuthtype = new byte[4];
	byte[] byt_nMode = new byte[4];
	byte[] byt_reserve = new byte[4];

	public SEP2P_RESULT_WIFI_INFO(byte[] data) {
		System.arraycopy(data, 0, chSSID, 0, chSSID.length);
		System.arraycopy(data, 64, chMAC, 0, chMAC.length);
		System.arraycopy(data, 128, byt_nAuthtype, 0, byt_nAuthtype.length);
		System.arraycopy(data, 132, dbm0, 0, dbm0.length);
		System.arraycopy(data, 164, dbm1, 0, dbm1.length);
		System.arraycopy(data, 196, byt_nMode, 0, byt_nMode.length);
	}

	public String getSSID() {
		if (chSSID == null) return "";
		else return Convert.bytesToString(chSSID);
	}

	public String getMac() {
		if (chMAC == null) return "";
		else return Convert.bytesToString(chMAC);
	}

	public int getAuthType() {
		if (byt_nAuthtype == null) return 0;
		else return Convert.byteArrayToInt_Little(byt_nAuthtype);
	}

	public String getdbmo() {
		if (dbm0 == null) return "";
		else return Convert.bytesToString(dbm0);
	}

	public String getdbm1() {
		if (dbm1 == null) return "";
		else return Convert.bytesToString(dbm1);
	}

	public int getMode() {
		if (byt_nMode == null) return 0;
		else return Convert.byteArrayToInt_Little(byt_nMode);
	}

}
