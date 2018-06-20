#ifndef __INCLUDED_AT_API____H
#define __INCLUDED_AT_API____H


#ifdef WIN32DLL
	#define SEAT_CALLBACK	  __stdcall
	#ifdef SEAT_API_EXPORTS
		#define SEAT_API_API  __declspec(dllexport)
	#else
		#define SEAT_API_API __declspec(dllimport)
	#endif
#endif //// #ifdef WIN32DLL

#ifdef LINUX
	#include <netinet/in.h>
	#define SEAT_API_API 
	#define SEAT_CALLBACK
#endif //// #ifdef LINUX

//LINUX_ANDROID

//LINUX_iOS

#include "SEP2P_Type.h"
#include "SEAT_Error.h"

typedef enum {
	CPU_PRIORITY	= 1, //不占内存，但CPU消耗比较大一些
	MEMORY_PRIORITY = 2	 //不占CPU，但内存消耗大一些
}E_RECOGNIZER_PRIORITY;

typedef enum {
	AT_RECOGNIZER = 1, 
	AT_PLAYER = 2	 
}E_APP_TYPE;

typedef enum{
	SAMPLE_RATE_16K=1,//16000
	SAMPLE_RATE_441  //44100
}E_SAMPLE_RATE;

typedef enum{
	TRANSMIT_TYPE_HEX_STR=1,//call SEAT_WriteByte to play
	TRANSMIT_TYPE_WIFI_PWD,		//call SEAT_WriteSSIDWiFi to play
}E_TRANSMIT_TYPE;

typedef struct tagSSID_WIFI_INFO
{
	char chAppType;
	char chHead[4];
	char ssid[75];
	char pwd[32];
	int  ssidLen;
	int  pwdLen;
}SSID_WIFI_INFO;

typedef enum tag_WIFI_SECURITY_MODE_E
{
	WIFI_SECURITY_MODE_OPEN,            // 0: none
	WIFI_SECURITY_MODE_WEP,             // 1: WEP,share, default key1
	WIFI_SECURITY_MODE_WEP_64_ASCII,    // 2: WEP 64 ASCII
	WIFI_SECURITY_MODE_WEP_64_HEX,      // 3: WEP 64 HEX
	WIFI_SECURITY_MODE_WEP_128_ASCII,   // 4: WEP 128 ASCII
	WIFI_SECURITY_MODE_WEP_128_HEX,     // 5: WEP 128 HEX(X support)
	WIFI_SECURITY_MODE_WPAPSK_TKIP,     // 6: WPAPSK-TKIP
	WIFI_SECURITY_MODE_WPAPSK_AES,      // 7: WPAPSK-AES
	WIFI_SECURITY_MODE_WPA2PSK_TKIP,    // 8: WPA2PSK-TKIP
	WIFI_SECURITY_MODE_WPA2PSK_AES,     // 9: WPA2PSK-AES

	WIFI_SECURITY_MODE_UNKNOWN=0xF
}E_WIFI_SECURITY_MODE;


typedef void (*POnBegin)(void *pUserData, INT32 nATType, float fSoundTime);
//for recognizer:
//	if nResult=ERR_SEAT_SUCCESSFUL, pData recognized, nDataLen is the data size
//	
typedef void (*POnEnd)(void *pUserData, INT32 nATType, float fSoundTime, int nResult, char *pData, int nDataLen);

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

	SEAT_API_API UINT32 SEAT_GetSdkVer(CHAR *chDesc, INT32 nDescMaxSize);
	SEAT_API_API INT32  SEAT_Init(E_SAMPLE_RATE eSampleRate, E_TRANSMIT_TYPE eTransmitType);
	SEAT_API_API VOID   SEAT_DeInit();

	SEAT_API_API INT32  SEAT_Create(UCHAR **ppHandle, E_APP_TYPE eATType, E_RECOGNIZER_PRIORITY ePriority);
	SEAT_API_API VOID   SEAT_Destroy(UCHAR **ppHandle);
	SEAT_API_API INT32  SEAT_SetCallback(UCHAR *pHandle, VOID*pUserData, POnBegin pBegin, POnEnd pEnd);
	SEAT_API_API INT32  SEAT_Start(UCHAR *pHandle);
	SEAT_API_API INT32  SEAT_Stop(UCHAR *pHandle);
	SEAT_API_API INT32  SEAT_Pause(UCHAR *pHandleRecgnizer, INT32 nMicroSecond); //valid for recognizer
	//for Player:
	//		write data is play the content of the data
	//for recognizer:
	//		write data is that the data is writen to the recognizer
	SEAT_API_API INT32  SEAT_WriteByte(UCHAR *pHandle, CHAR *pData, INT32 nDataLen);
	//Parameter:
	//	There is one valid between parameter 'eWifiSecurityMode' and parameter 'pMACAddrWithColon'.
	//	chAppType: 0--15, now default=0
	SEAT_API_API INT32  SEAT_WriteSSIDWiFi(UCHAR *pHandle, CHAR chAppType, CHAR *pSSID, INT32 nSSIDLen, CHAR *pPwd, INT32 nPwdLen, 
											E_WIFI_SECURITY_MODE eWifiSecurityMode, CHAR *pMACAddrWithColon); //only for player

#ifdef __cplusplus
}
#endif // __cplusplus
#endif ////#ifndef __INCLUDED_AT_API____H
