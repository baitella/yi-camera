package com.p2p;

import java.util.ArrayList;

import android.content.Context;

public class SEP2P_AppSDK {
	//NOTES: android:targetSdkVersion<=13 in AndroidManifest.xml
	//
	static {
		try
		{ 
			System.loadLibrary("SEP2P_AppSDK"); 
		}
		catch(UnsatisfiedLinkError ule)
		{
			System.out.println("loadLibrary(SEP2P_AppSDK),"+ule.getMessage()); 
		}
	}
	//------SEP2P_AppSDK Error Code-----------------------------------------------------------------
	public static final int ERR_SEP2P_SUCCESSFUL						= 0;
	public static final int ERR_SEP2P_NOT_INITIALIZED					= -1;
	public static final int ERR_SEP2P_ALREADY_INITIALIZED				= -2;
	public static final int ERR_SEP2P_TIME_OUT							= -3;
	public static final int ERR_SEP2P_INVALID_ID						= -4;
	public static final int ERR_SEP2P_INVALID_PARAMETER					= -5;
	public static final int ERR_SEP2P_DEVICE_NOT_ONLINE					= -6;
	public static final int ERR_SEP2P_FAIL_TO_RESOLVE_NAME				= -7;
	public static final int ERR_SEP2P_INVALID_PREFIX					= -8;
	public static final int ERR_SEP2P_ID_OUT_OF_DATE					= -9;
	public static final int ERR_SEP2P_NO_RELAY_SERVER_AVAILABLE			= -10;
	public static final int ERR_SEP2P_INVALID_SESSION_HANDLE			= -11;
	public static final int ERR_SEP2P_SESSION_CLOSED_REMOTE				= -12;
	public static final int ERR_SEP2P_SESSION_CLOSED_TIMEOUT			= -13;
	public static final int ERR_SEP2P_SESSION_CLOSED_CALLED				= -14;
	public static final int ERR_SEP2P_REMOTE_SITE_BUFFER_FULL			= -15;
	public static final int ERR_SEP2P_USER_LISTEN_BREAK					= -16;
	public static final int ERR_SEP2P_MAX_SESSION						= -17;
	public static final int ERR_SEP2P_UDP_PORT_BIND_FAILED				= -18;
	public static final int ERR_SEP2P_USER_CONNECT_BREAK				= -19;
	public static final int ERR_SEP2P_SESSION_CLOSED_INSUFFICIENT_MEMORY= -20;
	public static final int ERR_SEP2P_INVALID_APILICENSE				= -21;
	public static final int ERR_SEP2P_FAIL_TO_CREATE_THREAD				= -22;

	public static final int ERR_SEP2P_EXCEED_MAX_CONNECT_NUM			= -200;
	public static final int ERR_SEP2P_ALREADY_CONNECTED					= -201;
	public static final int ERR_SEP2P_INVALID_MSG_TYPE					= -202;
	public static final int ERR_SEP2P_NO_CONNECT_THIS_DID				= -203;
	public static final int ERR_SEP2P_NO_SUPPORT_THIS_CODECID			= -204;
	public static final int ERR_SEP2P_NO_SUPPORT_THIS_RESO				= -205;
	public static final int ERR_SEP2P_FIRST_START_VIDEO					= -206;
	public static final int ERR_SEP2P_WRITTEN_SIZE_TOO_BIG				= -207;
	
	//------SEP2P_AppSDK CameraPlugin------------------------------------------------------------------------
   	public native static int  SEP2P_GetSDKVersion(byte[] chDesc, int nDescMaxSize);
	public native static int  SEP2P_Initialize(ArrayList<INIT_STR> arrInitStr);
	public native static int  SEP2P_DeInitialize();

	public native static int  SEP2P_StartSearch();
	public native static int  SEP2P_StopSearch();
	public native static int  SEP2P_Connect(String pDID, String pUser, String pPwd);
	public native static int  SEP2P_Disconnect(String pDID);
	public native static int  SEP2P_GetAVParameterSupported(String pDID, AV_PARAMETER pOut_AV_Parameter);
	
	public native static int  SEP2P_SendTalkData(String pDID, byte[] pData, int nDataSize, long nTimestamp);
	public native static int  SEP2P_SendMsg(String pDID, int nMsgType, byte[] pMsgData, int nMsgDataSize);

	public native static int  SetCallbackContext(Context context, int nTargetSdkVer);
}
