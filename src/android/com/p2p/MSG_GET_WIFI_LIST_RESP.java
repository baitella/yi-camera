package com.p2p;

public class MSG_GET_WIFI_LIST_RESP {
   
	int nResultCount; 
    SEP2P_RESULT_WIFI_INFO[] wifi =new SEP2P_RESULT_WIFI_INFO[50]; 
    
    byte[] byt_nResultCount = new byte[4];
    
    public MSG_GET_WIFI_LIST_RESP(byte[] data) {
		System.arraycopy(data, 0, byt_nResultCount, 0, byt_nResultCount.length);
		System.arraycopy(data, 4, wifi, 0, wifi.length);
	}
	public int getnResultCount() {
		if(byt_nResultCount == null) return 0;
		else return Convert.byteArrayToInt_Little(byt_nResultCount);
	}
	public void setnResultCount(int nResultCount) {
		this.nResultCount = nResultCount;
	}
	public SEP2P_RESULT_WIFI_INFO[] getWifi() {
		return wifi;
	}
	public void setWifi(SEP2P_RESULT_WIFI_INFO[] wifi) {
		this.wifi = wifi;
	}
    
    
}
