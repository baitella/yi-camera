package com.smarteye;

public class SEAT_API {
	public static int ms_verAPI=0;
	
	static {
		try{ 
			System.loadLibrary("SEP2P_AppSDK"); 
			System.loadLibrary("SEAT_API"); 
			ms_verAPI=SEAT_GetSdkVer(null, 0);
			System.out.println("loadLibrary(SEAT_API), api_ver=="+ms_verAPI);
		}catch(UnsatisfiedLinkError ule){ System.out.println("loadLibrary(SEAT_API),"+ule.getMessage()); }
	}
	
	//E_RECOGNIZER_PRIORITY
	public static final int CPU_PRIORITY	=1;
	public static final int MEMORY_PRIORITY	=2;
	
	//E_APP_TYPE
	public static final int AT_RECOGNIZER	=1;
	public static final int AT_PLAYER		=2;
	
	//E_SAMPLE_RATE
	public static final int SAMPLE_RATE_16K =1; //16000Hz
	public static final int SAMPLE_RATE_441 =2; //44100Hz
	
	//E_TRANSMIT_TYPE
	public static final int TRANSMIT_TYPE_HEX_STR =1;//call SEAT_WriteByte to play
	public static final int TRANSMIT_TYPE_WIFI_PWD=2;//call SEAT_WriteSSIDWiFi to play
	
	//E_WIFI_SECURITY_MODE
	public static final int WIFI_SECURITY_MODE_OPEN			=0; // 0: none
	public static final int WIFI_SECURITY_MODE_WEP			=1; // 1: WEP
	public static final int WIFI_SECURITY_MODE_WEP_64_ASCII	=2; // 2: WEP 64 ASCII
	public static final int WIFI_SECURITY_MODE_WEP_64_HEX	=3; // 3: WEP 64 HEX
	public static final int WIFI_SECURITY_MODE_WEP_128_ASCII=4; // 4: WEP 128 ASCII
	public static final int WIFI_SECURITY_MODE_WEP_128_HEX	=5; // 5: WEP 128 HEX
	public static final int WIFI_SECURITY_MODE_WPAPSK_TKIP	=6; // 6: WPAPSK-TKIP
	public static final int WIFI_SECURITY_MODE_WPAPSK_AES	=7; // 7: WPAPSK-AES
	public static final int WIFI_SECURITY_MODE_WPA2PSK_TKIP	=8; // 8: WPA2PSK-TKIP
	public static final int WIFI_SECURITY_MODE_WPA2PSK_AES	=9; // 9: WPA2PSK-AES
	public static final int WIFI_SECURITY_MODE_UNKNOWN		=0xF;

	//------SEAT_API Error Code--------------------------------------------
	public static final int ERR_SEAT_SUCCESSFUL						=0;
	public static final int ERR_SEAT_NOT_INITIALIZED				=-1;
	public static final int ERR_SEAT_INVALID_PARAMETER				=-2;
	public static final int ERR_SEAT_WRONG_AT_TYPE					=-3;
	public static final int ERR_SEAT_INVALID_HANDLE					=-4;
	public static final int ERR_SEAT_WRONG_HANDLE					=-5;

	public static final int ERR_SEAT_RECOGNIZER_NO_SIGNAL			=-6;
	public static final int ERR_SEAT_RECOGNIZER_NOT_ENOUGHSIGNAL	=-7;
	public static final int ERR_SEAT_RECOGNIZER_NO_HEAD_OR_TAIL		=-8;
	public static final int ERR_SEAT_RECOGNIZER_NO_EXPIRES			=-9;
	public static final int ERR_SEAT_RECOGNIZER_WRONG_ECC			=-10;

	public static final int ERR_SEAT_CREATE_FAIL					=-11;
	
	//------SEAT_API ------------------------------------------------------
	void POnBegin(int pUserData, int nATType, float fSoundTime)
	{
		System.out.println("POnBegin] nATType="+nATType);
	}
	void POnEnd(int pUserData, int nATType, float fSoundTime, int nResult, byte[] pData, int nDataLen)
	{
		String str=String.format("POnEnd] nATType=%d nResult=%d nDataLen=%d", nATType, nResult, nDataLen);
		System.out.println(str);
	}
	void PConfigOK(int pUserData, byte[] bytConfigOK, int nBytSize)
	{
		if(bytConfigOK==null || nBytSize<CONFIG_OK.MY_LEN) return;
		CONFIG_OK stConfig=new CONFIG_OK(bytConfigOK);
		String str=String.format("PConfigOK] did=%s ssid=%s bss=%s firmver=%s\n", 
								  stConfig.getDID(), stConfig.getWiFi_ssid(), stConfig.getWiFi_bss(), stConfig.getSysFirmVer());
		System.out.println(str);
	}
	
	
	public SEAT_API() {}
	public native static int SEAT_GetSdkVer(byte[] chDesc, int nDescMaxSize);
	//strAndroidPackageName is the name of this application's package
	public native static int SEAT_Init2(String strAndroidPackageName, int nAndroidBuildVersion);
	
	public native int  SEAT_Init(int eSampleRate, int eTransmitType);
	public native void SEAT_DeInit();
	public native int  SEAT_Create(int[] ppHandle, int eATType, int ePriority);
	public native void SEAT_Destroy(int[] ppHandle);
	public native int SEAT_SetCallback(int pHandle, int pUserData);
	public native int SEAT_Start(int pHandle);
	public native int SEAT_Stop(int pHandle);
	public native int SEAT_Pause(int pHandleRecgnizer, int nMicroSecond);
	public native int SEAT_WriteByte(int pHandle, byte[]pData, int nDataLen);
	public native int SEAT_WriteSSIDWiFi(int pHandle, int chAppType, byte[] pSSID, int nSSIDLen, byte[] pPwd, int nPwdLen, int eWifiMode, byte[] pMACAddrWithColon);
	public native int SEAT_WriteSSIDWiFi2(int pHandle, int chAppType, byte[] pSSID, int nSSIDLen, byte[] pPwd, int nPwdLen, int eWifiMode, byte[] pMACAddrWithColon, byte[] pDID);
	
	public native int  SEAT_SmartlinkStart(int nInterval_ms);
	public native int  SEAT_SmartlinkSend(byte[] pSSID, int nSSIDLen, byte[] pPwd, int nPwdLen, byte[] pCustom, int nCustomLen);
	public native void SEAT_SmartlinkStop();
	
	public native int SEAT_SetCallbackConfigOK(int pUserData); //added v0.1.0.15
	
}
