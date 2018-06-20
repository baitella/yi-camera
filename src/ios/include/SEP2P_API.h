#ifndef __INCLUDED_SEP2P_API____H
#define __INCLUDED_SEP2P_API____H

/*!
 @header SEP2P_API
 @abstract This file defines all the APIs that they can connect and control the device.NOTES: This SDK will automatically reconnect the device once you start connecting the device.
 @version 
 */

#ifdef WIN32DLL
	#define SEP2P_CALLBACK	  __stdcall
	#ifdef SEP2P_API_EXPORTS
		#define SEP2P_API_API  __declspec(dllexport)
	#else
		#define SEP2P_API_API __declspec(dllimport)
	#endif
#endif //// #ifdef WIN32DLL

#ifdef LINUX
	#include <netinet/in.h>
	#define SEP2P_API_API 
	#define SEP2P_CALLBACK
#endif //// #ifdef LINUX

//LINUX_ANDROID

//LINUX_iOS

#include "SEP2P_Type.h"
#include "SEP2P_Error.h"
#include "SEP2P_Define.h"

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

	typedef enum{
		DEVICE_TYPE_IPC =0,
		DEVICE_TYPE_NVR =1,
		DEVICE_TYPE_DOORBELL=2 //added on 20150907

	}E_DEVICE_TYPE;


    /*!
     @struct SEARCH_RESP
     @abstract tag_stSearchResp£¬SEARCH_RESP define the device information that have been found in LAN by excute SEP2P_StartSearch() function. the result return by call back funtion (PLANSearchCallback)..
     @field szIpAddr  type:  CHAR; means: Device IP address
     @field reserve1  type: CHAR ; means: no used, perpare for future use.
     @field szMacAddr  type:  CHAR; means: Device MAC address
     @field nPort  type:  UINT16; means: Device port
     @field szDeviceID  type:  CHAR; means: Device DID
     @field szDevName  type:  CHAR; means: Device name
     @field reserve2  type: CHAR ; means: no used, perpare for future use.
     @field product_type  type: CHAR ; means: Product type. It is M series if its value is 0x4D01. It is L series if 0x0000.
     @field reserve3  type: CHAR ; means:  no used, perpare for future use.
     @discussion tag_stSearchResp£¬SEARCH_RESP define the camera information that have been found in LAN by excute SEP2P_StartSearch() function. the result return by call back funtion (PLANSearchCallback)...
     */
	typedef struct tag_stSearchResp
	{
		CHAR            szIpAddr[16];	//Device IP address
		CHAR            reserve1[64];
		CHAR            szMacAddr[6];	//Device MAC address
		UINT16			       nPort;	//Device port
		CHAR            szDeviceID[32]; //DID
		CHAR            szDevName[32];	//Device name
		
		CHAR			szFWDeviceVer[16];//device firmware version
		CHAR            szFWP2PVer[16];   //p2p firmware version
		CHAR            reserve2[65];
		CHAR			product_type[2];  //=0x4D01, M series; product_type[0]='M'; =0x0000, L series 
		CHAR			nDeviceType;	  //refer to E_DEVICE_TYPE
		CHAR            szProductMode[20];//added 2015-09-16
	}SEARCH_RESP, *PSEARCH_RESP;
    
    /*!
     @typedef PLANSearchCallback( CHAR*	pData, UINT32  nDataSize, VOID* pUserData)
     @abstract The callback function. The function will be excute when have find any camera in lan network. one device information return at a time.
     @param nUserTag INT32 nUserTag the tag for the caller.
     @param nStreamType INT32 nStreamType the call back stream type such as video stream, audio stream.
     @param pUserData VOID* pUserData.
     @result INT32.
     @discussion The callback function. The function will be excute when have find any camera in lan network.
     Lorem ipsum...
     */
	typedef INT32 (* PLANSearchCallback)(
                                         CHAR*	pData,
                                         UINT32  nDataSize,
                                         VOID*	pUserData);

    /*!
     @struct AV_PARAMETER
     @abstract tag_stAVParameter, AV_PARAMETER define the Stream params head packet information, it used for known the stream type.
     @field nVideoCodecID  type:  UINT32; means: refer to SEP2P_ENUM_AV_CODECID, tell you the video stream type.
     @field nAudioCodecID  type:  UINT32; means: refer to SEP2P_ENUM_AV_CODECID, the audio stream type.
     @field nVideoParameter  type:  CHAR; means: Video: refer to SEP2P_ENUM_VIDEO_RESO in SEP2P_Define.h, tell you The resolution of the device's video.
     @field nAudioParameter  type:  CHAR; means: Audio:(samplerate << 2) | (databits << 1) | (channel)
     @field reserve  type:  CHAR; means: no used, prepared for future use.
     @discussion tag_stAVParameter, AV_PARAMETER define the Stream head packet information, it used for known the stream type..
     */
	typedef struct tag_stAVParameter
	{
		UINT32 nVideoCodecID;	  // refer to SEP2P_ENUM_AV_CODECID
		UINT32 nAudioCodecID;	  // refer to SEP2P_ENUM_AV_CODECID
		CHAR   nVideoParameter[7];// Video: refer to SEP2P_ENUM_VIDEO_RESO
		CHAR   nAudioParameter;	  // Audio:(samplerate << 2) | (databits << 1) | (channel)
		UCHAR  nDeviceType;		  // added on 20150504, 0=DEVICE_TYPE_IPC, 1=DEVICE_TYPE_NVR, 2=DEVICE_TYPE_DOORBELL, ...
		UCHAR  nMaxChannel;		  // added on 20150504,
		CHAR   reserve[6];
	}AV_PARAMETER;
    
    
    /*!
     @struct STREAM_HEAD
     @abstract tag_stStreamHead, STREAM_HEAD define the Stream head packet information, it's used for difference between audio stream and video stream, it's also tell you the stream channel.
     @field nCodecID  type:  UINT32; means: refer to SEP2P_ENUM_AV_CODECID, tell you the video stream type.
     @field nParameter  type:  UINT32; means: Video: refer to SEP2P_ENUM_VIDEO_FRAME.   Audio:(samplerate << 2) | (databits << 1) | (channel), if it is video stream, the param means the first frame type. if current stream is audio stream , the param means the audio samplerate, databits ,channel.
     @field nLivePlayback  type:  CHAR; means: Video: refer to SEP2P_ENUM_VIDEO_RESO
     @field reserve1  type:  CHAR*; means: no used, prepared for future use.
     @field nStreamDataLen  type:  CHAR; means: no used, prepared for future use.
     @field nTimestamp  type:  CHAR; means: no used, prepared for future use.
     @field reserve2  type:  CHAR; means: no used, prepared for future use.
     @discussion tag_stAVParameter, AV_PARAMETER define the Stream head packet information, it's used for difference between audio stream and video stream, it's also tell you the stream channel..
     */
	typedef struct tag_stStreamHead
	{
		UINT32 nCodecID;	 // refer to SEP2P_ENUM_AV_CODECID
		CHAR   nParameter;	 // Video: refer to SEP2P_ENUM_VIDEO_FRAME.   Audio:(samplerate << 2) | (databits << 1) | (channel), samplerate refer to SEP2P_ENUM_AUDIO_SAMPLERATE; databits refer to SEP2P_ENUM_AUDIO_DATABITS; channel refer to SEP2P_ENUM_AUDIO_CHANNEL
		CHAR   nLivePlayback;// Video: 0:live video or audio;  1:playback video or audio
		UCHAR  nChannel;	 // begin from 0
		CHAR   reserve1;

		UINT32 nStreamDataLen;	// Stream data size after following struct 'STREAM_HEAD'
		UINT32 nTimestamp;		// Timestamp of the frame, in milliseconds
		UCHAR  nNumConnected;	// amount that app connected this device for M,X series when nCodecID is AV_CODECID_VIDEO...
		UCHAR  nNumLiveView;	// amount that app is at liveview UI for M,X series when nCodecID is AV_CODECID_VIDEO...
		CHAR   reserve2[2];
		UINT32 nPlaybackID;		// reserve2[2,5] -> nPlaybackID, modified on 20141201
	}STREAM_HEAD;
    
    /*!
     @typedef POnStreamCallback(const CHAR* pDID, CHAR*	pData, UINT32  nDataSize, VOID* pUserData)
     @abstract The callback function. The function will be excute when receive video stream, audio stream, you can distinguish stream type by the nStreamType param. you should register the call back function before you open the  video stream or open the audio stream.
     @param pDID CHAR* pDID:camera's DID.
     @param pData CHAR* the return data .
     @param nDataSize INT32 the returned data size.
     @param pUserData VOID* pUserData the information about caller.
     @result INT32.
     @discussion The callback function. The function will be excute when receive video stream, audio stream, you can distinguish stream type by the nStreamType param. you should register the call back function before you open the  video stream or open the audio stream. if the returned stream is video stream, the data contain a stream head which you can refer to STREAM_HEAD define, the stream head tell you the size of video frame. if the video type is mjpeg, you can direct convert the char* data to image for display, otherwise, if the video type is h264, you should first decode the data, then convert the data to image data. if the stream is audio stream, it also contain a stream head that define in STREAM_HEAD, you can get the size of the audio data and the audio encode type by the STREAM_HEAD. for example,if the audio encode type is adpcm, you should first decode the adpcm data, if the device's type is L series, the audio encode type is adpcm, The M series device audio encode type is g726. The most import thing you should known that the call back can be register successfully after you called the SEP2P_Connect() api .
     */
	typedef INT32 (* POnStreamCallback)(
                                        CHAR*   pDID,
                                        CHAR*	pData,
                                        UINT32  nDataSize,
                                        VOID*	pUserData);
    
    /*!
     @typedef POnRecvMsgCallback(const CHAR* pDID, UINT32  nMsgType, CHAR*  pMsg,UINT32  nMsgSize, VOID *pUserData)
     @abstract The callback function. The function will be excute when receive io command excute finished, you can distinguish command type by the IOCtrlType param. you should register the call back function before you send any command to control the camera, For example, when you want to send commands such as set wifi, snap picture,set camera's video quality, set camera's mirror flip, set alarm params, set the ftp params, get camera's information and so on .
     @param pDID CHAR* pDID:camera's DID.
     @param nMsgType INT32 the message type you can refer to the message enum SEP2P_ENUM_MSGTYPE.
     @param pMsg CHAR*    the message data information.
     @param nMsgSize UINT32  the size of message.
     @param pUserData VOID* pUserData  the attached information, it may save the caller information.
     @result INT32.
     @discussion The callback function. The function will be excute when receive io command excute finished, you can distinguish command type by the IOCtrlType param. you should register the call back function before you send any command to control the camera, For example, when you want to send commands such as set wifi, snap picture,set camera's video quality, set camera's mirror flip, set alarm params, set the ftp params, get camera's information and so on  you can refer to the enum SEP2P_ENUM_MSGTYPE.The most import thing you should known that the call back can be register successfully after you called the SEP2P_Connect() api ..
     */
	typedef INT32 (* POnRecvMsgCallback)(
							CHAR*   pDID,
							UINT32  nMsgType,
							CHAR*   pMsg,
							UINT32  nMsgSize,
							VOID*   pUserData);

	/*!
	 @enum SEP2P_ENUM_EVENT_TYPE
	 @abstract the enum used to distinguish event type.
		SEP2P_ENUM_EVENT_TYPE eEvent;
		......
		if(eEvent<EVENT_TYPE_DOORBELL_ALARM){
			switch(eEvent){
				case EVENT_TYPE_MOTION_ALARM:
					motion_alarm;
					break;

				case EVENT_TYPE_INPUT_ALARM:
					in_io_alarm;
					break;

				case EVENT_TYPE_AUDIO_ALARM:
					audio_alarm
					break;

				case EVENT_TYPE_MANUAL_ALARM:
					manual_alarm
					break;

				default:;
		   }
		}else{
		   if((eEvent & EVENT_TYPE_DOORBELL_ALARM)==EVENT_TYPE_DOORBELL_ALARM) doorbell_alarm;
		   if((eEvent & EVENT_TYPE_TEMPERATURE_ALARM)==EVENT_TYPE_TEMPERATURE_ALARM) temperature_alarm;
		   if((eEvent & EVENT_TYPE_HUMIDITY_ALARM)==EVENT_TYPE_HUMIDITY_ALARM) humidity_alarm;
		}

	 @discussion the enum defined event type.
	 @constant EVENT_TYPE_UNKNOWN  means that the event type is unknown .
	 @constant EVENT_TYPE_MOTION_ALARM  means that event type is motion detect alarm.
	 @constant EVENT_TYPE_INPUT_ALARM  means that event type is extern input alarm.
	 */
	typedef enum
	{
		EVENT_TYPE_UNKNOWN      = 0x00,
		EVENT_TYPE_MOTION_ALARM = 0x01,
		EVENT_TYPE_INPUT_ALARM  = 0x02,
		EVENT_TYPE_AUDIO_ALARM  = 0x03,
		EVENT_TYPE_MANUAL_ALARM = 0x04,

		EVENT_TYPE_DOORBELL_ALARM	 = 0x08,
		EVENT_TYPE_TEMPERATURE_ALARM = 0x10,
		EVENT_TYPE_HUMIDITY_ALARM	 = 0x20
	}SEP2P_ENUM_EVENT_TYPE;

	typedef struct tag_stEventData
	{
		CHAR	eDeviceType; // refer to E_DEVICE_TYPE
		CHAR    nChannel;	 // for Doorbell, gate ipc no
		CHAR    nTypeNotify; // for Doorbell, 0=power on of gate ipc, 1=power off of gate ipc,  -1=unknown
		CHAR	reserve[13];
	}EVENT_DATA;
/*!
     @typedef POnEventCallback(const CHAR* pDID,  INT32 nEventType, VOID *pUserData)
     @abstract The callback function. The function will be excute when receive the event notificatons that send by camera, the events include camera' status change notifications, camera's alarm notification, some push notifications, you can distinguish event type by the nEventType param. you should register the call back function first.£¬.
     @param pDID CHAR* pDID:camera's DID.
     @param nEventType INT32 nEventType the event type, refer to SEP2P_ENUM_EVENT_TYPE.
	 @param pEventData CHAR* pEventData the event data for future use.
	 @param nEventDataSize INT32 nEventDataSize the event data size for future use.
     @param pUserData VOID* pUserData the attached information.
     @result null.
     @discussion The callback function. The function will be excute when receive the event notificatons that send by camera, the events include camera' status change notifications, camera's alarm notification, some push notifications, you can distinguish event type by the nEventType param. you should register the call back function first.The most import thing you should known that the call back can be register successfully after you called the SEP2P_Connect() api ..
     Lorem ipsum...
     */
	typedef INT32 (* POnEventCallback)(
							CHAR*   pDID,
							UINT32  nEventType, //refer to SEP2P_ENUM_EVENT_TYPE
							CHAR*   pEventData,
							UINT32  nEventDataSize,
							VOID*   pUserData);

	/*!
     @method
     @abstract SEP2P_GetSDKVersion(CHAR *chDesc, INT32 nDescMaxSize) Get the version of sdk.
     @discussion Get the version of sdk.
     @param chDesc   CHAR *chDesc The buffer that used catch the SDK summary information.
     @param nDescMaxSize INT32 nDescMaxSize The max size of the buffer, suggest 256 bytes.
     @result UINT32 Returns an integer value of little-endian. It is SDK version. 
     */
	SEP2P_API_API UINT32 SEP2P_GetSDKVersion(CHAR *chDesc, INT32 nDescMaxSize);
    
	/*!
	 @struct ST_InitStr
	 @abstract ST_InitStr, .
	 @discussion Every ST_InitStr object represents a product series. The different products have different prefix and initialization string. Please acquire them from the manufacturer.
	 @field chPrefix  type: CHAR* ; means: the prefix of the device ID.
	 @field chInitStr  type:  CHAR* ; means: the initialization string of the device.
	 */
	typedef struct tag_stInitStr
	{
		CHAR chPrefix[8];
		CHAR chInitStr[256];
	}ST_InitStr;

    /*!
     @method
     @abstract SEP2P_Initialize(ST_InitStr *pArrStInitStr, INT32 nArrNum);  Initialize the sdk manager class.It must be the first API called(exclude SEP2P_GetSDKVersion)
     @discussion Initialize the sdk manager class, you should first initial the sdk, then call the SEP2P_Connect() api to connect device, if the device connected successfully, finally, you can start play video, play audio , start talk and so on. You should known that the audio , talk can not be open successfully when the video stream is not opened. only the device's connect status is connected, all the api interface is valid. You can initial the sdk like this: (ios example: - (void) initSDK
     {
     char chDesc[256]={0};
     UINT32 nAPIVer=SEP2P_GetSDKVersion(chDesc, sizeof(chDesc));
     char *pVer=(char *)&nAPIVer;
     
     NSLog(@"SEP2P_API ver=%d.%d.%d.%d, %s\n", *(pVer+3), *(pVer+2), *(pVer+1), *(pVer+0), chDesc);
     
     ST_InitStr stInitStr;
     memset(&stInitStr, 0, sizeof(stInitStr));
     strcpy(stInitStr.chInitStr, "EBGDEKBKKHJLGHJIEJGEFGEBHHNNHKNGHGFMBACGAAJELKLBDNAICGOKGMLJJDLPALMLLMDIODMFBPCIJLMP");
     strcpy(stInitStr.chPrefix, "VIEW");
     SEP2P_Initialize(&stInitStr, 1);
     NSLog(@"%s %s", KYL_THE_FILE_NAME, __FUNCTION__);
     }
     )
     @param pArrStInitStr   ST_InitStr *pArrStInitStr the struct contain  some important information of sdk.
     @param nArrNum   INT32.ST_InitStr number. Max number is 18. To return ERR_SEP2P_INVALID_PARAMETER if >18
     @result INT32 Returns ERR_SEP2P_SUCCESSFUL.
     */
	SEP2P_API_API INT32 SEP2P_Initialize(ST_InitStr *pArrStInitStr, INT32 nArrNum);
    
    /*!
     @method
     @abstract SEP2P_DeInitialize(void) Release resources allocated when initialization.
     @discussion Release all resources used by SEP2P_AppSDK APIs.After this, no SEP2P_AppSDK APIs can be used. Unless SEP2P_Initialize() is called again. the api is used for release the resource that the sdk have alloc .
         The ios example as follows:
     - (void) deInitializeSDK
     {
     SEP2P_DeInitialize();
     NSLog(@"%s %s", KYL_THE_FILE_NAME, __FUNCTION__);
     }

     @param void  .
     @result INT32 Returns ERR_SEP2P_SUCCESSFUL.
     */
	SEP2P_API_API INT32 SEP2P_DeInitialize(void);
    
    /*!
     @method
     @abstract SEP2P_StartSearch(PLANSearchCallback pLANSearchCallback, VOID *pUserData) Start LAN search all equipment.
     @discussion Start LAN search all equipment.
     @param pLANSearchCallback PLANSearchCallback pLANSearchCallback the search call back function.
     @param pUserData VOID *pUserData save the data for sdk user pointer.
     @result INT32 Returns ERR_SEP2P_SUCCESSFUL or ERR_SEP2P_NOT_INITIALIZED.
     */
	SEP2P_API_API INT32 SEP2P_StartSearch(PLANSearchCallback pLANSearchCallback, VOID *pUserData);
    
    /*!
     @method
     @abstract SEP2P_StopSearch() Stop search.
     @discussion Stop search.
     @param NULL.
     @result INT32 Returns ERR_SEP2P_SUCCESSFUL or ERR_SEP2P_NOT_INITIALIZED.
     */
	SEP2P_API_API INT32 SEP2P_StopSearch();
    
    /*!
     @method
     @abstract SEP2P_Connect(const CHAR* pDID, const CHAR* pUser, const CHAR* pPwd) Connect to device.
     @discussion Connect to Device.
     @param pDID   CHAR* pDID Device's DID.
     @param pUser  CHAR* the device's username.
     @param pPwd   CHAR* the device's password.
     @result INT32 Returns ERR_SEP2P_NOT_INITIALIZED, ERR_SEP2P_INVALID_PARAMETER, ERR_SEP2P_ALREADY_CONNECTED, ERR_SEP2P_EXCEED_MAX_CONNECT_NUM, ERR_SEP2P_SUCCESSFUL.
     */
	SEP2P_API_API INT32 SEP2P_Connect(const CHAR* pDID, const CHAR* pUser, const CHAR* pPwd);
    
    /*!
     @method
     @abstract SEP2P_Disconnect(const CHAR* pDID) Disconnect with device.
     @discussion Disconnect with device.
     @param pDID type: const CHAR*; means: the device's did..
     @result INT32 Returns ERR_SEP2P_NOT_INITIALIZED, ERR_SEP2P_INVALID_PARAMETER, ERR_SEP2P_NO_CONNECT_THIS_DID or ERR_SEP2P_SUCCESSFUL.
     */
	SEP2P_API_API INT32 SEP2P_Disconnect(const CHAR* pDID);
    
    /*!
     @method
     @abstract SEP2P_GetAVParameterSupported(const CHAR* pDID, AV_PARAMETER *pOut_AV_Parameter).
     @discussion Only the device's status is connected, the interfact is valid. (you can find device's status by SEP2P_MSG_CONNECT_STATUS).
     @param pDID type: const CHAR*; means: the device's did  ..
     @param pOut_AV_Parameter type: AV_PARAMETER *; means: the param is output param, return the information of  stream. you can find detail information of AV_PARAMETER refer to the define of struct AV_PARAMETER , .
     @result INT32  Returns ERR_SEP2P_NOT_INITIALIZED, ERR_SEP2P_INVALID_PARAMETER or ERR_SEP2P_SUCCESSFUL
     */
	SEP2P_API_API INT32 SEP2P_GetAVParameterSupported(const CHAR* pDID, AV_PARAMETER *pOut_AV_Parameter);

    /*!
     @method
     @abstract SEP2P_SendTalkData(const CHAR* pDID, CHAR* pData, INT32 nDataSize, UINT64 nTimestamp).
     @discussion Only the device's status is connected, the interfact is valid. (you can find device's status by SEP2P_MSG_CONNECT_STATUS).Before you send talk audio stream data, you should first send open device's talk channel by send talk cgi command. You can send it by SEP2P_SendMsg() function (the msgtype is SEP2P_MSG_START_TALK), then you can get the result by POnRecvMsgCallback call back funtion (the msgtype is SEP2P_MSG_START_TALK_RESP, you can get a MSG_START_TALK_RESP data, if the result in MSG_START_TALK_RESP equal to 0, it's means that the talk channel be opened succefully, you can send talk data at once; other wise, if the result = 1, means that someone has used the talk channel, you must wait it be free, if the result= 2, it's means that some error happen );
     @param pDID type: const CHAR*; means: the device's did..
     @param pDID type: CHAR*; means: the talk data want to be sent..
     @param pDID type: INT32; means: the size of data..
     @param pDID type: UINT64; means: the talk's timestamp..
     @result INT32  Returns ERR_SEP2P_NOT_INITIALIZED, ERR_SEP2P_INVALID_PARAMETER, ERR_SEP2P_NO_CONNECT_THIS_DID, ERR_SEP2P_WRITTEN_SIZE_TOO_BIG, ERR_SEP2P_STOPPED_TALK or ERR_SEP2P_SUCCESSFUL.
     */
	//1>nDataSize>1024 bytes			-- ERR_SEP2P_WRITTEN_SIZE_TOO_BIG
	//2>(nDataSize%40)!=0 for G726		-- ERR_SEP2P_INVALID_PARAMETER
	//3>(nDataSize%160)!=0 for G711A	-- ERR_SEP2P_INVALID_PARAMETER
	//4>nDataSize<0						-- ERR_SEP2P_INVALID_PARAMETER
	//5>nDataSize!=256 for ADPCM		-- ERR_SEP2P_INVALID_PARAMETER
	SEP2P_API_API INT32 SEP2P_SendTalkData(const CHAR* pDID, CHAR* pData, INT32 nDataSize, UINT64 nTimestamp);
    
    /*!
     @method
     @abstract SEP2P_SendMsg(const CHAR* pDID, INT32 nMsgType, const CHAR* pMsgData, INT32 nMsgDataSize) Send the command that control the device or set the device's params, or get the device's params.
     @discussion  Send the command that control the device or set the device's params, or get the device's params..
     
     <br><b>For example:</b>
     <br>(1)start video: INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_START_VIDEO, NULL, 0);
     <br>(2)stop video: INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_STOP_VIDEO, NULL, 0);
     <br>(3) start audio: INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_START_AUDIO, NULL, 0);
     <br>(4) stop audio: INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_STOP_AUDIO, NULL, 0);
     <br>(5) start talk:INT32 nRet=SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_START_TALK, NULL, 0);
     <br>(6) stop talk: INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_STOP_TALK, NULL, 0);
     <br>(7) control the device's ptz:
     <br>{
     <br>MSG_PTZ_CONTROL_REQ ptzMsg;
     <br>ptzMsg.nCtrlCmd = PTZ_CTRL_LEFT;
     <br>ptzMsg.nCtrlParam = 0;
     <br>const CHAR* pMsgData = (CHAR*)&ptzMsg;
     <br>INT32 nMsgDataSize = (INT32)sizeof(MSG_PTZ_CONTROL_REQ);
     <br>INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_PTZ_CONTROL_REQ, pMsgData, nMsgDataSize);
     <br>}
     <br>(8) // send the get camera's params command to device
     <br>INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_CAMERA_PARAM_REQ, NULL, 0);
     <br>(9)// send the get camera's wifi command to device
     <br>INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_CURRENT_WIFI_REQ, NULL, 0);
     <br>(10)// send the get camera's wifi list command to device
     <br>INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_WIFI_LIST_REQ, NULL, 0);
     <br>(11) // send the get camera's user command to device
     <br>INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_USER_INFO_REQ, NULL, 0);
     <br>(12)// send the get camera's datetime command to device
     <br>INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_DATETIME_REQ, NULL, 0);
     <br>(13)// send the get camera's ftp command to device
     <br>INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_FTP_INFO_REQ, NULL, 0);
     <br>(14)// send the get camera's sdcard schedule command to device
     <br>INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_SDCARD_REC_PARAM_REQ, NULL, 0);
     <br>(15)// send the get camera's hard soft version information command to device
     <br>INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_DEVICE_VERSION_REQ, NULL, 0);
     
     @param pDID type: const CHAR*; means: the device's did..
     @param nMsgType   INT32 nMsgType command type, you can refer to SEP2P_ENUM_MSGTYPE enum.
     @param pMsgData   CHAR* pIOData command data.
     @param nMsgDataSize   INT32 nIODataSize the size of data.It must be less than or equal to 4KBytes
     @result INT32 Returns ERR_SEP2P_NOT_INITIALIZED, ERR_SEP2P_INVALID_PARAMETER, ERR_SEP2P_NO_CONNECT_THIS_DID, ERR_SEP2P_INVALID_MSG_TYPE,ERR_SEP2P_NO_SUPPORT_THIS_CODECID or ERR_SEP2P_SUCCESSFUL 
     */
	//will return ERR_SEP2P_INVALID_PARAMETER if nMsgDataSize>4KBytes every time
	SEP2P_API_API INT32	SEP2P_SendMsg(const CHAR* pDID, INT32 nMsgType, const CHAR* pMsgData, INT32 nMsgDataSize);
	
    /*!
     @method
     @abstract SSEP2P_SetStreamCallback(const CHAR* pDID, POnStreamCallback pStreamCallback, VOID *pUserData) register the call back function to receive the stream such as video stream, audio stream.
     @discussion register the call back function to receive the stream such as video stream, audio stream.
     @param pDID type: const CHAR*; means: the device's did..
     @param pStreamCallback   POnStreamCallback pStreamCallback The call back function that you want to register.
     @param pUserData   VOID *pUserData The params that mark the user pointer.
     @result INT32 Returns ERR_SEP2P_NOT_INITIALIZED, ERR_SEP2P_NO_CONNECT_THIS_DID or ERR_SEP2P_SUCCESSFUL.
     */
	SEP2P_API_API INT32 SEP2P_SetStreamCallback(const CHAR* pDID, POnStreamCallback pStreamCallback, VOID *pUserData);
    
    /*!
     @method
     @abstract  SEP2P_SetRecvIOCtrlCallback(const CHAR* pDID, POnRecvIOCtrlCallback pRecvIOCtrlCallback,  VOID *pUserData) register the call back function to receive the result of send command.
     @discussion register the call back function to receive the result of send command.
     @param pDID type: const CHAR*; means: the device's did..
     @param pRecvIOCtrlCallback   POnRecvIOCtrlCallback pRecvIOCtrlCallback The call back function that you want to register..
     @param pUserData   VOID *pUserData The params that mark the user pointer.
     @result INT32 Returns ERR_SEP2P_NOT_INITIALIZED, ERR_SEP2P_NO_CONNECT_THIS_DID or ERR_SEP2P_SUCCESSFUL.
     */
    SEP2P_API_API INT32 SEP2P_SetRecvMsgCallback(const CHAR* pDID, POnRecvMsgCallback pRecvMsgCallback, VOID *pUserData);
    
    /*!
     @method
     @abstract SEP2P_SetEventCallback(const CHAR* pDID, POnEventCallback pEventCallback, VOID *pUserData) register the call back function to receive the events from device.
     @discussion register the call back function to receive the events from device.
     @param pDID type: const CHAR*; means: the device's did..
     @param pEventCallback   POnEventCallback pEventCallback The call back function that you want to register.
     @param pUserData   VOID *pUserData The params that mark the user pointer.
     @result INT32 Returns ERR_SEP2P_NOT_INITIALIZED, ERR_SEP2P_NO_CONNECT_THIS_DID or ERR_SEP2P_SUCCESSFUL.
     */
    SEP2P_API_API INT32 SEP2P_SetEventCallback(const CHAR* pDID, POnEventCallback pEventCallback, VOID *pUserData);

#ifdef __cplusplus
}
#endif // __cplusplus
#endif ////#ifndef __INCLUDED_SEP2P_API____H
