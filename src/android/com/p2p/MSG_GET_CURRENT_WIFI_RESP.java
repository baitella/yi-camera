package com.p2p;

public class MSG_GET_CURRENT_WIFI_RESP {
	int bEnable; 					// 0->disable Wi-Fi, 1->enable Wi-Fi
	byte[] chSSID = new byte[128];	// WiFi SSID name
	int reserve=0;
	int nMode=0;		// 0->infra; 1->adhoc
	int nAuthtype=0;	// 0->WEP-NONE; 1->WEP; 2->WPA-PSK AES; 3->WPA-PSK TKIP;
						// 4->WPA2-PSK AES; 5->WPA2-PSK TKIP
	int nWEPEncrypt=0; 	// WEP: 0->open; 1->share key
	int nWEPKeyFormat=0;// WEP: 0->hexadecimal number; 1->ASCII Character
	int nWEPDefaultKey=0; // WEP: [0,3]
	byte[] chWEPKey1 = new byte[128]; // WEP: WEP key1
	byte[] chWEPKey2 = new byte[128]; // WEP: WEP key2
	byte[] chWEPKey3 = new byte[128]; // WEP: WEP key3
	byte[] chWEPKey4 = new byte[128]; // WEP: WEP key4
	int nWEPKey1_bits=0; // WEP: 0->64bits, 1->128bits for WEP key1
	int nWEPKey2_bits=0; // WEP: 0->64bits, 1->128bits for WEP key2
	int nWEPKey3_bits=0; // WEP: 0->64bits, 1->128bits for WEP key3
	int nWEPKey4_bits=0; // WEP: 0->64bits, 1->128bits for WEP key4
	byte[] chWPAPsk = new byte[128];

	public MSG_GET_CURRENT_WIFI_RESP(byte[] data) {
		System.arraycopy(data, 0, byt_enable, 0, byt_enable.length);
		System.arraycopy(data, 4, chSSID, 0, chSSID.length);
		System.arraycopy(data, 136, byt_nmode, 0, byt_nmode.length);
		System.arraycopy(data, 140, byt_nauthtype, 0, byt_nauthtype.length);
		System.arraycopy(data, 144, byt_nwepencrypt, 0, byt_nwepencrypt.length);
		System.arraycopy(data, 148, byt_nwepkeyformat, 0, byt_nwepkeyformat.length);
		System.arraycopy(data, 152, byt_nwepdefaultkey, 0, byt_nwepdefaultkey.length);
		System.arraycopy(data, 156, chWEPKey1, 0, chWEPKey1.length);
		System.arraycopy(data, 284, chWEPKey2, 0, chWEPKey2.length);
		System.arraycopy(data, 412, chWEPKey3, 0, chWEPKey3.length);
		System.arraycopy(data, 540, chWEPKey4, 0, chWEPKey4.length);
		System.arraycopy(data, 668, byt_nwepkey1_bits, 0, byt_nwepkey1_bits.length);
		System.arraycopy(data, 672, byt_nwepkey2_bits, 0, byt_nwepkey2_bits.length);
		System.arraycopy(data, 676, byt_nwepkey3_bits, 0, byt_nwepkey3_bits.length);
		System.arraycopy(data, 680, byt_nwepkey4_bits, 0, byt_nwepkey4_bits.length);
		System.arraycopy(data, 684, chWPAPsk, 0, chWPAPsk.length);
	}

	public int getbEnable() {
		if (byt_enable == null) return bEnable = 0;
		else return Convert.byteArrayToInt_Little(byt_enable);
	}
	public void setbEnable(int bEnable) {
		this.bEnable = bEnable;
	}
	public String getChSSID() {
		if (chSSID == null) return "";
		else return Convert.bytesToString(chSSID);
	}
	public int getnMode() {
		if (byt_nmode == null) return nMode = 0;
		else return Convert.byteArrayToInt_Little(byt_nmode);
	}
	public void setnMode(int nMode) {
		this.nMode = nMode;
	}
	public int getnAuthtype() {
		if (byt_nauthtype == null) return nAuthtype = 0;
		else return Convert.byteArrayToInt_Little(byt_nauthtype);
	}
	public void setnAuthtype(int nAuthtype) {
		this.nAuthtype = nAuthtype;
	}
	public int getnWEPEncrypt() {
		if (byt_nwepencrypt == null) return nWEPEncrypt = 0;
		else return Convert.byteArrayToInt_Little(byt_nwepencrypt);
	}
	public void setnWEPEncrypt(int nWEPEncrypt) {
		this.nWEPEncrypt = nWEPEncrypt;
	}

	public int getnWEPKeyFormat() {
		if (byt_nwepkeyformat == null) return nWEPKeyFormat = 0;
		else return Convert.byteArrayToInt_Little(byt_nwepkeyformat);
	}

	public void setnWEPKeyFormat(int nWEPKeyFormat) {
		this.nWEPKeyFormat = nWEPKeyFormat;
	}

	public int getnWEPDefaultKey() {
		if (byt_nwepdefaultkey == null) return nWEPDefaultKey = 0;
		else return Convert.byteArrayToInt_Little(byt_nwepdefaultkey);
	}

	public void setnWEPDefaultKey(int nWEPDefaultKey) {
		this.nWEPDefaultKey = nWEPDefaultKey;
	}
	
	public String getChWEPKey1() {
		if(chWEPKey1 == null) return "";
		else return Convert.bytesToString(chWEPKey1);
	}
	public void setChWEPKey1(byte[] chWEPKey1) {
		this.chWEPKey1 = chWEPKey1;
	}
	public String getChWPAPsk() {
		if (chWPAPsk == null) return "";
		else return Convert.bytesToString(chWPAPsk);
	}

	public void setChWPAPsk(byte[] chWPAPsk) {
		this.chWPAPsk = chWPAPsk;
	}

	byte[] byt_enable = new byte[4];
	byte[] byt_reserve = new byte[4];
	byte[] byt_nmode = new byte[4];
	byte[] byt_nauthtype = new byte[4];
	byte[] byt_nwepencrypt = new byte[4];
	byte[] byt_nwepkeyformat = new byte[4];
	byte[] byt_nwepdefaultkey = new byte[4];
	byte[] byt_nwepkey1_bits = new byte[4];
	byte[] byt_nwepkey2_bits = new byte[4];
	byte[] byt_nwepkey3_bits = new byte[4];
	byte[] byt_nwepkey4_bits = new byte[4];
}
