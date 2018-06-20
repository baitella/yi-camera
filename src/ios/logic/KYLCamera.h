//
//  KYLCamera.h
//  SEP2PAppSDKDemo
//


#import <Foundation/Foundation.h>
#import "SEP2P_API.h"
#import "SEP2P_Define.h"
#import "SEP2P_Error.h"
#import "SE_AudioCodec.h"
#import "SE_VideoCodec.h"
#import "KYLCameraProtocol.h"
#import "KYLSearchProtocol.h"
#import "KYLSetWifiProtocol.h"
#import "KYLSetUserInfoProtocol.h"
#import "KYLSetFTPInfoProtocol.h"
#import "KYLSetAlarmInfoProtocol.h"
#import "KYLSetDatetimeProtocol.h"
#import "KYLSetEmailProtocol.h"
#import "KYLSetCameraParamsProtocol.h"
#import "KYLSetSDCardScheduleProtocol.h"
#import "KYLEventProtocol.h"
#import "KYLImageProtocol.h"
#import "KYLSnapPictureProtocol.h"
#import "KYLRemoteRecordPlayProtocol.h"
#import "KYLRemoteRecordPlayImageProtocol.h"
#import "KYLDeviceStatusChangedProtocol.h"
#import "KYLCameraPushFunctionSetProtocol.h"
#import "KYLDefine.h"
#import "KYLRecordFileInfo.h"
#import "KYLCurrentPlayRecordInfo.h"

#import "KYLCircleBuf.h"
#import "KYLOpenALPlayer.h"
#import "PCMRecorder.h"
#import "mp4.h"
#import "KYLComFunUtil.h"

#define K_Error_Video_Stoped            -11
#define K_Error_Camera_Connected_Failed -12


typedef struct tag_MsgInfo
{
	UINT32 nChanNo;
	UINT32 nMsgType;
	UINT32 nMsgSize;
	CHAR*  pMsg;
}MSG_INFO;


typedef enum
{
    KYL_CAMERA_TYPE_UNKNOWN = 0,
	KYL_CAMERA_TYPE_L		= 1,
	KYL_CAMERA_TYPE_M		= 2,
	KYL_CAMERA_TYPE_H		= 3,
    KYL_CAMERA_TYPE_X		= 4
	
}KYL_CAMERA_TYPE;


typedef enum
{
    KYL_REMOTE_RECORD_UNKNOWN = 0,
    KYL_REMOTE_RECORD_TYPE_PLAN		= 1,// plan record
    KYL_REMOTE_RECORD_TYPE_ALARM		= 2, // alarm record
    KYL_REMOTE_RECORD_TYPE_ALL		= 3 // contain all record (plan record, alarm record)
    
}KYL_REMOTE_RECORD_TYPE;

typedef enum
{
    KYL_Talk_REQUEST_STATUS_UNKNOWN = -1,
    KYL_Talk_REQUEST_STATUS_SUCCEED = 0, // can talking now
    KYL_Talk_REQUEST_STATUS_FAILED_FOR_SOME_ONE_TALIKING		= 1,// some one using the talk
    KYL_Talk_REQUEST_STATUS_FAILED_FOR_ERROR		= 2, // send talk request failed
    
}KYL_Talk_REQUEST_STATUS;

/*!
 @class
 @abstract KYLCamera class use to show how to call the interface of sdk。
 */
@interface KYLCamera : NSObject
{
    UINT32 m_nFirstFrameDeviceTime_video; //20150924
}


@property (nonatomic, retain) NSMutableArray *m_listNVRCameras;
@property(nonatomic, assign) int m_nCameraResolution;
@property(nonatomic, assign) int m_nCameraBirght;
@property(nonatomic, assign) int m_nCameraContrast;
@property(nonatomic, assign) int m_nCameraSaturation;
@property(nonatomic, assign) int m_nCameraOSD;
@property(nonatomic, assign) int m_nCameraMode;
@property(nonatomic, assign) int m_nCameraFlip;
@property(nonatomic, assign) int m_nCameraIRLed;
@property(nonatomic, assign) int m_nCurrentAudioSampleRate;
@property(nonatomic, assign) int m_nCurrentAudioChannel;
@property(nonatomic, assign) int nVideoCodecID;	  // refer to SEP2P_ENUM_AV_CODECID
@property(nonatomic, assign) int nAudioCodecID;	  // refer to SEP2P_ENUM_AV_CODECID
@property(nonatomic, retain) NSString *m_sNVideoParameter;// Video: refer to SEP2P_ENUM_VIDEO_RESO
@property(nonatomic, assign) int   nAudioParameter;	  // Audio:(samplerate << 2) | (databits << 1) | (channel)
@property(nonatomic, assign) BOOL m_bIsAdmin;
@property(nonatomic, assign) int m_iIndexForTableView;//记录在设备列表中的位置，第几行
@property(nonatomic, assign) int m_iIndexForImageView;//记录在那个播放窗口显示
@property(nonatomic, assign) id<KYLCameraProtocol> delegate;
@property (nonatomic, assign) id<KYLSearchProtocol> searchDelegate;
@property(atomic, assign) id<KYLSetWifiProtocol> m_pSetWifiDelegate;
@property(atomic, assign) id<KYLSetUserInfoProtocol> m_pSetUserInfoDelegate;
@property(atomic, assign) id<KYLSetFTPInfoProtocol> m_pSetFtpInfoDelegate;
@property(atomic, assign) id<KYLSetAlarmInfoProtocol> m_pSetAlarmInfoDelegate;
@property(atomic, assign) id<KYLSetDatetimeProtocol> m_pSetDatetimeDelegate;
@property(atomic, assign) id<KYLSetEmailProtocol> m_pSetEmailDelegate;
@property(atomic, assign) id<KYLSetCameraParamsProtocol> m_pSetCameraParamDelegate;
@property(atomic, assign) id<KYLEventProtocol> m_pEventDelegate;
@property(atomic, assign) id<KYLImageProtocol> m_pImageDelegate;
@property(atomic, assign) id<KYLSnapPictureProtocol> m_pSnapPictureDelegate;
@property(atomic, assign) id<KYLSetSDCardScheduleProtocol> m_pSetSDCardDelegate;
@property(atomic, assign) id<KYLRemoteRecordPlayProtocol> m_pRemoteRecordDelegate;
@property(atomic, assign) id<KYLRemoteRecordPlayImageProtocol> m_pRemoteRecordPlaybackImageDelegate;
@property(atomic, assign) id<KYLDeviceStatusChangedProtocol> m_pDeviceStatusChangedDelegate;
@property(nonatomic, assign) id<KYLCameraPushFunctionSetProtocol> m_pCameraPushFunctionSetDelegate;

@property (nonatomic, retain) KYLCurrentPlayRecordInfo *m_pCurrentRemoteRecordPlayInfo;

@property (nonatomic, retain) NSString *m_strCurrentLocalRecordFileDate ;
@property (nonatomic, retain) NSString *m_strCurrentLocalRecordFileName ;
@property (nonatomic, retain) NSString *m_strCurrentLocalRecordFilePath ;
@property (nonatomic, copy)  UIImage *m_imgForDeviceHead;
@property (nonatomic, copy) NSString *m_strAdmin;
@property (nonatomic, copy) NSString *m_strAdminPwd;
@property (nonatomic, copy) NSString *m_strVistor;
@property (nonatomic, copy) NSString *m_strVistorPwd;
@property (nonatomic, copy) NSString *onlineCameras;
@property(nonatomic, assign) int m_nCurrentVideoResolution;
@property(nonatomic, assign) int m_iUserType;//用户类型
@property (nonatomic, copy) NSString *m_sDID;
@property (nonatomic, copy) NSString *m_sUsername;
@property (nonatomic, copy) NSString *m_sPassword;
@property (nonatomic, copy) NSString *m_sDeviceName;

@property(nonatomic, assign) int m_nCurrentChannel;
@property(nonatomic, assign) int m_nDeviceType; //	typedef enum{DEVICE_TYPE_IPC =0,DEVICE_TYPE_NVR =1 }E_DEVICE_TYPE;
@property(nonatomic, assign) int m_nNVRChannelNum;
@property(nonatomic, assign) int m_nP2PConnectMode;
@property (nonatomic, assign) int m_nDeviceStatus;
@property (nonatomic, retain) NSNumber *deviceConnectStatus;
@property (nonatomic, assign) int m_nP2PMode;
@property (nonatomic, assign) int m_nAuthor;
@property (nonatomic, assign) int  m_nIMNVersion;
@property (nonatomic, assign) int m_bIsSupportPushFunction;
@property (nonatomic, assign) int m_bAllowCameraPushMsg;
@property (nonatomic, copy) NSString *m_sP2papi_ver;             //API version
@property (nonatomic, copy) NSString *m_sFwp2p_app_ver;          //P2P firmware version
@property (nonatomic, copy) NSString *m_sFwp2p_app_buildtime;    //P2P firmware build time
@property (nonatomic, copy) NSString *m_sFwddns_app_ver;         //firmware version
@property (nonatomic, copy) NSString *m_sFwhard_ver;             //the device hard version
@property (nonatomic, copy) NSString *m_sVendor;//factory name
@property (nonatomic, copy) NSString *m_sProduct;//product mode
@property (nonatomic, copy) NSString *m_sProduct_series;//product main category, L series: product_series[0]='L'; M series:product_series[0]='M',product_series[1]='1';
@property (nonatomic, copy) NSString *m_sCameraToken;
@property (nonatomic, assign) AV_PARAMETER *m_pavParameter;


/*!
 @property
 @abstract m_sDID the device did, it's the uniquely string to mark the device.
 */


+ (int) initSDK;
+ (void) deInitializeSDK;
+ (NSString *) getSDKVersion;
- (id) initCameraWithDID:(NSString *) _sDid account:(NSString *) _sAccount password:(NSString *) _sPwd cameraName:(NSString *) _sCameraName deviceType:(int) _nDeviceType channel:(int) nChannel NVRChannelNum:(int) nNVRChannelNum IMNVersion:(int) nIMNVer isSupportPushFuntion:(int) bIsSupportPushFuntion;
- (id) CopyAllParamFromOther:(KYLCamera *) other;
- (AV_PARAMETER *) getAVParamter;

- (int ) connect;
- (int ) disconnect;
- (int) reGetTheVideoStream;
- (int) reGetTheAudioStream;
- (int) reOpenTalkStream;
- (int) getCameraStatus;
- (int) disconnectAndStop;
- (int) disconnectAndStopWhenInBackground;
- (int) clearAllDelegate;
- (void) setTheLastVideoStatus:(int) _iLastStatus;
- (int) getTheLastVideoStatus;
- (int) cameraType;
- (char *)getTheAVVideoParams;
- (NSMutableArray *)getCameraSupportResolutionList;
- (int) getTheUserType;
- (BOOL) IsAdmin;
- (BOOL) IsConnectedOK;
- (int ) startVideo;
- (int) stopVideo;
- (int) startLocalRecord;
- (int) stopLocalRecord;
- (int) startTalk;
- (int) stopTalk;
- (int) startSendTalkData;//按住说话时，开启发送对讲数据线程
- (int) stopSendTalkData;//松开停止说话时，关闭发送对讲数据线程
- (int) startAudio;
- (int) stopAudio;
- (int) rebootTheCamera;
- (int) snapPicture;
- (int) startSnapPicture;
- (int) stopSnapPicture;
- (int) getAllTheSDCardRecordParam;
- (int) getAllRemoteRecordDays:(int) nYearMonth;
- (int) getAllRemoteRecordDayByMonthWithYear:(int) nYear month:(int) nMonth;
- (int) getAllRemoteRecordFilesByDayWithYear:(int) nYear month:(int) nMonth day:(int) nDay recordType:(int) nRecordType;
- (int) getAllRemoteRecordFilesByDayWithYear:(int) nYear month:(int) nMonth day:(int) nDay  recordType:(int) nRecordType beginIndex:(int) nBegin endIndex:(int) nEnd;
- (int) getAllRemoteAlarmRecordFilesByDayWithYearMonthDay:(int) nYearMonthDay;
- (int) getAllRemoteAllScheduleRecordFilesByDayWithYearMonthDay:(int) nYearMonthDay;
- (int) getAllRemoteAllTypeRecordFilesByDayWithYearMonthDay:(int) nYearMonthDay;
- (int) getAllRemoteRecordFilesByDayWithYearMonthDay:(int) nYearMonthDay  recordType:(int) nRecordType beginIndex:(int) nBegin endIndex:(int) nEnd;
- (int) startPlayRemoteRecordFile:(NSString *) sFilePath;
- (int) startPlayRemoteRecordFile:(NSString *) sFilePath atPos:(int) nPosSec;
- (int) stopPlayRemoteRecordFile:(NSString *) sFilePath;
- (int) startPlayTheRemoteRecordFileWhenSucceedReceiveVideoStream;
- (int) stopPlayTheRemoteRecordFileWhenSucceedReceiveVideoStream;
- (int) left;
- (int) right;
- (int) up;
- (int) down;
- (int) stopPTZGo;
- (int) startGoLeftRight;
- (int) stopGoLeftRight;
- (int) startGoUpDown;
- (int) stopGoUpDown;
- (int) setThePresetBit:(int) nBit;
- (int) runThePresetBit:(int) nBit;
- (int) getVideoStreamType;
- (int) getAudioStreamType;
- (int) getAudioStatus;
- (int) getVideoStatus;
- (int) getRemoteSDCardAudioStatus;
- (int) getRemoteSDCardVideoStatus;
- (int) getTalkStatus;
- (int) getSupportResultionTypeNum;
- (int) getCameraParams;
- (int) getCameraWifi;
- (int) getCameraWifiList;
- (int) getCameraUserInfo;
- (int) getCameraDatetimeInfo;
- (int) getCameraFTPInfo;
- (int) getCameraEmailInfo;
- (int) getCameraAlarmInfo;
- (int) getCameraSDCardScheduleInfo;
- (int) getCameraSoftVersionInfo;
- (int) setTheDefaultCameraParams:(NSString *) sDID;
- (int) setTheCameraResolutionParams:(NSString *) sDID  resolution:(int) nResolution;
- (int) setTheCameraBrightParams:(NSString *) sDID   bright:(int) nBright;
- (int) setTheCameraContrastParams:(NSString *) sDID  contrast:(int) nContrast;
- (int) setTheCameraIRLedParams:(NSString *) sDID  irled:(int) nIRLed;
- (int) setTheCameraOSDParams:(NSString *) sDID   osd:(int) bOSD;
- (int) setTheCameraModeParams:(NSString *) sDID   mode:(int) nMode;
- (int) setTheCameraFlipParams:(NSString *) sDID  flip:(int) nFlip;
- (int) setTheCameraHueParams:(NSString *) sDID  hue:(int) nHue;
- (int) setTheCameraSaturationParams:(NSString *) sDID  saturation:(int) nSaturation;
- (int) setTheCameraAllParams:(NSString *) sDID  resolution:(int) nResolution bright:(int) nBright contrast:(int) nContrast irled:(int) nIRLed osd:(int) bOSD mode:(int) nMode flip:(int) nFlip saturation:(int) nSaturation hue:(int) nHue;
- (int) setTheCameraParams:(NSString *) sDID bitMaskToSet:(int) nBitMaskToSet resolution:(int) nResolution bright:(int) nBright contrast:(int) nContrast irled:(int) nIRLed osd:(int) bOSD mode:(int) nMode flip:(int) nFlip saturation:(int) nSaturation hue:(int) nHue;
- (int) setTheCameraWifi:(NSString *) sDID ssid:(NSString *) sSSID password:(NSString *) sPwd isEnable:(int) bEnable channel:(int) nChannel mode:(int) nMode authType:(int) nAuthtype wepEncrypt:(int)nWEPEncrypt wepKeyFormat:(int)nWEPKeyFormat wepDefaultKey:(int) nWEPDefaultKey wepKey1:(NSString *) sWePKey1 wepKey2:(NSString *) sWepKey2 wepKey3:(NSString *) sWepKey3 wepKey4:(NSString *) sWepKey4 wepKey1Bit:(int) nWEPKey1_bits wepKey2Bit:(int) nWEPKey2_bits wepKey3Bit:(int) nWEPKey3_bits wepKey4Bit:(int) nWEPKey4_bits reqTestResult:(int)bReqTestWifiResult;
- (int) setTheUserInfo:(NSString *) sDID admin:(NSString *) sAdmin adminPassword:(NSString *) adminPwd vistor:(NSString *) sVistor vistorPassword:(NSString *) visitorPwd;
- (int) setTheDatetimeInfo:(NSString *) sDID secToNow:(int) nSecToNow secTimeZone:(int) nSecTimeZone enableFTP:(int) nEnableFTP ntpServer:(NSString *) sNTPServer  indexOfTimeZoneTable:(int) nIndex;
- (int) setTheFTPInfo:(NSString *) sDID ftpServer:(NSString *) sFtpServer username:(NSString *) user password:(NSString *) pwd ftpPath:(NSString  *) sPath port:(int) nPort mode:(int) nMode uploadTime:(int) nUptime;

- (int) setTheAlarmInfo2:(MSG_SET_ALARM_INFO_REQ *) pReq;
- (int) setTheMailInfo:(NSString *) sDID smtpServer:(NSString *) smtpServer user:(NSString *) user password:(NSString *) pwd sender:(NSString *) sender receiver1:(NSString *) receiver1 receiver2:(NSString *) receiver2 receiver3:(NSString *) receiver3 receiver4:(NSString *) receiver4 subject:(NSString *) subject smtpPort:(int) port sslAuth:(int) nSSLAuth;
- (int) setTheSDCardRecordParam:(NSString *) sDID RecordCoverInSDCard:(int) bRecordCoverInSDCard recordTimeLen:(int) nRecordTime isAllowTimeRecord:(int) bTimeRecord;
- (int) formatSDCard:(NSString *) sDID;


/**      interface for NVR   */

- (KYLCamera *) getTheNVRCameraObjWitchChannel:(int) nChannel;



- (int) dealWithTheStreamCallbackResultForNVR:(CHAR *) _sStreamData  dataSize:(UINT32) nSize;

//设置开启，关闭推送功能
- (int) setTheCameraReceivePushFunctionEnable:(BOOL) bEnable;
//获取设备推送功能的开启，关闭状态
- (int) getTheCameraReceivePushFunctionStatus;

//设置cameraToken属性
- (void) setTheCameraTokenInfo:(NSString *) sToken;



@end
