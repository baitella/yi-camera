//
//  KYLCamera.m
//  SEP2PAppSDKDemo
//

#import "KYLCamera.h"

#define KYL_THE_FILE_NAME "KYLCamera"

#define KYL_MAX_CONNECT_TIME 900
#define KYL_MAX_TIME_OUT_FOR_RECONNECT (100)

static NSString *m_gStrSDKVersion = nil;
static int m_gnSDKVersion = 0;

@interface KYLCamera ()
{
    UCHAR *m_pAudioHandleG726;
    UCHAR *m_pAudioHandleAdpcm;
    UCHAR *m_pAudioHandleG711;
    UCHAR *m_pAudioHandleAAC;
    UCHAR *m_pMp4videoRecordToolHandle;
    int m_bVideoPlayThreadRuning;
    int m_bAudioPlayThreadRuning;
    int m_bTalkThreadRuning;
    KYLCircleBuf *m_pVideoBuf;
    KYLCircleBuf *m_pAudioBuf;
    KYLCircleBuf *m_pTalkAudioBuf;
    KYLCircleBuf *m_pRemoteRecordPlayBackVideoBuf;
    KYLCircleBuf *m_pRemoteRecordPlayBackAudioBuf;
    
    int m_nCurrentPlaybackID;
    int m_nCurrentPlaybackAudioParam;
    int m_bRemoteRecordVideoPlayThreadRuning;
    int m_bRemoteRecordAudioPlayThreadRuning;
    int m_bRemoteRecordVideoShowing;//čżç¨ĺćžč§é˘ćŻĺŚĺˇ˛çťĺźĺ§ćžç¤ş
    KYLOpenALPlayer *m_pAudioPlayer;
    KYLOpenALPlayer *m_pRemoteRecordAudioPlayer;
    CPCMRecorder *m_pPCMRecorder;
    
    int m_bTalkResp; //=0 OK, juju1
    int m_bLocalRecording;
    NSInteger m_nFirstLocalRecordFrameTimeStamp;
    int m_iTalkEncodeType;//
    int m_iLastVideoStatusBeforeInBackground;//čŽ°ĺ˝ćĺćşĺ¨ććşéĺąćččżĺĽĺĺ°ĺçč§é˘çść
    BOOL m_bFindIFrame;
    BOOL m_bCameraReconnectStarted;
    BOOL m_bSucceedGetCameraSoftVersionInfo;
    int m_bIsPrepareForSnapPicture;//ćŻĺŚčŚććďźććçćśĺďźčżčĄyuvč˝Źrgb24
    NSCondition *m_LockForVideoBuf;
    NSCondition *m_LockForRemoteVideoBuf;
    NSCondition *m_LockForAudioBuf;
    NSCondition *m_LockForRemoteAudioBuf;
    NSCondition *m_LockForTalkBuf;
    int m_nSubscribeType;// 0 -- unsubscribe push , 1 -- subscribe push
    AV_PARAMETER m_avParameter;
    int m_bIsSendingTalkDataToDevice;//ĺŚćć­Łĺ¨ĺéĺŻščŽ˛ć°ćŽďźĺčŚĺć­˘ććşĺŁ°éłć­ćžďźm_bIsSendingTalkDataToDevice=1ďźďźĺ˝ĺéĺŻščŽ˛ć°ćŽĺć­˘ďźĺŚćçĺŹĺźĺŻĺć­ćžĺŁ°éł
    /** NVR param **/
}

@end


@implementation KYLCamera
- (id) init
{
    NSLog(@"init kylcamera");
    self = [super init];
    if (self) {
        [self initData];
        // [self initSDK];
    }
    return self;
}


- (id) initCameraWithDID:(NSString *) _sDid account:(NSString *) _sAccount password:(NSString *) _sPwd cameraName:(NSString *) _sCameraName deviceType:(int) _nDeviceType channel:(int) nChannel NVRChannelNum:(int) nNVRChannelNum IMNVersion:(int) nIMNVer isSupportPushFuntion:(int) bIsSupportPushFuntion
{
    id result = [self init];
    if (result) {
        self.m_sDID = _sDid;
        self.m_sUsername = _sAccount;
        self.m_sPassword = _sPwd;
        self.m_sDeviceName = _sCameraName;
        self.m_nCurrentChannel = nChannel;
        self.m_nNVRChannelNum = nNVRChannelNum;
        self.m_nIMNVersion = nIMNVer;
        self.m_nDeviceType = _nDeviceType;
        self.m_bIsSupportPushFunction = bIsSupportPushFuntion;
    }
    return result;
}

- (AV_PARAMETER *) getAVParamter
{
    return (AV_PARAMETER *) &m_avParameter;
}

- (void) clearAllResources
{
    [self disconnect];
    [self stopAudio];
    [self stopTalk];
    [self stopVideo];
    
    
    [m_LockForVideoBuf release];
    m_LockForVideoBuf = nil;
    
    [m_LockForRemoteVideoBuf release];
    m_LockForRemoteVideoBuf = nil;
    
    [m_LockForAudioBuf release];
    m_LockForAudioBuf = nil;
    
    [m_LockForRemoteAudioBuf release];
    m_LockForRemoteAudioBuf = nil;
    
    [m_LockForTalkBuf release];
    m_LockForTalkBuf = nil;
    
    self.searchDelegate = nil;
    self.delegate = nil;
    
    self.m_pSetWifiDelegate = nil;
    self.m_pSetUserInfoDelegate = nil;
    self.m_pSetFtpInfoDelegate = nil;
    self.m_pSetAlarmInfoDelegate = nil;
    self.m_pSetDatetimeDelegate = nil;
    self.m_pSetEmailDelegate = nil;
    self.m_pSetCameraParamDelegate = nil;
    self.m_pEventDelegate = nil;
    self.m_pImageDelegate = nil;
    self.m_pSnapPictureDelegate = nil;
    self.m_pSetSDCardDelegate = nil;
    self.m_pRemoteRecordDelegate = nil;
    self.m_pDeviceStatusChangedDelegate = nil;
    self.m_pRemoteRecordPlaybackImageDelegate = nil;
    self.m_pCameraPushFunctionSetDelegate = nil;
    
    self.m_sDID = nil;
    self.m_strAdmin = nil;
    self.m_strAdminPwd = nil;
    self.m_strVistor = nil;
    self.m_strVistorPwd = nil;
    
    self.m_imgForDeviceHead = nil;
    
    if (m_pVideoBuf) {
        delete m_pVideoBuf;
        m_pVideoBuf = NULL;
    }
    //{{-- add by kongyulu at 20141217
    if (m_pRemoteRecordPlayBackVideoBuf) {
        delete m_pRemoteRecordPlayBackVideoBuf;
        m_pRemoteRecordPlayBackVideoBuf = NULL;
    }
    if (m_pRemoteRecordPlayBackAudioBuf) {
        delete m_pRemoteRecordPlayBackAudioBuf;
        m_pRemoteRecordPlayBackAudioBuf = NULL;
    }
    //}}-- add by kongyulu at 20141217
    if (m_pAudioBuf) {
        delete m_pAudioBuf;
        m_pAudioBuf = NULL;
    }
    if (m_pTalkAudioBuf) {
        delete m_pTalkAudioBuf;
        m_pTalkAudioBuf = NULL;
    }
    if (m_pAudioPlayer) {
        [m_pAudioPlayer release];
        m_pAudioPlayer = nil;
    }
    
    if (m_pRemoteRecordAudioPlayer) {
        [m_pRemoteRecordAudioPlayer release];
        m_pRemoteRecordAudioPlayer = nil;
    }
    
    if (m_pPCMRecorder) {
        delete m_pPCMRecorder;
        m_pPCMRecorder = NULL;
    }
    
    self.m_pCurrentRemoteRecordPlayInfo = nil;
    
    [self destoryTheAudioCodec];
    
    if(m_pMp4videoRecordToolHandle)
    {
        SEMP4_CloseMp4File(m_pMp4videoRecordToolHandle);
        SEMP4_Destroy(&m_pMp4videoRecordToolHandle);
        m_pMp4videoRecordToolHandle=NULL;
    }
    if (self.m_listNVRCameras) {
        [self.m_listNVRCameras removeAllObjects];
    }
    self.m_listNVRCameras = nil;
    
    self.m_nCameraResolution = 0;
    self.m_nCameraBirght = 0;
    self.m_nCameraContrast = 0;
    self.m_nCameraSaturation = 0;
    self.m_nCameraOSD = 0;
    self.m_nCameraMode = 0;
    self.m_nCameraFlip = 0;
    self.m_nCameraIRLed = 0;
    self.m_nCurrentAudioSampleRate = 0;
    self.m_nCurrentAudioChannel = 0;
    self.nVideoCodecID = 0;   // refer to SEP2P_ENUM_AV_CODECID
    self.nAudioCodecID = 0;   // refer to SEP2P_ENUM_AV_CODECID
    self.m_sNVideoParameter = nil;// Video: refer to SEP2P_ENUM_VIDEO_RESO
    self.nAudioParameter = 0;     // Audio:(samplerate << 2) | (databits << 1) | (channel)
    self.m_bIsAdmin = 0;
    self.m_iIndexForTableView = 0;//čŽ°ĺ˝ĺ¨čŽžĺ¤ĺčĄ¨ä¸­çä˝ç˝ŽďźçŹŹĺ čĄ
    self.m_iIndexForImageView = 0;//čŽ°ĺ˝ĺ¨éŁä¸Şć­ćžçŞĺŁćžç¤ş
    
    self.delegate = nil;
    self.searchDelegate = nil;
    self.m_pSetWifiDelegate = nil;
    self.m_pSetUserInfoDelegate = nil;
    self.m_pSetFtpInfoDelegate = nil;
    self.m_pSetAlarmInfoDelegate = nil;
    self.m_pSetDatetimeDelegate = nil;
    self.m_pSetEmailDelegate = nil;
    self.m_pSetCameraParamDelegate = nil;
    self.m_pEventDelegate = nil;
    self.m_pImageDelegate = nil;
    self.m_pSnapPictureDelegate = nil;
    self.m_pSetSDCardDelegate = nil;
    self.m_pRemoteRecordDelegate = nil;
    self.m_pRemoteRecordPlaybackImageDelegate = nil;
    self.m_pDeviceStatusChangedDelegate = nil;
    self.m_pCameraPushFunctionSetDelegate = nil;
    
    self.m_pCurrentRemoteRecordPlayInfo = nil;
    self.m_strCurrentLocalRecordFileDate = nil ;
    self.m_strCurrentLocalRecordFileName = nil ;
    self.m_strCurrentLocalRecordFilePath = nil ;
    self.m_imgForDeviceHead = nil;
    self.m_strAdmin = nil;
    self.m_strAdminPwd = nil;
    self.m_strVistor = nil;
    self.m_strVistorPwd = nil;
    self.m_nCurrentVideoResolution = 0;
    self.m_iUserType = 0;//ç¨ćˇçąťĺ
    
    self.m_sDID = nil;
    self.m_sUsername = nil;
    self.m_sPassword = nil;
    self.m_sDeviceName = nil;
    
    self.m_nCurrentChannel = 0;
    self.m_nDeviceType = 0; //  typedef enum{DEVICE_TYPE_IPC =0,DEVICE_TYPE_NVR =1 }E_DEVICE_TYPE;
    self.m_nNVRChannelNum = 0;
    self.m_nP2PConnectMode = 0;
    self.m_nDeviceStatus = 0;
    
    self.deviceConnectStatus = nil;
    self.m_nP2PMode = 0;
    self.m_nAuthor = 0;
    self.m_nIMNVersion = 0;
    self.m_bIsSupportPushFunction = 0;
    self.m_bAllowCameraPushMsg = 0;
    self.m_sP2papi_ver = nil;             //API version
    self.m_sFwp2p_app_ver = nil;          //P2P firmware version
    self.m_sFwp2p_app_buildtime = nil;    //P2P firmware build time
    self.m_sFwddns_app_ver = nil;         //firmware version
    self.m_sFwhard_ver = nil;             //the device hard version
    self.m_sVendor = nil;//factory name
    self.m_sProduct = nil;//product mode
    self.m_sProduct_series = nil;//product main category, L series: product_series[0]='L'; M series:product_series[0]='M',product_series[1]='1';
    self.m_sCameraToken = nil;
}

- (void) initData
{
    m_bIsSendingTalkDataToDevice = 0;
    m_nSubscribeType = 0;
    self.m_listNVRCameras = nil;
    m_pMp4videoRecordToolHandle = NULL;
    m_LockForVideoBuf = [[NSCondition alloc] init];
    m_LockForRemoteVideoBuf = [[NSCondition alloc] init];
    m_LockForAudioBuf = [[NSCondition alloc] init];
    m_LockForRemoteAudioBuf = [[NSCondition alloc] init];
    m_LockForTalkBuf = [[NSCondition alloc] init];
    m_bIsPrepareForSnapPicture = 1;
    m_bSucceedGetCameraSoftVersionInfo = NO;
    m_bCameraReconnectStarted = NO;
    m_bFindIFrame = FALSE;
    m_iLastVideoStatusBeforeInBackground = VIDEO_UNKNOWN;
    self.m_pSetWifiDelegate = nil;
    self.m_pSetUserInfoDelegate = nil;
    self.m_pSetFtpInfoDelegate = nil;
    self.m_pSetAlarmInfoDelegate = nil;
    self.m_pSetDatetimeDelegate = nil;
    self.m_pSetEmailDelegate = nil;
    self.m_pSetCameraParamDelegate = nil;
    self.m_pEventDelegate = nil;
    self.m_pImageDelegate = nil;
    self.m_pSnapPictureDelegate = nil;
    self.m_pSetSDCardDelegate = nil;
    self.m_pRemoteRecordDelegate = nil;
    self.m_pDeviceStatusChangedDelegate = nil;
    self.m_pRemoteRecordPlaybackImageDelegate = nil;
    self.searchDelegate = nil;
    self.delegate = nil;
    m_bTalkResp = KYL_Talk_REQUEST_STATUS_UNKNOWN;
    m_pAudioHandleG726 = NULL;
    m_pAudioHandleAdpcm = NULL;
    m_pAudioHandleG711 = NULL;
    m_pAudioHandleAAC = NULL;
    m_pVideoBuf = NULL;
    m_pAudioBuf = NULL;
    m_pTalkAudioBuf = NULL;
    m_pAudioPlayer = nil;
    m_pRemoteRecordAudioPlayer = NULL;
    m_pPCMRecorder = NULL;
    m_pVideoBuf = new KYLCircleBuf();
    m_pAudioBuf = new KYLCircleBuf();
    m_pTalkAudioBuf = new KYLCircleBuf();
    m_pRemoteRecordPlayBackVideoBuf = NULL;
    m_pRemoteRecordPlayBackVideoBuf = new KYLCircleBuf();
    m_pRemoteRecordPlayBackAudioBuf = NULL;
    m_pRemoteRecordPlayBackAudioBuf = new KYLCircleBuf();
    m_nCurrentPlaybackID = 0;
    m_nCurrentPlaybackAudioParam = 0;
    
    self.m_nCameraResolution = 0;
    self.m_nCameraBirght = 0;
    self.m_nCameraContrast = 0;
    self.m_nCameraSaturation = 0;
    self.m_nCameraOSD = 0;
    self.m_nCameraMode = 0;
    self.m_nCameraFlip = 0;
    self.m_nCameraIRLed = 0;
    self.m_nCurrentAudioSampleRate = 8000;
    self.m_nCurrentAudioChannel = 0;
    self.nVideoCodecID = 0;   
    self.nAudioCodecID = 0;   
    self.m_sNVideoParameter = nil;
    self.nAudioParameter = 0;     
    self.m_bIsAdmin = 0;
    self.m_iIndexForTableView = 0;
    self.m_iIndexForImageView = 0;
    
    self.delegate = nil;
    self.searchDelegate = nil;
    self.m_pSetWifiDelegate = nil;
    self.m_pSetUserInfoDelegate = nil;
    self.m_pSetFtpInfoDelegate = nil;
    self.m_pSetAlarmInfoDelegate = nil;
    self.m_pSetDatetimeDelegate = nil;
    self.m_pSetEmailDelegate = nil;
    self.m_pSetCameraParamDelegate = nil;
    self.m_pEventDelegate = nil;
    self.m_pImageDelegate = nil;
    self.m_pSnapPictureDelegate = nil;
    self.m_pSetSDCardDelegate = nil;
    self.m_pRemoteRecordDelegate = nil;
    self.m_pRemoteRecordPlaybackImageDelegate = nil;
    self.m_pDeviceStatusChangedDelegate = nil;
    self.m_pCameraPushFunctionSetDelegate = nil;
    
    self.m_pCurrentRemoteRecordPlayInfo = nil;
    self.m_strCurrentLocalRecordFileDate = nil ;
    self.m_strCurrentLocalRecordFileName = nil ;
    self.m_strCurrentLocalRecordFilePath = nil ;
    self.m_imgForDeviceHead = [UIImage imageNamed:@"back.png"];
    self.m_strAdmin = nil;
    self.m_strAdminPwd = nil;
    self.m_strVistor = nil;
    self.m_strVistorPwd = nil;
    self.m_nCurrentVideoResolution = 0;
    self.m_iUserType = 0;//ç¨ćˇçąťĺ
    
    self.m_sDID = nil;
    self.m_sUsername = nil;
    self.m_sPassword = nil;
    self.m_sDeviceName = nil;
    
    self.m_nCurrentChannel = 0;
    self.m_nDeviceType = 0; 
    self.m_nNVRChannelNum = 0;
    self.m_nP2PConnectMode = 0;
    self.m_nDeviceStatus = CONNECT_STATUS_UNKNOWN;
    self.deviceConnectStatus = nil;
    self.m_nP2PMode = 0;
    self.m_nAuthor = 0;
    self.m_nIMNVersion = 0;
    self.m_bIsSupportPushFunction = 0;
    self.m_bAllowCameraPushMsg = 0;
    self.m_sP2papi_ver = nil;
    self.m_sFwp2p_app_ver = nil;
    self.m_sFwp2p_app_buildtime = nil;
    self.m_sFwddns_app_ver = nil;
    self.m_sFwhard_ver = nil;
    self.m_sVendor = nil;
    self.m_sProduct = nil;
    self.m_sProduct_series = nil;
    self.m_sCameraToken = nil;
    
    [self createTheAudioCodec];
}

- (void) createTheAudioCodec
{
    if (NULL == m_pAudioHandleG726)
    {
        SEAudio_Create(AUDIO_CODE_TYPE_G726, &m_pAudioHandleG726);
    }
    if (NULL == m_pAudioHandleAdpcm)
    {
        SEAudio_Create(AUDIO_CODE_TYPE_ADPCM, &m_pAudioHandleAdpcm);
    }
    if (NULL == m_pAudioHandleG711) {
        SEAudio_Create(AUDIO_CODE_TYPE_G711A, &m_pAudioHandleG711);
    }
    if (NULL == m_pAudioHandleAAC) {
        SEAudio_Create(AUDIO_CODE_TYPE_AAC, &m_pAudioHandleAAC);
    }
}

- (void) destoryTheAudioCodec
{
    if(m_pAudioHandleG726) {
        SEAudio_Destroy(&m_pAudioHandleG726);
        m_pAudioHandleG726=NULL;
    }
    if (m_pAudioHandleG711) {
        SEAudio_Destroy(&m_pAudioHandleG711);
        m_pAudioHandleG711 = NULL;
    }
    if(m_pAudioHandleAdpcm){
        SEAudio_Destroy(&m_pAudioHandleAdpcm);
        m_pAudioHandleAdpcm=NULL;
    }
    if(m_pAudioHandleAAC)
    {
        SEAudio_Destroy(&m_pAudioHandleAAC);
        m_pAudioHandleAAC = NULL;
    }
}

- (void) dealloc
{
    [self clearAllResources];
    [super dealloc];
}

- (void) setTheCameraTokenInfo:(NSString *) sToken
{
    DebugLog(@"čŽžç˝Ž camera token did=%@ , m_sCameraToken=%@",self.m_sDID, sToken);
    self.m_sCameraToken = sToken;
}






+ (int) initSDK
{

    ST_InitStr init_str;
    memset(&init_str, 0, sizeof(init_str));

    strcpy(init_str.chInitStr, "EBGDEKBKKHJLGHJIEJGEFGEBHHNNHKNGHGFMBACGAAJELKLBDNAICGOKGMLJJDLPALMLLMDIODMFBPCIJLMP");
    strcpy(init_str.chPrefix, "VIEW");

    INT32 nRet = SEP2P_Initialize(&init_str, 1);    
    return m_gnSDKVersion;
}

+ (void) deInitializeSDK
{
    SEP2P_DeInitialize();
}

+ (NSString *) getSDKVersion
{
    char chDesc[256]={0};
    UINT32 nAPIVer=SEP2P_GetSDKVersion(chDesc, sizeof(chDesc));
    char *pVer=(char *)&nAPIVer;
    m_gnSDKVersion = nAPIVer;
    NSLog(@"SEP2P_API ver=%d.%d.%d.%d, %s\n", *(pVer+3), *(pVer+2), *(pVer+1), *(pVer+0), chDesc);
    m_gStrSDKVersion = [NSString stringWithFormat:@"%d.%d.%d.%d", *(pVer+3), *(pVer+2), *(pVer+1), *(pVer+0)];
    return m_gStrSDKVersion;
}

- (void) registerTheSDKCallbackFun:(NSString *) sDID
{
    if (nil == sDID || [sDID length] == 0) {
        return;
    }
    [sDID retain];
    const char *m_sDid =  [sDID UTF8String];
    int m_iRegistOK = 0;
    // register the stream callback
    m_iRegistOK = SEP2P_SetStreamCallback(m_sDid, OnStreamCallback, self);
    if (m_iRegistOK == ERR_SEP2P_SUCCESSFUL)
    {
        NSLog(@"register stream call back ok!");
    }
    else if (m_iRegistOK == ERR_SEP2P_NOT_INITIALIZED)
    {
        NSLog(@"register stream call back error:ERR_SEP2P_NOT_INITIALIZED!");
    }
    else
    {
        NSLog(@"register stream call back failed: ERR_SEP2P_NO_CONNECT_THIS_DID!");
    }
    // register the message callback
    m_iRegistOK = SEP2P_SetRecvMsgCallback(m_sDid, OnRecvMsgCallback, self);
    if (m_iRegistOK == ERR_SEP2P_SUCCESSFUL)
    {
        NSLog(@"register receive message call back ok!");
    }
    else if (m_iRegistOK == ERR_SEP2P_NOT_INITIALIZED)
    {
        NSLog(@"register receive message call back error:ERR_SEP2P_NOT_INITIALIZED!");
    }
    else
    {
        NSLog(@"register receive message call back failed: ERR_SEP2P_NO_CONNECT_THIS_DID!");
    }
    
    m_iRegistOK = SEP2P_SetEventCallback(m_sDid, OnEventCallback, self);
    
    if (m_iRegistOK == ERR_SEP2P_SUCCESSFUL)
    {
        NSLog(@"register event call back ok!");
    }
    else if (m_iRegistOK == ERR_SEP2P_NOT_INITIALIZED)
    {
        NSLog(@"register event call back error:ERR_SEP2P_NOT_INITIALIZED!");
    }
    else
    {
        NSLog(@"register event call back failed: ERR_SEP2P_NO_CONNECT_THIS_DID!");
    }
    // register the event callback
    NSLog(@"%s %s", KYL_THE_FILE_NAME, __FUNCTION__);
    [sDID release];
}


- (int ) connect
{
    //@synchronized(self)
    {
        int m_iRet = - 1;
        if ( nil == self.m_sDID || nil == self.m_sUsername || nil == self.m_sPassword) {
            return m_iRet;
        }
        m_iRet = SEP2P_Connect([self.m_sDID UTF8String], [self.m_sUsername UTF8String], [self.m_sPassword UTF8String]);
        
        NSLog(@"the connect end result = %d, DID = %@, username=%@, password=%@", m_iRet, self.m_sDID, self.m_sUsername, self.m_sPassword);
        
        if (m_iRet == ERR_SEP2P_SUCCESSFUL)
        {
                NSLog(@"registerTheSDKCallbackFun");
            [self registerTheSDKCallbackFun:self.m_sDID];
        }
        else if (m_iRet == ERR_SEP2P_ALREADY_CONNECTED)
        {
        }
        else if (m_iRet == ERR_SEP2P_EXCEED_MAX_CONNECT_NUM)
        {
        }
        else if (m_iRet == ERR_SEP2P_NOT_INITIALIZED)
        {
        }
        else if (m_iRet == ERR_SEP2P_INVALID_PARAMETER)
        {
        }
        else
        {
        }
        return m_iRet;
    }
}


- (int ) disconnect
{
    //@synchronized(self)
    {
        int m_iRet=0;
        m_iRet = SEP2P_Disconnect([self.m_sDID UTF8String]);
        return m_iRet;
    }
}

- (int) getCameraStatus
{
    return _m_nDeviceStatus;
}

- (int) disconnectAndStop
{
    [self stopVideo];
    [self stopAudio];
    [self stopTalk];
    int nRet = [self disconnect];
    return nRet;
}

- (int) disconnectAndStopWhenInBackground
{
    if (1 == [self getVideoStatus]) m_iLastVideoStatusBeforeInBackground = VIDEO_PLAYING;
    else m_iLastVideoStatusBeforeInBackground = VIDEO_STOPED;
    
    [self stopVideo];
    [self stopAudio];
    [self stopTalk];
    int nRet = [self disconnect];
    
    return nRet;
}

- (int) clearAllDelegate
{
    int nRet = 0;
    self.delegate = nil;
    self.m_pEventDelegate = nil;
    self.m_pImageDelegate = nil;
    self.searchDelegate = nil;
    self.m_pSetWifiDelegate = nil;
    self.m_pSetUserInfoDelegate = nil;
    self.m_pSetFtpInfoDelegate = nil;
    self.m_pSetAlarmInfoDelegate = nil;
    self.m_pSetDatetimeDelegate = nil;
    self.m_pSetEmailDelegate = nil;
    self.m_pSetCameraParamDelegate = nil;
    self.m_pEventDelegate = nil;
    self.m_pImageDelegate = nil;
    self.m_pSnapPictureDelegate = nil;
    self.m_pSetSDCardDelegate = nil;
    self.m_pRemoteRecordPlaybackImageDelegate = nil;
    self.m_pRemoteRecordDelegate = nil;
    self.m_pDeviceStatusChangedDelegate = nil;
    
    nRet = 1;
    return nRet;
}

- (int) getTheLastVideoStatus
{
    return m_iLastVideoStatusBeforeInBackground;
}

- (void) setTheLastVideoStatus:(int) _iLastStatus
{
    m_iLastVideoStatusBeforeInBackground = _iLastStatus;
}

- (char *)getTheAVVideoParams
{
    char *pVideoParam = m_avParameter.nVideoParameter;
    return pVideoParam;
}

- (NSMutableArray *)getCameraSupportResolutionList
{
    char *pVideoParam = m_avParameter.nVideoParameter;
    if (pVideoParam == NULL) {
        return nil;
    }
    NSMutableArray *arrList = [[[NSMutableArray alloc] initWithCapacity:7] autorelease];
    for(int i = 0; i<7; i++)
    {
        int nTempValue = (int)pVideoParam[i];
        //DebugLog(@"%@ éĺĺčž¨ç  p[%d]=%d" ,_m_sDID,i,(int)nTempValue);
        if (nTempValue == -1)
        {
            //DebugLog(@"ä¸ćŻćčŻĽĺčž¨çďźpVideoParams[%d]=%d",i,0xFF);
            continue;
        }
        //DebugLog(@" éĺćććŻćçĺčž¨ç  p[%d]=%d",i,(int)nTempValue);
        NSNumber *num = [NSNumber numberWithInt:nTempValue];
        [arrList addObject:num];
    }
    return arrList;
}

- (int) getTheAVCodeParameter
{
    AV_PARAMETER avParameter;
    memset(&avParameter, 0, sizeof(AV_PARAMETER));
    int ret = SEP2P_GetAVParameterSupported([self.m_sDID UTF8String], &avParameter);
    if (ret == ERR_SEP2P_SUCCESSFUL)
    {
        memset(&m_avParameter, 0, sizeof(AV_PARAMETER));
        _nVideoCodecID = avParameter.nVideoCodecID;
        _nAudioCodecID = avParameter.nAudioCodecID;
        if (avParameter.nVideoParameter) {
            self.m_sNVideoParameter = [[[NSString alloc] initWithCString:avParameter.nVideoParameter encoding:NSUTF8StringEncoding] autorelease];
        }
        _nAudioParameter = avParameter.nAudioParameter;
        _m_nDeviceType = avParameter.nDeviceType;
        _m_nNVRChannelNum = avParameter.nMaxChannel;
        memcpy(&m_avParameter,&avParameter,sizeof(AV_PARAMETER));
        self.m_pavParameter = &m_avParameter;
    }
    DebugLog(@"\nčżçşżćĺĺďźčˇĺč§é˘äżĄćŻ, did=%@ nVideoCodecID=%d, nAudioCodecID=%d, m_sNVideoParameter=%@, nAudioParameter=%d, deviceType=%d, nvrChannelNum=%d \n", _m_sDID,_nVideoCodecID,_nAudioCodecID,_m_sNVideoParameter,_nAudioParameter,_m_nDeviceType,_m_nNVRChannelNum);
    if (_m_nDeviceType == DEVICE_TYPE_NVR) {
        self.m_imgForDeviceHead = [UIImage imageNamed:@"nvr_icon.png"];
    }
    
    return ret;
}

- (int) getTheAVCodeParameterAndInitNVRForOnce
{
    int nRet = 0;
    if (nil == self.m_listNVRCameras && DEVICE_TYPE_NVR == _m_nDeviceType) {//ĺŚććŻNVR,ĺĺĺťşĺŻšĺşééć°éçKYLCamera ĺŻščąĄ
        [self CreateTheNVRCameraObjList];
    }
    return nRet;
}

- (int) getVideoStreamType
{
    return _nVideoCodecID;
}

- (int) getAudioStreamType
{
    return _nAudioCodecID;
}

- (int) getAudioStatus
{
    int status = 0;
    status = m_bAudioPlayThreadRuning;
    return status;
}

- (int) getVideoStatus
{
    return m_bVideoPlayThreadRuning;
}

- (int) getRemoteSDCardAudioStatus
{
    return m_bRemoteRecordAudioPlayThreadRuning;
}

- (int) getRemoteSDCardVideoStatus
{
    return m_bRemoteRecordVideoPlayThreadRuning;
}

- (int) getTalkStatus
{
    return m_bTalkThreadRuning;
}

- (int) getVideoStreamResolution
{
    int nVideoStreamResolution = 0;
    if (_m_sNVideoParameter) {
        nVideoStreamResolution = [_m_sNVideoParameter intValue];
    }
    return nVideoStreamResolution;
}

- (int) getSupportResultionTypeNum
{
    int nAllResultionTypeTotalNum = 0;
    for(int i = 0; i < 7; i++)
    {
        int nResultion = m_avParameter.nVideoParameter[i] ;
        if(nResultion == VIDEO_RESO_UNKNOWN)
        {
            break;
        }
        nAllResultionTypeTotalNum++;
    }
    return nAllResultionTypeTotalNum;
}

- (int) cameraType
{
    int ncameraType = KYL_CAMERA_TYPE_UNKNOWN;
    NSString *strProductSeriers = self.m_sProduct_series;
    if (strProductSeriers && [strProductSeriers length] > 0)
    {
        char type = [strProductSeriers characterAtIndex:0];
        if ('L' == type)
        {
            ncameraType = KYL_CAMERA_TYPE_L;
            NSLog(@"camera type = L");
            
        }else if ('M' == type){
            ncameraType = KYL_CAMERA_TYPE_M;
            NSLog(@"camera type = M");
            
        }else if ('X' == type)
        {
            ncameraType = KYL_CAMERA_TYPE_X;
            NSLog(@"camera type = X");
        }
        else
        {
            NSLog(@"camera type = unknown, get failed");
        }
    }
    return ncameraType;
}

- (BOOL) IsAdmin
{
    return _m_bIsAdmin;
}

- (BOOL) IsConnectedOK
{
    if(_m_nDeviceStatus == CONNECT_STATUS_CONNECTED)
    {
        return YES;
    }
    return NO;
}

- (int) getTheUserType
{
    if (_m_strAdmin == nil || [_m_strAdmin length] < 1)
    {
        [self getCameraUserInfo];
    }
    if ([_m_sUsername isEqualToString:_m_strAdmin])
    {
        _m_iUserType = 1;
        _m_bIsAdmin = YES;
    }
    else if ([_m_sUsername isEqualToString:_m_strVistor])
    {
        _m_iUserType = 0;
        _m_bIsAdmin = NO;
    }
    else
    {
        _m_iUserType = -1;
        _m_bIsAdmin = NO;
    }
    
    return _m_iUserType;
}




//čŻˇćąĺłé­č§é˘ćľ
- (int) requestToCloseTheVideoStream
{
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_STOP_VIDEO, NULL, 0);
    return nRet;
}

//čŻˇćąĺłé­éłé˘ćľ
- (int) requestToCloseTheAudioStream
{
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_STOP_AUDIO, NULL, 0);
    return nRet;
}

//čŻˇćąĺłé­ĺŻščŽ˛é˘ćľ
- (int) requestToCloseTheTalkStream
{
    
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_STOP_TALK, NULL, 0);
    
    return nRet;
}



- (int) reGetTheVideoStream
{
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_START_VIDEO, NULL, 0);
    NSLog(@"reGetTheVideoStream : %d", nRet);
    return nRet;
}
- (int) reGetTheAudioStream
{
    
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_START_AUDIO, NULL, 0);
    
    return nRet;
}
- (int) reGetTheTalkStream
{
    
    
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_START_TALK, NULL, 0);
    
    return nRet;
}



- (int ) startVideo
{
    if (m_bVideoPlayThreadRuning) {
        NSLog(@" m_bVideoPlayThreadRuning");
        return 1;
    }
    
    INT32 nRet = [self reGetTheVideoStream];
    NSLog(@" camera start video: %d", nRet);
    if (nRet == ERR_SEP2P_SUCCESSFUL)
    {
        int nTempCameraType = [self cameraType];
        int nTempBufSize = KYL_VBUF_SIZE;
        if (KYL_CAMERA_TYPE_L == nTempCameraType)
        {
            nTempBufSize = KYL_VBUF_SIZE_L;
        }
        else if (KYL_CAMERA_TYPE_M == nTempCameraType)
        {
            nTempBufSize = KYL_VBUF_SIZE_M;
        }
        else if (KYL_CAMERA_TYPE_X == nTempCameraType)
        {
            nTempBufSize = KYL_VBUF_SIZE_X;
        }
        if(0 == m_pVideoBuf->Create(nTempBufSize))
        {
            m_bVideoPlayThreadRuning = 0;
            return -2;
        }
        [self startPlayVideo];
    }
    else
    {
    }
    return nRet;
}


- (int) stopVideo
{
    MSG_STOP_VIDEO stReq;
    memset(&stReq, 0, sizeof(stReq));
    stReq.nChannel = _m_nCurrentChannel;
    // send stop video stream command to device
    INT32 nRet = [self requestToCloseTheVideoStream];
    [self requestToCloseTheAudioStream];
    
    m_bVideoPlayThreadRuning = 0;
    [self stopPlayVideo];
    if (m_pVideoBuf) {
        m_pVideoBuf->Release();
    }
    return nRet;
}

//start local record,save the local file is mp4
- (int) startLocalRecord
{
    int nRet = 0;
    if (!m_bVideoPlayThreadRuning) {
        return K_Error_Video_Stoped;
    }
    if(m_bLocalRecording == 1) return 1;
    
    if(NULL == m_pMp4videoRecordToolHandle)
    {
        nRet = SEMP4_Create(&m_pMp4videoRecordToolHandle);
        if(nRet < 0)
        {
            SEMP4_Destroy(&m_pMp4videoRecordToolHandle);
            m_pMp4videoRecordToolHandle = NULL;
            m_bLocalRecording = 0;
            return -2;
        }else{
            //open the record file
            self.m_strCurrentLocalRecordFileName = [self GetRecordFileName];
            self.m_strCurrentLocalRecordFilePath = [self GetRecordPath: _m_strCurrentLocalRecordFileName];
            NSLog(@"m_strCurrentLocalRecordFilePath=%@",_m_strCurrentLocalRecordFilePath);
            //čˇĺéłé˘ĺć°
            
            //čˇĺĺ˝ĺĺčž¨çďźć šćŽĺčž¨çčŽžç˝Žĺ˝ĺćäťśçĺčž¨ç
            int nTempWidth = 640;
            int nTempHeight = 320;
            int nTempImageType = 0;
            int nTempResolution = self.m_nCameraResolution;
            //ĺŽäšéłé˘äżĄćŻ
            INT32 nTempAudioSampleRate = 8000;
            INT32 nTempAudioChannel = 1;
            INT32 nTempAudioType = AV_CODECID_AUDIO_ADPCM;
            
            int nTempAudioStreamType = _nAudioCodecID;
            if(nTempAudioStreamType == AV_CODECID_AUDIO_ADPCM)
            {
                //nTempAudioType = RTSP_AV_CODECID_AUDIO_ADPCM;
                //nTempAudioSampleRate = 8000;
                
                //for test ,adpcm format audio no support for local record
                nTempAudioType = 0;
                nTempAudioSampleRate = 0;
            }
            else if(nTempAudioStreamType == AV_CODECID_AUDIO_G726)
            {
                nTempAudioType = RTSP_AV_CODECID_AUDIO_G726;
                nTempAudioSampleRate = 8000;
            }
            else if(nTempAudioStreamType == AV_CODECID_AUDIO_G711A)
            {
                nTempAudioType = RTSP_AV_CODECID_AUDIO_G711A;
                nTempAudioSampleRate = 8000;
            }
            else if(nTempAudioStreamType == AV_CODECID_AUDIO_AAC)
            {
                nTempAudioType = RTSP_AV_CODECID_AUDIO_AAC;
                nTempAudioSampleRate = 16000;
            }
            
            switch(nTempResolution)
            {
                case VIDEO_RESO_QQVGA://160*120
                {
                    nTempWidth = 160;
                    nTempHeight = 120;
                }
                    break;
                case VIDEO_RESO_QVGA://320*240
                {
                    nTempWidth = 320;
                    nTempHeight = 240;
                }
                    break;
                case VIDEO_RESO_VGA1://640*480
                {
                    nTempWidth = 640;
                    nTempHeight = 480;
                }
                    break;
                case VIDEO_RESO_VGA2://640*360
                {
                    nTempWidth = 640;
                    nTempHeight = 360;
                }
                    break;
                case VIDEO_RESO_720P://1280*720
                {
                    nTempWidth = 1280;
                    nTempHeight = 720;
                }
                    break;
                case VIDEO_RESO_960P://1280*960
                {
                    nTempWidth = 1280;
                    nTempHeight = 960;
                }
                    break;
                case VIDEO_RESO_1080P://1280*1080
                {
                    nTempWidth = 1280;
                    nTempHeight = 1080;
                }
                    break;
                default:
                {
                    nTempWidth = 640;
                    nTempHeight = 480;
                }
                    
            }
            
            //čˇĺĺ˝ĺč§é˘çč§é˘ćľçąťĺ
            int nTempVideoStreamType = _nVideoCodecID;
            if(nTempVideoStreamType == AV_CODECID_VIDEO_H264)
            {
                nTempImageType = RTSP_AV_CODECID_VIDEO_H264;
            }
            else if(nTempVideoStreamType == AV_CODECID_VIDEO_MJPEG)
            {
                nTempImageType = RTSP_AV_CODECID_VIDEO_MJPEG;
            }
            
            char *pchRecordPath = (char *)[_m_strCurrentLocalRecordFilePath UTF8String];
            
            
            //ćĺźĺ˝ĺćäťśďźćĺźĺĺ¨ć­ćžč§é˘ćśďźĺŚćĺźĺŻĺ˝ĺćŻćŹĄĺĺĽä¸ĺ¸§ć°ćŽ
            nRet = SEMP4_OpenMp4File(m_pMp4videoRecordToolHandle, pchRecordPath,
                                     nTempWidth, nTempHeight, nTempImageType,
                                     nTempAudioSampleRate, nTempAudioChannel, nTempAudioType); //h264 or mjpeg video
            NSLog(@"---ăč°ç¨ćĺźĺ˝ĺćäťśĺ˝ć°SEMP4_OpenMp4File() nRet=%d",nRet);
            if(nRet>= 0)
            {
                NSLog(@"succeed beign local record path=%@",_m_strCurrentLocalRecordFilePath);
                m_bLocalRecording = 1;
                //insert the record info into db
                NSDate* date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *recordFileDate = [formatter stringFromDate:date];
                self.m_strCurrentLocalRecordFileDate = recordFileDate;
                
                [formatter release];
                //                IpCameraClientAppDelegate *IPCamDelegate = (IpCameraClientAppDelegate*)[[UIApplication sharedApplication] delegate];
                //                RecPathManagement *m_pRecPathMgt = (RecPathManagement *)IPCamDelegate.m_pRecPathMgt ;
                //                BOOL bResult = [m_pRecPathMgt InsertPath:_m_sDID Date:recordFileDate Path:_m_strCurrentLocalRecordFileName channel:_m_nCurrentChannel reserve1:@"" reserve2:@""];
                
            }
            else
            {
                m_bLocalRecording = 0;
                NSLog(@"failed beign local record path=%@",_m_strCurrentLocalRecordFilePath);
                SEMP4_CloseMp4File(m_pMp4videoRecordToolHandle);
                SEMP4_Destroy(&m_pMp4videoRecordToolHandle);
                m_pMp4videoRecordToolHandle = NULL;
            }
        }
    }
    
    return nRet;
}

- (int) stopLocalRecord
{
    int nRet = 0;
    m_bLocalRecording = 0;
    if(m_pMp4videoRecordToolHandle)
    {
        SEMP4_CloseMp4File(m_pMp4videoRecordToolHandle);
        SEMP4_Destroy(&m_pMp4videoRecordToolHandle);
        m_pMp4videoRecordToolHandle = NULL;
    }
    return nRet;
}

//local record add one video frame
- (int) addOneVideoFrameIntoLocalRecordFile:(char *) pData dataSize:(NSInteger) nDataSize deviceTimeTamp:(NSInteger) nDeviceTimeStamp localTimeTamp:(NSInteger) nLocalTimeTamp isIFrame:(int) bIsIFrame
{
    int nRet = 0;
    //if the record time is over the max time length ,then restart record in a new file.
    if(m_nFirstLocalRecordFrameTimeStamp == 0)
    {
        m_nFirstLocalRecordFrameTimeStamp = nDeviceTimeStamp;
    }
    BOOL bIsOverMaxTimeLength = false;
    NSInteger nTempDiffTime = nDeviceTimeStamp - m_nFirstLocalRecordFrameTimeStamp;
    if(nTempDiffTime > KYL_LOCAL_RECORD_MAX_TIME_LENGTH)
    {
        bIsOverMaxTimeLength = true;
    }
    if (bIsOverMaxTimeLength)
    {
        [self performSelectorOnMainThread:@selector(reStartLocalRecordWhenTimeOut) withObject:nil waitUntilDone:YES];
        return 0;
    }
    if(m_bLocalRecording && m_pMp4videoRecordToolHandle)
    {
        nRet = SEMP4_AddVideoFrame(m_pMp4videoRecordToolHandle, (UCHAR *)pData, (INT32)nDataSize, (INT32)nDeviceTimeStamp, bIsIFrame);//juju2
        //NSLog(@"ćŹĺ°ĺ˝ĺďźĺĺĽä¸ĺ¸§č§é˘ć°ćŽ*** nRet =%d",nRet);
    }
    return nRet;
}

//local record add one audio frame
- (int) addOneAudioFrameIntoLocalRecordFile:(char *) pData dataSize:(NSInteger) nDataSize deviceTimeTamp:(NSInteger) nDeviceTimeStamp
{
    int nRet = 0;
    
    if(m_bLocalRecording && m_pMp4videoRecordToolHandle)
    {
        //NSInteger nTempCurtime = (NSInteger)[self getCurrentTime];
        nRet = SEMP4_AddAudioFrame(m_pMp4videoRecordToolHandle, (UCHAR *)pData, (INT32)nDataSize, (INT32)nDeviceTimeStamp); //juju2
        NSLog(@"ćŹĺ°ĺ˝ĺďźĺĺĽä¸ĺ¸§éłé˘ nRet =%d",nRet);
    }
    return nRet;
}

- (int) reStartLocalRecordWhenTimeOut
{
    int nRet = 0;
    [self stopLocalRecord];
    nRet = [self startLocalRecord];
    return nRet;
}

- (NSString*) GetRecordFileName
{
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    NSString* strDateTime = [formatter stringFromDate:date];
    NSString *strFileName = [NSString stringWithFormat:@"%@_%@.mp4", _m_sDID, strDateTime];
    [formatter release];
    return strFileName;
}

- (NSString*) GetRecordFileNameForMOV
{
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    NSString* strDateTime = [formatter stringFromDate:date];
    NSString *strFileName = [NSString stringWithFormat:@"%@_%@.mov", _m_sDID, strDateTime];
    [formatter release];
    return strFileName;
}

- (NSString*) GetRecordPath: (NSString*)strFileName
{
    //čŽžç˝Žä¸ĺ¤äť˝ĺ°iCloudçć čŻă
    NSString *strPath = [KYLComFunUtil getDefaultFolderInDocumentForDid:_m_sDID];
    strPath = [strPath stringByAppendingPathComponent:strFileName];
    return strPath;
}

- (int) startTalk
{
    INT32 nRet= [self reGetTheTalkStream];
    
    return nRet;
}

- (int) startSendTalkData
{
    DebugLog(@"");
    m_bIsSendingTalkDataToDevice = 1;
    int nRet = [self startGatherTheTalkAudioThread];
    return nRet;
}

- (int) stopSendTalkData
{
    DebugLog(@"");
    m_bIsSendingTalkDataToDevice = 0;
    int nRet = [self stopGatherTheTalkAudioThread];;
    return nRet;
}

- (int) startGatherTheTalkAudioThread
{
    int nRet = 0;
    if (m_bTalkThreadRuning)
    {
        DebugLog(@"ĺŻĺ¨ĺŻščŽ˛éłé˘ééçşżç¨ĺ¤ąč´ĽďźĺŻščŽ˛çşżç¨ć­Łĺ¨čżčĄ");
        return 1;
    }
    
    if(0 == m_pTalkAudioBuf->Create(KYL_ABUF_SIZE))
    {
        m_bTalkThreadRuning = 0;
        DebugLog(@"ĺŻĺ¨ĺŻščŽ˛éłé˘ééçşżç¨ĺ¤ąč´ĽďźĺĺťşĺŻščŽ˛ĺžŞçŻçźĺ˛ĺşĺ¤ąč´Ľ");
        return -1;
    }
    if (m_pPCMRecorder == NULL)
    {
        int nSamplingRate = KYL_AUDIO_SAMPLE_RATE_L;
        if ([self cameraType] ==  KYL_CAMERA_TYPE_M)
        {
            nSamplingRate = KYL_AUDIO_SAMPLE_RATE_M;
        }
        else  if ([self cameraType] ==  KYL_CAMERA_TYPE_X)
        {
            nSamplingRate = KYL_AUDIO_SAMPLE_RATE_X;
        }
        _m_nCurrentAudioSampleRate = nSamplingRate;
        DebugLog(@"ĺŻĺ¨ĺéĺŻščŽ˛ć°ćŽçşżç¨");
        m_pPCMRecorder = new CPCMRecorder(RecordAudioBuffer_Callback, self,nSamplingRate);
        m_pPCMRecorder->StartRecord();
        
        [self startSendingAudio];
    }
    if (NULL == m_pPCMRecorder) {
        m_bTalkThreadRuning = 0;
        DebugLog(@"ĺŻĺ¨ĺŻščŽ˛éłé˘ééçşżç¨ĺ¤ąč´Ľďźĺĺťşĺ˝éłĺŽäžĺ¤ąč´Ľ");
        return -2;
    }
    
    nRet = 1;
    return  nRet;
}

- (int) stopGatherTheTalkAudioThread
{
    DebugLog(@"ĺłé­ĺéĺŻščŽ˛ć°ćŽçşżç¨");
    int nRet = 0;
    m_bTalkThreadRuning = 0;
    [self stopSendingAudio];
    if (m_pPCMRecorder)
    {
        delete m_pPCMRecorder;
        m_pPCMRecorder = NULL;
    }
    if (m_pTalkAudioBuf) {
        m_pTalkAudioBuf->Release();
    }
    nRet = 1;
    return  nRet;
}


- (int) stopTalk
{
    int nRet = [self requestToCloseTheTalkStream];
    [self stopGatherTheTalkAudioThread];
    return nRet;
}


- (int) startAudio
{
    if (m_bAudioPlayThreadRuning) {
        return 1;
    }
    INT32 nRet = [self reGetTheAudioStream];
    if (nRet == ERR_SEP2P_SUCCESSFUL)
    {
        int nAudioFormat = AL_FORMAT_MONO16;
        if (nil == m_pAudioPlayer)
        {
            m_pAudioPlayer = [[KYLOpenALPlayer alloc] init];
            int nSamplingRate = KYL_AUDIO_SAMPLE_RATE_L;
            if ([self cameraType] ==  KYL_CAMERA_TYPE_M)
            {
                nSamplingRate = KYL_AUDIO_SAMPLE_RATE_M;
                nAudioFormat = AL_FORMAT_MONO16;
            }
            else  if ([self cameraType] ==  KYL_CAMERA_TYPE_X)
            {
                nSamplingRate = KYL_AUDIO_SAMPLE_RATE_X;
                nAudioFormat = AL_FORMAT_MONO16;
            }
            [m_pAudioPlayer initOpenAL:nAudioFormat :nSamplingRate];
        }
        if (nil == m_pAudioPlayer)
        {
            m_bAudioPlayThreadRuning = 0;
            return -3;
        }
        if(0 == m_pAudioBuf->Create(KYL_ABUF_SIZE))
        {
            m_bAudioPlayThreadRuning = 0;
            return -4;
        }
        [self startPlayAudio];
    }
    return nRet;
}

- (int) stopAudio
{
    [self requestToCloseTheAudioStream];
    m_bAudioPlayThreadRuning = 0;
    [self stopPlayAudio];
    if (m_pAudioPlayer != nil)
    {
        [m_pAudioPlayer stopSound];
        [m_pAudioPlayer cleanUpOpenAL];
        [m_pAudioPlayer release];
        m_pAudioPlayer = nil;
    }
    if (m_pAudioBuf) {
        m_pAudioBuf->Release();
    }
    return 1;
}

- (int) left
{
    MSG_PTZ_CONTROL_REQ ptzMsg;
    ptzMsg.nCtrlCmd = PTZ_CTRL_LEFT;
    ptzMsg.nCtrlParam = 0;
    ptzMsg.nChannel = _m_nCurrentChannel;
    const CHAR* pMsgData = (CHAR*)&ptzMsg;
    INT32 nMsgDataSize = (INT32)sizeof(MSG_PTZ_CONTROL_REQ);
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_PTZ_CONTROL_REQ, pMsgData, nMsgDataSize);
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        //ćĺäšĺďźĺŚććŻXçłťĺďźčż500ćŻŤç§ĺéĺć­˘ĺ˝äť¤
        // if([self cameraType] == KYL_CAMERA_TYPE_X)
        // {
        //     [self performSelector:@selector(stopPTZGo) withObject:nil afterDelay:0.5];
        // }
    }
    return nRet;
}

- (int) right
{
    MSG_PTZ_CONTROL_REQ ptzMsg;
    ptzMsg.nCtrlCmd = PTZ_CTRL_RIGHT;
    ptzMsg.nCtrlParam = 0;
    ptzMsg.nChannel = _m_nCurrentChannel;
    const CHAR* pMsgData = (CHAR*)&ptzMsg;
    INT32 nMsgDataSize = (INT32)sizeof(MSG_PTZ_CONTROL_REQ);
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_PTZ_CONTROL_REQ, pMsgData, nMsgDataSize);
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        //ćĺäšĺďźĺŚććŻXçłťĺďźčż500ćŻŤç§ĺéĺć­˘ĺ˝äť¤
        // if([self cameraType] == KYL_CAMERA_TYPE_X)
        // {
        //     [self performSelector:@selector(stopPTZGo) withObject:nil afterDelay:0.5];
        // }
    }
    return nRet;
}

- (int) up
{
    MSG_PTZ_CONTROL_REQ ptzMsg;
    ptzMsg.nCtrlCmd = PTZ_CTRL_UP;
    ptzMsg.nCtrlParam = 0;
    ptzMsg.nChannel = _m_nCurrentChannel;
    const CHAR* pMsgData = (CHAR*)&ptzMsg;
    INT32 nMsgDataSize = (INT32)sizeof(MSG_PTZ_CONTROL_REQ);
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_PTZ_CONTROL_REQ, pMsgData, nMsgDataSize);
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        //ćĺäšĺďźĺŚććŻXçłťĺďźčż500ćŻŤç§ĺéĺć­˘ĺ˝äť¤
        // if([self cameraType] == KYL_CAMERA_TYPE_X)
        // {
        //     [self performSelector:@selector(stopPTZGo) withObject:nil afterDelay:0.5];
        // }
    }
    return nRet;
}

- (int) down
{
    MSG_PTZ_CONTROL_REQ ptzMsg;
    ptzMsg.nCtrlCmd = PTZ_CTRL_DOWN;
    ptzMsg.nCtrlParam = 0;
    ptzMsg.nChannel = _m_nCurrentChannel;
    const CHAR* pMsgData = (CHAR*)&ptzMsg;
    INT32 nMsgDataSize = (INT32)sizeof(MSG_PTZ_CONTROL_REQ);
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_PTZ_CONTROL_REQ, pMsgData, nMsgDataSize);
    if (nRet == ERR_SEP2P_SUCCESSFUL)
    {
        //ćĺäšĺďźĺŚććŻXçłťĺďźčż500ćŻŤç§ĺéĺć­˘ĺ˝äť¤
        // if([self cameraType] == KYL_CAMERA_TYPE_X)
        // {
        //     [self performSelector:@selector(stopPTZGo) withObject:nil afterDelay:0.5];
        // }
    }
    return nRet;
}

- (int) stopPTZGo
{
    MSG_PTZ_CONTROL_REQ ptzMsg;
    ptzMsg.nCtrlCmd = PTZ_CTRL_STOP;
    ptzMsg.nCtrlParam = 0;
    ptzMsg.nChannel = _m_nCurrentChannel;
    const CHAR* pMsgData = (CHAR*)&ptzMsg;
    INT32 nMsgDataSize = (INT32)sizeof(MSG_PTZ_CONTROL_REQ);
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_PTZ_CONTROL_REQ, pMsgData, nMsgDataSize);
    return nRet;
}

- (int) startGoLeftRight
{
    MSG_PTZ_CONTROL_REQ ptzMsg;
    ptzMsg.nCtrlCmd = PTZ_CTRL_CRUISE_H;
    ptzMsg.nCtrlParam = 0;
    ptzMsg.nChannel = _m_nCurrentChannel;
    const CHAR* pMsgData = (CHAR*)&ptzMsg;
    INT32 nMsgDataSize = (INT32)sizeof(MSG_PTZ_CONTROL_REQ);
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_PTZ_CONTROL_REQ, pMsgData, nMsgDataSize);
    return nRet;
}

- (int) stopGoLeftRight
{
    return [self stopPTZGo];
}

- (int) startGoUpDown
{
    MSG_PTZ_CONTROL_REQ ptzMsg;
    ptzMsg.nCtrlCmd = PTZ_CTRL_CRUISE_V;
    ptzMsg.nCtrlParam = 0;
    ptzMsg.nChannel = _m_nCurrentChannel;
    const CHAR* pMsgData = (CHAR*)&ptzMsg;
    INT32 nMsgDataSize = (INT32)sizeof(MSG_PTZ_CONTROL_REQ);
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_PTZ_CONTROL_REQ, pMsgData, nMsgDataSize);
    return nRet;
}

- (int) stopGoUpDown
{
    return [self stopPTZGo];
}

- (int) setThePresetBit:(int) nBit
{
    MSG_PTZ_CONTROL_REQ ptzMsg;
    ptzMsg.nCtrlCmd = PTZ_CTRL_PRESET_BIT_SET;
    ptzMsg.nCtrlParam = nBit;
    ptzMsg.nChannel = _m_nCurrentChannel;
    const CHAR* pMsgData = (CHAR*)&ptzMsg;
    INT32 nMsgDataSize = (INT32)sizeof(MSG_PTZ_CONTROL_REQ);
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_PTZ_CONTROL_REQ, pMsgData, nMsgDataSize);
    return nRet;
}

- (int) runThePresetBit:(int) nBit
{
    MSG_PTZ_CONTROL_REQ ptzMsg;
    ptzMsg.nCtrlCmd = PTZ_CTRL_PRESET_BIT_GOTO;
    ptzMsg.nCtrlParam = nBit;
    ptzMsg.nChannel = _m_nCurrentChannel;
    const CHAR* pMsgData = (CHAR*)&ptzMsg;
    INT32 nMsgDataSize = (INT32)sizeof(MSG_PTZ_CONTROL_REQ);
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_PTZ_CONTROL_REQ, pMsgData, nMsgDataSize);
    return nRet;
}

- (int) rebootTheCamera
{
    // send the get camera's params command to device
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_REBOOT_DEVICE, NULL, 0);
    return nRet;
}

- (int) snapPicture
{
    // send the get camera's params command to device
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_SNAP_PICTURE_REQ, NULL, 0);
    return nRet;
}

- (int) startSnapPicture
{
    m_bIsPrepareForSnapPicture = 1;
    return 1;
}

- (int) stopSnapPicture
{
    m_bIsPrepareForSnapPicture = 0;
    return 1;
}

- (int) getAllTheSDCardRecordParam
{
    int nRet = 0;
    // send the get camera's params command to device
    nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_SDCARD_REC_PARAM_REQ, NULL, 0);
    return nRet;
}

- (int) getAllRemoteRecordDays:(int) nYearMonth
{
    int nRet = 0;
    int nRecType = 1;
    MSG_GET_REMOTE_REC_DAY_BY_MONTH_REQ stReq;
    memset(&stReq, 0, sizeof(stReq));
    stReq.nYearMon = nYearMonth;
    stReq.nRecType = nRecType;
    // send the get camera's params command to device
    nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_REMOTE_REC_DAY_BY_MONTH_REQ, (CHAR *)&stReq, sizeof(stReq));
    return nRet;
}

- (int) getAllRemoteRecordDayByMonthWithYear:(int) nYear month:(int) nMonth
{
    int nRet = 0;
    NSString *strYearMonth = [NSString stringWithFormat:@"%d%d", nYear, nMonth];
    int nYearMonth = [strYearMonth intValue];
    int nRecType = 1;
    MSG_GET_REMOTE_REC_DAY_BY_MONTH_REQ stReq;
    memset(&stReq, 0, sizeof(stReq));
    stReq.nYearMon = nYearMonth;
    stReq.nRecType = nRecType;
    // send the get camera's params command to device
    nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_REMOTE_REC_DAY_BY_MONTH_REQ, (CHAR *)&stReq, sizeof(stReq));
    return nRet;
}
- (int) getAllRemoteRecordFilesByDayWithYear:(int) nYear month:(int) nMonth day:(int) nDay  recordType:(int) nRecordType
{
    int nRet = 0;
    //request all the record files in one day
    NSString *strYearMonth = [NSString stringWithFormat:@"%d%d%d", nYear, nMonth,nDay];
    int nYearMonth = [strYearMonth intValue];
    int nRecType = nRecordType;
    int nBeginNoOfThisTime = 0;
    int nEndNoofThisTime = 0;
    MSG_GET_REMOTE_REC_FILE_BY_DAY_REQ stReq;
    memset(&stReq, 0, sizeof(stReq));
    stReq.nYearMonDay = nYearMonth;
    stReq.nRecType = nRecType;
    stReq.nBeginNoOfThisTime = nBeginNoOfThisTime;
    stReq.nEndNoOfThisTime = nEndNoofThisTime;
    
    // send the get camera's params command to device
    nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_REMOTE_REC_FILE_BY_DAY_REQ, (CHAR *)&stReq, sizeof(stReq));
    return nRet;
}

- (int) getAllRemoteRecordFilesByDayWithYear:(int) nYear month:(int) nMonth day:(int) nDay  recordType:(int) nRecordType beginIndex:(int) nBegin endIndex:(int) nEnd
{
    int nRet = 0;
    NSString *strYearMonth = [NSString stringWithFormat:@"%d%02d%02d", nYear, nMonth,nDay];
    int nYearMonth = [strYearMonth intValue];
    int nRecType = nRecordType;
    int nBeginNoOfThisTime = nBegin;
    int nEndNoofThisTime = nEnd;
    MSG_GET_REMOTE_REC_FILE_BY_DAY_REQ stReq;
    memset(&stReq, 0, sizeof(stReq));
    stReq.nYearMonDay = nYearMonth;
    stReq.nRecType = nRecType;
    stReq.nBeginNoOfThisTime = nBeginNoOfThisTime;
    stReq.nEndNoOfThisTime = nEndNoofThisTime;
    // send the get camera's params command to device
    nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_REMOTE_REC_FILE_BY_DAY_REQ, (CHAR *)&stReq, sizeof(stReq));
    return nRet;
}

- (int) getAllRemoteAlarmRecordFilesByDayWithYearMonthDay:(int) nYearMonthDay
{
    int nRet = 0;
    //request all the record files in one day
    int nYearMonthDays = nYearMonthDay;
    int nRecType = 2;
    int nBeginNoOfThisTime = 0;
    int nEndNoofThisTime = 0;
    MSG_GET_REMOTE_REC_FILE_BY_DAY_REQ stReq;
    memset(&stReq, 0, sizeof(stReq));
    stReq.nYearMonDay = nYearMonthDays;
    stReq.nRecType = nRecType;
    stReq.nBeginNoOfThisTime = nBeginNoOfThisTime;
    stReq.nEndNoOfThisTime = nEndNoofThisTime;
    // send the get camera's params command to device
    nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_REMOTE_REC_FILE_BY_DAY_REQ, (CHAR *)&stReq, sizeof(stReq));
    
    return nRet;
}

- (int) getAllRemoteAllScheduleRecordFilesByDayWithYearMonthDay:(int) nYearMonthDay
{
    int nRet = 0;
    //request all the record files in one day
    
    int nYearMonthDays = nYearMonthDay;
    int nRecType = 1;
    int nBeginNoOfThisTime = 0;
    int nEndNoofThisTime = 0;
    MSG_GET_REMOTE_REC_FILE_BY_DAY_REQ stReq;
    memset(&stReq, 0, sizeof(stReq));
    stReq.nYearMonDay = nYearMonthDays;
    stReq.nRecType = nRecType;
    stReq.nBeginNoOfThisTime = nBeginNoOfThisTime;
    stReq.nEndNoOfThisTime = nEndNoofThisTime;
    // send the get camera's params command to device
    nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_REMOTE_REC_FILE_BY_DAY_REQ, (CHAR *)&stReq, sizeof(stReq));
    return nRet;
}

- (int) getAllRemoteAllTypeRecordFilesByDayWithYearMonthDay:(int) nYearMonthDay
{
    int nRet = 0;
    int nYearMonthDays = nYearMonthDay;
    int nRecType = 3;
    int nBeginNoOfThisTime = 0;
    int nEndNoofThisTime = 0;
    MSG_GET_REMOTE_REC_FILE_BY_DAY_REQ stReq;
    memset(&stReq, 0, sizeof(stReq));
    stReq.nYearMonDay = nYearMonthDays;
    stReq.nRecType = nRecType;
    stReq.nBeginNoOfThisTime = nBeginNoOfThisTime;
    stReq.nEndNoOfThisTime = nEndNoofThisTime;
    NSLog(@"KYLCamera::getAllRemoteAllTypeRecordFilesByDayWithYearMonthDay() ćĽčŻ˘çćĽćďź%d",nYearMonthDay);
    // send the get camera's params command to device
    nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_REMOTE_REC_FILE_BY_DAY_REQ, (CHAR *)&stReq, sizeof(stReq));
    return nRet;
}

- (int) getAllRemoteRecordFilesByDayWithYearMonthDay:(int) nYearMonthDay  recordType:(int) nRecordType beginIndex:(int) nBegin endIndex:(int) nEnd
{
    int nRet = 0;
    int nYearMonthDays = nYearMonthDay;
    int nRecType = nRecordType;
    int nBeginNoOfThisTime = nBegin;
    int nEndNoofThisTime = nEnd;
    MSG_GET_REMOTE_REC_FILE_BY_DAY_REQ stReq;
    memset(&stReq, 0, sizeof(stReq));
    stReq.nYearMonDay = nYearMonthDays;
    stReq.nRecType = nRecType;
    stReq.nBeginNoOfThisTime = nBeginNoOfThisTime;
    stReq.nEndNoOfThisTime = nEndNoofThisTime;
    // send the get camera's params command to device
    nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_REMOTE_REC_FILE_BY_DAY_REQ, (CHAR *)&stReq, sizeof(stReq));
    return nRet;
}

- (int) startPlayRemoteRecordFile:(NSString *) sFilePath atPos:(int) nPosSec
{
    int nRet = 0;
    MSG_START_PLAY_REC_FILE_REQ stReq;
    memset(&stReq, 0, sizeof(stReq));
    strcpy(stReq.chFilePath, [sFilePath UTF8String]);
    stReq.nBeginPos_sec = nPosSec;
    // send the get camera's params command to device
    nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_START_PLAY_REC_FILE_REQ, (CHAR *)&stReq, sizeof(stReq));
    return nRet;
}

- (int) startPlayRemoteRecordFile:(NSString *) sFilePath
{
    int nRet = 0;
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED || sFilePath == NULL || [sFilePath length] < 1)
    {
        return -1;
    }
    MSG_START_PLAY_REC_FILE_REQ stReq;
    memset(&stReq, 0, sizeof(stReq));
    strcpy(stReq.chFilePath, [sFilePath UTF8String]);
    
    // send the get camera's params command to device
    nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_START_PLAY_REC_FILE_REQ, (CHAR *)&stReq, sizeof(stReq));
    m_bFindIFrame = false;
    return nRet;
}

- (int) stopPlayRemoteRecordFile:(NSString *) sFilePath
{
    int nRet = 0;
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED || sFilePath == NULL || [sFilePath length] < 1)
    {
        return -1;
    }
    MSG_STOP_PLAY_REC_FILE_REQ stReq;
    memset(&stReq, 0, sizeof(stReq));
    strcpy(stReq.chFilePath, [sFilePath UTF8String]);
    
    // send the get camera's params command to device
    nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_STOP_PLAY_REC_FILE_REQ, (CHAR *)&stReq, sizeof(stReq));
    return nRet;
}

- (int) startPlayTheRemoteRecordFileWhenSucceedReceiveVideoStream
{
    KYLCurrentPlayRecordInfo *oneCurrentPlayRecordInfo = self.m_pCurrentRemoteRecordPlayInfo;
    if (oneCurrentPlayRecordInfo.m_nResult == 0) {
        [self startPlayRemoteRecordVideoThread];
        //if (oneCurrentPlayRecordInfo.m_nAudioParam >= 0)
        {
            [self startPlayRemoteRecordAuidoThread];
        }
    }
    return 1;
}
- (int) stopPlayTheRemoteRecordFileWhenSucceedReceiveVideoStream
{
    [self stopPlayRemoteRecordVideoThread];
    [self stopPlayRemoteRecordAudioThread];
    return 1;
}

- (int) getCameraParams
{
    // send the get camera's params command to device
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_CAMERA_PARAM_REQ, NULL, 0);
    return nRet;
}

- (int) getCameraWifi
{
    // send the get camera's wifi command to device
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_CURRENT_WIFI_REQ, NULL, 0);
    return nRet;
}

- (int) getCameraWifiList
{
    // send the get camera's wifi list command to device
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_WIFI_LIST_REQ, NULL, 0);
    return nRet;
}

- (int) getCameraUserInfo
{
    // send the get camera's user command to device
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_USER_INFO_REQ, NULL, 0);
    return nRet;
}

- (int) getCameraDatetimeInfo
{
    // send the get camera's datetime command to device
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_DATETIME_REQ, NULL, 0);
    return nRet;
}

- (int) getCameraFTPInfo
{
    // send the get camera's ftp command to device
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_FTP_INFO_REQ, NULL, 0);
    return nRet;
}

- (int) getCameraEmailInfo
{
    // send the get camera's email command to device
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_EMAIL_INFO_REQ, NULL, 0);
    return nRet;
}

- (int) getCameraAlarmInfo
{
    // send the get camera's alarm command to device
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_ALARM_INFO_REQ, NULL, 0);
    return nRet;
}

- (int) getCameraSDCardScheduleInfo
{
    // send the get camera's sdcard schedule command to device
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_SDCARD_REC_PARAM_REQ, NULL, 0);
    return nRet;
}

- (int) getCameraSoftVersionInfo
{
    // send the get camera's hard soft version information command to device
    INT32 nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_DEVICE_VERSION_REQ, NULL, 0);
    return nRet;
}


#pragma mark deal call back function
/*!
 @method
 @abstract processRecordAudioBuf.
 @discussion deal the recording audio data that call back returned. save the auido data into  the talk audio bufffer.
 @result null .
 */
- (void) processRecordAudioBuf:(AudioQueueRef) inAQ inBuffer:(AudioQueueBufferRef)inBuffer startTime:(const AudioTimeStamp *)inStartTime packetsNum:(UInt32) inNumPackets inPacketDescribe:(const AudioStreamPacketDescription *) inPacketDesc
{
    {
        if (nil == m_pTalkAudioBuf || m_bTalkResp != KYL_Talk_REQUEST_STATUS_SUCCEED) {
            return;
        }
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        if(0 == m_pTalkAudioBuf->Write(inBuffer->mAudioData, inBuffer->mAudioDataByteSize))
        {
            m_pTalkAudioBuf->Reset();
            m_pTalkAudioBuf->Write(inBuffer->mAudioData, inBuffer->mAudioDataByteSize);
        }
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
        [pool drain];
        pool = nil;
    }
}


/*!
 @method
 @abstract RecordAudioBuffer_Callback.
 @discussion static call back function, used for receive the recording auido data call back.
 @result null .
 */
static void RecordAudioBuffer_Callback(void *aqData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime, UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc)
{
    //DebugLog(@"ĺ˝éłĺč°");
    KYLCamera *pCamera = (KYLCamera*)aqData;
    [pCamera processRecordAudioBuf:inAQ inBuffer:inBuffer startTime:inStartTime packetsNum:inNumPackets inPacketDescribe:inPacketDesc];
}

/*!
 @method
 @abstract didReceivedStreamCallBack.
 @discussion deal the stream call back data.
 @result null .
 */
- (void) didReceivedStreamCallBack:(CHAR *) pDID streamData:(CHAR *) pData dataSize:(UINT32) nDataSize
{
    @synchronized(self)
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSString *stempDid = [[NSString alloc] initWithCString:pDID encoding:NSUTF8StringEncoding];
        if ([stempDid isEqualToString:self.m_sDID])
        {
            [self dealWithTheStreamCallbackResult:pData dataSize:nDataSize];
        }
        [stempDid release];
        [pool drain];
        pool = nil;
    }
}


/*!
 @method
 @abstract didReceivedMsgCallBack.
 @discussion deal the send message call back data.
 @result null .
 */
- (void) didReceivedMsgCallBack:(CHAR *) pDID messageType:(UINT32) nMessageType messageData:(CHAR *) messageData dataSize:(UINT32) nMsgDataSize
{
    @synchronized(self)
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSLog(@"KYLCamera::didReceivedMsgCallBack() did= %s, datasize=%d messageData=%c nMessageType=%i SEP2P_MSG_CONNECT_STATUS=%i",pDID,nMsgDataSize,messageData,nMessageType,SEP2P_MSG_CONNECT_STATUS);

        NSString *string = [NSString stringWithFormat:@"%s", pDID];
    
        if ([self.onlineCameras containsString:string]) {
            NSLog(@"string does  contain bla");
            
        } else {
            NSString* did = [NSString stringWithFormat:@"%@%@", self.onlineCameras, string];
            self.onlineCameras = did;
            NSLog(@"string contains bla!");
        }

        if (SEP2P_MSG_CONNECT_STATUS == nMessageType)
        {
            MSG_CONNECT_STATUS *pResp=(MSG_CONNECT_STATUS *)messageData;
            int iStatus = pResp->eConnectStatus;
            NSLog(@"SEP2P_MSG_CONNECT_STATUS  %i  CONNECT_STATUS_ONLINE  %i pDID=%s",iStatus, CONNECT_STATUS_ONLINE ,pDID);
            if(iStatus == CONNECT_STATUS_DISCONNECT || iStatus == CONNECT_STATUS_DEVICE_NOT_ONLINE || iStatus == CONNECT_STATUS_CONNECT_TIMEOUT || iStatus == CONNECT_STATUS_CONNECTING){
                NSLog(@"CONNECT_STATUS_DISCONNECT  did=%s self.onlineCameras=%@", pDID, self.onlineCameras);
                self.onlineCameras  = [self.onlineCameras stringByReplacingOccurrencesOfString:string withString:@""];
            }
            NSLog(@"onlineCameras --> yearMonth=%@ ",self.onlineCameras);
        
            [self dealTheDeviceStatusMsg:pResp];
        }

        NSString *stempDid = [[NSString alloc] initWithCString:pDID encoding:NSUTF8StringEncoding];
        if ([stempDid isEqualToString:self.m_sDID])
        {
            if (SEP2P_MSG_START_TALK_RESP == nMessageType)// if the message type is talk
            {
                [self dealTheTalkCallbackData:messageData size:nMessageType];
            }
            else if (SEP2P_MSG_CONNECT_STATUS == nMessageType)
            {
                MSG_CONNECT_STATUS *pResp=(MSG_CONNECT_STATUS *)messageData;
                int iStatus = pResp->eConnectStatus;
                if(iStatus == CONNECT_STATUS_DISCONNECT || iStatus == CONNECT_STATUS_DEVICE_NOT_ONLINE){
                    self.onlineCameras  = [self.onlineCameras stringByReplacingOccurrencesOfString:string withString:@" "];
                }
                [self dealTheDeviceStatusMsg:pResp];
            }
            else if (SEP2P_MSG_SNAP_PICTURE_RESP == nMessageType)
            {
                //the data no contain head, all the purge data are image bin data
                [self dealTheCallbackSnapPictureResponse:messageData size:nMsgDataSize];
            }
            else if (SEP2P_MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP == nMessageType)
            {
                [self dealWithTheGetAllRecordFilesByDayMsg:messageData dataSize:nMsgDataSize];
            }else{
                MSG_INFO *pMsgInfo=(MSG_INFO *)malloc(sizeof(MSG_INFO));
                memset(pMsgInfo, 0, sizeof(MSG_INFO));
                pMsgInfo->nChanNo=0;
                pMsgInfo->nMsgType=nMessageType;
                pMsgInfo->nMsgSize=nMsgDataSize;
                if(nMsgDataSize>0){
                    pMsgInfo->pMsg=(CHAR *)malloc(nMsgDataSize);
                    memcpy(pMsgInfo->pMsg, messageData, nMsgDataSize);
                }
                
                //deal with message
                [self dealTheReceivedMsg:pMsgInfo];
                
                // free memory
                if(pMsgInfo){
                    if(pMsgInfo->pMsg) {
                        free(pMsgInfo->pMsg);
                        pMsgInfo->pMsg=NULL;
                    }
                    free(pMsgInfo);
                    pMsgInfo=NULL;
                }
            }
        }
        [stempDid release];
        [pool drain];
        pool = nil;
    }
}


/*!
 @method
 @abstract didReceivedEventCallBack.
 @discussion deal the event call back data.
 @result null .
 */
- (void) didReceivedEventCallBack:(CHAR *) pDID  eventData:(CHAR*  ) pEventData  dataSize:(UINT32 ) nEventDataSize eventType:(UINT32) nEventType
{
    @synchronized(self)
    {
        NSLog(@"---->IPCćśĺ°äşäťśäżĄćŻďźdidReceivedEventCallBack DID=%s, eventype=%d datasize=%d",pDID, nEventType,nEventDataSize);
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSString *stempDid = [[NSString alloc] initWithCString:pDID encoding:NSUTF8StringEncoding];
        NSString *strEventType = [[NSString alloc] initWithFormat:@"%d",nEventType];
        NSData *eventData = [[NSData alloc] initWithBytes:(Byte *)pEventData length:nEventDataSize];
        NSString *strDataLength = [[NSString alloc] initWithFormat:@"%d",nEventDataSize];
        // send the broadcast to notification the event.
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:stempDid,@"did",strEventType,@"eventtype",eventData,@"data",strDataLength,@"datasize", nil];
        [strDataLength release];
        [strEventType release];
        [eventData release];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@KYL_NOTIFICATION_RECEIVE_CAMERA_EVENT object:self userInfo:dic];
        // free memory
        [dic release];
        
        if ([stempDid isEqualToString:self.m_sDID])
        {
            [self dealWithTheEventResult:nEventType];
        }
        [stempDid release];
        [pool drain];
        pool = nil;
    }
}


- (BOOL) insertOneAlarmLogInfo:(NSString *) sDID eventData:(CHAR*  ) pEventData  dataSize:(UINT32 ) nEventDataSize eventType:(UINT32) nEventType
{
    return NO;
}

- (int) dealWithTheLiveVideoStreamCallbackResult:(CHAR *) _sStreamData  dataSize:(UINT32) nSize
{
    int m_iRet = 0;
    STREAM_HEAD *pStreamHead=(STREAM_HEAD *)_sStreamData;
    int nRet = 0;
    if(pStreamHead->nCodecID==AV_CODECID_VIDEO_H264 )
    {
        if(!m_bVideoPlayThreadRuning) return -1;
        if(!m_bFindIFrame){
            if(pStreamHead->nParameter == VIDEO_FRAME_FLAG_I) m_bFindIFrame = true;
            else {
                m_iRet=-4;
                return m_iRet;
            }
        }
        if(m_bFindIFrame){
            nRet = [self AddOneFrameIntoVideoBuf:(char *) _sStreamData dataSize:nSize];
            if(nRet == 0)
            {
                [self ResetTheVideoBuf];
                m_bFindIFrame = false;
                m_iRet=-4;
                return m_iRet;
            }
        }
    }
    else if(pStreamHead->nCodecID==AV_CODECID_VIDEO_MJPEG )
    {
        if(!m_bVideoPlayThreadRuning) return -1;
        nRet = [self AddOneFrameIntoVideoBuf:(char *) _sStreamData dataSize:nSize];
        if(nRet == 0)
        {
            [self ResetTheVideoBuf];
            m_bFindIFrame = false;
        }
    }
    return m_iRet;
}

- (int) dealWithTheLiveAudioStreamCallbackResult:(CHAR *) _sStreamData  dataSize:(UINT32) nSize
{
    int m_iRet = 0;
    
    STREAM_HEAD *pStreamHead=(STREAM_HEAD *)_sStreamData;
    int nDataLength = pStreamHead->nStreamDataLen;
    int nCodecID = pStreamHead->nCodecID;
    unsigned int nTimestamp = pStreamHead->nTimestamp;
    //ĺ¤çćŹĺ°ĺ˝ĺéłé˘
    if(m_bLocalRecording && m_pMp4videoRecordToolHandle)
    {
        //ĺĺĽĺ˝ĺéłé˘ć°ćŽ
        UINT32 Length = nDataLength;
        UCHAR *inBuf = (UCHAR *)(_sStreamData + sizeof(STREAM_HEAD));
        if(AV_CODECID_AUDIO_ADPCM == nCodecID)//adpcm audio
        {
            //ä¸ćŻćADPCMć źĺź
            //[self addOneAudioFrameIntoLocalRecordFile:(char*)inBuf dataSize:Length deviceTimeTamp:nTimestamp];
        }
        else if(AV_CODECID_AUDIO_G726 == nCodecID)//g726 audio
        {
            [self addOneAudioFrameIntoLocalRecordFile:(char*)inBuf dataSize:Length deviceTimeTamp:nTimestamp];
        }
        else if(AV_CODECID_AUDIO_G711A == nCodecID)//g711 audio
        {
            [self addOneAudioFrameIntoLocalRecordFile:(char*)inBuf dataSize:Length deviceTimeTamp:nTimestamp];
        }
        else if(AV_CODECID_AUDIO_AAC == nCodecID)//aac audio
        {
            [self addOneAudioFrameIntoLocalRecordFile:(char*)inBuf dataSize:Length deviceTimeTamp:nTimestamp];
        }
    }
    int nRet = 0 ;
    if(!m_bAudioPlayThreadRuning) return -1;
    if (0==m_bIsSendingTalkDataToDevice) {//ć˛ĄćĺéĺŻščŽ˛ć°ćŽćśďźĺĺĽçĺŹć°ćŽ
        nRet = [self AddOneFrameIntoAudioBuf:(char *) _sStreamData dataSize:nSize];
        if(nRet == 0)
        {
            [self ResetTheAudioBuf];
        }
    }
    else
    {
        [self ResetTheAudioBuf];
    }
    return m_iRet;
}

- (int) dealWithTheSDCardVideoStreamCallbackResult:(CHAR *) _sStreamData  dataSize:(UINT32) nSize
{
    int m_iRet = 0;
    STREAM_HEAD *pStreamHead=(STREAM_HEAD *)_sStreamData;
    int nTempPlaybackID = pStreamHead->nPlaybackID;
    int nDataLength = pStreamHead->nStreamDataLen;
    if (m_nCurrentPlaybackID == nTempPlaybackID)
    {//only deal the same playback id
        int nRet = 0;
        if(pStreamHead->nCodecID==AV_CODECID_VIDEO_H264 )
        {
            if(!m_bRemoteRecordVideoPlayThreadRuning) return -1;
            if (nDataLength == 0) {//čŻ´ćSDCardĺ˝ĺĺćžĺŽć
                NSLog(@"\n\nćĽćść°ćŽĺč°ĺ˝ć°ďź SDCardĺ˝ĺĺćžć°ćŽćĽćśĺŽćŻ-----");
            }
            if(!m_bFindIFrame){
                if(pStreamHead->nParameter == VIDEO_FRAME_FLAG_I) m_bFindIFrame = true;
                else {
                    m_iRet=-4;
                    return m_iRet;
                }
            }
            if(m_bFindIFrame){
                nRet = [self AddOneFrameIntoRemoteVideoBuf:(char *) _sStreamData dataSize:nSize];
                if(nRet == 0)
                {
                    [self ResetTheRemoteVideoBuf];
                    m_bFindIFrame = false;
                    m_iRet=-4;
                    return m_iRet;
                }
            }
        }
        else if(pStreamHead->nCodecID==AV_CODECID_VIDEO_MJPEG )
        {
            if(!m_bRemoteRecordVideoPlayThreadRuning) return -1;
            nRet = [self AddOneFrameIntoRemoteVideoBuf:(char *) _sStreamData dataSize:nSize];
            if(nRet == 0)
            {
                [self ResetTheRemoteVideoBuf];
            }
        }
    }
    return m_iRet;
}

- (int) dealWithTheSDCardAudioStreamCallbackResult:(CHAR *) _sStreamData  dataSize:(UINT32) nSize
{
    int m_iRet = 0;
    STREAM_HEAD *pStreamHead=(STREAM_HEAD *)_sStreamData;
    int nTempPlaybackID = pStreamHead->nPlaybackID;
    int nCodeID =pStreamHead->nCodecID;
    if (m_nCurrentPlaybackID == nTempPlaybackID)
    {//only deal the same playback id
        int nRet = 0;
        if(!m_bRemoteRecordAudioPlayThreadRuning) return -1;
        
        if(nCodeID==AV_CODECID_AUDIO_ADPCM
           || nCodeID==AV_CODECID_AUDIO_G726
           || nCodeID==AV_CODECID_AUDIO_G711A
           || nCodeID==AV_CODECID_AUDIO_AAC  )
        {
            nRet = [self AddOneFrameIntoRemoteRecordAudioBuf:(char *) _sStreamData dataSize:nSize];
            if(nRet == 0)
            {
                [self ResetTheRemoteRecordAudioBuf];
            }
        }
        else if(pStreamHead->nCodecID==AV_CODECID_UNKNOWN)
        {
            NSLog(@"The callback stream is unknown");
        }
        else
        {
            NSLog(@"The callback stream have some error!");
        }
    }// end for if (m_nCurrentPlaybackID == nTempPlaybackID) {//only deal the same playback id
    return m_iRet;
}


- (int) dealWithTheStreamCallbackResult:(CHAR *) _sStreamData  dataSize:(UINT32) nSize
{
    int m_iRet = 0;
    STREAM_HEAD *pStreamHead=(STREAM_HEAD *)_sStreamData;
    int nTempLivePlayback = pStreamHead->nLivePlayback;
    if (nTempLivePlayback == 0)
    { //live video stream
        if(pStreamHead->nCodecID==AV_CODECID_VIDEO_H264 || pStreamHead->nCodecID==AV_CODECID_VIDEO_MJPEG)
        {
            [self dealWithTheLiveVideoStreamCallbackResult:_sStreamData dataSize:nSize];
        }
        else if(pStreamHead->nCodecID==AV_CODECID_AUDIO_G726
                || pStreamHead->nCodecID==AV_CODECID_AUDIO_ADPCM
                || pStreamHead->nCodecID==AV_CODECID_AUDIO_G711A
                || pStreamHead->nCodecID==AV_CODECID_AUDIO_AAC
                )
        {
            [self dealWithTheLiveAudioStreamCallbackResult:_sStreamData dataSize:nSize];
        }
    }
    else if (nTempLivePlayback == 1)
    { //remote playback video stream
        
        if(pStreamHead->nCodecID==AV_CODECID_VIDEO_H264 || pStreamHead->nCodecID==AV_CODECID_VIDEO_MJPEG)
        {
            [self dealWithTheSDCardVideoStreamCallbackResult:_sStreamData dataSize:nSize];
        }
        else if(pStreamHead->nCodecID==AV_CODECID_AUDIO_G726
                || pStreamHead->nCodecID==AV_CODECID_AUDIO_ADPCM
                || pStreamHead->nCodecID==AV_CODECID_AUDIO_G711A
                || pStreamHead->nCodecID==AV_CODECID_AUDIO_AAC
                )
        {
            [self dealWithTheSDCardAudioStreamCallbackResult:_sStreamData dataSize:nSize];
        }
    }
    return m_iRet;
}


- (int) dealWithTheEventResult:(UINT32) nEventType
{
    return 0;
}


- (int) dealTheTalkCallbackData:(CHAR *) data size:(UINT32) dataSize
{
    MSG_START_TALK_RESP *pTalkResp=(MSG_START_TALK_RESP *)data;
    
    int nTalkStatus = pTalkResp->result;
    int nTempTalkRequestStatus = -1;
    if (nTalkStatus == 0)
    {
        NSLog(@"talk channel open successfully, you can send talk data now!");
        // start a thread to record the audio, then send the audio dato to device.
        nTempTalkRequestStatus = KYL_Talk_REQUEST_STATUS_SUCCEED;
        [self performSelectorOnMainThread:@selector(startSendTalkData) withObject:nil waitUntilDone:NO];
        //äżŽćšĺ°ďźćä˝čŻ´čŻćśĺŻĺ¨ĺéĺŻščŽ˛äżĄćŻĺ°čŽžĺ¤ďźćžĺźćśďźĺć­˘çşżç¨
    }
    else if (nTalkStatus == 1)
    {
        nTempTalkRequestStatus = KYL_Talk_REQUEST_STATUS_FAILED_FOR_SOME_ONE_TALIKING;
        NSLog(@"talk channel open failed, someone has used it now , you must wait it be free!");
    }
    else if (nTalkStatus == 2)
    {
        nTempTalkRequestStatus = KYL_Talk_REQUEST_STATUS_FAILED_FOR_ERROR;
        NSLog(@"talk channel open failed, some error  happen!");
    }
    else
    {
        nTempTalkRequestStatus = KYL_Talk_REQUEST_STATUS_UNKNOWN;
        NSLog(@"talk channel open failed, the status is unknown!");
    }
    @synchronized(self)
    {
        m_bTalkResp = nTempTalkRequestStatus;
    }
    NSString *strReserve = [[NSString alloc] initWithCString:pTalkResp->reserve encoding:NSUTF8StringEncoding];
    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveTheTalkResponseNotify:talkStatus:reserver:)]) {
        [_delegate didReceiveTheTalkResponseNotify:self.m_sDID talkStatus:nTalkStatus reserver:strReserve];
    }
    [strReserve release];
    return 0;
}

- (int) startTheTalkGatherSpeakerAudioData
{
    int nRet = 0;
    nRet = [self startGatherTheTalkAudioThread];
    return nRet;
}

- (UINT64) getCurrentTime
{
    UINT64 unTimestamp = 0;
    struct timeval tv;
    struct timezone tz;
    gettimeofday(&tv, &tz);
    unTimestamp = tv.tv_usec / 1000 + tv.tv_sec * 1000 ;
    return unTimestamp;
}

// recorder audio call back
static int  onDoReceiveRecordAudioDataCallback(NSString *sDID, CHAR*    pData, UINT32  nDataSize, void* pUserData)
{
    KYLCamera *pCamera = (KYLCamera *) pUserData;
    if (pCamera) {
        [pCamera didReceiveRecordData:pData size:nDataSize];
    }
    return 0;
}

- (void) didReceiveRecordData:(CHAR*) pData size:(UINT32) nDataSize
{
    //
}

- (int) dealTheReceivedMsg:(void *) _sData
{
    MSG_INFO *pMsgInfo = (MSG_INFO *) _sData;
    
    if(pMsgInfo==NULL) return 0;
    //CHAR chTmp[256]={0};
    switch(pMsgInfo->nMsgType)
    {
        case SEP2P_MSG_GET_CAMERA_PARAM_RESP:// the response on get camera's params.
        {
            NSLog(@"case SEP2P_MSG_GET_CAMERA_PARAM_RESP:// the response on get camera's params.");
            MSG_GET_CAMERA_PARAM_RESP *pResp=(MSG_GET_CAMERA_PARAM_RESP *)pMsgInfo->pMsg;
            
            [self dealTheGetCameraParamsMsg:pResp];
        }
            break;
        case CONNECT_STATUS_CONNECTING:// the response on get camera's params.
        {
            NSLog(@"case CONNECT_STATUS_CONNECTING:// the response on get camera's params.");
            NSLog(@"CONNECT_STATUS_CONNECTING");
        }
            break;
            
        case SEP2P_MSG_GET_CURRENT_WIFI_RESP:// the response on get camera's wifi.
        {
            NSLog(@"case SEP2P_MSG_GET_CURRENT_WIFI_RESP:// the response on get camera's wifi.");
            MSG_GET_CURRENT_WIFI_RESP *pResp=(MSG_GET_CURRENT_WIFI_RESP *)pMsgInfo->pMsg;
            
            [self dealTheGetCameraWifiMsg:pResp];
        }
            break;
            
        case SEP2P_MSG_GET_WIFI_LIST_RESP:// the response on get camera's wifi list.
        {
            NSLog(@"case SEP2P_MSG_GET_WIFI_LIST_RESP:// the response on get camera's wifi list.");
            MSG_GET_WIFI_LIST_RESP *pResp=(MSG_GET_WIFI_LIST_RESP *)pMsgInfo->pMsg;
            
            [self dealTheGetCameraWifiListMsg:pResp];
        }
            break;
            
        case SEP2P_MSG_GET_USER_INFO_RESP:// the response on get camera's user information.
        {
            NSLog(@"case SEP2P_MSG_GET_USER_INFO_RESP:// the response on get camera's user information.");
            MSG_GET_USER_INFO_RESP *pResp=(MSG_GET_USER_INFO_RESP *)pMsgInfo->pMsg;
            [self dealTheGetUserInfoMsg:pResp];
        }
            break;
            
        case SEP2P_MSG_GET_DATETIME_RESP:// the response on get camera's datetime information.
        {
            NSLog(@"case SEP2P_MSG_GET_DATETIME_RESP:// the response on get camera's datetime information.");
            MSG_GET_DATETIME_RESP *pResp=(MSG_GET_DATETIME_RESP *)pMsgInfo->pMsg;
            
            [self dealTheGetDatetimeMsg:pResp];
        }
            break;
            
        case SEP2P_MSG_GET_FTP_INFO_RESP:
        {
            NSLog(@"case SEP2P_MSG_GET_FTP_INFO_RESP:");
            MSG_GET_FTP_INFO_RESP *pResp=(MSG_GET_FTP_INFO_RESP *)pMsgInfo->pMsg;
            
            [self dealTheFTPInfoMsg:pResp];
        }
            break;
            
        case SEP2P_MSG_GET_EMAIL_INFO_RESP:// the response on get camera's ftp information.
        {
            NSLog(@"case SEP2P_MSG_GET_EMAIL_INFO_RESP:// the response on get camera's ftp information.");
            MSG_GET_EMAIL_INFO_RESP *pResp=(MSG_GET_EMAIL_INFO_RESP *)pMsgInfo->pMsg;
            
            [self dealTheEmailInfoMsg:pResp];
        }
            break;
            
        case SEP2P_MSG_GET_ALARM_INFO_RESP:// the response on get camera's alarm information.
        {
            NSLog(@"case SEP2P_MSG_GET_ALARM_INFO_RESP:// the response on get camera's alarm information.");
            MSG_GET_ALARM_INFO_RESP *pResp=(MSG_GET_ALARM_INFO_RESP *)pMsgInfo->pMsg;
            
            
            [self dealTheAlarmInfoMsg:pResp];
        }
            break;
            
        case SEP2P_MSG_GET_SDCARD_REC_PARAM_RESP:// the response on get camera's sdcard scheld params.
        {
            NSLog(@"case SEP2P_MSG_GET_SDCARD_REC_PARAM_RESP:// the response on get camera's sdcard scheld params.");
            MSG_GET_SDCARD_REC_PARAM_RESP *pResp=(MSG_GET_SDCARD_REC_PARAM_RESP *)pMsgInfo->pMsg;
            
            
            [self dealTheSDCardScheduleParamsMsg:pResp];
        }
            break;
            
        case SEP2P_MSG_GET_DEVICE_VERSION_RESP:// the response on get camera's version.
        {
            NSLog(@"case SEP2P_MSG_GET_DEVICE_VERSION_RESP:// the response on get camera's version.");
            NSLog(@"--->>SEP2P_MSG_GET_DEVICE_VERSION_RESP");
            MSG_GET_DEVICE_VERSION_RESP *pResp=(MSG_GET_DEVICE_VERSION_RESP *)pMsgInfo->pMsg;
            
            [self dealTheDeviceVersionInfoMsg:pResp];
        }
            break;
            
        case SEP2P_MSG_PTZ_CONTROL_RESP:// the response on set camera's ptz yuntai.
        {
            NSLog(@"case SEP2P_MSG_PTZ_CONTROL_RESP:// the response on set camera's ptz yuntai.");
            
            MSG_PTZ_CONTROL_RESP *pResp=(MSG_PTZ_CONTROL_RESP *)pMsgInfo->pMsg;
            [self dealTheCallbackPTZControlResponse:pResp];
            
        }
            break;
        case SEP2P_MSG_SNAP_PICTURE_RESP:// the response on get camera's snap picture.
        {
            NSLog(@"case SEP2P_MSG_SNAP_PICTURE_RESP:// the response on get camera's snap picture.");
            
            //the data no contain head, all the purge data are image bin data
            
        }
            break;
            /////// the set cgi response
        case SEP2P_MSG_SET_CAMERA_PARAM_RESP:// the response on set camera's default params.
        {
            NSLog(@"case SEP2P_MSG_SET_CAMERA_PARAM_RESP:// the response on set camera's default params.");
            
            MSG_SET_CAMERA_PARAM_RESP *pResp=(MSG_SET_CAMERA_PARAM_RESP *)pMsgInfo->pMsg;
            [self dealTheCallbackSetCameraParamsResponse:pResp];
            
        }
            break;
        case SEP2P_MSG_SET_CAMERA_PARAM_DEFAULT_RESP:// the response on set camera's default params.
        {
            NSLog(@"case SEP2P_MSG_SET_CAMERA_PARAM_DEFAULT_RESP:// the response on set camera's default params.");
            
            MSG_SET_CAMERA_PARAM_DEFAULT_RESP *pResp=(MSG_SET_CAMERA_PARAM_DEFAULT_RESP *)pMsgInfo->pMsg;
            [self dealTheCallbackSetCameraDefaultParamsResponse:pResp];
            
        }
            break;
        case SEP2P_MSG_SET_CURRENT_WIFI_RESP:// the response on set camera's wifi.
        {
            NSLog(@"case SEP2P_MSG_SET_CURRENT_WIFI_RESP:// the response on set camera's wifi.");
            
            MSG_SET_CURRENT_WIFI_RESP *pResp=(MSG_SET_CURRENT_WIFI_RESP *)pMsgInfo->pMsg;
            [self dealTheCallbackSetWifiResponse:pResp];
            
        }
            break;
        case SEP2P_MSG_SET_USER_INFO_RESP:// the response on set camera's userinfo.
        {
            NSLog(@"case SEP2P_MSG_SET_USER_INFO_RESP:// the response on set camera's userinfo.");
            
            MSG_SET_USER_INFO_RESP *pResp=(MSG_SET_USER_INFO_RESP *)pMsgInfo->pMsg;
            [self dealTheCallbackSetUserInfoResponse:pResp];
            
        }
            break;
        case SEP2P_MSG_SET_DATETIME_RESP:// the response on set camera's datetime.
        {
            NSLog(@"case SEP2P_MSG_SET_DATETIME_RESP:// the response on set camera's datetime.");
            
            MSG_SET_DATETIME_RESP *pResp=(MSG_SET_DATETIME_RESP *)pMsgInfo->pMsg;
            [self dealTheCallbackSetDatetimeInfoResponse:pResp];
            
        }
            break;
        case SEP2P_MSG_SET_FTP_INFO_RESP:// the response on set camera's ftp information.
        {
            NSLog(@"case SEP2P_MSG_SET_FTP_INFO_RESP:// the response on set camera's ftp information.");
            
            MSG_SET_FTP_INFO_RESP *pResp=(MSG_SET_FTP_INFO_RESP *)pMsgInfo->pMsg;
            [self dealTheCallbackFTPInfoResponse:pResp];
            
        }
            break;
        case SEP2P_MSG_SET_EMAIL_INFO_RESP:// the response on set camera's email.
        {
            NSLog(@"case SEP2P_MSG_SET_EMAIL_INFO_RESP:// the response on set camera's email.");
            
            MSG_SET_EMAIL_INFO_RESP *pResp=(MSG_SET_EMAIL_INFO_RESP *)pMsgInfo->pMsg;
            [self dealTheCallbackSetEmailInfoResponse:pResp];
            
        }
            break;
        case SEP2P_MSG_SET_ALARM_INFO_RESP:// the response on set camera's alarm.
        {
            NSLog(@"case SEP2P_MSG_SET_ALARM_INFO_RESP:// the response on set camera's alarm.");
            
            MSG_SET_ALARM_INFO_RESP *pResp=(MSG_SET_ALARM_INFO_RESP *)pMsgInfo->pMsg;
            [self dealTheCallbackSetAlarmInfoResponse:pResp];
            
        }
            break;
        case SEP2P_MSG_SET_SDCARD_REC_PARAM_RESP:// the response on set camera's sdcard record schedule.
        {
            NSLog(@"case SEP2P_MSG_SET_SDCARD_REC_PARAM_RESP:// the response on set camera's sdcard record schedule.");
            
            MSG_SET_SDCARD_REC_PARAM_RESP *pResp=(MSG_SET_SDCARD_REC_PARAM_RESP *)pMsgInfo->pMsg;
            [self dealTheCallbackSetSDCardSheduleParamsResponse:pResp];
            
        }
            break;
            //{{-- add by kongyulu at 20141216 for remote record play
            
        case SEP2P_MSG_GET_REMOTE_REC_DAY_BY_MONTH_RESP:// the response on get sdcard record day by month.
        {
            NSLog(@"case SEP2P_MSG_GET_REMOTE_REC_DAY_BY_MONTH_RESP:// the response on get sdcard record day by month.");
            
            MSG_GET_REMOTE_REC_DAY_BY_MONTH_RESP *pResp=(MSG_GET_REMOTE_REC_DAY_BY_MONTH_RESP *)pMsgInfo->pMsg;
            [self dealTheGetRemoteRecordDayByMonthResp:pResp];
            
        }
            break;
        case SEP2P_MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP:// the response on get all the record files by day.
        {
            NSLog(@"case SEP2P_MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP:// the response on get all the record files by day.");
            
            MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP *pResp=(MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP *)pMsgInfo->pMsg;
            [self dealTheGetRemoteRecordFilesByDayResp:pResp];
            
        }
            break;
        case SEP2P_MSG_START_PLAY_REC_FILE_RESP:// the response on start the remote record play
        {
            NSLog(@"case SEP2P_MSG_START_PLAY_REC_FILE_RESP:// the response on start the remote record play");
            
            MSG_START_PLAY_REC_FILE_RESP *pResp=(MSG_START_PLAY_REC_FILE_RESP *)pMsgInfo->pMsg;
            [self dealTheStartPlayRemoteRecordFileResp:pResp];
            
        }
            break;
        case SEP2P_MSG_STOP_PLAY_REC_FILE_RESP:// the response on stop remote record play .
        {
            NSLog(@"case SEP2P_MSG_STOP_PLAY_REC_FILE_RESP:// the response on stop remote record play .");
            
            MSG_STOP_PLAY_REC_FILE_RESP *pResp=(MSG_STOP_PLAY_REC_FILE_RESP *)pMsgInfo->pMsg;
            [self dealTheStopPlayRemoteRecordFileResp:pResp];
            
        }
            break;
        case SEP2P_MSG_GET_IPUSH_INFO_RESP:// čˇĺčŽžĺ¤ćŻĺŚĺčŽ¸ć¨éĺč­ŚäżĄćŻççść .
        {
            NSLog(@"case SEP2P_MSG_GET_IPUSH_INFO_RESP:// čˇĺčŽžĺ¤ćŻĺŚĺčŽ¸ć¨éĺč­ŚäżĄćŻççść .");
            
            MSG_GET_IPUSH_INFO_RESP *pResp=(MSG_GET_IPUSH_INFO_RESP *)pMsgInfo->pMsg;
            [self dealTheGetIPushInfoResp:pResp];
            
        }
            break;
        case SEP2P_MSG_SET_IPUSH_INFO_RESP:// čŽžç˝ŽčŽžĺ¤ĺźĺŻďźĺłé­ć¨éĺč­ŚäżĄćŻďźčŽžç˝Žçťć.
        {
            NSLog(@"case SEP2P_MSG_SET_IPUSH_INFO_RESP:// čŽžç˝ŽčŽžĺ¤ĺźĺŻďźĺłé­ć¨éĺč­ŚäżĄćŻďźčŽžç˝Žçťć.");
            
            MSG_SET_IPUSH_INFO_RESP *pResp=(MSG_SET_IPUSH_INFO_RESP *)pMsgInfo->pMsg;
            [self dealTheSetIPushInfoResp:pResp];
            
        }
            break;
        default:;
    }
    
    return 1;
}


- (void) dealWithTheGetAllRecordFilesByDayMsg:(CHAR *) pMsgData dataSize:(int) nDataSize
{
    //the data no contain head, all the purge data are image bin data
    MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP *pResp=(MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP *)pMsgData;
    [self dealTheGetRemoteRecordFilesByDayResp:pResp];
}


- (int) dealTheDeviceStatusMsg:(MSG_CONNECT_STATUS *) pResp
{
    int nRet = 0;
    @synchronized(self)
    {
        int iStatus = pResp->eConnectStatus;
        {
            self.m_nDeviceStatus = pResp->eConnectStatus;
            self.deviceConnectStatus = [NSNumber numberWithInt:self.m_nDeviceStatus];
            
        }
        NSString *strServer = [[NSString alloc ] initWithCString:pResp->reserve encoding:NSUTF8StringEncoding];
        if (_delegate && [_delegate respondsToSelector:@selector(didReceiveCameraStatus:status:reserve:user:)])
        {
            [_delegate didReceiveCameraStatus:self.m_sDID status:iStatus reserve:strServer user:self];
        }
        if (_m_pEventDelegate && [_m_pEventDelegate respondsToSelector:@selector(KYLEventProtocol_didReceiveCameraStatus:status:reserve:user:)])
        {
            [_m_pEventDelegate KYLEventProtocol_didReceiveCameraStatus:self.m_sDID status:iStatus reserve:strServer user:self];
        }
        if (_m_pDeviceStatusChangedDelegate && [_m_pDeviceStatusChangedDelegate respondsToSelector:@selector(didReceiveCameraStatus_KYLDeviceStatusChangedProtocol:status:reserve:user:)]) {
            [_m_pDeviceStatusChangedDelegate didReceiveCameraStatus_KYLDeviceStatusChangedProtocol:self.m_sDID status:iStatus reserve:strServer user:self];
        }
        
        // send notification
        NSString *strStatus = [[NSString alloc] initWithFormat:@"%d",iStatus];
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.m_sDID,@"did",strStatus,@"status",strServer,@"reserver", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@KYL_NOTIFICATION_DEVICE_STATUS_CHANGE object:self userInfo:dic];
        // free memory
        [strServer release];
        [strStatus release];
        [dic release];
        
        //deal the camera status change
        [self listenTheCameraStatusChanging:iStatus];
    }
    
    return nRet;
}

- (int) listenTheCameraStatusChanging:(int) nStatus
{
    @synchronized(self)
    {
        switch (nStatus) {
            case CONNECT_STATUS_CONNECTING:
                {
                    NSLog(@"case CONNECT_STATUS_CONNECTING");
                }
                break;
                
            case CONNECT_STATUS_INITIALING:
                {
                    NSLog(@"case CONNECT_STATUS_INITIALING:");
                }
                break;
                
            case CONNECT_STATUS_ONLINE:
                {
                    NSLog(@"case CONNECT_STATUS_ONLINE:");
                }
                break;
                
            case CONNECT_STATUS_CONNECT_FAILED:
                {
                    NSLog(@"case CONNECT_STATUS_CONNECT_FAILED:");
                }
                break;
                
            case CONNECT_STATUS_DISCONNECT:
                {
                    NSLog(@"case CONNECT_STATUS_DISCONNECT:");
                }
                break;
                
            case CONNECT_STATUS_INVALID_ID:
                {
                    NSLog(@"case CONNECT_STATUS_INVALID_ID:");
                }
                break;
                
            case CONNECT_STATUS_DEVICE_NOT_ONLINE:
                {
                    NSLog(@"case CONNECT_STATUS_DEVICE_NOT_ONLINE:");
                }
                break;
                
            case CONNECT_STATUS_CONNECT_TIMEOUT:
                {
                    NSLog(@"case CONNECT_STATUS_CONNECT_TIMEOUT:");
                }
                break;
                
            case CONNECT_STATUS_WRONG_USER_PWD:
                {
                    NSLog(@"case CONNECT_STATUS_WRONG_USER_PWD:");
                }
                break;
                
            case CONNECT_STATUS_INVALID_REQ:
                {
                    NSLog(@"case CONNECT_STATUS_INVALID_REQ:");
                }
                break;
                
            case CONNECT_STATUS_EXCEED_MAX_USER:
                {
                    NSLog(@"case CONNECT_STATUS_EXCEED_MAX_USER:");
                }
                break;
                
            case CONNECT_STATUS_CONNECTED:
            {
                NSLog(@"case CONNECT_STATUS_CONNECTED:");
                
                //ĺŚćĺ˝ĺč§é˘ć­ćžçşżç¨ć˛Ąćĺć­˘ďźĺéć°čŻˇćąč§é˘ćľďźĺŚćéłé˘ďźĺŻščŽ˛ć˛Ąćĺć­˘ďźĺéć°čŻˇćąéłé˘ćľ
                [self performSelectorOnMainThread:@selector(reRequestTheVideoStream) withObject:nil waitUntilDone:NO];
                
                //čˇĺç¨ćˇćé
                [self performSelectorOnMainThread:@selector(getCameraUserInfo) withObject:nil waitUntilDone:NO];
                
                //čˇĺčŽžĺ¤ćŻĺŚĺčŽ¸ć¨éĺč­ŚäżĄćŻ
                [self performSelectorOnMainThread:@selector(getTheCameraReceivePushFunctionStatus) withObject:nil waitUntilDone:NO];
                
                [self performSelectorOnMainThread:@selector(getTheAVCodeParameter) withObject:nil waitUntilDone:NO];
                
                //ĺéčŻˇćąčˇĺčŽžĺ¤çćŹäżĄćŻďźĺŞčˇĺä¸ćŹĄďźĺŚćčˇĺčżďźĺä¸ĺťčˇĺ
                if (!m_bSucceedGetCameraSoftVersionInfo)
                {
                    //čˇĺč§é˘ćľďźéłé˘ćľçąťĺ
                    [self performSelectorOnMainThread:@selector(getTheAVCodeParameterAndInitNVRForOnce) withObject:nil waitUntilDone:NO];
                    
                    //čˇĺçćŹäżĄćŻ
                    [self performSelectorOnMainThread:@selector(getCameraHardVersionInfo) withObject:nil waitUntilDone:NO];
                    //čˇĺcamera push token
                }
            }
                break;
            case CONNECT_STATUS_UNKNOWN:
                {
                    NSLog(@"case CONNECT_STATUS_UNKNOWN:");
                }
                break;
                
            default:
                break;
        }
    }
    return 1;
}

- (void) reRequestTheVideoStream
{
    if (m_bVideoPlayThreadRuning)
    {
        if (m_bVideoPlayThreadRuning)
        {
            //éć°čŻˇćąč§é˘ćľ
            NSLog(@"----->>reSend start the video stream command to device ");
            // send start the video stream command to device
            INT32 nRet = [self reGetTheVideoStream];
            if (nRet == ERR_SEP2P_SUCCESSFUL)
            {
                //éçĽéć°čŻˇćąč§é˘ćľďźćĺă
                NSLog(@"----->>reSend start the video stream éć°čŻˇćąč§é˘ćľďźćĺ");
                // send notification
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.m_sDID,@"did", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REREQUEST_VIDEO_STREAM_NOTIFICATION" object:self userInfo:dic];
                // free memory
                [dic release];
                
            }
        }
        if (m_bAudioPlayThreadRuning)
        {
            NSLog(@"----->>reSend start the audio stream command to device ");
            //éć°čŻˇćąéłé˘ćľ
            INT32 nRet = [self reGetTheAudioStream];
            if (nRet == ERR_SEP2P_SUCCESSFUL)
            {
                //éçĽéć°čŻˇćąéłé˘ćľďźćĺă
            }
        }
        if (m_bTalkThreadRuning)
        {
            NSLog(@"----->>reSend start the talk stream command to device ");
            //éć°ĺéĺŻščŽ˛éłé˘ćľ
            INT32 nRet = [self reGetTheTalkStream];
            if (nRet == ERR_SEP2P_SUCCESSFUL)
            {
                //éçĽéć°čŻˇćąĺéĺŻščŽ˛éłé˘ćľďźćĺă
            }
        }
    }
}

- (void) getCameraHardVersionInfo
{
    [self getCameraSoftVersionInfo];
}

- (int) dealTheGetCameraParamsMsg:(MSG_GET_CAMERA_PARAM_RESP *) pResp
{
    int nRet = 0;
    NSLog(@"%s GET_CAMERA_PARAM_RESP, nResolution=%d, nBright=%d, nContrast=%d, nSaturation=%d, bOSD=%d, nMode=%d, nFlip=%d, nIRLed=%c\n", [self.m_sDID UTF8String], pResp->nResolution, pResp->nBright, pResp->nContrast, pResp->nSaturation, pResp->bOSD, pResp->nMode, pResp->nFlip, pResp->nIRLed);
    int nResolution = pResp->nResolution;   //0->160*120, 1->320*240, 2->640*480, 3->640*360, 4->1280*720, 5->1280*960
    int nBright = pResp->nBright;       //[0,255]
    int nContrast = pResp->nContrast;   //[0,255]
    int nSaturation = pResp->nSaturation;   //[0,255]
    int bOSD = pResp->bOSD;         //0->disable, 1->enable
    int nMode = pResp->nMode;       //0->50Hz, 1->60Hz
    int nFlip = pResp->nFlip;       //0->normal, 1->mirror, 2->flip, 3->mirror & flip
    int  nIRLed = pResp->nIRLed;        //0->close, 1->open, 2->auto
    // NSString* did = [NSString stringWithFormat:@"%@/%s/", self.onlineCameras, [self.m_sDID UTF8String]];
    // self.onlineCameras = did;
    
    // NSLog(@"onlineCameras --> yearMonth=%@ ",self.onlineCameras);
    _m_nCameraResolution = nResolution;
    _m_nCameraBirght = nBright;
    _m_nCameraContrast = nContrast;
    _m_nCameraSaturation = nSaturation;
    _m_nCameraOSD = bOSD;
    _m_nCameraMode = nMode;
    _m_nCameraFlip = nFlip;
    _m_nCameraIRLed = nIRLed;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveGetCameraParams:resolution:bright:contrast:hue:saturation:osd:mode:flip:reserve1:irLed:reserver2:user:)])
    {
        [_delegate didReceiveGetCameraParams:self.m_sDID resolution:nResolution bright:nBright contrast:nContrast hue:0 saturation:nSaturation osd:bOSD mode:nMode flip:nFlip reserve1:nil irLed:nIRLed reserver2:nil  user:self];
    }
    if (_m_pSetCameraParamDelegate && [_m_pSetCameraParamDelegate respondsToSelector:@selector(KYLSetCameraParamsProtocol_didReceiveGetCameraParams:resolution:bright:contrast:hue:saturation:osd:mode:flip:reserve1:irLed:reserver2:user:)])
    {
        [_m_pSetCameraParamDelegate KYLSetCameraParamsProtocol_didReceiveGetCameraParams:self.m_sDID resolution:nResolution bright:nBright contrast:nContrast hue:0 saturation:nSaturation osd:bOSD mode:nMode flip:nFlip reserve1:nil irLed:nIRLed reserver2:nil  user:self];
    }
    
    return nRet;
}

- (int) dealTheGetCameraWifiMsg:(MSG_GET_CURRENT_WIFI_RESP *) pResp
{
    int nRet = 0;
    NSLog(@"%s GET_CURRENT_WIFI_RESP, ssid=%s, enable=%d, channel=%d, mode=%d, authtype=%d, encrypt=%d, keyformat=%d, defkey=%d, key1=%s, key2=%s, key3=%s, key4=%s, key1_bits=%d, key2_bits=%d, key3_bits=%d, key4_bits=%d, wpa_psk=%s\n", [self.m_sDID UTF8String],pResp->chSSID, (int)pResp->bEnable, (int)pResp->nChannel, (int)pResp->nMode, (int)pResp->nAuthtype, (int)pResp->nWEPEncrypt, (int)pResp->nWEPKeyFormat, (int)pResp->nWEPDefaultKey, pResp->chWEPKey1, pResp->chWEPKey2, pResp->chWEPKey2, pResp->chWEPKey4, (int)pResp->nWEPKey1_bits, (int)pResp->nWEPKey2_bits, (int)pResp->nWEPKey3_bits, (int)pResp->nWEPKey4_bits, pResp->chWPAPsk);
    
    int  enable = pResp->bEnable;
    NSString *strSsid = [[NSString alloc] initWithCString:pResp->chSSID encoding:NSUTF8StringEncoding];
    int  channel = pResp->nChannel;
    int  mode = pResp->nMode;
    int  authtype = pResp->nAuthtype;
    int  encrypt = pResp->nWEPEncrypt;
    int  keyformat = pResp->nWEPKeyFormat;
    int  defkey = pResp->nWEPDefaultKey;
    NSString *strKey1 = [[NSString alloc] initWithCString:pResp->chWEPKey1 encoding:NSUTF8StringEncoding];
    NSString *strKey2 = [[NSString alloc] initWithCString:pResp->chWEPKey2 encoding:NSUTF8StringEncoding];
    NSString *strKey3 = [[NSString alloc] initWithCString:pResp->chWEPKey3 encoding:NSUTF8StringEncoding];
    NSString *strKey4 = [[NSString alloc] initWithCString:pResp->chWEPKey4 encoding:NSUTF8StringEncoding];
    int  key1_bits = pResp->nWEPKey1_bits;
    int  key2_bits = pResp->nWEPKey2_bits;
    int  key3_bits = pResp->nWEPKey3_bits;
    int  key4_bits = pResp->nWEPKey4_bits;
    NSString *strWpa_psk = [[NSString alloc] initWithCString:pResp->chWPAPsk encoding:NSUTF8StringEncoding];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveGetWifiParams:enable:ssid:channel:mode:authtype:encryp:keyformat:defkey:strKey1:strKey2:strKey3:strKey4:key1_bits:key2_bits:key3_bits:key4_bits:wpa_psk: user:)])
    {
        [_delegate didReceiveGetWifiParams:self.m_sDID enable:enable ssid:strSsid channel:channel mode:mode authtype:authtype encryp:encrypt keyformat:keyformat defkey:defkey strKey1:strKey1 strKey2:strKey2 strKey3:strKey3 strKey4:strKey4 key1_bits:key1_bits key2_bits:key2_bits key3_bits:key3_bits key4_bits:key4_bits wpa_psk:strWpa_psk  user:self];
    }
    
    if (_m_pSetWifiDelegate && [_m_pSetWifiDelegate respondsToSelector:@selector(KYLSetWifiProtocol_didReceiveGetWifiParams:enable:ssid:channel:mode:authtype:encryp:keyformat:defkey:strKey1:strKey2:strKey3:strKey4:key1_bits:key2_bits:key3_bits:key4_bits:wpa_psk: user:)])
    {
        [_m_pSetWifiDelegate KYLSetWifiProtocol_didReceiveGetWifiParams:self.m_sDID enable:enable ssid:strSsid channel:channel mode:mode authtype:authtype encryp:encrypt keyformat:keyformat defkey:defkey strKey1:strKey1 strKey2:strKey2 strKey3:strKey3 strKey4:strKey4 key1_bits:key1_bits key2_bits:key2_bits key3_bits:key3_bits key4_bits:key4_bits wpa_psk:strWpa_psk  user:self];
    }
    
    // free memory
    [strSsid release];
    [strKey1 release];
    [strKey2 release];
    [strKey3 release];
    [strKey4 release];
    [strWpa_psk release];
    return nRet;
}

/*!
 @method
 @abstract dealTheGetCameraWifiListMsg.
 @discussion deal response data after send get device's wifi list cgi command.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */
- (int) dealTheGetCameraWifiListMsg:(MSG_GET_WIFI_LIST_RESP *) pResp
{
    int nRet = 0;
    int count = (int)pResp->nResultCount;
    NSLog(@"%s GET_CURRENT_WIFI_RESP, ssid count = %d\n", [self.m_sDID UTF8String], count);
    if (count <= 0) {
        return -1;
    }
    for (int i = 0; i < count; i++)
    {
        SEP2P_RESULT_WIFI_INFO oneWifiInfo = (SEP2P_RESULT_WIFI_INFO )pResp->wifi[i];
        BOOL m_bIsEnd = NO;
        if (i == count-1) {
            m_bIsEnd = YES;
        }
        NSString *strSsid = [[NSString alloc] initWithCString:oneWifiInfo.chSSID encoding:NSUTF8StringEncoding];
        NSString *strMac = [[NSString alloc] initWithCString:oneWifiInfo.chMAC encoding:NSUTF8StringEncoding];
        int  security = oneWifiInfo.nAuthtype;//0->WEP-NONE, 1->WEP, 2->WPA-PSK TKIP, 3->WPA-PSK AES, 4->WPA2-PSK TKIP, 5->WPA2-PSK AES
        
        NSString *strDbm0 = [[NSString alloc] initWithCString:oneWifiInfo.dbm0 encoding:NSUTF8StringEncoding];//'80' sign level
        NSString *strDbm1 = [[NSString alloc] initWithCString:oneWifiInfo.dbm1 encoding:NSUTF8StringEncoding];//'100'
        int  mode = oneWifiInfo.nMode;  //0->infra 1->adhoc
        int  channel = oneWifiInfo.reserve; //wifi channel #
        if (_delegate && [_delegate respondsToSelector:@selector(didSucceedGetOneWifiScanResult:ssid:mac:security:db0:db1:mode:channel:bEnd:user:)])
        {
            [_delegate didSucceedGetOneWifiScanResult:self.m_sDID ssid:strSsid mac:strMac security:security db0:strDbm0 db1:strDbm1 mode:mode channel:channel bEnd:m_bIsEnd user:self];
        }
        if (_m_pSetWifiDelegate && [_m_pSetWifiDelegate respondsToSelector:@selector(KYLSetWifiProtocol_didSucceedGetOneWifiScanResult:ssid:mac:security:db0:db1:mode:channel:bEnd:user:)])
        {
            [_m_pSetWifiDelegate KYLSetWifiProtocol_didSucceedGetOneWifiScanResult:self.m_sDID ssid:strSsid mac:strMac security:security db0:strDbm0 db1:strDbm1 mode:mode channel:channel bEnd:m_bIsEnd user:self];
        }
        //free memory
        [strSsid release];
        [strMac release];
        [strDbm0 release];
        [strDbm1 release];
        
    }
    return nRet;
}


- (int) dealTheGetUserInfoMsg:(MSG_GET_USER_INFO_RESP *) pResp
{
    int nRet = 0;
    NSLog(@"%s GET_USER_INFO_RESP, chVisitor=%s, chVisitorPwd=%s, reserve=%s, chAdmin=%s, chAdminPwd=%s\n", [self.m_sDID UTF8String],
          pResp->chVisitor,pResp->chVisitorPwd,pResp->reserve, pResp->chAdmin, pResp->chAdminPwd);
    
    NSString *strVisitor = [[NSString alloc] initWithCString:pResp->chVisitor encoding:NSUTF8StringEncoding];
    NSString *strVisitorPwd = [[NSString alloc] initWithCString:pResp->chVisitorPwd encoding:NSUTF8StringEncoding];
    NSString *strreserve = [[NSString alloc] initWithCString:pResp->reserve encoding:NSUTF8StringEncoding];
    NSString *strAdmin = [[NSString alloc] initWithCString:pResp->chAdmin encoding:NSUTF8StringEncoding];
    NSString *strAdminPwd = [[NSString alloc] initWithCString:pResp->chAdminPwd encoding:NSUTF8StringEncoding];
    
    self.m_strAdmin = strAdmin;
    self.m_strAdminPwd = strAdminPwd;
    self.m_strVistor = strVisitor;
    self.m_strVistorPwd = strVisitorPwd;
    if ([self.m_sUsername isEqualToString:self.m_strAdmin])
    {
        self.m_iUserType = 1;
        self.m_bIsAdmin = YES;
    }
    else if ([self.m_sUsername isEqualToString:self.m_strVistor])
    {
        self.m_iUserType = 0;
        self.m_bIsAdmin = NO;
    }
    else
    {
        self.m_iUserType = -1;
        self.m_bIsAdmin = NO;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveGetUserPwdResult:admin:adminPwd:vistor:vistorPwd:resever:user:)])
    {
        [self.delegate didReceiveGetUserPwdResult:self.m_sDID admin:strAdmin adminPwd:strAdminPwd vistor:strVisitor vistorPwd:strVisitorPwd resever:strreserve user:self];
    }
    if (self.m_pSetUserInfoDelegate && [self.m_pSetUserInfoDelegate respondsToSelector:@selector(KYLSetUserInfoProtocol_didReceiveGetUserPwdResult:admin:adminPwd:vistor:vistorPwd:resever:user:)])
    {
        [self.m_pSetUserInfoDelegate KYLSetUserInfoProtocol_didReceiveGetUserPwdResult:self.m_sDID admin:strAdmin adminPwd:strAdminPwd vistor:strVisitor vistorPwd:strVisitorPwd resever:strreserve user:self];
    }
    // free memory
    [strVisitor release];
    [strVisitorPwd release];
    [strreserve release];
    [strAdmin release];
    [strAdminPwd release];
    return nRet;
}

- (int) dealTheGetDatetimeMsg:(MSG_GET_DATETIME_RESP *) pResp
{
    int nRet = 0;
    NSLog(@"%s MSG_GET_DATETIME_RESP,  nSecToNow=%d, nSecTimeZone=%d bEnableNTP=%d chNTPServer=%s nIndexOfTimezoneTable=%d\n", [self.m_sDID UTF8String],pResp->nSecToNow,pResp->nSecTimeZone,pResp->bEnableNTP,pResp->chNTPServer,pResp->nIndexTimeZoneTable);
    int now = pResp->nSecToNow;;
    int tz = pResp->nSecTimeZone;;      //secondsFromGMT in local TimeZone
    int ntp_enable = pResp->bEnableNTP;
    NSString *strNtp_svr = [[NSString alloc] initWithCString:pResp->chNTPServer encoding:NSUTF8StringEncoding];
    int nIndexOfTimezoneTable = pResp->nIndexTimeZoneTable;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveGetDateTimeParams:now:tz:ntpEnable:ntpServer:indexOfTimeZoneTable:user:)])
    {
        [self.delegate didReceiveGetDateTimeParams:self.m_sDID now:now tz:tz ntpEnable:ntp_enable ntpServer:strNtp_svr indexOfTimeZoneTable:nIndexOfTimezoneTable user:self];
    }
    if (self.m_pSetDatetimeDelegate && [self.m_pSetDatetimeDelegate respondsToSelector:@selector(KYLSetDatetimeProtocol_didReceiveGetDateTimeParams:now:tz:ntpEnable:ntpServer:indexOfTimeZoneTable:user:)])
    {
        [self.m_pSetDatetimeDelegate KYLSetDatetimeProtocol_didReceiveGetDateTimeParams:self.m_sDID now:now tz:tz ntpEnable:ntp_enable ntpServer:strNtp_svr indexOfTimeZoneTable:nIndexOfTimezoneTable user:self];
    }
    
    // free memory
    [strNtp_svr release];
    return nRet;
}

- (int) dealTheFTPInfoMsg:(MSG_GET_FTP_INFO_RESP *) pResp
{
    int nRet = 0;
    NSLog(@"%s MSG_GET_FTP_INFO_RESP, svr_ftp=%s, user=%s, pwd=%s, dir=%s, port=%d, mode=%d, upload_interval=%d\n", [self.m_sDID UTF8String],
          pResp->chFTPSvr,pResp->chUser,pResp->chPwd, pResp->chDir,pResp->nPort,pResp->nMode,pResp->reserve);
    NSString *strSvr_ftp = [[NSString alloc] initWithCString:pResp->chFTPSvr encoding:NSUTF8StringEncoding];
    NSString *strUser = [[NSString alloc] initWithCString:pResp->chUser encoding:NSUTF8StringEncoding];
    NSString *strPwd = [[NSString alloc] initWithCString:pResp->chPwd encoding:NSUTF8StringEncoding];
    NSString *strDir = [[NSString alloc] initWithCString:pResp->chDir encoding:NSUTF8StringEncoding];
    int  port = pResp->nPort;
    int  mode = pResp->nMode; //0:port mode 1:passive mode
    int  upload_interval = pResp->reserve;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSucceedGetFtpParam:ftpserver:user:pwd:dir:port:uploadinterval:mode:user:)])
    {
        [self.delegate didSucceedGetFtpParam:self.m_sDID ftpserver:strSvr_ftp user:strUser pwd:strPwd dir:strDir port:port uploadinterval:mode mode:upload_interval user:self];
    }
    
    if (self.m_pSetFtpInfoDelegate && [self.m_pSetFtpInfoDelegate respondsToSelector:@selector(KYLSetFTPInfoProtocol_didSucceedGetFtpParam:ftpserver:user:pwd:dir:port:uploadinterval:mode:user:)])
    {
        [self.m_pSetFtpInfoDelegate KYLSetFTPInfoProtocol_didSucceedGetFtpParam:self.m_sDID ftpserver:strSvr_ftp user:strUser pwd:strPwd dir:strDir port:port uploadinterval:mode mode:upload_interval user:self];
    }
    //free memory
    [strSvr_ftp release];
    [strUser release];
    [strPwd release];
    [strDir release];
    
    return nRet;
}

- (int) dealTheEmailInfoMsg:(MSG_GET_EMAIL_INFO_RESP *) pResp
{
    int nRet = 0;
    NSLog(@"%s MSG_GET_EMAIL_INFO_RESP, svr=%s, user=%s, pwd=%s, sender=%s, receiver1=%s, receiver2=%s, receiver3=%s, receiver4=%s, subject=%s, port=%d, ssl=%d\n", [self.m_sDID UTF8String],
          pResp->chSMTPSvr,pResp->chUser,pResp->chPwd,pResp->chSender,pResp->chReceiver1,pResp->chReceiver2,pResp->chReceiver3,pResp->chReceiver4,pResp->chSubject,pResp->nSMTPPort,pResp->nSSLAuth);
    NSString *strsvr = [[NSString alloc] initWithCString:pResp->chSMTPSvr encoding:NSUTF8StringEncoding];
    NSString *struser = [[NSString alloc] initWithCString:pResp->chUser encoding:NSUTF8StringEncoding];
    NSString *strpwd = [[NSString alloc] initWithCString:pResp->chPwd encoding:NSUTF8StringEncoding];
    NSString *strsender = [[NSString alloc] initWithCString:pResp->chSender encoding:NSUTF8StringEncoding];
    NSString *strreceiver1 = [[NSString alloc] initWithCString:pResp->chReceiver1 encoding:NSUTF8StringEncoding];
    NSString *strreceiver2 = [[NSString alloc] initWithCString:pResp->chReceiver2 encoding:NSUTF8StringEncoding];
    NSString *strreceiver3 = [[NSString alloc] initWithCString:pResp->chReceiver3 encoding:NSUTF8StringEncoding];
    NSString *strreceiver4 = [[NSString alloc] initWithCString:pResp->chReceiver4 encoding:NSUTF8StringEncoding];
    NSString *strsubject = [[NSString alloc] initWithCString:pResp->chSubject encoding:NSUTF8StringEncoding]; //add 2014-04-18
    int  port = pResp->nSMTPPort;
    int  ssl = pResp->nSSLAuth; //0:NONE, 1:SSL, 2:TLS
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSucceedGetMailParam:server:user:pwd:sender:recv1:recv2:recv3:recv4:subject:port:ssl:user:)])
    {
        [self.delegate didSucceedGetMailParam:self.m_sDID server:strsvr user:struser pwd:strpwd sender:strsender recv1:strreceiver1 recv2:strreceiver2 recv3:strreceiver3 recv4:strreceiver4 subject:strsubject port:port ssl:ssl user:self];
    }
    
    if (self.m_pSetEmailDelegate && [self.m_pSetEmailDelegate respondsToSelector:@selector(KYLSetEmailProtocol_didSucceedGetMailParam:server:user:pwd:sender:recv1:recv2:recv3:recv4:subject:port:ssl:user:)])
    {
        [self.m_pSetEmailDelegate KYLSetEmailProtocol_didSucceedGetMailParam:self.m_sDID server:strsvr user:struser pwd:strpwd sender:strsender recv1:strreceiver1 recv2:strreceiver2 recv3:strreceiver3 recv4:strreceiver4 subject:strsubject port:port ssl:ssl user:self];
    }
    // free memory
    [strsvr release];
    [struser release];
    [strpwd release];
    [strsender release];
    [strreceiver1 release];
    [strreceiver2 release];
    [strreceiver3 release];
    [strreceiver4 release];
    [strsubject release];
    
    return nRet;
}

- (int) dealTheAlarmInfoMsg:(MSG_GET_ALARM_INFO_RESP *) pResp
{
    int nRet = 0;
    //    NSLog(@"%s MSG_GET_ALARM_INFO_RESP, bMDEnable=%d,  nMDSensitivity=%d, bInputAlarm=%d, nInputAlarmMode=%d, bIOLinkageWhenAlarm=%d, bIOLinkageWhenAlarm=%d,  reserve1=%d, nPresetbitWhenAlarm=%d, bMailWhenAlarm=%d, bSnapshotToSDWhenAlarm=%d, bRecordToSDWhenAlarm=%d,  bSnapshotToFTPWhenAlarm=%d, bRecordToFTPWhenAlarm=%d, reserve2=%s\n", [self.m_sDID UTF8String] ,pResp->bMDEnable,pResp->nMDSensitivity, pResp->bInputAlarm, pResp->nInputAlarmMode, pResp->bIOLinkageWhenAlarm, pResp->bIOLinkageWhenAlarm, pResp->reserve1, pResp->nPresetbitWhenAlarm, pResp->bMailWhenAlarm, pResp->bSnapshotToSDWhenAlarm, pResp->bRecordToSDWhenAlarm, pResp->bSnapshotToFTPWhenAlarm, pResp->bRecordToFTPWhenAlarm, pResp->reserve2);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSucceedGetAlarmProtocolResult2:result:)]) {
        [self.delegate didSucceedGetAlarmProtocolResult2:self.m_sDID result:pResp];
    }
    
    if (self.m_pSetAlarmInfoDelegate && [self.m_pSetAlarmInfoDelegate respondsToSelector:@selector(KYLSetAlarmInfoProtocol_didSucceedGetAlarmProtocolResult2:result:)]) {
        [self.m_pSetAlarmInfoDelegate KYLSetAlarmInfoProtocol_didSucceedGetAlarmProtocolResult2:self.m_sDID result:pResp];
    }
    
    int bMDEnable = pResp->bMDEnable[0];
    int nMDSensitivity = pResp->nMDSensitivity[0];
    int bInputAlarm = pResp->bInputAlarm;
    int nInputAlarmMode = pResp->nInputAlarmMode;
    int bIOLinkageWhenAlarm = pResp->bIOLinkageWhenAlarm;
    int reserve1 = pResp->reserve1;
    int nPresetbitWhenAlarm = pResp->nPresetbitWhenAlarm;
    int bMailWhenAlarm = pResp->bMailWhenAlarm;
    int bSnapshotToSDWhenAlarm = pResp->bSnapshotToSDWhenAlarm;
    int bRecordToSDWhenAlarm = pResp->bRecordToSDWhenAlarm;
    int bSnapshotToFTPWhenAlarm = pResp->bSnapshotToFTPWhenAlarm;   //juju 2014-04-19
    int bRecordToFTPWhenAlarm = pResp->bRecordToFTPWhenAlarm;     //juju 2014-04-19
    NSString *strreserve2  = [[NSString alloc] initWithCString:pResp->reserve2 encoding:NSUTF8StringEncoding];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSucceedGetAlarmProtocolResult:bMDEnable:nMDSensitivity:bInputAlarm:nInputAlarmMode:bIOLinkageWhenAlarm:reserve1:nPresetbitWhenAlarm:bMailWhenAlarm:bSnapshotToSDWhenAlarm:bRecordToSDWhenAlarm:bSnapshotToFTPWhenAlarm:bRecordToFTPWhenAlarm:strreserve2:user:)])
    {
        [self.delegate didSucceedGetAlarmProtocolResult:self.m_sDID bMDEnable:bMDEnable nMDSensitivity:nMDSensitivity bInputAlarm:bInputAlarm nInputAlarmMode:nInputAlarmMode bIOLinkageWhenAlarm:bIOLinkageWhenAlarm reserve1:reserve1 nPresetbitWhenAlarm:nPresetbitWhenAlarm bMailWhenAlarm:bMailWhenAlarm bSnapshotToSDWhenAlarm:bSnapshotToSDWhenAlarm bRecordToSDWhenAlarm:bRecordToSDWhenAlarm bSnapshotToFTPWhenAlarm:bSnapshotToFTPWhenAlarm bRecordToFTPWhenAlarm:bRecordToFTPWhenAlarm strreserve2:strreserve2 user:self];
    }
    
    if (self.m_pSetAlarmInfoDelegate && [self.m_pSetAlarmInfoDelegate respondsToSelector:@selector(KYLSetAlarmInfoProtocol_didSucceedGetAlarmProtocolResult:bMDEnable:nMDSensitivity:bInputAlarm:nInputAlarmMode:bIOLinkageWhenAlarm:reserve1:nPresetbitWhenAlarm:bMailWhenAlarm:bSnapshotToSDWhenAlarm:bRecordToSDWhenAlarm:bSnapshotToFTPWhenAlarm:bRecordToFTPWhenAlarm:strreserve2:user:)])
    {
        [self.m_pSetAlarmInfoDelegate KYLSetAlarmInfoProtocol_didSucceedGetAlarmProtocolResult:self.m_sDID bMDEnable:bMDEnable nMDSensitivity:nMDSensitivity bInputAlarm:bInputAlarm nInputAlarmMode:nInputAlarmMode bIOLinkageWhenAlarm:bIOLinkageWhenAlarm reserve1:reserve1 nPresetbitWhenAlarm:nPresetbitWhenAlarm bMailWhenAlarm:bMailWhenAlarm bSnapshotToSDWhenAlarm:bSnapshotToSDWhenAlarm bRecordToSDWhenAlarm:bRecordToSDWhenAlarm bSnapshotToFTPWhenAlarm:bSnapshotToFTPWhenAlarm bRecordToFTPWhenAlarm:bRecordToFTPWhenAlarm strreserve2:strreserve2 user:self];
    }
    
    
    [strreserve2 release];
    return nRet;
}

- (int) dealTheSDCardScheduleParamsMsg:(MSG_GET_SDCARD_REC_PARAM_RESP *) pResp
{
    int nRet = 0;
    NSLog(@"%s MSG_GET_SDCARD_REC_PARAM_RESP, bRecordCoverInSDCard=%d,  nRecordTimeLen=%d, reserve1=%d, bRecordTime=%d, reserve2=%s, nSDCardStatus=%d,   nSDTotalSpace=%d,  nSDFreeSpace=%d\n", [self.m_sDID UTF8String], pResp->bRecordCoverInSDCard,pResp->nRecordTimeLen, pResp->reserve1, pResp->bRecordTime, pResp->reserve2, pResp->nSDCardStatus, pResp->nSDTotalSpace, pResp->nSDFreeSpace);
    int bRecordCoverInSDCard = pResp->bRecordCoverInSDCard; 
    int nRecordTimeLen = pResp->nRecordTimeLen;      
    int reserve1 = pResp->reserve1;
    int bRecordTime = pResp->bRecordTime;  
    NSString *strReserve2 = [[NSString alloc] initWithCString:pResp->reserve2 encoding:NSUTF8StringEncoding];
    int nSDCardStatus = pResp->nSDCardStatus;       
    int nSDTotalSpace = pResp->nSDTotalSpace;   
    int nSDFreeSpace = pResp->nSDFreeSpace;     
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSucceedGetSdcardScheduleParams:bRecordCoverInSDCard:nRecordTimeLen:reserve1:bRecordTime:reserve2:nSDCardStatus:nSDTotalSpace:nSDFreeSpace:user:)])
    {
        [self.delegate didSucceedGetSdcardScheduleParams:self.m_sDID bRecordCoverInSDCard:bRecordCoverInSDCard nRecordTimeLen:nRecordTimeLen reserve1:reserve1 bRecordTime:bRecordTime reserve2:strReserve2 nSDCardStatus:nSDCardStatus nSDTotalSpace:nSDTotalSpace nSDFreeSpace:nSDFreeSpace  user:self];
    }
    
    if (self.m_pSetSDCardDelegate && [self.m_pSetSDCardDelegate respondsToSelector:@selector(KYLSetSDCardScheduleProtocol_didSucceedGetSdcardScheduleParams:bRecordCoverInSDCard:nRecordTimeLen:reserve1:bRecordTime:reserve2:nSDCardStatus:nSDTotalSpace:nSDFreeSpace:user:)])
    {
        [self.m_pSetSDCardDelegate KYLSetSDCardScheduleProtocol_didSucceedGetSdcardScheduleParams:self.m_sDID bRecordCoverInSDCard:bRecordCoverInSDCard nRecordTimeLen:nRecordTimeLen reserve1:reserve1 bRecordTime:bRecordTime reserve2:strReserve2 nSDCardStatus:nSDCardStatus nSDTotalSpace:nSDTotalSpace nSDFreeSpace:nSDFreeSpace  user:self];
    }
    
    
    [strReserve2 release];
    return nRet;
}

- (int) dealTheDeviceVersionInfoMsg:(MSG_GET_DEVICE_VERSION_RESP *) pResp
{
    int nRet = 0;
    NSLog(@"%s GET_DEVICE_VERSION_RESP, fwddns_app_ver=%s, fwp2p_app_ver=%s, fwp2p_app_buildtime=%s, chFwddns_app_ver=%s, chVendor=%s, chProduct=%s, product_series =%s, imn_ver_of_device =%d,is_push_function = %d, reserve=%s\n", [self.m_sDID UTF8String],
          pResp->chP2papi_ver, pResp->chFwp2p_app_ver, pResp->chFwp2p_app_buildtime,
          pResp->chFwddns_app_ver, pResp->chVendor, pResp->chProduct, pResp->product_series,pResp->imn_ver_of_device,(int)pResp->is_push_function, pResp->reserve);
    NSString *strp2papi_ver = [[NSString alloc] initWithCString:pResp->chP2papi_ver encoding:NSUTF8StringEncoding];
    NSString *strfwp2p_app_ver = [[NSString alloc] initWithCString:pResp->chFwp2p_app_ver encoding:NSUTF8StringEncoding];
    NSString *strfwp2p_app_buildtime = [[NSString alloc] initWithCString:pResp->chFwp2p_app_buildtime encoding:NSUTF8StringEncoding];
    NSString *strfwddns_app_ver = [[NSString alloc] initWithCString:pResp->chFwddns_app_ver encoding:NSUTF8StringEncoding];
    NSString *strfwhard_ver = [[NSString alloc] initWithCString:pResp->chFwhard_ver encoding:NSUTF8StringEncoding];
    NSString *strvendor = [[NSString alloc] initWithCString:pResp->chVendor encoding:NSUTF8StringEncoding];
    NSString *strproduct = [[NSString alloc] initWithCString:pResp->chProduct encoding:NSUTF8StringEncoding];
    NSString *strProductSeriers = [[NSString alloc] initWithCString:pResp->product_series encoding:NSUTF8StringEncoding];
    NSString *strreserve = [[NSString alloc] initWithCString:pResp->reserve encoding:NSUTF8StringEncoding];
    

    // NSString* did = [NSString stringWithFormat:@"%@/%s/", self.onlineCameras, [self.m_sDID UTF8String]];
    // self.onlineCameras = did;
    
    // NSLog(@"onlineCameras --> yearMonth=%@ ",self.onlineCameras);
    
    int imn_ver_of_device = (int)pResp->imn_ver_of_device;
    int is_push_function = (int) pResp->is_push_function;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSucceedGetCameraHardVerson:p2papi_ver:fwp2p_app_ver:fwp2p_app_buildtime:fwddns_app_ver:fwhard_ver:vendor:product:reserve:user:)])
    {
        [self.delegate didSucceedGetCameraHardVerson:self.m_sDID p2papi_ver:strp2papi_ver fwp2p_app_ver:strfwp2p_app_ver fwp2p_app_buildtime:strfwp2p_app_buildtime fwddns_app_ver:strfwddns_app_ver fwhard_ver:strfwhard_ver vendor:strvendor product:strproduct reserve:strreserve user:self];
    }
    
    if (self.m_pEventDelegate && [self.m_pEventDelegate respondsToSelector:@selector(KYLEventProtocol_didSucceedGetCameraHardVerson:p2papi_ver:fwp2p_app_ver:fwp2p_app_buildtime:fwddns_app_ver:fwhard_ver:vendor:product:reserve:user:)])
    {
        [self.m_pEventDelegate KYLEventProtocol_didSucceedGetCameraHardVerson:self.m_sDID p2papi_ver:strp2papi_ver fwp2p_app_ver:strfwp2p_app_ver fwp2p_app_buildtime:strfwp2p_app_buildtime fwddns_app_ver:strfwddns_app_ver fwhard_ver:strfwhard_ver vendor:strvendor product:strproduct reserve:strreserve user:self];
    }
    
    m_bSucceedGetCameraSoftVersionInfo = YES;
    //äżĺ­čŽžĺ¤çćŹäżĄćŻĺ°çźĺ­ä¸­
    
    self.m_sP2papi_ver = strp2papi_ver;
    self.m_sFwp2p_app_ver = strfwp2p_app_ver;
    self.m_sFwp2p_app_buildtime = strfwp2p_app_buildtime;
    self.m_sFwddns_app_ver = strfwddns_app_ver;
    self.m_sFwhard_ver = strfwhard_ver;
    self.m_sVendor = strvendor;
    self.m_sProduct = strproduct;
    self.m_sProduct_series = strProductSeriers;
    self.m_nIMNVersion = imn_ver_of_device;
    self.m_bIsSupportPushFunction = is_push_function;
    //    self..m_sreserve = strreserve;
    
    //free memory
    [strp2papi_ver release];
    [strfwp2p_app_ver release];
    [strfwp2p_app_buildtime release];
    [strfwddns_app_ver release];
    [strfwhard_ver release];
    [strvendor release];
    [strproduct release];
    [strProductSeriers release];
    [strreserve release];
    //ć´ć°ć°ćŽĺşčŽžĺ¤çćŹäżĄćŻ
    
    return nRet;
}

- (int) dealTheDevicePTZControlInfoMsg:(MSG_PTZ_CONTROL_RESP *) pResp
{
    int nRet = 0;
    return nRet;
}


//{{--- add by kongyulu at 20141216 for remote record player
- (int) dealTheGetSDCardRecordParamResp:(MSG_GET_SDCARD_REC_PARAM_RESP *) pResp
{
    int nRet = 0;
    return nRet;
}

- (int) dealTheGetRemoteRecordDayByMonthResp:(MSG_GET_REMOTE_REC_DAY_BY_MONTH_RESP *) pResp
{
    int nRet = 0;
    if (pResp->chDay[0] == 0 && pResp->chDay[1] == 0) {
        //ć˛Ąćĺ˝ĺĺ¤Šć°ďźç´ćĽčżĺ
        return 0;
    }
    NSString *strAllDays = [NSString stringWithCString:pResp->chDay encoding:NSUTF8StringEncoding];
    
    NSArray *allDaysList = [strAllDays componentsSeparatedByString:@","];
    int nRecordType = pResp->nRecType;
    int nYearMonth = pResp->nYearMon;
    NSLog(@"dealTheGetRemoteRecordDayByMonthResp -->record days:%@ recordType=%d, yearMonth=%d",strAllDays,nRecordType,nYearMonth);
    NSString *strReserve = [NSString stringWithCString:pResp->reserve encoding:NSUTF8StringEncoding];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveTheGetRemoteRecordDaysByMonth:recordType:yearMonth:theRecordedDays:reserve:)])
    {
        [self.delegate didReceiveTheGetRemoteRecordDaysByMonth:self.m_sDID recordType:nRecordType yearMonth:nYearMonth theRecordedDays:allDaysList reserve:strReserve];
    }
    if (self.m_pRemoteRecordDelegate && [self.m_pRemoteRecordDelegate respondsToSelector:@selector(KYLRemoteRecordPlayProtocol_didReceiveTheGetRemoteRecordDaysByMonth:recordType:yearMonth:theRecordedDays:reserve:)])
    {
        [self.m_pRemoteRecordDelegate KYLRemoteRecordPlayProtocol_didReceiveTheGetRemoteRecordDaysByMonth:self.m_sDID recordType:nRecordType yearMonth:nYearMonth theRecordedDays:allDaysList reserve:strReserve];
    }
    return nRet;
}

- (int) dealTheGetRemoteRecordFilesByDayResp:(MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP *) pResp
{
    MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP *pResp1=(MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP *)pResp;
    CHAR chTmp[128], *pChResp=(CHAR *)pResp;
    sprintf(chTmp,"\tMSG_GET_REMOTE_REC_FILE_BY_DAY_RESP,res=%d TNum=%d no=[%d,%d]\n", pResp1->nResult, pResp1->nFileTotalNum, pResp1->nBeginNoOfThisTime, pResp1->nEndNoOfThisTime);
    NSLog(@"%s",chTmp);
    
    int nRet = 0;
    INT32 nResult = pResp->nResult; //0:OK, 1:NO SDCard; 2:fail
    
    
    INT32 nFileTotalNum = pResp->nFileTotalNum;     //total file num >=0
    INT32 nBeginNoOfThisTime = pResp->nBeginNoOfThisTime;   //to return the first file index in this time
    INT32 nEndNoOfThisTime = pResp->nEndNoOfThisTime;       //to return the last file index in this time
    int nTempCurrentItemCount = nEndNoOfThisTime - nBeginNoOfThisTime +1;
    NSLog(@"dealTheGetRemoteRecordFilesByDayResp get all record file info:  nResult:%d nBeginNoOfThisTime:%d, nEndNoOfThisTime=%d, nFileTotalNum=%d",nResult,nBeginNoOfThisTime,nEndNoOfThisTime,nFileTotalNum);
    BOOL m_bIsTheLastOne = false;
    
    if(nEndNoOfThisTime+1 == nFileTotalNum)
    {
        m_bIsTheLastOne = true;
    }
    
    REC_FILE_INFO *pRecFile = (REC_FILE_INFO *)(pChResp + sizeof(MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP));
    NSMutableArray *listAllRecordFilesPerTime = [[NSMutableArray alloc] initWithCapacity:20];
    for (int i = 0; i < nTempCurrentItemCount; i++) {
        NSString *strStartTime = [NSString stringWithCString:pRecFile->chStartTime encoding:NSUTF8StringEncoding];
        NSString *strSEndTime = [NSString stringWithCString:pRecFile->chEndTime encoding:NSUTF8StringEncoding];
        NSString *strSFilePath = [NSString stringWithCString:pRecFile->chFilePath encoding:NSUTF8StringEncoding];
        NSString *strSReserve = [NSString stringWithCString:pRecFile->reserve encoding:NSUTF8StringEncoding];
        int nFileSize = pRecFile->nFileSize_KB;
        int nRecordType = pRecFile->nRecType;
        int nTimeLength = pRecFile->nTimeLen_sec;
        NSLog(@"get one record file info:  startTime:%@, endTime:%@, \nfilePath:%@, fileSize=%d,recordType:%d,timeLength=%d",strStartTime,strSEndTime,strSFilePath,nFileSize,nRecordType,nTimeLength);
        KYLRecordFileInfo *oneRecordInfo = [[KYLRecordFileInfo alloc] init];
        oneRecordInfo.m_nFileSize_KB = nFileSize;
        oneRecordInfo.m_nRecordType = nRecordType;
        oneRecordInfo.m_nTimeLength_Sec = nTimeLength;
        oneRecordInfo.m_sStartTime = strStartTime;
        oneRecordInfo.m_sEndTime = strSEndTime;
        oneRecordInfo.m_sFilePath = strSFilePath;
        oneRecordInfo.m_sReserve = strSReserve;
        [listAllRecordFilesPerTime addObject:oneRecordInfo];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveTheGetOneRemoteRecordFileInOneDay:filePath:startTime:endTime:fileTimeLength:fileSize:recordType:reserve:isTheLastItem:)]) {
            [self.delegate didReceiveTheGetOneRemoteRecordFileInOneDay:self.m_sDID filePath:strSFilePath startTime:strStartTime endTime:strSEndTime fileTimeLength:nTimeLength fileSize:nFileSize recordType:nRecordType reserve:strSReserve isTheLastItem:m_bIsTheLastOne];
        }
        if (self.m_pRemoteRecordDelegate && [self.m_pRemoteRecordDelegate respondsToSelector:@selector(KYLRemoteRecordPlayProtocol_didReceiveTheGetOneRemoteRecordFileInOneDay:filePath:startTime:endTime:fileTimeLength:fileSize:recordType:reserve:isTheLastItem:)]) {
            [self.m_pRemoteRecordDelegate KYLRemoteRecordPlayProtocol_didReceiveTheGetOneRemoteRecordFileInOneDay:self.m_sDID filePath:strSFilePath startTime:strStartTime endTime:strSEndTime fileTimeLength:nTimeLength fileSize:nFileSize recordType:nRecordType reserve:strSReserve isTheLastItem:m_bIsTheLastOne];
        }
        [oneRecordInfo release];
        pRecFile += 1;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveTheGetRemoteRecordFilesInOneDay:result:fileTotalNum:beginNofoThisTime:endNoOfThisTime:theRecordFiles:)])
    {
        [self.delegate didReceiveTheGetRemoteRecordFilesInOneDay:self.m_sDID result:nResult fileTotalNum:nFileTotalNum beginNofoThisTime:nBeginNoOfThisTime endNoOfThisTime:nEndNoOfThisTime theRecordFiles:listAllRecordFilesPerTime];
    }
    if (self.m_pRemoteRecordDelegate && [self.m_pRemoteRecordDelegate respondsToSelector:@selector(KYLRemoteRecordPlayProtocol_didReceiveTheGetRemoteRecordFilesInOneDay:result:fileTotalNum:beginNofoThisTime:endNoOfThisTime:theRecordFiles:)])
    {
        [self.m_pRemoteRecordDelegate KYLRemoteRecordPlayProtocol_didReceiveTheGetRemoteRecordFilesInOneDay:self.m_sDID result:nResult fileTotalNum:nFileTotalNum beginNofoThisTime:nBeginNoOfThisTime endNoOfThisTime:nEndNoOfThisTime theRecordFiles:listAllRecordFilesPerTime];
    }
    
    [listAllRecordFilesPerTime release];
    return nRet;
}


- (int) dealTheStartPlayRemoteRecordFileResp:(MSG_START_PLAY_REC_FILE_RESP *) pResp
{
    int nRet = 0;
    NSString *strFilePath = [NSString stringWithCString:pResp->chFilePath encoding:NSUTF8StringEncoding];
    NSString *strReserve1 = [NSString stringWithCString:pResp->reserve1 encoding:NSUTF8StringEncoding];
    NSString *strReserve2 = [NSString stringWithCString:pResp->reserve2 encoding:NSUTF8StringEncoding];
    int nResult = pResp->nResult;
    int nAudioParam = pResp->nAudioParam;
    int nTimeLen = pResp->nTimeLen_sec;
    int nFileSize = pResp->nFileSize_KB;
    int nPlaybackID = pResp->nPlaybackID;
    int nBeginPos_Sec = pResp->nBeginPos_sec;
    
    NSLog(@"-----*******remote record playback request response: result=%d, nAudioParam=%d, nTimeLen=%d, nFileSize=%d,nPlaybackID=%d,nBeginPos=%d,filepath=%@",nResult,nAudioParam,nTimeLen,nFileSize,nPlaybackID,nBeginPos_Sec,strFilePath);
    KYLCurrentPlayRecordInfo *oneCurrentPlayRecordInfo = [[KYLCurrentPlayRecordInfo alloc] init];
    oneCurrentPlayRecordInfo.m_nAudioParam = nAudioParam;
    oneCurrentPlayRecordInfo.m_nBeginPos_sec = nBeginPos_Sec;
    oneCurrentPlayRecordInfo.m_nPlaybackID = nPlaybackID;
    oneCurrentPlayRecordInfo.m_nResult = nResult;
    oneCurrentPlayRecordInfo.m_nTimeLen_sec = nTimeLen;
    oneCurrentPlayRecordInfo.m_nFileSize_KB = nFileSize;
    oneCurrentPlayRecordInfo.m_sFilePath = strFilePath;
    oneCurrentPlayRecordInfo.m_sReserve1 = strReserve1;
    oneCurrentPlayRecordInfo.m_sReserve2 = strReserve2;
    
    m_nCurrentPlaybackID = nPlaybackID;
    self.m_pCurrentRemoteRecordPlayInfo = oneCurrentPlayRecordInfo;
    [oneCurrentPlayRecordInfo release];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveTheStartPlayRemoteRecordFile:result:filePath:audipParam:beginPos:timeLenSec:fileSize:playbackID:reserve1:reserve2:)])
    {
        [self.delegate didReceiveTheStartPlayRemoteRecordFile:self.m_sDID result:nResult filePath:strFilePath audipParam:nAudioParam beginPos:nBeginPos_Sec timeLenSec:nTimeLen fileSize:nFileSize playbackID:nPlaybackID reserve1:strReserve1 reserve2:strReserve2];
    }
    if (self.m_pRemoteRecordDelegate && [self.m_pRemoteRecordDelegate respondsToSelector:@selector(KYLRemoteRecordPlayProtocol_didReceiveTheStartPlayRemoteRecordFile:result:filePath:audipParam:beginPos:timeLenSec:fileSize:playbackID:reserve1:reserve2:)])
    {
        [self.m_pRemoteRecordDelegate KYLRemoteRecordPlayProtocol_didReceiveTheStartPlayRemoteRecordFile:self.m_sDID result:nResult filePath:strFilePath audipParam:nAudioParam beginPos:nBeginPos_Sec timeLenSec:nTimeLen fileSize:nFileSize playbackID:nPlaybackID reserve1:strReserve1 reserve2:strReserve2];
    }
    
    if (self.m_pRemoteRecordPlaybackImageDelegate && [self.m_pRemoteRecordPlaybackImageDelegate respondsToSelector:@selector(KYLRemoteRecordPlayImageProtocol_didReceiveTheStartPlayRemoteRecordFile:result:filePath:audipParam:beginPos:timeLenSec:fileSize:playbackID:reserve1:reserve2:)]) {
        [self.m_pRemoteRecordPlaybackImageDelegate KYLRemoteRecordPlayImageProtocol_didReceiveTheStartPlayRemoteRecordFile:self.m_sDID result:nResult filePath:strFilePath audipParam:nAudioParam beginPos:nBeginPos_Sec timeLenSec:nTimeLen fileSize:nFileSize playbackID:nPlaybackID reserve1:strReserve1 reserve2:strReserve2];
    }
    
    if (nResult == 0) {//succeed request the remote record video stream.
        
    }
    return nRet;
}

- (int) dealTheStopPlayRemoteRecordFileResp:(MSG_STOP_PLAY_REC_FILE_RESP *) pResp
{
    int nRet = 0;
    int nResult = pResp->nResult;
    NSString *strFilePath = [NSString stringWithCString:pResp->chFilePath encoding:NSUTF8StringEncoding];
    NSString *strReserve1 = [NSString stringWithCString:pResp->reserve encoding:NSUTF8StringEncoding];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveTheStopPlayRemoteRecordFile:result:filePath:reserve1:)])
    {
        [self.delegate didReceiveTheStopPlayRemoteRecordFile:self.m_sDID result:nResult filePath:strFilePath reserve1:strReserve1];
    }
    if (self.m_pRemoteRecordDelegate && [self.m_pRemoteRecordDelegate respondsToSelector:@selector(KYLRemoteRecordPlayProtocol_didReceiveTheStopPlayRemoteRecordFile:result:filePath:reserve1:)])
    {
        [self.m_pRemoteRecordDelegate KYLRemoteRecordPlayProtocol_didReceiveTheStopPlayRemoteRecordFile:self.m_sDID result:nResult filePath:strFilePath reserve1:strReserve1];
    }
    if (self.m_pRemoteRecordPlaybackImageDelegate && [self.m_pRemoteRecordPlaybackImageDelegate respondsToSelector:@selector(KYLRemoteRecordPlayImageProtocol_didReceiveTheStopPlayRemoteRecordFile:result:filePath:reserve1:)]) {
        [self.m_pRemoteRecordPlaybackImageDelegate KYLRemoteRecordPlayImageProtocol_didReceiveTheStopPlayRemoteRecordFile:self.m_sDID result:nResult filePath:strFilePath reserve1:strReserve1];
    }
    return nRet;
}

- (int) dealTheSetIPushInfoResp:(MSG_SET_IPUSH_INFO_RESP *) pResp
{
    int nRet = 0;
    int nResult = pResp->nResult;
    int bEnable = pResp->bEnable;
    NSString *strReserve =[NSString stringWithCString:pResp->reserve encoding:NSUTF8StringEncoding];
    DebugLog(@"čŽžç˝ŽčŽžĺ¤ć¨éĺč˝ Did=%@, ĺźĺŻć¨éĺč­ŚäżĄćŻĺč˝ nResult = %d, bEnable=%d reserve=%@",self.m_sDID,nResult, bEnable,strReserve);
    if (bEnable == 0) {
        self.m_bAllowCameraPushMsg = 0;
    }
    else
    {
        self.m_bAllowCameraPushMsg = 1;
    }
    
    if (self.m_pCameraPushFunctionSetDelegate && [self.m_pCameraPushFunctionSetDelegate respondsToSelector:@selector(didKYLCameraPushFunctionSetProtocolGetPushStatusFinished:result:enable:reserve:user:)]) {
        [self.m_pCameraPushFunctionSetDelegate didKYLCameraPushFunctionSetProtocolGetPushStatusFinished:self.m_sDID result:nResult enable:bEnable reserve:strReserve user:self];
    }
    NSNumber *result = [NSNumber numberWithInt:nResult];
    NSNumber *enable = [NSNumber numberWithInt:bEnable];
    //type = 1 čĄ¨ç¤şćŻčŽžç˝Žć¨éĺč˝, type = 0 čĄ¨ç¤şćŻčˇĺć¨éĺč˝çść
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"type",
                         result,@"result",
                         enable,@"enable",
                         strReserve,@"reserve",
                         nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@KYL_NOTIFICATION_RECEIVE_CAMERA_PUSH_FUNCTION_CHANGE object:self userInfo:dic];
    [dic release];
    
    return nRet;
}

- (int) dealTheGetIPushInfoResp:(MSG_GET_IPUSH_INFO_RESP *) pResp
{
    int nRet = 0;
    int nResult = pResp->nResult;
    int bEnable = pResp->bEnable;
    NSString *strReserve =[NSString stringWithCString:pResp->reserve encoding:NSUTF8StringEncoding];
    DebugLog(@"čˇĺčŽžĺ¤ć¨éĺč˝ Did=%@, ĺźĺŻć¨éĺč­ŚäżĄćŻĺč˝ nResult = %d, bEnable=%d reserve=%@",self.m_sDID,nResult, bEnable,strReserve);
    
    if (bEnable == 0) {
        self.m_bAllowCameraPushMsg = 0;
    }
    else
    {
        self.m_bAllowCameraPushMsg = 1;
    }
    
    if (self.m_pCameraPushFunctionSetDelegate && [self.m_pCameraPushFunctionSetDelegate respondsToSelector:@selector(didKYLCameraPushFunctionSetProtocolSetFinished:result:enable:reserve:user:)]) {
        [self.m_pCameraPushFunctionSetDelegate didKYLCameraPushFunctionSetProtocolSetFinished:self.m_sDID result:nResult enable:self.m_bIsSupportPushFunction reserve:strReserve user:self];
    }
    
    NSNumber *result = [NSNumber numberWithInt:nResult];
    NSNumber *enable = [NSNumber numberWithInt:self.m_bIsSupportPushFunction];
    //type = 1 čĄ¨ç¤şćŻčŽžç˝Žć¨éĺč˝, type = 0 čĄ¨ç¤şćŻčˇĺć¨éĺč˝çść
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"type",
                         result,@"result",
                         enable,@"enable",
                         strReserve,@"reserve",
                         nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@KYL_NOTIFICATION_RECEIVE_CAMERA_PUSH_FUNCTION_CHANGE object:self userInfo:dic];
    [dic release];
    
    return nRet;
}
//}}--- add by kongyulu at 20141216 for remote record player

#pragma mark start search device
- (int ) startSearch
{
    int m_iRet = SEP2P_StartSearch(OnLANSearchCallback, self);
    return m_iRet;
}

- (int) stopSearch
{
    int m_iRet = SEP2P_StopSearch();;
    return m_iRet;
}

static INT32 OnLANSearchCallback(
                                 CHAR*  pData,
                                 UINT32  nDataSize,
                                 VOID*  pUserData)
{
    NSLog(@"OnLANSearchCallback ---");
    KYLCamera *pThis = (KYLCamera *) pUserData;
    [pThis didReceivedLanSearchCallBack:pData dataSize:nDataSize];
    return 0L;
}

- (void) didReceivedLanSearchCallBack:(CHAR *) pData dataSize:(UINT32) nDataSize
{
    SEARCH_RESP *pSearchResp=(SEARCH_RESP *)pData;
    NSString *strIP = [[NSString alloc] initWithCString:pSearchResp->szIpAddr encoding:NSUTF8StringEncoding];
    NSString *strDID = [[NSString alloc] initWithCString:pSearchResp->szDeviceID encoding:NSUTF8StringEncoding];
    NSString *strMac = [[NSString alloc] initWithCString:pSearchResp->szMacAddr encoding:NSUTF8StringEncoding];
    NSString *strDevName = [[NSString alloc] initWithCString:pSearchResp->szDevName encoding:NSUTF8StringEncoding];
    NSString *strProductType = [[NSString alloc] initWithCString:pSearchResp->product_type encoding:NSUTF8StringEncoding];
    int port = pSearchResp->nPort;
    
    if (self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(didSucceedSearchOneDevice:ip:port:devName:macaddress:productType:)])
    {
        [self.searchDelegate didSucceedSearchOneDevice:strIP ip:strDID port:port devName:strDevName macaddress:strMac productType:strProductType];
    }
    
    [strIP release];
    [strDID release];
    [strMac release];
    [strDevName release];
    [strProductType release];
}

#pragma mark set cgi command

/*!
 @method
 @abstract - (int) setTheCameraParams:(NSString *) sDID bitMaskToSet:(int) nBitMaskToSet resolution:(int) nResolution bright:(int) nBright contrast:(int) nContrast irled:(int) nIRLed osd:(int) bOSD mode:(int) nMode flip:(int) nFlip saturation:(int) nSaturation hue:(int) nHue.
 @discussion The function use to set the camera's params information.
 @param sDID the camear's did.
 @param nBitMaskToSet the camear's bit mask to set.
 @param nResolution the camear's image resolution.
 @param nBright the camear's video bright.
 @param nContrast the camear's video contrast.
 @param nIRLed whether the camear's irled is enable.
 @param bOSD whether the camear's osd is enable.
 @param nMode the camear's video mode.
 @param nFlip the camear's video flip.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */
- (int) setTheCameraParams:(NSString *) sDID bitMaskToSet:(int) nBitMaskToSet resolution:(int) nResolution bright:(int) nBright contrast:(int) nContrast irled:(int) nIRLed osd:(int) bOSD mode:(int) nMode flip:(int) nFlip saturation:(int) nSaturation hue:(int) nHue
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    MSG_SET_CAMERA_PARAM_REQ setReq;
    memset(&setReq, 0, sizeof(setReq));
    setReq.nBitMaskToSet=nBitMaskToSet;
    setReq.nResolution=nResolution;
    setReq.nBright  =nBright;
    setReq.nContrast=nContrast;
    setReq.nIRLed=nIRLed;
    setReq.bOSD=bOSD;
    setReq.nMode=nMode;
    setReq.nFlip=nFlip;
    setReq.reserve1 = nHue;
    setReq.nSaturation = nSaturation;
    //setReq.nBitMaskToSet = 0x1FF;
    nRet = SEP2P_SendMsg((CHAR *)[sDID UTF8String], SEP2P_MSG_SET_CAMERA_PARAM_REQ, (CHAR *)&setReq, sizeof(setReq));
    
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheCameraParams() excute succeed");
    }
    else
    {
        NSLog(@"the function: setTheCameraParams() excute failed");
    }
    
    return nRet;
}

/*!
 @method
 @abstract - (int) setTheCameraAllParams:(NSString *) sDID  resolution:(int) nResolution bright:(int) nBright contrast:(int) nContrast irled:(int) nIRLed osd:(int) bOSD mode:(int) nMode flip:(int) nFlip saturation:(int) nSaturation hue:(int) nHue.
 @discussion The function use to set the camera's params information.
 @param sDID the camear's did.
 @param nBitMaskToSet the camear's bit mask to set.
 @param nResolution the camear's image resolution.
 @param nBright the camear's video bright.
 @param nContrast the camear's video contrast.
 @param nIRLed whether the camear's irled is enable.
 @param bOSD whether the camear's osd is enable.
 @param nMode the camear's video mode.
 @param nFlip the camear's video flip.
 @param nSaturation the camear's saturation.
 @param nHue the camear's Hue .
 @result >=0: means that excute successfully, other wise means excute failed . .
 */

- (int) setTheCameraAllParams:(NSString *) sDID  resolution:(int) nResolution bright:(int) nBright contrast:(int) nContrast irled:(int) nIRLed osd:(int) bOSD mode:(int) nMode flip:(int) nFlip saturation:(int) nSaturation hue:(int) nHue
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    MSG_SET_CAMERA_PARAM_REQ setReq;
    memset(&setReq, 0, sizeof(setReq));
    setReq.nResolution=nResolution;
    setReq.nBright  =nBright;
    setReq.nContrast=nContrast;
    setReq.nIRLed=nIRLed;
    setReq.bOSD=bOSD;
    setReq.nMode=nMode;
    setReq.nFlip=nFlip;
    setReq.reserve1 = nHue;
    setReq.nSaturation = nSaturation;
    
    setReq.nBitMaskToSet = 0x1FF;
    nRet = SEP2P_SendMsg((CHAR *)[sDID UTF8String], SEP2P_MSG_SET_CAMERA_PARAM_REQ, (CHAR *)&setReq, sizeof(setReq));
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheCameraAllParams() excute succeed");
    }
    else
    {
        NSLog(@"the function: setTheCameraAllParams() excute failed");
    }
    
    return nRet;
}

//čŽžç˝ŽĺźĺŻďźĺłé­ć¨éĺč˝
- (int) setTheCameraReceivePushFunctionEnable:(BOOL) bEnable
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    
    MSG_GET_IPUSH_INFO_RESP setReq;
    memset(&setReq, 0, sizeof(setReq));
    int nEnable = 0;
    if(bEnable)
    {
        nEnable = 1;
    }
    else
    {
        nEnable = 0;
    }
    
    setReq.bEnable = nEnable;
    
    nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_SET_IPUSH_INFO_REQ, (CHAR *)&setReq, sizeof(setReq));
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        DebugLog(@"SEP2P_MSG_SET_IPUSH_INFO_REQ nEnable=%d",nEnable);
    }
    else
    {
        DebugLog(@"SEP2P_MSG_SET_IPUSH_INFO_REQ nEnable=%d",nEnable);
    }
    return nRet;
}

//čˇĺčŽžĺ¤ć¨éĺč˝çĺźĺŻďźĺłé­çść
- (int) getTheCameraReceivePushFunctionStatus
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    
    nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_GET_IPUSH_INFO_REQ, NULL, 0);
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        DebugLog(@" succeed");
    }
    else
    {
        DebugLog(@" failed");
    }
    
    return nRet;
}

/*!
 @method
 @abstract  setTheCameraResolutionParams:(NSString *) sDID  resolution:(int) nResolution.
 @discussion The function use to set the camera's resolution information.
 @param sDID the camear's did.
 @param nResolution the camear's image resolution.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */

- (int) setTheCameraResolutionParams:(NSString *) sDID  resolution:(int) nResolution
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    MSG_SET_CAMERA_PARAM_REQ setReq;
    memset(&setReq, 0, sizeof(setReq));
    setReq.nResolution = nResolution;
    setReq.nBitMaskToSet = BIT_MASK_CAM_PARAM_RESOLUTION;
    nRet = SEP2P_SendMsg((CHAR *)[sDID UTF8String], SEP2P_MSG_SET_CAMERA_PARAM_REQ, (CHAR *)&setReq, sizeof(setReq));
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheCameraResolutionParams() excute succeed");
    }
    else
    {
        NSLog(@"the function: setTheCameraResolutionParams() excute failed");
    }
    
    return nRet;
}

/*!
 @method
 @abstract setTheCameraBrightParams:(NSString *) sDID   bright:(int) nBright.
 @discussion The function use to set the camera's bright information.
 @param sDID the camear's did.
 @param nBright the camear's video bright.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */

- (int) setTheCameraBrightParams:(NSString *) sDID   bright:(int) nBright
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    MSG_SET_CAMERA_PARAM_REQ setReq;
    memset(&setReq, 0, sizeof(setReq));
    setReq.nBright  =nBright;
    setReq.nBitMaskToSet = BIT_MASK_CAM_PARAM_BRIGHT;
    nRet = SEP2P_SendMsg((CHAR *)[sDID UTF8String], SEP2P_MSG_SET_CAMERA_PARAM_REQ, (CHAR *)&setReq, sizeof(setReq));
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheCameraBrightParams() excute succeed");
    }
    else
    {
        NSLog(@"the function: setTheCameraBrightParams() excute failed");
    }
    
    return nRet;
}


/*!
 @method
 @abstract setTheCameraResolutionParams:(NSString *) sDID  contrast:(int) nContrast.
 @discussion The function use to set the camera's contrast param information.
 @param sDID the camear's did.
 @param nContrast the camear's video contrast.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */

- (int) setTheCameraContrastParams:(NSString *) sDID  contrast:(int) nContrast
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    MSG_SET_CAMERA_PARAM_REQ setReq;
    memset(&setReq, 0, sizeof(setReq));
    setReq.nContrast=nContrast;
    setReq.nBitMaskToSet = BIT_MASK_CAM_PARAM_CONTRAST;
    nRet = SEP2P_SendMsg((CHAR *)[sDID UTF8String], SEP2P_MSG_SET_CAMERA_PARAM_REQ, (CHAR *)&setReq, sizeof(setReq));
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheCameraContrastParams() excute succeed");
    }
    else
    {
        NSLog(@"the function: setTheCameraContrastParams() excute failed");
    }
    
    return nRet;
}


/*!
 @method
 @abstract setTheCameraResolutionParams:(NSString *) sDID  irled:(int) nIRLed.
 @discussion The function use to set the camera's  irled param information.
 @param sDID the camear's did.
 @param nIRLed whether the camear's irled is enable.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */

- (int) setTheCameraIRLedParams:(NSString *) sDID  irled:(int) nIRLed
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    MSG_SET_CAMERA_PARAM_REQ setReq;
    memset(&setReq, 0, sizeof(setReq));
    
    setReq.nIRLed=nIRLed;
    setReq.nBitMaskToSet = BIT_MASK_CAM_PARAM_IRLED;
    nRet = SEP2P_SendMsg((CHAR *)[sDID UTF8String], SEP2P_MSG_SET_CAMERA_PARAM_REQ, (CHAR *)&setReq, sizeof(setReq));
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheCameraIRLedParams() excute succeed");
    }
    else
    {
        NSLog(@"the function: setTheCameraIRLedParams() excute failed");
    }
    
    return nRet;
}


/*!
 @method
 @abstract  setTheCameraOSDParams:(NSString *) sDID   osd:(int) bOSD.
 @discussion The function use to set the camera's bOSD params information.
 @param sDID the camear's did.
 @param bOSD whether the camear's osd is enable.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */

- (int) setTheCameraOSDParams:(NSString *) sDID   osd:(int) bOSD
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    MSG_SET_CAMERA_PARAM_REQ setReq;
    memset(&setReq, 0, sizeof(setReq));
    setReq.bOSD=bOSD;
    setReq.nBitMaskToSet = BIT_MASK_CAM_PARAM_OSD;
    nRet = SEP2P_SendMsg((CHAR *)[sDID UTF8String], SEP2P_MSG_SET_CAMERA_PARAM_REQ, (CHAR *)&setReq, sizeof(setReq));
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheCameraOSDParams() excute succeed");
    }
    else
    {
        NSLog(@"the function: setTheCameraOSDParams() excute failed");
    }
    
    return nRet;
}

/*!
 @method
 @abstract setTheCameraModeParams:(NSString *) sDID   mode:(int) nMode.
 @discussion The function use to set the camera's mode param information.
 @param sDID the camear's did.
 @param nMode the camear's video mode.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */

- (int) setTheCameraModeParams:(NSString *) sDID   mode:(int) nMode
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    MSG_SET_CAMERA_PARAM_REQ setReq;
    memset(&setReq, 0, sizeof(setReq));
    setReq.nMode=nMode;
    setReq.nBitMaskToSet = BIT_MASK_CAM_PARAM_MODE;
    nRet = SEP2P_SendMsg((CHAR *)[sDID UTF8String], SEP2P_MSG_SET_CAMERA_PARAM_REQ, (CHAR *)&setReq, sizeof(setReq));
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheCameraModeParams() excute succeed");
    }
    else
    {
        NSLog(@"the function: setTheCameraModeParams() excute failed");
    }
    
    return nRet;
}


/*!
 @method
 @abstract setTheCameraFlipParams:(NSString *) sDID  flip:(int) nFlip.
 @discussion The function use to set the camera's flip param information.
 @param sDID the camear's did.
 @param nFlip the camear's video flip.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */
- (int) setTheCameraFlipParams:(NSString *) sDID  flip:(int) nFlip
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    MSG_SET_CAMERA_PARAM_REQ setReq;
    memset(&setReq, 0, sizeof(setReq));
    setReq.nFlip=nFlip;
    setReq.nBitMaskToSet = BIT_MASK_CAM_PARAM_FLIP;
    nRet = SEP2P_SendMsg((CHAR *)[sDID UTF8String], SEP2P_MSG_SET_CAMERA_PARAM_REQ, (CHAR *)&setReq, sizeof(setReq));
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheCameraFlipParams() excute succeed");
    }
    else
    {
        NSLog(@"the function: setTheCameraFlipParams() excute failed");
    }
    
    return nRet;
}

/*!
 @method
 @abstract setTheCameraHueParams:(NSString *) sDID  hue:(int) nHue.
 @discussion The function use to set the camera's hue param information.
 @param sDID the camear's did.
 @param nHue the camear's video Hue.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */
- (int) setTheCameraHueParams:(NSString *) sDID  hue:(int) nHue
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    MSG_SET_CAMERA_PARAM_REQ setReq;
    memset(&setReq, 0, sizeof(setReq));
    setReq.reserve1=nHue;
    setReq.nBitMaskToSet = BIT_MASK_CAM_PARAM_HUE;
    nRet = SEP2P_SendMsg((CHAR *)[sDID UTF8String], SEP2P_MSG_SET_CAMERA_PARAM_REQ, (CHAR *)&setReq, sizeof(setReq));
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheCameraHueParams() excute succeed");
    }
    else
    {
        NSLog(@"the function: setTheCameraHueParams() excute failed");
    }
    
    return nRet;
}

/*!
 @method
 @abstract setTheCameraSaturationParams:(NSString *) sDID  saturation:(int) nSaturation.
 @discussion The function use to set the camera's saturation param information.
 @param sDID the camear's did.
 @param nSaturation the camear's saturation flip.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */

- (int) setTheCameraSaturationParams:(NSString *) sDID  saturation:(int) nSaturation
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    MSG_SET_CAMERA_PARAM_REQ setReq;
    memset(&setReq, 0, sizeof(setReq));
    setReq.nSaturation=nSaturation;
    setReq.nBitMaskToSet = BIT_MASK_CAM_PARAM_SATURATION;
    nRet = SEP2P_SendMsg((CHAR *)[sDID UTF8String], SEP2P_MSG_SET_CAMERA_PARAM_REQ, (CHAR *)&setReq, sizeof(setReq));
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheCameraSaturationParams() excute succeed");
    }
    else
    {
        NSLog(@"the function: setTheCameraSaturationParams() excute failed");
    }
    return nRet;
}

/*!
 @method
 @abstract setTheDefaultCameraParams:(NSString *) sDID.
 @discussion The function use to set the camera's default params information.
 @param sDID the camear's did.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */
- (int) setTheDefaultCameraParams:(NSString *) sDID
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    nRet = SEP2P_SendMsg([sDID UTF8String], SEP2P_MSG_SET_CAMERA_PARAM_DEFAULT_REQ, NULL, 0);
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheDefaultCameraParams() excute succeed");
    }
    else
    {
        NSLog(@"the function: setTheDefaultCameraParams() excute failed");
    }
    
    return nRet;
}


/*!
 @method
 @abstract  setTheCameraWifi:(NSString *) sDID ssid:(NSString *) sSSID password:(NSString *) sPwd isEnable:(int) bEnable.
 @discussion The function use to set the camera's current wifi network information.
 @param sDID the camear's did.
 @param sSSID the camear's wifi ssid name.
 @param sPwd the camear's wifi password.
 @param bEnable whether the camear's wifi is enable.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */

- (int) setTheCameraWifi:(NSString *) sDID ssid:(NSString *) sSSID password:(NSString *) sPwd isEnable:(int) bEnable channel:(int) nChannel mode:(int) nMode authType:(int) nAuthtype wepEncrypt:(int)nWEPEncrypt wepKeyFormat:(int)nWEPKeyFormat wepDefaultKey:(int) nWEPDefaultKey wepKey1:(NSString *) sWePKey1 wepKey2:(NSString *) sWepKey2 wepKey3:(NSString *) sWepKey3 wepKey4:(NSString *) sWepKey4 wepKey1Bit:(int) nWEPKey1_bits wepKey2Bit:(int) nWEPKey2_bits wepKey3Bit:(int) nWEPKey3_bits wepKey4Bit:(int) nWEPKey4_bits reqTestResult:(int)bReqTestWifiResult
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    MSG_SET_CURRENT_WIFI_REQ setReq;
    memset(&setReq, 0, sizeof(setReq));
    setReq.bEnable=bEnable;
    setReq.nChannel=nChannel;
    setReq.bReqTestWifiResult=bReqTestWifiResult;
    setReq.nMode=nMode;
    setReq.nAuthtype=nAuthtype;
    setReq.nWEPEncrypt=nWEPEncrypt;
    setReq.nWEPKeyFormat=nWEPKeyFormat;
    setReq.nWEPDefaultKey=nWEPDefaultKey;
    setReq.nWEPKey1_bits=nWEPKey1_bits;
    setReq.nWEPKey2_bits=nWEPKey2_bits;
    setReq.nWEPKey3_bits=nWEPKey3_bits;
    setReq.nWEPKey4_bits=nWEPKey4_bits;
    if (sSSID) {
        strcpy(setReq.chSSID,[sSSID UTF8String]);
    }
    setReq.nAuthtype = nAuthtype;
    if (sPwd) {
        strcpy(setReq.chWPAPsk,[sPwd UTF8String]);
    }
    if (sWePKey1) {
        strcpy(setReq.chWEPKey1,[sWePKey1 UTF8String]);
    }
    if (sWepKey2) {
        strcpy(setReq.chWEPKey2,[sWepKey2 UTF8String]);
    }
    if (sWepKey3) {
        strcpy(setReq.chWEPKey3,[sWepKey3 UTF8String]);
    }
    if (sWepKey4) {
        strcpy(setReq.chWEPKey4,[sWepKey4 UTF8String]);
    }
    NSLog(@"the function: setTheCameraWifi() data : bEnable = %d, reserve=%d, nMode=%d, nAuthtype=%d, nWEPEncrypt=%d,nWEPKeyFormat=%d,nWEPDefaultKey=%d,chWEPKey1=%s,chWEPKey2=%s,chWEPKey3=%s,chWEPKey4=%s,nWEPKey1_bits=%d,nWEPKey2_bits==%d,nWEPKey3_bits=%d,nWEPKey4_bits=%d,chWPAPsk=%s   \n",setReq.bEnable,setReq.nChannel,setReq.nMode,setReq.nAuthtype,setReq.nWEPEncrypt,setReq.nWEPKeyFormat,setReq.nWEPDefaultKey,setReq.chWEPKey1,setReq.chWEPKey2,setReq.chWEPKey3,setReq.chWEPKey4, setReq.nWEPKey1_bits,setReq.nWEPKey2_bits,setReq.nWEPKey3_bits, setReq.nWEPKey4_bits ,setReq.chWPAPsk);
    
    nRet = SEP2P_SendMsg((CHAR *)[sDID UTF8String], SEP2P_MSG_SET_CURRENT_WIFI_REQ, (CHAR *)&setReq, sizeof(setReq));
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheCameraWifi() excute succeed");
    }
    else
    {
        NSLog(@"the function: setTheCameraWifi() excute failed");
    }
    
    return nRet;
}


/*!
 @method
 @abstract  setTheUserInfo:(NSString *) sDID admin:(NSString *) sAdmin adminPassword:(NSString *) adminPwd vistor:(NSString *) sVistor vistorPassword:(NSString *) visitorPwd.
 @discussion The function use to set the camera's user and password information.
 @param sDID the camear's did.
 @param sAdmin the camear's administator name.
 @param adminPwd the camear's administator password.
 @param sVistor the camear's vistor name.
 @param visitorPwd the camear's vistor password.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */

- (int) setTheUserInfo:(NSString *) sDID admin:(NSString *) sAdmin adminPassword:(NSString *) adminPwd vistor:(NSString *) sVistor vistorPassword:(NSString *) visitorPwd
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    
    NSLog(@"ĺźĺ§äżŽćšç¨ćˇĺĺŻç äżĄćŻďźadmin=%@, adminPwd=%@, vistor=%@, vistorPwd=%@ --the did=%@",sAdmin,adminPwd,sVistor,visitorPwd,sDID);
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    MSG_SET_USER_INFO_REQ setReq;
    memset(&setReq, 0, sizeof(setReq));
    if (sAdmin) {
        strcpy(setReq.chAdmin,[sAdmin UTF8String]);
    }
    if (adminPwd) {
        strcpy(setReq.chAdminPwd,[adminPwd UTF8String]);
    }
    if (sVistor) {
        strcpy(setReq.chVisitor,[sVistor UTF8String]);
    }
    if (visitorPwd) {
        strcpy(setReq.chVisitorPwd,[visitorPwd UTF8String]);
    }
    nRet = SEP2P_SendMsg((CHAR *)[sDID UTF8String], SEP2P_MSG_SET_USER_INFO_REQ, (CHAR *)&setReq, sizeof(setReq));
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheUserInfo() excute succeed, the ret=%d",nRet);
    }
    else
    {
        NSLog(@"the function: setTheUserInfo() excute failed ,the ret=%d",nRet);
    }
    
    return nRet;
}

/*!
 @method
 @abstract  setTheDatetimeInfo:(NSString *) sDID secToNow:(int) nSecToNow secTimeZone:(int) nSecTimeZone enableFTP:(int) nEnableFTP ntpServer:(NSString *) sNTPServer.
 @discussion The function use to set the camera's datetime information.
 @param sDID the camear's did.
 @param nSecToNow the camear's current time.
 @param nSecTimeZone the camear's current timezone.
 @param nEnableFTP whether the camear's ftp server is enable.
 @param sNTPServer the camear's ftp server ip address.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */

- (int) setTheDatetimeInfo:(NSString *) sDID secToNow:(int) nSecToNow secTimeZone:(int) nSecTimeZone enableFTP:(int) nEnableFTP ntpServer:(NSString *) sNTPServer indexOfTimeZoneTable:(int) nIndex
{
    //    INT32 nSecToNow;      //[date timeIntervalSince1970], To MSG_SET_DATETIME_REQ: it used to calibrate the device time if its value is NOT zero.
    //    INT32 nSecTimeZone;       //time interval from GMT in second, e.g.:28800 seconds is GMT+08; -28800 seconds is GMT-08
    //    INT32 bEnableNTP;     //0->disable; 1->enable
    //    CHAR  chNTPServer[64];
    //    INT32 nIndexTimeZoneTable;//-1: invalid //added on 2014-11-17, for x series
    
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    NSLog(@"setTheDatetimeInfo: secToNow=%d ,secTimeZone=%d, enableFTP=%d, ntpServer=%@",nSecToNow,nSecTimeZone,nEnableFTP,sNTPServer);
    MSG_SET_DATETIME_REQ setReq;
    memset(&setReq, 0, sizeof(setReq));
    setReq.nSecToNow=nSecToNow;
    setReq.nSecTimeZone=nSecTimeZone;
    setReq.bEnableNTP = nEnableFTP;
    setReq.nIndexTimeZoneTable = nIndex;
    if (sNTPServer) {
        strcpy(setReq.chNTPServer,[sNTPServer UTF8String]);
    }
    int dataSize = sizeof(MSG_SET_DATETIME_REQ);
    nRet = SEP2P_SendMsg((CHAR *)[sDID UTF8String], SEP2P_MSG_SET_DATETIME_REQ, (CHAR *)&setReq, dataSize);
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheDatetimeInfo() excute succeed");
    }
    else
    {
        NSLog(@"the function: setTheDatetimeInfo() excute failed");
    }
    return nRet;
}

/*!
 @method
 @abstract  setTheFTPInfo:(NSString *) sDID ftpServer:(NSString *) sFtpServer username:(NSString *) user password:(NSString *) pwd ftpPath:(NSString  *) sPath port:(int) nPort mode:(int) nMode.
 @discussion The function use to set the camera's ftp information.
 @param sDID the camear's did.
 @param sFtpServer the camear's ftp server.
 @param user the camear's ftp user name.
 @param pwd the camear's ftp user password.
 @param sPath the camear's ftp upload path.
 @param nPort the camear's ftp server port.
 @param nMode  the camear's ftp mode.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */
- (int) setTheFTPInfo:(NSString *) sDID ftpServer:(NSString *) sFtpServer username:(NSString *) user password:(NSString *) pwd ftpPath:(NSString  *) sPath port:(int) nPort mode:(int) nMode uploadTime:(int) nUptime
{
    NSLog(@"ĺźĺ§čŽžç˝ŽFtp, ftpServer=%@, name=%@, password=%@, ftpPath=%@, port=%d, mode=%d, uploadTime=%d, the did=%@",sFtpServer,user,pwd,sPath,nPort,nMode,nUptime,sDID);
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    MSG_SET_FTP_INFO_REQ setReq;
    memset(&setReq, 0, sizeof(setReq));
    if (sFtpServer) {
        strcpy(setReq.chFTPSvr,[sFtpServer UTF8String]);
    }
    if (user) {
        strcpy(setReq.chUser,[user UTF8String]);
    }
    if (pwd) {
        strcpy(setReq.chPwd,[pwd UTF8String]);
    }
    if (sPath) {
        strcpy(setReq.chDir,[sPath UTF8String]);
    }
    
    setReq.nPort=nPort;
    setReq.nMode = nMode;
    setReq.reserve = nUptime;
    
    nRet = SEP2P_SendMsg((CHAR *)[sDID UTF8String], SEP2P_MSG_SET_FTP_INFO_REQ, (CHAR *)&setReq, sizeof(setReq));
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheFTPInfo() excute succeed");
    }
    else
    {
        NSLog(@"the function: setTheFTPInfo() excute failed");
    }
    
    return nRet;
}

- (int) setTheAlarmInfo2:(MSG_SET_ALARM_INFO_REQ *) pReq
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if(pReq == NULL) return nRet;
    
    pReq->nAlarmTime_sun_0=-1;
    pReq->nAlarmTime_sun_1=-1;
    pReq->nAlarmTime_sun_2=-1;
    pReq->nAlarmTime_mon_0=-1;
    pReq->nAlarmTime_mon_1=-1;
    pReq->nAlarmTime_mon_2=-1;
    pReq->nAlarmTime_tue_0=-1;
    pReq->nAlarmTime_tue_1=-1;
    pReq->nAlarmTime_tue_2=-1;
    pReq->nAlarmTime_wed_0=-1;
    pReq->nAlarmTime_wed_1=-1;
    pReq->nAlarmTime_wed_2=-1;
    pReq->nAlarmTime_thu_0=-1;
    pReq->nAlarmTime_thu_1=-1;
    pReq->nAlarmTime_thu_2=-1;
    pReq->nAlarmTime_fri_0=-1;
    pReq->nAlarmTime_fri_1=-1;
    pReq->nAlarmTime_fri_2=-1;
    pReq->nAlarmTime_sat_0=-1;
    pReq->nAlarmTime_sat_1=-1;
    pReq->nAlarmTime_sat_2=-1;
    
    nRet = SEP2P_SendMsg((CHAR *)[self.m_sDID UTF8String], SEP2P_MSG_SET_ALARM_INFO_REQ, (CHAR *)&pReq, sizeof(pReq));
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheAlarmInfo2() excute succeedďźRet=%d, did=%@",nRet,_m_sDID);
    }else NSLog(@"the function: setTheAlarmInfo2() excute failedďźRet=%d, did=%@",nRet,_m_sDID);
    
    return nRet;
}

/*!
 @method
 @abstract  setTheMailInfo:(NSString *) sDID smtpServer:(NSString *) smtpServer user:(NSString *) user password:(NSString *) pwd sender:(NSString *) sender receiver1:(NSString *) receiver1 receiver2:(NSString *) receiver2 receiver3:(NSString *) receiver3 receiver4:(NSString *) receiver4 subject:(NSString *) subject smtpPort:(int) port sslAuth:(int) nSSLAuth.
 @discussion The function use to set the camera's email information.
 @param sDID the camear's did.
 @param smtpServer the camear's smtp server.
 @param user the camear's username.
 @param pwd the camear's password.
 @param sender the camear's email sender.
 @param receiver1 the camear's email receiver.
 @param receiver2 the camear's email receiver.
 @param receiver3 the camear's email receiver.
 @param receiver4 the camear's email receiver.
 @param subject the camear's email subject.
 @param port the camear's smtp server port.
 @param nSSLAuth the camear's ssl auth.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */
- (int) setTheMailInfo:(NSString *) sDID smtpServer:(NSString *) smtpServer user:(NSString *) user password:(NSString *) pwd sender:(NSString *) sender receiver1:(NSString *) receiver1 receiver2:(NSString *) receiver2 receiver3:(NSString *) receiver3 receiver4:(NSString *) receiver4 subject:(NSString *) subject smtpPort:(int) port sslAuth:(int) nSSLAuth
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    
    NSLog(@"setTheMailInfo : smtpServer=%@, user=%@, password=%@, sender=%@, receiver1=%@, receiver2=%@, receiver3=%@, receiver4=%@, subject=%@, smtpPort=%d, sslAuth=%d",smtpServer,user,pwd,sender,receiver1,receiver2,receiver3,receiver4,subject,port,nSSLAuth);
    
    MSG_SET_EMAIL_INFO_REQ setReq;
    memset(&setReq, 0, sizeof(setReq));
    
    if (smtpServer && ![smtpServer isEqualToString:@""]) {
        strcpy(setReq.chSMTPSvr,[smtpServer UTF8String]);
    }
    
    if (sender) {
        strcpy(setReq.chSender,[sender UTF8String]);
    }
    
    if (user) {
        strcpy(setReq.chUser,[user UTF8String]);
    }
    
    if (pwd) {
        strcpy(setReq.chPwd,[pwd UTF8String]);
    }
    
    if (nil != receiver1) {
        strcpy(setReq.chReceiver1,[receiver1 UTF8String]);
        NSLog(@"receiver1=%s\n",setReq.chReceiver1);
    }
    
    if (nil != receiver2) {
        strcpy(setReq.chReceiver2,[receiver2 UTF8String]);
        NSLog(@"receiver2=%s\n",setReq.chReceiver2);
    }
    
    if (nil != receiver3) {
        strcpy(setReq.chReceiver3,[receiver3 UTF8String]);
        NSLog(@"receiver3=%s\n",setReq.chReceiver3);
    }
    
    if (nil != receiver4) {
        strcpy(setReq.chReceiver4,[receiver4 UTF8String]);
        NSLog(@"receiver4=%s\n",setReq.chReceiver4);
    }
    
    if (nil != subject) {
        strcpy(setReq.chSubject,[subject UTF8String]);
    }
    
    setReq.nSMTPPort = port;
    setReq.nSSLAuth = nSSLAuth;
    
    
    nRet = SEP2P_SendMsg((CHAR *)[sDID UTF8String], SEP2P_MSG_SET_EMAIL_INFO_REQ, (CHAR *)&setReq, sizeof(setReq));
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheMailInfo() excute succeed");
    }
    else
    {
        NSLog(@"the function: setTheMailInfo() excute failed");
    }
    
    return nRet;
}


/*!
 @method
 @abstract  - (int) setTheSDCardRecordParam:(NSString *) sDID RecordCoverInSDCard:(int) bRecordCoverInSDCard recordTimeLen:(int) nRecordTime isAllowTimeRecord:(int) bTimeRecord.
 @discussion The function use to set the camera's sdcard record schedule information.
 @param sDID the camear's did.
 @param bRecordCoverInSDCard whether the camear's sdcard record can be recovered.
 @param nRecordTime the camear's record time.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */

- (int) setTheSDCardRecordParam:(NSString *) sDID RecordCoverInSDCard:(int) bRecordCoverInSDCard recordTimeLen:(int) nRecordTime isAllowTimeRecord:(int) bTimeRecord
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    MSG_SET_SDCARD_REC_PARAM_REQ setReq;
    memset(&setReq, 0, sizeof(setReq));
    setReq.bRecordCoverInSDCard=bRecordCoverInSDCard;
    setReq.nRecordTimeLen=nRecordTime;
    setReq.bRecordTime = bTimeRecord;
    //setReq.nSDCardStatus = nSDCardStatus;
    
    nRet = SEP2P_SendMsg((CHAR *)[sDID UTF8String], SEP2P_MSG_SET_SDCARD_REC_PARAM_REQ, (CHAR *)&setReq, sizeof(setReq));
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: setTheSDCardRecordParam() excute succeed");
    }
    else
    {
        NSLog(@"the function: setTheSDCardRecordParam() excute failed");
    }
    
    return nRet;
}


/*!
 @method
 @abstract  formatSDCard:(NSString *) sDID.
 @param sDID the camear's did.
 @discussion The function use to format the camera's sdcard.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */

- (int) formatSDCard:(NSString *) sDID
{
    if ([self getCameraStatus] != CONNECT_STATUS_CONNECTED )
    {
        return K_Error_Camera_Connected_Failed;
    }
    int nRet = -1;
    if (sDID == nil || [sDID length] < 1) {
        return nRet;
    }
    nRet = SEP2P_SendMsg((CHAR *)[sDID UTF8String], SEP2P_MSG_FORMAT_SDCARD_REQ, NULL, 0);
    if (nRet == ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"the function: formatSDCard() excute succeed");
    }
    else
    {
        NSLog(@"the function: formatSDCard() excute failed");
    }
    
    return nRet;
}

#pragma mark - deal the set cgi command call back
// the control ptz response
- (void) dealTheCallbackPTZControlResponse:(MSG_PTZ_CONTROL_RESP *) pResp
{
    NSLog(@"%@--->>SEP2P_MSG_PTZ_CONTROL_RESP result = %d, reserver=%s", self.m_sDID, pResp->result, pResp->reserve);
}

// the snap picture response
- (void) dealTheCallbackSnapPictureResponse:(CHAR *) pRespData size:(UINT32) nDataSize
{
    {
        //äżĺ­ĺžçĺ°çŁç
        if (nDataSize < 20) {
            return;
        }
        @synchronized(self)
        {
            //ć­¤ĺ¤äťŁç ĺ¨ĺä¸ćśĺťĺŞč˝ćä¸ä¸Şçşżç¨ć§čĄ.
            //ćžç¤şĺžç
            NSData *image = [[NSData alloc] initWithBytes:pRespData length:nDataSize];
            if (image == nil) {
                [image release];
                return;
            }
            UIImage *img = [[UIImage alloc] initWithData:image];
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            UIImage *imgScale = [self imageWithImage:img scaledToSize:CGSizeMake(160, 120)];
            if (imgScale)
            {
                self.m_imgForDeviceHead = imgScale;
                [self saveSnapshot:imgScale DID:self.m_sDID];
            }
            
            [pool release];
            [img release];
            [image release];
        }
        
        NSLog(@"%@--->>čˇĺä¸ĺź čŽžĺ¤ĺ°é˘ĺžç", self.m_sDID);
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSucceedSnapshotNotify:data:length:user:)])
        {
            [self.delegate didSucceedSnapshotNotify:self.m_sDID data:pRespData length:nDataSize user:self];
        }
        if (self.m_pSnapPictureDelegate && [self.m_pSnapPictureDelegate respondsToSelector:@selector(KYLSnapPictureProtocol_didSucceedSnapshotNotify:data:length:user:)])
        {
            [self.m_pSnapPictureDelegate KYLSnapPictureProtocol_didSucceedSnapshotNotify:self.m_sDID data:pRespData length:nDataSize user:self];
        }
        
        NSDictionary *dic = [[NSDictionary alloc ] initWithObjectsAndKeys:self.m_sDID,@"uid", nil];
        //ĺééçĽďźéçĽčŽžĺ¤ĺčĄ¨ĺˇć°
        [[NSNotificationCenter defaultCenter] postNotificationName:@KYL_NOTIFICATION_SUCCEED_GET_ONE_SNAP_IMAGE object:self userInfo:dic];
        [dic release];
    }
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    NSData *dataImg = UIImageJPEGRepresentation(newImage, 0.0001);
    UIImage *imgOK = [UIImage imageWithData:dataImg];
    
    // Return the new image.
    return imgOK;
}

- (void) saveSnapshot: (UIImage*) image DID: (NSString*) strDID
{
    NSLog(@"%@--->>äżĺ­čŽžĺ¤ĺ°é˘ĺžçĺ°çŁç", self.m_sDID);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //ĺĺťşćäťśçŽĄçĺ¨
    // NSFileManager *fileManager = [NSFileManager defaultManager];
    //čˇĺčˇŻĺž
    //ĺć°NSDocumentDirectoryčŚčˇĺéŁç§čˇŻĺž
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];//ĺťĺ¤éčŚçčˇŻĺž
    //    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:strDID];
    //    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    //{{-- kongyulu at 20150427
    //čŽžç˝Žä¸ĺ¤äť˝ĺ°iCloudçć čŻă
    NSString *strPath  = [KYLComFunUtil getDefaultFolderInDocumentForDid:strDID];
    //}}-- kongyulu at 20150427
    strPath = [strPath stringByAppendingPathComponent:@KYL_CAMERA_COVER_IMAGE];
    NSData *dataImage = UIImageJPEGRepresentation(image, 1.0);
    [dataImage writeToFile:strPath atomically:YES ];
    [pool release];
}

// the set camera's params response
- (void) dealTheCallbackSetCameraParamsResponse:(MSG_SET_CAMERA_PARAM_RESP *) pResp
{
    {
        NSLog(@"%@--->>SEP2P_MSG_SET_CAMERA_PARAM_RESP result = %d, reserver=%s, nBitMaskToSet=%d", self.m_sDID, pResp->result, pResp->reserve,pResp->nBitMaskToSet);
        int result = pResp->result;
        NSString *strReserver =  [[NSString alloc] initWithCString:pResp->reserve encoding:NSUTF8StringEncoding];
        int nbitToSet = pResp->nBitMaskToSet;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSetCameraParamsFinish:result:reserver:bitMaskToSet:user:)])
        {
            [self.delegate didSetCameraParamsFinish:self.m_sDID result:result reserver:strReserver bitMaskToSet:nbitToSet user:self];
        }
        if (self.m_pSetCameraParamDelegate && [self.m_pSetCameraParamDelegate respondsToSelector:@selector(KYLSetCameraParamsProtocol_didSetCameraParamsFinish:result:reserver:bitMaskToSet:user:)])
        {
            [self.m_pSetCameraParamDelegate KYLSetCameraParamsProtocol_didSetCameraParamsFinish:self.m_sDID result:result reserver:strReserver bitMaskToSet:nbitToSet user:self];
        }
        [strReserver release];
    }
    
}

// the set camera's default params response
- (void) dealTheCallbackSetCameraDefaultParamsResponse:(MSG_SET_CAMERA_PARAM_DEFAULT_RESP *) pResp
{
    {
        NSLog(@"%@--->>SEP2P_MSG_SET_CAMERA_PARAM_DEFAULT_RESP result = %d, reserver=%s", self.m_sDID, pResp->result, pResp->reserve);
        int result = pResp->result;
        NSString *strReserver =  [[NSString alloc] initWithCString:pResp->reserve encoding:NSUTF8StringEncoding];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSetDefaultCameraParamsFinish:result:reserver:user:)])
        {
            [self.delegate didSetDefaultCameraParamsFinish:self.m_sDID result:result reserver:strReserver user:self];
        }
        
        if (self.m_pSetCameraParamDelegate && [self.m_pSetCameraParamDelegate respondsToSelector:@selector(KYLSetCameraParamsProtocol_didSetDefaultCameraParamsFinish:result:reserver:user:)])
        {
            [self.m_pSetCameraParamDelegate KYLSetCameraParamsProtocol_didSetDefaultCameraParamsFinish:self.m_sDID result:result reserver:strReserver user:self];
        }
        
        [strReserver release];
    }
    
}

// the set camera's current wifi response
- (void) dealTheCallbackSetWifiResponse:(MSG_SET_CURRENT_WIFI_RESP *) pResp
{
    {
        NSLog(@"%@--->>SEP2P_MSG_SET_CURRENT_WIFI_RESP result = %d, reserver=%s", self.m_sDID, pResp->result, pResp->reserve);
        int result = pResp->result;
        NSString *strReserver =  [[NSString alloc] initWithCString:pResp->reserve encoding:NSUTF8StringEncoding];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSetWifiFinish:result:reserver:user:)])
        {
            [self.delegate didSetWifiFinish:self.m_sDID result:result reserver:strReserver user:self];
        }
        if (self.m_pSetWifiDelegate && [self.m_pSetWifiDelegate respondsToSelector:@selector(KYLSetWifiProtocol_didSetWifiFinish:result:reserver:user:)])
        {
            [self.m_pSetWifiDelegate KYLSetWifiProtocol_didSetWifiFinish:self.m_sDID result:result reserver:strReserver user:self];
        }
        [strReserver release];
    }
    
}

// the set  userinfo response
- (void) dealTheCallbackSetUserInfoResponse:(MSG_SET_USER_INFO_RESP *) pResp
{
    {
        NSLog(@"%@--->>SEP2P_MSG_SET_USER_INFO_RESP result = %d, reserver=%s", self.m_sDID, pResp->result, pResp->reserve);
        int result = pResp->result;
        NSString *strReserver =  [[NSString alloc] initWithCString:pResp->reserve encoding:NSUTF8StringEncoding];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSetUserInfoFinish:result:reserver:user:)])
        {
            [self.delegate didSetUserInfoFinish:self.m_sDID result:result reserver:strReserver user:self];
        }
        if (self.m_pSetUserInfoDelegate && [self.m_pSetUserInfoDelegate respondsToSelector:@selector(KYLSetUserInfoProtocol_didSetUserInfoFinish:result:reserver:user:)])
        {
            [self.m_pSetUserInfoDelegate KYLSetUserInfoProtocol_didSetUserInfoFinish:self.m_sDID result:result reserver:strReserver user:self];
        }
        [strReserver release];
    }
    
}

// the set datetime response
- (void) dealTheCallbackSetDatetimeInfoResponse:(MSG_SET_DATETIME_RESP *) pResp
{
    {
        NSLog(@"%@--->>SEP2P_MSG_SET_DATETIME_RESP result = %d, reserver=%s", self.m_sDID, pResp->result, pResp->reserve);
        int result = pResp->result;
        NSString *strReserver =  [[NSString alloc] initWithCString:pResp->reserve encoding:NSUTF8StringEncoding];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSetDatetimeInfoFinish:result:reserver:user:)])
        {
            [self.delegate didSetDatetimeInfoFinish:self.m_sDID result:result reserver:strReserver user:self];
        }
        
        if (self.m_pSetDatetimeDelegate && [self.m_pSetDatetimeDelegate respondsToSelector:@selector(KYLSetDatetimeProtocol_didSetDatetimeInfoFinish:result:reserver:user:)])
        {
            [self.m_pSetDatetimeDelegate KYLSetDatetimeProtocol_didSetDatetimeInfoFinish:self.m_sDID result:result reserver:strReserver user:self];
        }
        [strReserver release];
    }
    
}

// the set  ftp info response
- (void) dealTheCallbackFTPInfoResponse:(MSG_SET_FTP_INFO_RESP *) pResp
{
    {
        NSLog(@"%@--->>SEP2P_MSG_SET_FTP_INFO_RESP result = %d, reserver=%s", self.m_sDID, pResp->result, pResp->reserve);
        int result = pResp->result;
        NSString *strReserver =  [[NSString alloc] initWithCString:pResp->reserve encoding:NSUTF8StringEncoding];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSetCameraFTPInfoFinish:result:reserver:user:)])
        {
            [self.delegate didSetCameraFTPInfoFinish:self.m_sDID result:result reserver:strReserver user:self];
        }
        
        if (self.m_pSetFtpInfoDelegate && [self.m_pSetFtpInfoDelegate respondsToSelector:@selector(KYLSetFTPInfoProtocol_didSetCameraFTPInfoFinish:result:reserver:user:)])
        {
            [self.m_pSetFtpInfoDelegate KYLSetFTPInfoProtocol_didSetCameraFTPInfoFinish:self.m_sDID result:result reserver:strReserver user:self];
        }
        
        [strReserver release];
    }
    
}
// the set email info response
- (void) dealTheCallbackSetEmailInfoResponse:(MSG_SET_EMAIL_INFO_RESP *) pResp
{
    {
        NSLog(@"%@--->>SEP2P_MSG_SET_EMAIL_INFO_RESP result = %d, reserver=%s", self.m_sDID, pResp->result, pResp->reserve);
        int result = pResp->result;
        NSString *strReserver =  [[NSString alloc] initWithCString:pResp->reserve encoding:NSUTF8StringEncoding];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSetCameraEmailInfoFinish:result:reserver:user:)])
        {
            [self.delegate didSetCameraEmailInfoFinish:self.m_sDID result:result reserver:strReserver user:self];
        }
        if (self.m_pSetEmailDelegate && [self.m_pSetEmailDelegate respondsToSelector:@selector(KYLSetEmailProtocol_didSetCameraEmailInfoFinish:result:reserver:user:)])
        {
            [self.m_pSetEmailDelegate KYLSetEmailProtocol_didSetCameraEmailInfoFinish:self.m_sDID result:result reserver:strReserver user:self];
        }
        [strReserver release];
    }
    
}

// the set  alarm info response
- (void) dealTheCallbackSetAlarmInfoResponse:(MSG_SET_ALARM_INFO_RESP *) pResp
{
    {
        NSLog(@"%@--->>SEP2P_MSG_SET_ALARM_INFO_RESP result = %d, reserver=%s", self.m_sDID, pResp->result, pResp->reserve);
        int result = pResp->result;
        NSString *strReserver =  [[NSString alloc] initWithCString:pResp->reserve encoding:NSUTF8StringEncoding];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSetCameraAlarmInfoFinish:result:reserver:user:)])
        {
            [self.delegate didSetCameraAlarmInfoFinish:self.m_sDID result:result reserver:strReserver user:self];
        }
        if (self.m_pSetAlarmInfoDelegate && [self.m_pSetAlarmInfoDelegate respondsToSelector:@selector(KYLSetAlarmInfoProtocol_didSetCameraAlarmInfoFinish:result:reserver:user:)])
        {
            [self.m_pSetAlarmInfoDelegate KYLSetAlarmInfoProtocol_didSetCameraAlarmInfoFinish:self.m_sDID result:result reserver:strReserver user:self];
        }
        
        [strReserver release];
    }
    
}

// the set sdcard schedule params response
- (void) dealTheCallbackSetSDCardSheduleParamsResponse:(MSG_SET_SDCARD_REC_PARAM_RESP *) pResp
{
    {
        NSLog(@"%@--->>SEP2P_MSG_SET_SDCARD_REC_PARAM_RESP result = %d, reserver=%s", self.m_sDID, pResp->result, pResp->reserve);
        int result = pResp->result;
        NSString *strReserver =  [[NSString alloc] initWithCString:pResp->reserve encoding:NSUTF8StringEncoding];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSetCameraSDCardRecordScheduleParamsFinish:result:reserver:user:)])
        {
            [self.delegate didSetCameraSDCardRecordScheduleParamsFinish:self.m_sDID result:result reserver:strReserver user:self];
        }
        
        if (self.m_pSetSDCardDelegate && [self.m_pSetSDCardDelegate respondsToSelector:@selector(KYLSetSDCardScheduleProtocol_didSetCameraSDCardRecordScheduleParamsFinish:result:reserver:user:)])
        {
            [self.m_pSetSDCardDelegate KYLSetSDCardScheduleProtocol_didSetCameraSDCardRecordScheduleParamsFinish:self.m_sDID result:result reserver:strReserver user:self];
        }
        [strReserver release];
    }
}

////////////////////////////////////{{{{{
- (int) SendAudioRecordThread
{
    int m_result = 0;
    int nRet = 0;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int nAudioBufSize = KYL_MIN_PCM_AUDIO_SIZE;
    UINT32 nAudioEncodeSize = KYL_MIN_PCM_AUDIO_SIZE;
    char *AudioBuf= NULL;//çźç ĺççźĺ˛ĺş
    UCHAR *AudioForEncodeBuf=NULL;//çźç ĺççźĺ˛ĺş
    UCHAR *m_pHandleEncode=NULL;
    
    if(self.nAudioCodecID==AV_CODECID_AUDIO_G726)
    {
        if(m_pAudioHandleG726!=NULL) m_pHandleEncode=m_pAudioHandleG726;
        m_iTalkEncodeType = AV_CODECID_AUDIO_G726;
        
    }
    else if(self.nAudioCodecID==AV_CODECID_AUDIO_ADPCM)
    {
        if(m_pAudioHandleAdpcm!=NULL) m_pHandleEncode=m_pAudioHandleAdpcm;
        m_iTalkEncodeType = AV_CODECID_AUDIO_ADPCM;
    }
    else if(self.nAudioCodecID==AV_CODECID_AUDIO_G711A)
    {
        if(m_pAudioHandleG711!=NULL) m_pHandleEncode=m_pAudioHandleG711;
        m_iTalkEncodeType = AV_CODECID_AUDIO_G711A;
    }
    else if(self.nAudioCodecID==AV_CODECID_AUDIO_AAC)
    {
        if(m_pAudioHandleAAC!=NULL) m_pHandleEncode=m_pAudioHandleAAC;
        m_iTalkEncodeType = AV_CODECID_AUDIO_AAC;
        nAudioEncodeSize = KYL_MIN_PCM_AUDIO_SIZE_gAAC;
    }
    
    AudioBuf=(char *)malloc(nAudioBufSize);//çźç ĺççźĺ˛ĺş
    AudioForEncodeBuf=(UCHAR *)malloc(nAudioEncodeSize);//çźç ĺççźĺ˛ĺş
    memset(AudioBuf, 0, nAudioBufSize);
    memset(AudioForEncodeBuf, 0, nAudioEncodeSize);
    
    while(m_bTalkThreadRuning)
    {
        NSAutoreleasePool *pool1 = [[NSAutoreleasePool alloc] init];
        //
        if(m_bTalkResp!=KYL_Talk_REQUEST_STATUS_SUCCEED)
        {
            DebugLog(@"ĺŻščŽ˛ĺéçşżç¨éĺş....m_bTalkResp!=KYL_Talk_REQUEST_STATUS_SUCCEED");
            [pool1 drain];
            break;
        }
        
        //DebugLog(@"ĺŻščŽ˛ĺéçşżç¨ć­Łĺ¨čżčĄ....m_bTalkResp=%d",m_bTalkResp);
        if (m_iTalkEncodeType == AV_CODECID_AUDIO_G726) { //g726
            //pcm --> G726
            if(m_pTalkAudioBuf->GetStock() < KYL_MIN_PCM_AUDIO_SIZE_g726 || !m_bTalkThreadRuning)
            {
                usleep(10000);
                [pool1 drain];
                continue;
            }
            memset(AudioBuf, 0, nAudioBufSize);
            int nRead = m_pTalkAudioBuf->Read((char*)AudioBuf, KYL_MIN_PCM_AUDIO_SIZE_g726);
            
            DebugLog(@"čŻťĺĺ°ĺ˝éłć°ćŽ nRead=%d",nRead);
            if(nRead != KYL_MIN_PCM_AUDIO_SIZE_g726 || !m_bTalkThreadRuning)
            {
                usleep(10000);
                [pool1 drain];
                continue;
            }
            
            if(m_pHandleEncode)
            {
                
                if (CONNECT_STATUS_CONNECTED == [self getCameraStatus])
                {
                    nRet = SEAudio_Encode(m_pHandleEncode, (UCHAR *)AudioBuf, KYL_MIN_PCM_AUDIO_SIZE_g726, AudioForEncodeBuf, &nAudioEncodeSize);
                    UINT64 curtime = [self getCurrentTime];
                    if(nRet > 0 && nAudioEncodeSize > 0)
                    {
                        nRet=SEP2P_SendTalkData([self.m_sDID UTF8String], (CHAR *)AudioForEncodeBuf, nAudioEncodeSize, curtime);
                        DebugLog(@"ĺéĺŻščŽ˛ć°ćŽ G726 nRet=%d datasize=%d, time=%d",nRet ,nAudioEncodeSize, (int)curtime);
                        if(nRet >= 0)
                        {
                            //succeed send
                        }
                    }
                }
            }
        }else if (m_iTalkEncodeType == AV_CODECID_AUDIO_ADPCM)
        { //adpcm
            //pcm --> adpcm
            if(m_pTalkAudioBuf->GetStock() < KYL_MIN_PCM_AUDIO_SIZE || !m_bTalkThreadRuning)
            {
                usleep(10000);
                [pool1 drain];
                continue;
            }
            
            memset(AudioBuf, 0, sizeof(nAudioBufSize));
            int nRead = m_pTalkAudioBuf->Read((char*)AudioBuf, KYL_MIN_PCM_AUDIO_SIZE);
            if(nRead != KYL_MIN_PCM_AUDIO_SIZE || !m_bTalkThreadRuning)
            {
                usleep(10000);
                [pool1 drain];
                continue;
            }
            
            if(m_pHandleEncode){
                if (CONNECT_STATUS_CONNECTED == [self getCameraStatus])
                {
                    UINT64 curtime = [self getCurrentTime];
                    nRet = SEAudio_Encode(m_pHandleEncode, (UCHAR *)AudioBuf, KYL_MIN_PCM_AUDIO_SIZE, AudioForEncodeBuf, &nAudioEncodeSize);
                    if(nRet > 0 && nAudioEncodeSize > 0)
                    {
                        nRet=SEP2P_SendTalkData([self.m_sDID UTF8String], (CHAR *)AudioForEncodeBuf, nAudioEncodeSize, curtime);
                        DebugLog(@"ĺéĺŻščŽ˛ć°ćŽ ADPCM nRet=%d datasize=%d, time=%d",nRet ,nAudioEncodeSize, (int)curtime);
                        if(nRet >= 0)
                        {
                            //succeed send
                        }
                    }
                }
            }
        }
        else if (m_iTalkEncodeType == AV_CODECID_AUDIO_G711A) { //g711
            //pcm --> G711
            if(m_pTalkAudioBuf->GetStock() < KYL_MIN_PCM_AUDIO_SIZE_g711 || !m_bTalkThreadRuning)
            {
                usleep(10000);
                [pool1 drain];
                continue;
            }
            memset(AudioBuf, 0, nAudioBufSize);
            int nRead = m_pTalkAudioBuf->Read((char*)AudioBuf, KYL_MIN_PCM_AUDIO_SIZE_g711);
            DebugLog(@"čŻťĺĺ°ĺ˝éłć°ćŽ nRead=%d",nRead);
            if(nRead != KYL_MIN_PCM_AUDIO_SIZE_g711 || !m_bTalkThreadRuning)
            {
                usleep(10000);
                [pool1 drain];
                continue;
            }
            
            if(m_pHandleEncode)
            {
                
                if (CONNECT_STATUS_CONNECTED == [self getCameraStatus])
                {
                    nRet = SEAudio_Encode(m_pHandleEncode, (UCHAR *)AudioBuf, KYL_MIN_PCM_AUDIO_SIZE_g711, AudioForEncodeBuf, &nAudioEncodeSize);
                    UINT64 curtime = [self getCurrentTime];
                    if(nRet > 0 && nAudioEncodeSize > 0)
                    {
                        nRet=SEP2P_SendTalkData([self.m_sDID UTF8String], (CHAR *)AudioForEncodeBuf, nAudioEncodeSize, curtime);
                        DebugLog(@"ĺéĺŻščŽ˛ć°ćŽ G711 nRet=%d datasize=%d, time=%d",nRet ,nAudioEncodeSize, (int)curtime);
                        if(nRet >= 0)
                        {
                            //succeed send
                        }
                    }
                    
                }
            }
        }
        else if (m_iTalkEncodeType == AV_CODECID_AUDIO_AAC) { //{{--kongyulu at 20141118 aac
            //pcm --> G711
            DebugLog(@"čŻťĺAACć°ćŽ GetStock=%d, KYL_MIN_PCM_AUDIO_SIZE_gAAC=%d",m_pTalkAudioBuf->GetStock(),KYL_MIN_PCM_AUDIO_SIZE_gAAC);
            if(m_pTalkAudioBuf->GetStock() < KYL_MIN_PCM_AUDIO_SIZE_gAAC || !m_bTalkThreadRuning)
            {
                usleep(10000);
                [pool1 drain];
                continue;
            }
            memset(AudioBuf, 0, nAudioBufSize);
            int nRead = m_pTalkAudioBuf->Read((char*)AudioBuf, KYL_MIN_PCM_AUDIO_SIZE_gAAC);
            if(nRead != KYL_MIN_PCM_AUDIO_SIZE_gAAC || !m_bTalkThreadRuning)
            {
                usleep(10000);
                [pool1 drain];
                continue;
            }
            
            if(m_pHandleEncode)
            {
                
                if (CONNECT_STATUS_CONNECTED == [self getCameraStatus])
                {
                    nAudioEncodeSize = KYL_MIN_PCM_AUDIO_SIZE_gAAC;
                    nRet = SEAudio_Encode(m_pHandleEncode, (UCHAR *)AudioBuf, KYL_MIN_PCM_AUDIO_SIZE_gAAC, AudioForEncodeBuf, &nAudioEncodeSize);
                    UINT64 curtime = [self getCurrentTime];
                    if(nRet > 0 && nAudioEncodeSize > 0)
                    {
                        nRet=SEP2P_SendTalkData([self.m_sDID UTF8String], (CHAR *)AudioForEncodeBuf, nAudioEncodeSize, curtime);
                        
                        //succeed send
                        DebugLog(@"ĺéĺŻščŽ˛ć°ćŽ AAC nRet=%d datasize=%d, time=%d",nRet ,nAudioEncodeSize, (int)curtime);
                        if(nRet >= 0)
                        {
                            
                        }
                    }
                    
                }
            }
        }
        [pool1 drain];
    }
    [pool drain];
    
    //delete [] AudioBuf;
    if (AudioBuf) {
        free(AudioBuf);
        AudioBuf = NULL;
    }
    if(AudioForEncodeBuf)
    {
        free(AudioForEncodeBuf);
        AudioForEncodeBuf = NULL;
    }
    
    return m_result;
}

- (int) PlayVideoThread
{
    if(m_pVideoBuf && !m_pVideoBuf->IsBufCreateSucceed())
    {
        m_bVideoPlayThreadRuning=0;
        return -2;
    }
    
    int nRet = 0;
    CHAR bFirstIFrameWhenRecording=0, bFirstIFrame=0;
    unsigned int untimestamp=0, untimestampPrev=0;
    
    m_bVideoPlayThreadRuning = 1;
    char *outYUV420=(char *)malloc(KYL_MAX_SIZE_YUV);
    char *outRGB24=(char *)malloc(KYL_MAX_SIZE_RGB24);
    //char *pY=NULL, *pU=NULL, *pV=NULL;
    
    UCHAR *m_pVideoHandleH264 = NULL;
    nRet = SEVideo_Create(VIDEO_CODE_TYPE_H264, &m_pVideoHandleH264);
    NSLog(@"PlayVideoThread %d", m_bVideoPlayThreadRuning);
    NSLog(@"self.m_pImageDelegate : %@",self.m_pImageDelegate);

    while(m_bVideoPlayThreadRuning)
    {
        char *pbuf = NULL;
        int videoLen = 0;
        {
            STREAM_HEAD videohead;
            memset(&videohead, 0, sizeof(videohead));
            pbuf = [self GetAndRemoveOneFrameFromVideBufWithLenth:videoLen outStreamHead:videohead];
            if(NULL == pbuf)
            {
                usleep(10000);
                continue;
            }
            unsigned int untimestamp = videohead.nTimestamp;
            UINT32 nTempCodecID = videohead.nCodecID; // refer to SEP2P_ENUM_AV_CODECID
            int   nTempParameter = (int)videohead.nParameter;// Video: refer to SEP2P_ENUM_VIDEO_FRAME.   Audio:(samplerate << 2) | (databits << 1) |
            UINT32 nTempStreamDataLen = videohead.nStreamDataLen; // Stream data size after following struct 'STREAM_HEAD'
            //NSInteger nTempCurtime = (NSInteger)[self getCurrentTime];
            
            //{{---ĺźĺ§ĺ˝ĺ
            if(m_bLocalRecording)
            {
                //NSLog(@"write an record video frame");
                if(AV_CODECID_VIDEO_H264 == nTempCodecID){
                    if(!bFirstIFrameWhenRecording) {
                        if(nTempParameter == VIDEO_FRAME_FLAG_I) bFirstIFrameWhenRecording=1;//ĺ¤ć­çŹŹä¸ĺ¸§ćŻĺŚćŻďźŠĺ¸§
                    }
                }else bFirstIFrameWhenRecording=1;
                
                if(bFirstIFrameWhenRecording){
                    INT32 bTempIsIFrame = (nTempParameter == VIDEO_FRAME_FLAG_I) ? 1 :0;
                    NSInteger nTempCurtime = (NSInteger)[self getCurrentTime];
                    NSInteger nTempBufSize = nTempStreamDataLen;
                    
                    if(untimestamp!=0 && untimestamp<untimestampPrev) untimestamp=untimestampPrev+1;
                    untimestampPrev=untimestamp;
                    [self addOneVideoFrameIntoLocalRecordFile:pbuf dataSize:nTempBufSize deviceTimeTamp:untimestamp
                                                localTimeTamp:nTempCurtime isIFrame:bTempIsIFrame];
                }
            }
            //}}--ĺ˝ĺ
            
            if(AV_CODECID_VIDEO_H264 == nTempCodecID)
            {
                if(!bFirstIFrame) {
                    if(nTempParameter == VIDEO_FRAME_FLAG_I) bFirstIFrame=1;//ĺ¤ć­çŹŹä¸ĺ¸§ćŻĺŚćŻďźŠĺ¸§
                }
                if(!bFirstIFrame) continue;
                
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                int  nRet=0, nWidth=0, nHeigh=0;
                ULONG in_outLen=KYL_MAX_SIZE_YUV;
                
                nRet=SEVideo_Decode2YUV(m_pVideoHandleH264, (UCHAR *)pbuf, videoLen, (UCHAR *)outYUV420, &in_outLen, &nWidth,&nHeigh);
                // NSLog(@"ĺŽćśč§é˘č§Łç yuv] pDID=%@, SEVideo_Decode2YUV=%d in_outLen=%lu\n", self.m_sDID, nRet, in_outLen);
                if(nRet>0)
                {
                    if(m_bIsPrepareForSnapPicture == 1)//ĺŞćĺźĺŻäşććĺźĺłĺďźćčżčĄč§Łç Rgb24ć°ćŽ
                    {
                        //NSLog(@"----->snappicture open---->");
                        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                        
                        ULONG outLen=nWidth*nHeigh*3;
                        int nRGB24=SEVideo_YUV420toRGB24((UCHAR *)outYUV420, in_outLen, (UCHAR *)outRGB24, &outLen, nWidth, nHeigh);
                        if (nRGB24 > 0)
                        {
                            //NSLog(@"the function: SEVideo_YUV420toRGB24() excute succeed! error code=%d",nRGB24);
                            if (_delegate && [_delegate respondsToSelector:@selector(didReceiveOneVideoFrameRGB24Notify:length:width:height:timestamp:DID:user:)])
                            {
                                [_delegate didReceiveOneVideoFrameRGB24Notify:(char*)outRGB24 length:outLen width:nWidth height:nHeigh timestamp:untimestamp DID:self.m_sDID user:self];
                            }
                            if (_m_pImageDelegate && [_m_pImageDelegate respondsToSelector:@selector(KYLImageProtocol_didReceiveOneVideoFrameRGB24Notify:length:width:height:timestamp:DID:user:)])
                            {
                                [_m_pImageDelegate KYLImageProtocol_didReceiveOneVideoFrameRGB24Notify:(char*)outRGB24 length:outLen width:nWidth height:nHeigh timestamp:untimestamp DID:self.m_sDID user:self];
                            }
                        }
                        [pool drain];
                    }
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveOneH264VideoFrameWithH264Data:length:type:timestamp:DID:user:)])
                    {
                        [self.delegate didReceiveOneH264VideoFrameWithH264Data:pbuf length:videoLen type:nTempParameter timestamp:untimestamp DID:self.m_sDID user:self];
                    }
                    if (self.m_pImageDelegate && [self.m_pImageDelegate respondsToSelector:@selector(KYLImageProtocol_didReceiveOneH264VideoFrameWithH264Data:length:type:timestamp:DID:user:)])
                    {
                        [self.m_pImageDelegate KYLImageProtocol_didReceiveOneH264VideoFrameWithH264Data:pbuf length:videoLen type:nTempParameter timestamp:untimestamp DID:self.m_sDID user:self];
                    }
                }
                [pool drain];
                pool = nil;
                
            }else if(AV_CODECID_VIDEO_MJPEG == videohead.nCodecID)
            {
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                NSData *image= [[NSData alloc] initWithBytes:pbuf length:videoLen];
                UIImage *img = [[UIImage alloc] initWithData:image];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveMJPEGImageNotify:timestamp:DID:user:)])
                {
                    [self.delegate didReceiveMJPEGImageNotify:img timestamp:untimestamp DID:self.m_sDID user:self];
                }
                
                if (self.m_pImageDelegate && [self.m_pImageDelegate respondsToSelector:@selector(KYLImageProtocol_didReceiveMJPEGImageNotify:timestamp:DID:user:)])
                {
                    [self.m_pImageDelegate KYLImageProtocol_didReceiveMJPEGImageNotify:img timestamp:untimestamp DID:self.m_sDID user:self];
                }
                
                [img release];
                img = nil;
                [image release];
                image = nil;
                [pool drain];
                pool = nil;
            }
        }
        delete [] pbuf;
        pbuf = NULL;
        //usleep(10000);
    }
    
    if(outRGB24)
    {
        free(outRGB24);
        outRGB24=NULL;
    }
    
    if(outYUV420)
    {
        free(outYUV420);
        outYUV420=NULL;
    }
    if(m_pVideoHandleH264) {
        SEVideo_Destroy(&m_pVideoHandleH264);
        m_pVideoHandleH264=NULL;
    }
    m_bVideoPlayThreadRuning = 0;
    return nRet;
}

- (int) startPlayAudioThread
{
    if (m_bAudioPlayThreadRuning) {//ĺ˝ĺçşżç¨ć­Łĺ¨čżčĄďźç´ćĽéĺş
        NSLog(@"startPlayAudioThread()ĺ˝ĺçşżç¨ć­Łĺ¨čżčĄ");
        return -2;
    }
    __block int m_result = 0;
#ifdef __BLOCKS__
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    // No need to retain (just a local variable)
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{//ĺŻĺ¨çşżç¨
        // Do a taks in the background
        
        int ret = [self PlayAudioThread];
        m_result = ret;
        if (ret >= 0)
        {
            NSLog(@"the function: startPlayAudioThread2() excute finished, the startaudio thread over");
        }
        dispatch_async(dispatch_get_main_queue(), ^{ //ĺĺ°ä¸ťçşżç¨
            
            
        });
    });
    [pool drain];
    pool = nil;
#endif
    m_result = 1;
    
    return m_result;
}

- (int) PlayAudioThread
{
    if (nil == m_pAudioPlayer) {
        m_bAudioPlayThreadRuning = 0;
        return -1;
    }
    
    if(m_pAudioBuf && !m_pAudioBuf->IsBufCreateSucceed())
    {
        m_bAudioPlayThreadRuning = 0;
        return -2;
    }
    
    m_bAudioPlayThreadRuning = 1;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    while(m_bAudioPlayThreadRuning)
    {
        {
            char *pbuf = NULL;
            int videoLen = 0;
            {
                STREAM_HEAD videohead;
                memset(&videohead, 0, sizeof(videohead));
                pbuf = [self GetAndRemoveOneFrameFromAudioBufWithLenth:videoLen outStreamHead:videohead];
                if(NULL == pbuf)
                {
                    usleep(10000);
                    continue;
                }
                //unsigned int untimestamp = videohead.nTimestamp;
                
                UINT32 Length = videohead.nStreamDataLen;
                UINT32 nOutLen = 20*Length;
                UCHAR *pHandle = NULL;
                UCHAR *inBuf = (UCHAR *)pbuf;
                UINT32 inLen = (UINT32)Length;
                //int   nParameter = (int)videohead.nParameter;  // Video: refer to SEP2P_ENUM_VIDEO_FRAME.   Audio:(samplerate << 2) | (databits << 1) |
                //unsigned int nTimestamp = videohead.nTimestamp;
                //NSInteger nTempCurtime = (NSInteger)[self getCurrentTime];
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                //[self addOneAudioFrameIntoLocalRecordFile:(char*)inBuf dataSize:Length deviceTimeTamp:nTimestamp];
                
                if(AV_CODECID_AUDIO_ADPCM == videohead.nCodecID)//adpcm audio
                {
                    if (m_pAudioPlayer)
                    {
                        nOutLen = 4*Length;
                        unsigned char *pOutBuf = new unsigned char[nOutLen];
                        pHandle = m_pAudioHandleAdpcm;
                        if(pHandle && pOutBuf)
                        {
                            
                            int nRet = SEAudio_Decode(pHandle, inBuf,  inLen,  (UCHAR*)pOutBuf, &nOutLen);
                            //NSLog(@"AV_CODECID_AUDIO_AAC SEAudio_Decode()22 ret=%d inlen=%d,outlen=%d",nRet,inLen,nOutLen);
                            if(nRet > 0 && nOutLen > 0)
                            {
                                NSData *data = [[NSData alloc] initWithBytes:pOutBuf length:nOutLen];
                                if (m_bIsSendingTalkDataToDevice == 0 ) {//ć˛ĄćĺéĺŻščŽ˛ć°ćŽďźĺć­ćžĺŁ°éł
                                    [m_pAudioPlayer openAudioFromQueue:data];
                                }
                                
                                [data release];
                                //[self addOneAudioFrameIntoLocalRecordFile:(char*)pOutBuf dataSize:nOutLen deviceTimeTamp:nTimestamp];
                            }
                        }
                        delete [] pOutBuf;
                        pOutBuf = NULL;
                    }
                    
                }
                else if(AV_CODECID_AUDIO_G726 == videohead.nCodecID)//g726 audio
                {
                    if (m_pAudioPlayer)
                    {
                        nOutLen = 8*Length;
                        unsigned char *pOutBuf = new unsigned char[nOutLen];
                        pHandle = m_pAudioHandleG726;
                        if(pHandle && pOutBuf)
                        {
                            
                            int nRet = SEAudio_Decode(pHandle, inBuf,  inLen,  (UCHAR*)pOutBuf, &nOutLen);
                            //NSLog(@"AV_CODECID_AUDIO_AAC SEAudio_Decode()22 ret=%d inlen=%d,outlen=%d",nRet,inLen,nOutLen);
                            if(nRet > 0 && nOutLen > 0)
                            {
                                NSData *data = [[NSData alloc] initWithBytes:pOutBuf length:nOutLen];
                                //[m_pAudioPlayer openAudioFromQueue:data];
                                if (m_bIsSendingTalkDataToDevice == 0 ) {//ć˛ĄćĺéĺŻščŽ˛ć°ćŽďźĺć­ćžĺŁ°éł
                                    [m_pAudioPlayer openAudioFromQueue:data];
                                }
                                [data release];
                                //[self addOneAudioFrameIntoLocalRecordFile:(char*)pOutBuf dataSize:nOutLen deviceTimeTamp:nTimestamp];
                            }
                        }
                        delete [] pOutBuf;
                        pOutBuf = NULL;
                    }
                }
                else if(AV_CODECID_AUDIO_G711A == videohead.nCodecID)//g711 audio
                {
                    if (m_pAudioPlayer)
                    {
                        nOutLen = 2*Length;
                        unsigned char *pOutBuf = new unsigned char[nOutLen];
                        pHandle = m_pAudioHandleG711;
                        if(pHandle && pOutBuf)
                        {
                            
                            int nRet = SEAudio_Decode(pHandle, inBuf,  inLen,  (UCHAR*)pOutBuf, &nOutLen);
                            //NSLog(@"AV_CODECID_AUDIO_AAC SEAudio_Decode()22 ret=%d inlen=%d,outlen=%d",nRet,inLen,nOutLen);
                            if(nRet > 0 && nOutLen > 0)
                            {
                                NSData *data = [[NSData alloc] initWithBytes:pOutBuf length:nOutLen];
                                //[m_pAudioPlayer openAudioFromQueue:data];
                                if (m_bIsSendingTalkDataToDevice == 0 ) {//ć˛ĄćĺéĺŻščŽ˛ć°ćŽďźĺć­ćžĺŁ°éł
                                    [m_pAudioPlayer openAudioFromQueue:data];
                                }
                                [data release];
                                //[self addOneAudioFrameIntoLocalRecordFile:(char*)pOutBuf dataSize:nOutLen deviceTimeTamp:nTimestamp];
                            }
                        }
                        delete [] pOutBuf;
                        pOutBuf = NULL;
                    }
                }
                else if(AV_CODECID_AUDIO_AAC == videohead.nCodecID)//aac audio
                {
                    if (m_pAudioPlayer)
                    {
                        nOutLen = 100*Length;
                        if (nOutLen < KYL_AUDIO_DECODE_BUFFER_SIZE+1) {
                            nOutLen = KYL_AUDIO_DECODE_BUFFER_SIZE+1;
                        }
                        unsigned char *pOutBuf = new unsigned char[nOutLen];
                        pHandle = m_pAudioHandleAAC;
                        
                        if(pHandle && pOutBuf)
                        {
                            
                            int nRet = SEAudio_Decode(pHandle, inBuf,  inLen,  (UCHAR*)pOutBuf, &nOutLen);
                            //NSLog(@"AV_CODECID_AUDIO_AAC SEAudio_Decode()22 ret=%d inlen=%d,outlen=%d",nRet,inLen,nOutLen);
                            if(nRet > 0 && nOutLen > 0)
                            {
                                NSData *data = [[NSData alloc] initWithBytes:pOutBuf length:nOutLen];
                                //[m_pAudioPlayer openAudioFromQueue:data];
                                if (m_bIsSendingTalkDataToDevice == 0 ) {//ć˛ĄćĺéĺŻščŽ˛ć°ćŽďźĺć­ćžĺŁ°éł
                                    [m_pAudioPlayer openAudioFromQueue:data];
                                }
                                [data release];
                                //[self addOneAudioFrameIntoLocalRecordFile:(char*)pOutBuf dataSize:nOutLen deviceTimeTamp:nTimestamp];
                            }
                        }
                        delete [] pOutBuf;
                        pOutBuf = NULL;
                    }
                }
                [pool drain];
                pool = nil;
            }
            delete [] pbuf;
            pbuf = NULL;
        }//{{==
    }
    [pool drain];
    pool = nil;
    m_bAudioPlayThreadRuning = 0;
    
    return 1;
}

- (int) stopPlayAudioThread
{
    int m_result = 1;
    m_bAudioPlayThreadRuning = 0;
    NSLog(@"ĺć­˘ć­ćžĺŽćśéłé˘çşżç¨");
    return m_result;
}

- (int) startPlayVideoThread
{
    if (m_bVideoPlayThreadRuning) {//ĺ˝ĺçşżç¨ć­Łĺ¨čżčĄďźç´ćĽéĺş
        NSLog(@"ĺźĺŻĺŽćśč§é˘ĺ¤ąč´Ľďźĺ˝ĺçşżç¨ć­Łĺ¨čżčĄ");
        return -2;
    }
    m_bVideoPlayThreadRuning = 1;
    m_bFindIFrame = false;
    __block int m_result = 0;
#ifdef __BLOCKS__
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    // No need to retain (just a local variable)
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{//ĺŻĺ¨çşżç¨
        // Do a taks in the background
        
        int ret = [self PlayVideoThread];
        m_result = ret;
        if (ret >= 0)
        {
            NSLog(@"PlayVideoThread ĺŽćśč§é˘çşżç¨çťć");
        }
        dispatch_async(dispatch_get_main_queue(), ^{ //ĺĺ°ä¸ťçşżç¨
            
            
        });
    });
    [pool drain];
    pool = nil;
#endif
    m_result = 1;
    
    return m_result;
    
}

- (int) stopPlayVideoThread
{
    int m_result = 1;
    NSLog(@"ĺć­˘ć­ćžĺŽćśč§é˘çşżç¨");
    m_bVideoPlayThreadRuning = 0;
    return m_result;
}

- (int) startSendRecordingAudioThread
{
    __block int m_result = 0;
#ifdef __BLOCKS__
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    // No need to retain (just a local variable)
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{//ĺŻĺ¨çşżç¨
        // Do a taks in the background
        m_bTalkThreadRuning = 1;
        int ret = [self SendAudioRecordThread];
        m_result = ret;
        if (ret >= 0)
        {
            NSLog(@"ĺéĺŻščŽ˛éłé˘çşżç¨çťć");
        }
        dispatch_async(dispatch_get_main_queue(), ^{ //ĺĺ°ä¸ťçşżç¨
            
            
        });
    });
    [pool drain];
    pool = nil;
#endif
    m_result = 1;
    
    return m_result;
}

- (int) stopSendRecordingAudioThread
{
    int m_result = 1;
    @synchronized(self)
    {
        m_bTalkThreadRuning = 0;
    }
    
    NSLog(@"ĺć­˘ĺéĺŻščŽ˛éłé˘çşżç¨");
    return m_result;
}


#pragma mark Video Audio Talk Controler Thread

/*!
 @method
 @abstract startPlayAudio.
 @discussion start read audio stream thread.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */
- (int) startPlayAudio
{
    int nRet = 0;
    nRet = [self startPlayAudioThread];
    return nRet;
}


/*!
 @method
 @abstract stopPlayAudio.
 @discussion stop read audio stream thread.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */
- (int) stopPlayAudio
{
    int nRet = 0;
    nRet = [self stopPlayAudioThread];
    return nRet;
}


/*!
 @method
 @abstract startPlayVideo.
 @discussion start read video stream thread.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */
- (int) startPlayVideo
{
    int nRet = 0;
    nRet = [self startPlayVideoThread];
    return nRet;
}

/*!
 @method
 @abstract startSendingAudio.
 @discussion start send audio thread.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */
- (int) stopPlayVideo
{
    int nRet = 0;
    nRet = [self stopPlayVideoThread];
    return nRet;
}

/*!
 @method
 @abstract startSendingAudio.
 @discussion start send audio thread.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */
- (int) startSendingAudio
{
    int nRet = 0;
    DebugLog(@"");
    nRet = [self startSendRecordingAudioThread];
    return nRet;
}

/*!
 @method
 @abstract stopSendingAudio.
 @discussion stop send audio thread.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */
- (int) stopSendingAudio
{
    int nRet = 0;
    nRet = [self stopSendRecordingAudioThread];
    return nRet;
}

#pragma mark Remote playback Thread
- (int) PlayTheRemoteRecordAudioThread
{
    if (nil == m_pRemoteRecordAudioPlayer) {
        m_bRemoteRecordAudioPlayThreadRuning = 0;
        return -1;
    }
    
    if(m_pRemoteRecordPlayBackAudioBuf && !m_pRemoteRecordPlayBackAudioBuf->IsBufCreateSucceed())
    {
        m_bRemoteRecordAudioPlayThreadRuning = 0;
        return -2;
    }
    
    UINT64 nTempFirstFramePlayLocalTime = 0;
    UINT64 nTempFirstFrameDeviceTime = 0;
    UINT64 nTempCurrentFrameLocalTime=0;
    UINT64 nTempCurrentFrameDeviceTime=0;
    int nTempDiffTime = 0;
    
    //long nTempCurrentFrameNum = 0;
    int nRet = 0;
    int nTimeProgressSec = 0;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    while(m_bRemoteRecordAudioPlayThreadRuning)
    {
        //----{{20150924
        if (m_bRemoteRecordVideoShowing == 0)
        {
            usleep(10000);
            continue;
        }
        
        int  videoLen = 0;
        STREAM_HEAD videohead;
        memset(&videohead, 0, sizeof(videohead));
        [self GetOneFrameFromRemoteRecordAudioBufWithLenth:videoLen outStreamHead:videohead];
        if(videohead.nTimestamp>m_nFirstFrameDeviceTime_video){
            usleep(10000);
            continue;
        }
        char *pbuf = NULL;
        memset(&videohead, 0, sizeof(videohead));
        pbuf = [self GetAndRemoveOneFrameFromRemoteRecordAudioBufWithLenth:videoLen outStreamHead:videohead];
        if(NULL == pbuf)
        {
            usleep(1000);
            continue;
        }
        unsigned int untimestamp = videohead.nTimestamp;
        nTempCurrentFrameDeviceTime = untimestamp;
        nTempCurrentFrameLocalTime = [self getCurrentTime];
        if(nTempFirstFrameDeviceTime == 0)
        {
            nTempFirstFrameDeviceTime = untimestamp;
            nTempFirstFramePlayLocalTime = nTempCurrentFrameLocalTime;
        }
        
        
        nTempDiffTime = int((nTempCurrentFrameDeviceTime-nTempFirstFrameDeviceTime) - (nTempCurrentFrameLocalTime-nTempFirstFramePlayLocalTime));
        if(nTempDiffTime > 0 && nTempDiffTime <= 1000)
        {
            usleep(nTempDiffTime);
        }
        nTimeProgressSec = (int)(untimestamp - nTempFirstFrameDeviceTime)/1000;
        if(nTimeProgressSec >= 0)
        {
            //
        }
        UINT32 Length = videohead.nStreamDataLen;
        UINT32 nOutLen = 20*Length;
        UCHAR *pHandle = NULL;
        UCHAR *inBuf = (UCHAR *)pbuf;
        UINT32 inLen = (UINT32)Length;
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        if(AV_CODECID_AUDIO_ADPCM == videohead.nCodecID)//adpcm audio
        {
            if (m_pRemoteRecordAudioPlayer)
            {
                nOutLen = 4*Length;
                unsigned char *pOutBuf = new unsigned char[nOutLen];
                pHandle = m_pAudioHandleAdpcm;
                if(pHandle && pOutBuf)
                {
                    
                    int nRet = SEAudio_Decode(pHandle, inBuf,  inLen,  (UCHAR*)pOutBuf, &nOutLen);
                    //NSLog(@"AV_CODECID_AUDIO_AAC SEAudio_Decode()22 ret=%d inlen=%d,outlen=%d",nRet,inLen,nOutLen);
                    if(nRet > 0 && nOutLen > 0)
                    {
                        NSData *data = [[NSData alloc] initWithBytes:pOutBuf length:nOutLen];
                        [m_pRemoteRecordAudioPlayer openAudioFromQueue:data];
                        [data release];
                    }
                }
                delete [] pOutBuf;
                pOutBuf = NULL;
            }
            
        }
        else if(AV_CODECID_AUDIO_G726 == videohead.nCodecID)//g726 audio
        {
            if (m_pRemoteRecordAudioPlayer)
            {
                nOutLen = 8*Length;
                unsigned char *pOutBuf = new unsigned char[nOutLen];
                pHandle = m_pAudioHandleG726;
                if(pHandle && pOutBuf)
                {
                    
                    int nRet = SEAudio_Decode(pHandle, inBuf,  inLen,  (UCHAR*)pOutBuf, &nOutLen);
                    //NSLog(@"AV_CODECID_AUDIO_AAC SEAudio_Decode()22 ret=%d inlen=%d,outlen=%d",nRet,inLen,nOutLen);
                    if(nRet > 0 && nOutLen > 0)
                    {
                        NSData *data = [[NSData alloc] initWithBytes:pOutBuf length:nOutLen];
                        [m_pRemoteRecordAudioPlayer openAudioFromQueue:data];
                        [data release];
                    }
                }
                delete [] pOutBuf;
                pOutBuf = NULL;
            }
        }
        else if(AV_CODECID_AUDIO_G711A == videohead.nCodecID)//g711 audio
        {
            if (m_pRemoteRecordAudioPlayer)
            {
                nOutLen = 2*Length;
                unsigned char *pOutBuf = new unsigned char[nOutLen];
                pHandle = m_pAudioHandleG711;
                if(pHandle && pOutBuf)
                {
                    
                    int nRet = SEAudio_Decode(pHandle, inBuf,  inLen,  (UCHAR*)pOutBuf, &nOutLen);
                    //NSLog(@"AV_CODECID_AUDIO_AAC SEAudio_Decode()22 ret=%d inlen=%d,outlen=%d",nRet,inLen,nOutLen);
                    if(nRet > 0 && nOutLen > 0)
                    {
                        NSData *data = [[NSData alloc] initWithBytes:pOutBuf length:nOutLen];
                        [m_pRemoteRecordAudioPlayer openAudioFromQueue:data];
                        [data release];
                    }
                }
                delete [] pOutBuf;
                pOutBuf = NULL;
            }
        }
        else if(AV_CODECID_AUDIO_AAC == videohead.nCodecID)//aac audio
        {
            if (m_pRemoteRecordAudioPlayer)
            {
                nOutLen = 100*Length;
                if (nOutLen < KYL_AUDIO_DECODE_BUFFER_SIZE+1) {
                    nOutLen = KYL_AUDIO_DECODE_BUFFER_SIZE+1;
                }
                unsigned char *pOutBuf = new unsigned char[nOutLen];
                pHandle = m_pAudioHandleAAC;
                
                if(pHandle && pOutBuf)
                {
                    
                    int nRet = SEAudio_Decode(pHandle, inBuf,  inLen,  (UCHAR*)pOutBuf, &nOutLen);
                    //NSLog(@"AV_CODECID_AUDIO_AAC SEAudio_Decode()22 ret=%d inlen=%d,outlen=%d",nRet,inLen,nOutLen);
                    if(nRet > 0 && nOutLen > 0)
                    {
                        NSData *data = [[NSData alloc] initWithBytes:pOutBuf length:nOutLen];
                        [m_pRemoteRecordAudioPlayer openAudioFromQueue:data];
                        [data release];
                    }
                }
                delete [] pOutBuf;
                pOutBuf = NULL;
            }
        }
        [pool drain];
        pool = nil;
        
        delete [] pbuf;
        pbuf = NULL;
        
        //----}}20150924
    }
    [pool drain];
    pool = nil;
    
    m_bRemoteRecordAudioPlayThreadRuning = 0;
    
    return 1;
}



- (int) PlayTheRemoteRecordVideoThread
{
    if(m_pRemoteRecordPlayBackVideoBuf && !m_pRemoteRecordPlayBackVideoBuf->IsBufCreateSucceed())
    {
        m_bRemoteRecordVideoPlayThreadRuning = 0;
        return -1;
    }
    int nRet = 0;
    
    char *outYUV420=(char *)malloc(KYL_MAX_SIZE_YUV);
    char *outRGB24=(char *)malloc(KYL_MAX_SIZE_RGB24);
    UCHAR *m_pVideoHandleH264 = NULL;
    
    UINT64 nTempFirstFramePlayLocalTime = 0;
    UINT64 nTempFirstFrameDeviceTime = 0;
    UINT64 nTempCurrentFrameLocalTime=0;
    UINT64 nTempCurrentFrameDeviceTime=0;
    UINT64 nTempDiffTime = 0;
    UINT64 nTempForwardFrameDeviceTime=0;
    
    //long nCurrentFrameNum =0;
    int nTimeProgressSec = 0;
    
    nRet = SEVideo_Create(VIDEO_CODE_TYPE_H264, &m_pVideoHandleH264);
    m_bRemoteRecordVideoShowing = 0;
    m_nFirstFrameDeviceTime_video=0; //20150924
    
    BOOL bFirstFrame = NO;
    //int nTempWaitForFrameNum = 25;
    while(m_bRemoteRecordVideoPlayThreadRuning)
    {
        char *pbuf = NULL;
        int videoLen = 0;
        {
            STREAM_HEAD videohead;
            memset(&videohead, 0, sizeof(videohead));
            pbuf = [self GetAndRemoveOneFrameFromRemoteVideBufWithLenth:videoLen outStreamHead:videohead];
            if(NULL == pbuf)
            {
                usleep(10000);
                continue;
            }
            int nDataLength = videohead.nStreamDataLen;
            unsigned int untimestamp = videohead.nTimestamp;
            nTempCurrentFrameLocalTime = [self getCurrentTime];
            nTempCurrentFrameDeviceTime = untimestamp;
            m_nFirstFrameDeviceTime_video=untimestamp; //20150924
            
            if(!bFirstFrame)
            {
                bFirstFrame = YES;
                nTempFirstFrameDeviceTime = videohead.nTimestamp;
                nTempFirstFramePlayLocalTime = [self getCurrentTime];
                nTempForwardFrameDeviceTime = nTempFirstFrameDeviceTime;
            }
            
            nTempDiffTime = (nTempCurrentFrameDeviceTime-nTempFirstFrameDeviceTime) - (nTempCurrentFrameLocalTime-nTempFirstFramePlayLocalTime);
            //nTempDiffTime = nTempCurrentFrameDeviceTime-nTempForwardFrameDeviceTime;
            
            //NSLog(@"SDcardĺ˝ĺĺćž--sleepćśé´ďź%d",(int)nTempDiffTime);
            if(nTempDiffTime > 0 && nTempDiffTime <= 1000){
                usleep((int)nTempDiffTime *1000);
            }
            
            nTempForwardFrameDeviceTime = untimestamp;
            
            nTimeProgressSec = (int) (untimestamp - nTempFirstFrameDeviceTime)/1000;
            //NSLog(@"nTimeProgressSec:%d, nTempCurrentFrameDeviceTime=%d, nTempFirstFrameDeviceTime=%d",nTimeProgressSec,untimestamp,nTempFirstFrameDeviceTime);
            if(nDataLength == 0){ //čŻ´ćSDCardĺ˝ĺĺćžĺŽć
                NSLog(@"\n\nć­ćžSDCardĺ˝ĺçşżç¨ďź SDCardĺ˝ĺĺćžć°ćŽćĽćśĺŽćŻ-----");
                if (self.m_pRemoteRecordPlaybackImageDelegate && [self.m_pRemoteRecordPlaybackImageDelegate respondsToSelector:@selector(KYLRemoteRecordPlayImageProtocol_didReceiveRemoteRecordPlaybackDataFinishedWithTimestamp:timeProgressSec:DID:user:)]) {
                    [self.m_pRemoteRecordPlaybackImageDelegate KYLRemoteRecordPlayImageProtocol_didReceiveRemoteRecordPlaybackDataFinishedWithTimestamp:untimestamp timeProgressSec:nTimeProgressSec DID:self.m_sDID user:self];
                }
            }
            
            if(AV_CODECID_VIDEO_H264 == videohead.nCodecID)
            {
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                
                //h264 data call back
                if (self.m_pRemoteRecordDelegate && [self.m_pRemoteRecordDelegate respondsToSelector:@selector(KYLRemoteRecordPlayProtocol_didReceiveRemoteRecordPlaybackOneH264VideoFrameWithH264Data:length:type:timestamp:timeProgressSec:DID:user:)]) {
                    [self.m_pRemoteRecordDelegate KYLRemoteRecordPlayProtocol_didReceiveRemoteRecordPlaybackOneH264VideoFrameWithH264Data:pbuf  length:videoLen type:videohead.nParameter timestamp:untimestamp  timeProgressSec:nTimeProgressSec DID:self.m_sDID user:self];
                }
                
                if (self.m_pRemoteRecordPlaybackImageDelegate && [self.m_pRemoteRecordPlaybackImageDelegate respondsToSelector:@selector(KYLRemoteRecordPlayImageProtocol_didReceiveRemoteRecordPlaybackOneH264VideoFrameWithH264Data:length:type:timestamp:timeProgressSec:DID:user:)]) {
                    [self.m_pRemoteRecordPlaybackImageDelegate KYLRemoteRecordPlayImageProtocol_didReceiveRemoteRecordPlaybackOneH264VideoFrameWithH264Data:pbuf  length:videoLen type:videohead.nParameter timestamp:untimestamp  timeProgressSec:nTimeProgressSec DID:self.m_sDID user:self];
                }
                
                int  nRet=0, nWidth=0, nHeigh=0;
                ULONG in_outLen=KYL_MAX_SIZE_YUV;
                
                nRet=SEVideo_Decode2YUV(m_pVideoHandleH264, (UCHAR *)pbuf, videoLen, (UCHAR *)outYUV420, &in_outLen, &nWidth,&nHeigh);
                if(nRet>0)
                {
                    //NSLog(@"DoStreamCallback] pDID=%@, SEVideo_Decode2YUV=%d in_outLen=%lu\n", self.m_sDID, nRet, in_outLen);
                    
                    //yuv data call back
                    if (self.m_pRemoteRecordDelegate && [self.m_pRemoteRecordDelegate respondsToSelector:@selector(KYLRemoteRecordPlayProtocol_didReceiveRemoteRecordPlaybackOneVideoFrameYUVNotify:length:width:height:timestamp:timeProgressSec:DID:user:)]) {
                        [self.m_pRemoteRecordDelegate KYLRemoteRecordPlayProtocol_didReceiveRemoteRecordPlaybackOneVideoFrameYUVNotify:(char*)outYUV420  length:(int)in_outLen width:nWidth height:nHeigh timestamp:untimestamp  timeProgressSec:nTimeProgressSec DID:self.m_sDID  user:self];
                    }
                    
                    if (self.m_pRemoteRecordPlaybackImageDelegate && [self.m_pRemoteRecordPlaybackImageDelegate respondsToSelector:@selector(KYLRemoteRecordPlayImageProtocol_didReceiveRemoteRecordPlaybackOneVideoFrameYUVNotify:length:width:height:timestamp:timeProgressSec:DID:user:)]) {
                        [self.m_pRemoteRecordPlaybackImageDelegate KYLRemoteRecordPlayImageProtocol_didReceiveRemoteRecordPlaybackOneVideoFrameYUVNotify:(char*)outYUV420  length:(int)in_outLen width:nWidth height:nHeigh timestamp:untimestamp  timeProgressSec:nTimeProgressSec DID:self.m_sDID  user:self];
                        m_bRemoteRecordVideoShowing = 1;
                    }
                }
                [pool drain];
                pool = nil;
                
            }else if(AV_CODECID_VIDEO_MJPEG == videohead.nCodecID)
            {
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                NSData *image= [[NSData alloc] initWithBytes:pbuf length:videoLen];
                UIImage *img = [[UIImage alloc] initWithData:image];
                
                if (self.m_pRemoteRecordDelegate && [self.m_pRemoteRecordDelegate respondsToSelector:@selector(KYLRemoteRecordPlayProtocol_didReceiveRemoteRecordPlaybackMJPEGImageNotify:timestamp:timeProgressSec:DID:user:)]) {
                    [self.m_pRemoteRecordDelegate KYLRemoteRecordPlayProtocol_didReceiveRemoteRecordPlaybackMJPEGImageNotify:img  timestamp:untimestamp  timeProgressSec:nTimeProgressSec DID:self.m_sDID user:self];
                }
                if (self.m_pRemoteRecordPlaybackImageDelegate && [self.m_pRemoteRecordPlaybackImageDelegate respondsToSelector:@selector(KYLRemoteRecordPlayImageProtocol_didReceiveRemoteRecordPlaybackMJPEGImageNotify:timestamp:timeProgressSec:DID:user:)]) {
                    [self.m_pRemoteRecordPlaybackImageDelegate KYLRemoteRecordPlayImageProtocol_didReceiveRemoteRecordPlaybackMJPEGImageNotify:img   timestamp:untimestamp  timeProgressSec:nTimeProgressSec DID:self.m_sDID user:self];
                    m_bRemoteRecordVideoShowing = 1;
                }
                
                [img release];
                img = nil;
                [image release];
                image = nil;
                [pool drain];
                pool = nil;
            }
        }
        delete [] pbuf;
        pbuf = NULL;
    }
    m_bRemoteRecordVideoShowing = 0;
    if(outRGB24)
    {
        free(outRGB24);
        outRGB24=NULL;
    }
    if(outYUV420)
    {
        free(outYUV420);
        outYUV420=NULL;
    }
    if(m_pVideoHandleH264) {
        SEVideo_Destroy(&m_pVideoHandleH264);
        m_pVideoHandleH264=NULL;
    }
    
    m_bRemoteRecordVideoPlayThreadRuning = 0;
    return nRet;
}

- (int) startPlayRemoteRecordVideoThread
{
    if (m_bRemoteRecordVideoPlayThreadRuning) {//ĺ˝ĺçşżç¨ć­Łĺ¨čżčĄďźç´ćĽéĺş
        NSLog(@"startPlayRemoteRecordVideoThread()ĺ˝ĺçşżç¨ć­Łĺ¨čżčĄ");
        return -1;
    }
    int nTempCameraType = [self cameraType];
    int nTempBufSize = KYL_VBUF_SIZE;
    if (KYL_CAMERA_TYPE_L == nTempCameraType)
    {
        nTempBufSize = KYL_VBUF_SIZE_SD_RECORD_L;
    }
    else if (KYL_CAMERA_TYPE_M == nTempCameraType)
    {
        nTempBufSize = KYL_VBUF_SIZE_SD_RECORD_M;
    }
    else if (KYL_CAMERA_TYPE_X == nTempCameraType)
    {
        nTempBufSize = KYL_VBUF_SIZE_SD_RECORD_X;
    }
    if(0 == m_pRemoteRecordPlayBackVideoBuf->Create(nTempBufSize))
    {
        m_bRemoteRecordVideoPlayThreadRuning = 0;
        return -2;
    }
    
    m_bRemoteRecordVideoPlayThreadRuning = 1;
    __block int m_result = 0;
#ifdef __BLOCKS__
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    // No need to retain (just a local variable)
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{//ĺŻĺ¨çşżç¨
        // Do a taks in the background
        
        int ret = [self PlayTheRemoteRecordVideoThread];
        m_result = ret;
        if (ret >= 0)
        {
            NSLog(@"the function: startPlayRemoteRecordVideoThread() excute finished,the startvideo thread over!");
        }
        dispatch_async(dispatch_get_main_queue(), ^{ //ĺĺ°ä¸ťçşżç¨
            
            
        });
    });
    [pool drain];
    pool = nil;
#endif
    m_result = 1;
    
    return m_result;
    
}

- (int) stopPlayRemoteRecordVideoThread
{
    int m_result = 1;
    NSLog(@"the function: stopPlayRemoteRecordVideoThread() excute succeed!");
    m_bRemoteRecordVideoPlayThreadRuning = 0;
    if (m_pRemoteRecordPlayBackVideoBuf){
        m_pRemoteRecordPlayBackVideoBuf->Release();
    }
    return m_result;
}

- (int) startPlayRemoteRecordAuidoThread
{
    if (m_bRemoteRecordAudioPlayThreadRuning) {//ĺ˝ĺçşżç¨ć­Łĺ¨čżčĄďźç´ćĽéĺş
        NSLog(@"startPlayRemoteRecordAuidoThread()ĺ˝ĺçşżç¨ć­Łĺ¨čżčĄ");
        return -1;
    }
    
    if(0 == m_pRemoteRecordPlayBackAudioBuf->Create(KYL_ABUF_SIZE_SD_RECORD))
    {
        m_bRemoteRecordAudioPlayThreadRuning = 0;
        return -2;
    }
    int nAudioFormat = AL_FORMAT_MONO16;
    if (nil == m_pRemoteRecordAudioPlayer)
    {
        m_pRemoteRecordAudioPlayer = [[KYLOpenALPlayer alloc] init];
    }
    if (nil == m_pRemoteRecordAudioPlayer) {
        m_bRemoteRecordAudioPlayThreadRuning = 0;
        return -3;
    }
    int nSamplingRate = KYL_AUDIO_SAMPLE_RATE_L;
    if ([self cameraType] ==  KYL_CAMERA_TYPE_M)
    {
        nSamplingRate = KYL_AUDIO_SAMPLE_RATE_M;
        nAudioFormat = AL_FORMAT_MONO16;
    }
    else  if ([self cameraType] ==  KYL_CAMERA_TYPE_X)
    {
        nSamplingRate = KYL_AUDIO_SAMPLE_RATE_X;
        nAudioFormat = AL_FORMAT_MONO16;
    }
    [m_pRemoteRecordAudioPlayer initOpenAL:nAudioFormat :nSamplingRate];
    
    m_bRemoteRecordAudioPlayThreadRuning = 1;
    
    __block int m_result = 0;
#ifdef __BLOCKS__
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    // No need to retain (just a local variable)
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{//ĺŻĺ¨çşżç¨
        // Do a taks in the background
        
        int ret = 0;
        ret = [self PlayTheRemoteRecordAudioThread];
        m_result = ret;
        if (ret >= 0)
        {
            NSLog(@"the function: startPlayRemoteRecordAuidoThread() excute finished,the startvideo thread over!");
        }
        dispatch_async(dispatch_get_main_queue(), ^{ //ĺĺ°ä¸ťçşżç¨
            
            
        });
    });
    [pool drain];
    pool = nil;
#endif
    m_result = 1;
    
    return m_result;
    
}

- (int) stopPlayRemoteRecordAudioThread
{
    int m_result = 1;
    
    if (!m_bRemoteRecordAudioPlayThreadRuning) {
        return 1;
    }
    NSLog(@"the function: stopPlayRemoteRecordAudioThread() excute succeed!");
    m_bRemoteRecordAudioPlayThreadRuning = 0;
    
    if (m_pRemoteRecordPlayBackAudioBuf) {
        m_pRemoteRecordPlayBackAudioBuf->Release();
    }
    if (m_pRemoteRecordAudioPlayer != nil)
    {
        [m_pRemoteRecordAudioPlayer stopSound];
        [m_pRemoteRecordAudioPlayer cleanUpOpenAL];
        [m_pRemoteRecordAudioPlayer release];
        m_pRemoteRecordAudioPlayer = nil;
    }
    
    return m_result;
    
}

/////////////////////////////////////}}}}
#pragma mark -- NVR logic {{
/**      interface for NVR   */
- (KYLCamera *) getTheNVRCameraObjWitchChannel:(int) nChannel
{
    if (nil == self.m_listNVRCameras) {
        return nil;
    }
    if (nChannel != self.m_nNVRChannelNum) {
        return nil;
    }
    if (nChannel >= self.m_nNVRChannelNum) {
        return nil;
    }
    if (self.m_listNVRCameras)
    {
        if (nChannel < self.m_listNVRCameras.count)
        {
            KYLCamera *oneNVRCameraObj = [self.m_listNVRCameras objectAtIndex:nChannel];
            return oneNVRCameraObj;
        }
    }
    return nil;
    
}

- (id) CopyAllParamFromOther:(KYLCamera *) other
{
    //    memset(&self.m_pAVParameter, 0, sizeof(AV_PARAMETER));
    //    memcpy(&self.m_pAVParameter,&other.m_pAVParameter,sizeof(AV_PARAMETER));
    self.m_pavParameter->nVideoCodecID = other.m_pavParameter->nVideoCodecID;
    self.m_pavParameter->nAudioCodecID = other.m_pavParameter->nAudioCodecID;
    self.m_pavParameter->nAudioParameter = other.m_pavParameter->nAudioParameter;
    self.m_pavParameter->nDeviceType = other.m_pavParameter->nDeviceType;
    self.m_pavParameter->nMaxChannel = other.m_pavParameter->nMaxChannel;
    strcpy(self.m_pavParameter->nVideoParameter, other.m_pavParameter->nVideoParameter);
    strcpy(self.m_pavParameter->reserve, other.m_pavParameter->reserve);
    
    self.m_nCameraResolution = other.m_nCameraResolution;
    self.m_nCameraBirght = other.m_nCameraBirght;
    self.m_nCameraContrast = other.m_nCameraContrast;
    self.m_nCameraSaturation = other.m_nCameraSaturation;
    self.m_nCameraOSD = other.m_nCameraOSD;
    self.m_nCameraMode = other.m_nCameraMode;
    self.m_nCameraFlip = other.m_nCameraFlip;
    self.m_nCameraIRLed = other.m_nCameraIRLed;
    self.m_nCurrentAudioSampleRate = other.m_nCurrentAudioSampleRate;
    self.m_nCurrentAudioChannel = other.m_nCurrentAudioChannel;
    self.nVideoCodecID = other.nVideoCodecID;     // refer to SEP2P_ENUM_AV_CODECID
    self.nAudioCodecID = other.nAudioCodecID;     // refer to SEP2P_ENUM_AV_CODECID
    self.m_sNVideoParameter = other.m_sNVideoParameter;// Video: refer to SEP2P_ENUM_VIDEO_RESO
    self.nAudioParameter = other.nAudioParameter;     // Audio:(samplerate << 2) | (databits << 1) | (channel)
    self.m_bIsAdmin = other.m_bIsAdmin;
    self.m_iIndexForTableView = other.m_iIndexForTableView;//čŽ°ĺ˝ĺ¨čŽžĺ¤ĺčĄ¨ä¸­çä˝ç˝ŽďźçŹŹĺ čĄ
    self.m_iIndexForImageView = other.m_iIndexForImageView;//čŽ°ĺ˝ĺ¨éŁä¸Şć­ćžçŞĺŁćžç¤ş
    
    self.delegate = other.delegate;
    self.searchDelegate = other.searchDelegate;
    self.m_pSetWifiDelegate = other.m_pSetWifiDelegate;
    self.m_pSetUserInfoDelegate = other.m_pSetUserInfoDelegate;
    self.m_pSetFtpInfoDelegate = other.m_pSetFtpInfoDelegate;
    self.m_pSetAlarmInfoDelegate = other.m_pSetAlarmInfoDelegate;
    self.m_pSetDatetimeDelegate = other.m_pSetDatetimeDelegate;
    self.m_pSetEmailDelegate = other.m_pSetEmailDelegate;
    self.m_pSetCameraParamDelegate = other.m_pSetCameraParamDelegate;
    self.m_pEventDelegate = other.m_pEventDelegate;
    self.m_pImageDelegate = other.m_pImageDelegate;
    self.m_pSnapPictureDelegate = other.m_pSnapPictureDelegate;
    self.m_pSetSDCardDelegate = other.m_pSetSDCardDelegate;
    self.m_pRemoteRecordDelegate = other.m_pRemoteRecordDelegate;
    self.m_pRemoteRecordPlaybackImageDelegate = other.m_pRemoteRecordPlaybackImageDelegate;
    self.m_pDeviceStatusChangedDelegate = other.m_pDeviceStatusChangedDelegate;
    self.m_pCameraPushFunctionSetDelegate = other.m_pCameraPushFunctionSetDelegate;
    
    self.m_pCurrentRemoteRecordPlayInfo = other.m_pCurrentRemoteRecordPlayInfo;
    self.m_strCurrentLocalRecordFileDate = other.m_strCurrentLocalRecordFileDate ;
    self.m_strCurrentLocalRecordFileName = other.m_strCurrentLocalRecordFileName ;
    self.m_strCurrentLocalRecordFilePath = other.m_strCurrentLocalRecordFilePath ;
    self.m_imgForDeviceHead = other.m_imgForDeviceHead;
    self.m_strAdmin = other.m_strAdmin;
    self.m_strAdminPwd = other.m_strAdminPwd;
    self.m_strVistor = other.m_strVistor;
    self.m_strVistorPwd = other.m_strVistorPwd;
    self.m_nCurrentVideoResolution = other.m_nCurrentVideoResolution;
    self.m_iUserType = other.m_iUserType;//ç¨ćˇçąťĺ
    
    self.m_sDID = other.m_sDID;
    self.m_sUsername = other.m_sUsername;
    self.m_sPassword = other.m_sPassword;
    self.m_sDeviceName = other.m_sDeviceName;
    
    self.m_nCurrentChannel = other.m_nCurrentChannel;
    self.m_nDeviceType = other.m_nDeviceType; //    typedef enum{DEVICE_TYPE_IPC =0,DEVICE_TYPE_NVR =1 }E_DEVICE_TYPE;
    self.m_nNVRChannelNum = other.m_nNVRChannelNum;
    self.m_nP2PConnectMode = other.m_nP2PConnectMode;
    self.m_nDeviceStatus = other.m_nDeviceStatus;
    self.deviceConnectStatus = other.deviceConnectStatus;
    self.m_nP2PMode = other.m_nP2PMode;
    self.m_nAuthor = other.m_nAuthor;
    self.m_nIMNVersion = other.m_nIMNVersion;
    self.m_bIsSupportPushFunction = other.m_bIsSupportPushFunction;
    self.m_bAllowCameraPushMsg = other.m_bAllowCameraPushMsg;
    self.m_sP2papi_ver = other.m_sP2papi_ver;             //API version
    self.m_sFwp2p_app_ver = other.m_sFwp2p_app_ver;          //P2P firmware version
    self.m_sFwp2p_app_buildtime = other.m_sFwp2p_app_buildtime;    //P2P firmware build time
    self.m_sFwddns_app_ver = other.m_sFwddns_app_ver;         //firmware version
    self.m_sFwhard_ver = other.m_sFwhard_ver;             //the device hard version
    self.m_sVendor = other.m_sVendor;//factory name
    self.m_sProduct = other.m_sProduct;//product mode
    self.m_sProduct_series = other.m_sProduct_series;//product main category, L series: product_series[0]='L'; M series:product_series[0]='M',product_series[1]='1';
    self.m_sCameraToken = other.m_sCameraToken;
    
    return self;
}



- (void) CreateTheNVRCameraObjList
{
    if (self.m_listNVRCameras == nil) {
        self.m_listNVRCameras = [[NSMutableArray alloc] initWithCapacity:4];
    }
    if (self.m_listNVRCameras) {
        [self.m_listNVRCameras removeAllObjects];
        for (int i=0; i<self.m_nNVRChannelNum; i++) {
            KYLCamera *oneNVRCameraObj = [[KYLCamera alloc] init];
            [oneNVRCameraObj CopyAllParamFromOther:self];
            
            [self.m_listNVRCameras addObject:oneNVRCameraObj];
            [oneNVRCameraObj release];
        }
    }
}

- (void) DestroyTheNVRCameraObjList
{
    if (self.m_listNVRCameras) {
        [self.m_listNVRCameras removeAllObjects];
        self.m_listNVRCameras = nil;
    }
}

/*!
 @method
 @abstract didReceivedStreamCallBack.
 @discussion deal the stream call back data.
 @result null .
 */
- (void) didReceivedStreamCallBackForNVR:(CHAR *) pDID streamData:(CHAR *) pData dataSize:(UINT32) nDataSize
{
    @synchronized(self)
    {
        if (NULL == pDID)
        {
            return;
        }
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        NSString *stempDid = [[NSString alloc] initWithCString:pDID encoding:NSUTF8StringEncoding];
        if ([stempDid isEqualToString:self.m_sDID])
        {
            STREAM_HEAD *pStreamHead=(STREAM_HEAD *)pData;
            int nTempChannel = pStreamHead->nChannel;
            
            if (self.m_listNVRCameras)
            {
                NSInteger nNVRCameraNum = self.m_listNVRCameras.count;
                if (nTempChannel < nNVRCameraNum)
                {
                    KYLCamera *oneNVRCameraObj = (KYLCamera *)[self.m_listNVRCameras objectAtIndex:nTempChannel];
                    if (oneNVRCameraObj)
                    {
                        [oneNVRCameraObj dealWithTheStreamCallbackResultForNVR:pData dataSize:nDataSize];
                    }
                }
            }
        }
        [stempDid release];
        [pool drain];
        pool = nil;
    }
}


/*!
 @method
 @abstract didReceivedMsgCallBack.
 @discussion deal the send message call back data.
 @result null .
 */
- (void) didReceivedMsgCallBackForNVR:(CHAR *) pDID messageType:(UINT32) nMessageType messageData:(CHAR *) messageData dataSize:(UINT32) nMsgDataSize
{
    @synchronized(self)
    {
        if (NULL == pDID)
        {
            return;
        }
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSLog(@"KYLCamera::didReceivedMsgCallBack() did= %s, datasize=%d",pDID,nMsgDataSize);
        NSString *stempDid = [[NSString alloc] initWithCString:pDID encoding:NSUTF8StringEncoding];
        
        if ([stempDid isEqualToString:self.m_sDID])
        {
            if (SEP2P_MSG_START_TALK_RESP == nMessageType)// if the message type is talk
            {
                [self dealTheTalkCallbackData:messageData size:nMessageType];
            }
            else if (SEP2P_MSG_CONNECT_STATUS == nMessageType)
            {
                MSG_CONNECT_STATUS *pResp=(MSG_CONNECT_STATUS *)messageData;
                [self dealTheDeviceStatusMsg:pResp];
            }
            else if (SEP2P_MSG_SNAP_PICTURE_RESP == nMessageType)
            {
                //the data no contain head, all the purge data are image bin data
                [self dealTheCallbackSnapPictureResponse:messageData size:nMsgDataSize];
            }
            else if (SEP2P_MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP == nMessageType)
            {
                NSLog(@"SEP2P_MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP get dataSize = %d", nMsgDataSize);
                [self dealWithTheGetAllRecordFilesByDayMsg:messageData dataSize:nMsgDataSize];
            }
            else
            {
                MSG_INFO *pMsgInfo=(MSG_INFO *)malloc(sizeof(MSG_INFO));
                memset(pMsgInfo, 0, sizeof(MSG_INFO));
                pMsgInfo->nChanNo=0;
                pMsgInfo->nMsgType=nMessageType;
                pMsgInfo->nMsgSize=nMsgDataSize;
                if(nMsgDataSize>0){
                    pMsgInfo->pMsg=(CHAR *)malloc(nMsgDataSize);
                    memcpy(pMsgInfo->pMsg, messageData, nMsgDataSize);
                }
                
                //deal with message
                [self dealTheReceivedMsg:pMsgInfo];
                
                // free memory
                if(pMsgInfo){
                    if(pMsgInfo->pMsg) {
                        free(pMsgInfo->pMsg);
                        pMsgInfo->pMsg=NULL;
                    }
                    free(pMsgInfo);
                    pMsgInfo=NULL;
                }
            }
        }
        [stempDid release];
        [pool drain];
        pool = nil;
    }
}

- (void) didReceivedEventCallBackForNVR:(CHAR *) pDID  eventData:(CHAR*  ) pEventData  dataSize:(UINT32 ) nEventDataSize eventType:(UINT32) nEventType
{
    @synchronized(self)
    {
        NSLog(@"didReceivedEventCallBack DID=%s, eventype=%d",pDID, nEventType);
        if (NULL == pDID)
        {
            return;
        }
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSString *stempDid = [[NSString alloc] initWithCString:pDID encoding:NSUTF8StringEncoding];
        NSString *strEventType = [[NSString alloc] initWithFormat:@"%d",nEventType];
        NSData *eventData = [[NSData alloc] initWithBytes:(Byte *)pEventData length:nEventDataSize];
        NSString *strDataLength = [[NSString alloc] initWithFormat:@"%d",nEventDataSize];
        // send the broadcast to notification the event.
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:stempDid,@"did",strEventType,@"eventtype",eventData,@"data",strDataLength,@"datasize", nil];
        [strDataLength release];
        [strEventType release];
        [eventData release];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Camera_Events_Notification" object:self userInfo:dic];
        // free memory
        
        [dic release];
        
        if ([stempDid isEqualToString:self.m_sDID])
        {
            [self dealWithTheEventResult:nEventType];
        }
        [stempDid release];
        [pool drain];
        pool = nil;
        
    }
}

- (int) dealWithTheStreamCallbackResultForNVR:(CHAR *) _sStreamData  dataSize:(UINT32) nSize
{
    int m_iRet = 0;
    
    STREAM_HEAD *pStreamHead=(STREAM_HEAD *)_sStreamData;
    int nTempPlaybackID = pStreamHead->nPlaybackID;
    //int nTempTimeStamp = pStreamHead->nTimestamp;
    //int nTempCodecID = pStreamHead->nCodecID;
    int nTempLivePlayback = pStreamHead->nLivePlayback;
    //int nTempParameter = pStreamHead->nParameter;
    int nTempChannel = pStreamHead->nChannel;
    if (nTempChannel != self.m_nNVRChannelNum) {
        return 0;
    }
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (nTempLivePlayback == 0){ //live video stream
        int nRet = 0;
        if(pStreamHead->nCodecID==AV_CODECID_VIDEO_H264 )
        {
            if(!m_bVideoPlayThreadRuning) return -1;
            if(!m_bFindIFrame){
                if(pStreamHead->nParameter == VIDEO_FRAME_FLAG_I) m_bFindIFrame = true;
                else {
                    m_iRet=-4;
                    return m_iRet;
                }
            }
            if(m_bFindIFrame){
                nRet = [self AddOneFrameIntoVideoBuf:(char *) _sStreamData dataSize:nSize];
                if(nRet == 0)
                {
                    [self ResetTheVideoBuf];
                    m_bFindIFrame = false;
                    m_iRet=-4;
                    return m_iRet;
                }
            }
        }
        else if(pStreamHead->nCodecID==AV_CODECID_VIDEO_MJPEG )
        {
            if(!m_bVideoPlayThreadRuning) return -1;
            if (NULL == m_pVideoBuf) {
                return  -2;
            }
            nRet = [self AddOneFrameIntoVideoBuf:(char *) _sStreamData dataSize:nSize];
            if(nRet == 0)
            {
                [self ResetTheVideoBuf];
                m_bFindIFrame = false;
            }
        }
        else if(pStreamHead->nCodecID==AV_CODECID_AUDIO_G726 )
        {
            if(!m_bAudioPlayThreadRuning) return -1;
            nRet = [self AddOneFrameIntoAudioBuf:(char *) _sStreamData dataSize:nSize];
            if(nRet == 0)
            {
                [self ResetTheAudioBuf];
            }
        }
        else if(pStreamHead->nCodecID==AV_CODECID_AUDIO_ADPCM )
        {
            if(!m_bAudioPlayThreadRuning) return -1;
            nRet = [self AddOneFrameIntoAudioBuf:(char *) _sStreamData dataSize:nSize];
            if(nRet == 0)
            {
                [self ResetTheAudioBuf];
            }
        }
        else if(pStreamHead->nCodecID==AV_CODECID_AUDIO_G711A)
        {
            if(!m_bAudioPlayThreadRuning) return -1;
            nRet = [self AddOneFrameIntoAudioBuf:(char *) _sStreamData dataSize:nSize];
            if(nRet == 0)
            {
                [self ResetTheAudioBuf];
            }
        }
        else if(pStreamHead->nCodecID==AV_CODECID_AUDIO_AAC)//{{-- kongyulu at 20141118 for X series
        {
            if(!m_bAudioPlayThreadRuning) return -1;
            nRet = [self AddOneFrameIntoAudioBuf:(char *) _sStreamData dataSize:nSize];
            if(nRet == 0)
            {
                [self ResetTheAudioBuf];
            }
        }
        else if(pStreamHead->nCodecID==AV_CODECID_UNKNOWN)
        {
            NSLog(@"The callback stream is unknown");
        }
        else
        {
            NSLog(@"The callback stream have some error!");
        }
        
    }
    else if (nTempLivePlayback == 1) { //remote playback video stream
        
        if (m_nCurrentPlaybackID == nTempPlaybackID)
        {//only deal the same playback id
            int nRet = 0;
            
            if(pStreamHead->nCodecID==AV_CODECID_VIDEO_H264 )
            {
                if(!m_bRemoteRecordVideoPlayThreadRuning) return -1;
                if(!m_bFindIFrame){
                    if(pStreamHead->nParameter == VIDEO_FRAME_FLAG_I) m_bFindIFrame = true;
                    else {
                        m_iRet=-4;
                        return m_iRet;
                    }
                }
                if(m_bFindIFrame){
                    nRet = [self AddOneFrameIntoRemoteVideoBuf:(char *) _sStreamData dataSize:nSize];
                    if(nRet == 0)
                    {
                        [self ResetTheRemoteVideoBuf];
                        m_bFindIFrame = false;
                        m_iRet=-4;
                        return m_iRet;
                    }
                }
            }
            else if(pStreamHead->nCodecID==AV_CODECID_VIDEO_MJPEG )
            {
                if(!m_bRemoteRecordVideoPlayThreadRuning) return -1;
                nRet = [self AddOneFrameIntoRemoteVideoBuf:(char *) _sStreamData dataSize:nSize];
                if(nRet == 0)
                {
                    [self ResetTheRemoteVideoBuf];
                }
            }
            else if(pStreamHead->nCodecID==AV_CODECID_AUDIO_G726 )
            {
                if(!m_bRemoteRecordAudioPlayThreadRuning) return -1;
                nRet = [self AddOneFrameIntoRemoteRecordAudioBuf:(char *) _sStreamData dataSize:nSize];
                if(nRet == 0)
                {
                    [self ResetTheRemoteRecordAudioBuf];
                }
            }
            else if(pStreamHead->nCodecID==AV_CODECID_AUDIO_ADPCM )
            {
                if(!m_bRemoteRecordAudioPlayThreadRuning) return -1;
                nRet = [self AddOneFrameIntoRemoteRecordAudioBuf:(char *) _sStreamData dataSize:nSize];
                if(nRet == 0)
                {
                    [self ResetTheRemoteRecordAudioBuf];
                }
            }
            else if(pStreamHead->nCodecID==AV_CODECID_AUDIO_G711A)
            {
                if(!m_bRemoteRecordAudioPlayThreadRuning) return -1;
                nRet = [self AddOneFrameIntoRemoteRecordAudioBuf:(char *) _sStreamData dataSize:nSize];
                if(nRet == 0)
                {
                    [self ResetTheRemoteRecordAudioBuf];
                }
            }
            else if(pStreamHead->nCodecID==AV_CODECID_AUDIO_AAC)//{{-- kongyulu at 20141118 for X series
            {
                if(!m_bRemoteRecordAudioPlayThreadRuning) return -1;
                nRet = [self AddOneFrameIntoRemoteRecordAudioBuf:(char *) _sStreamData dataSize:nSize];
                if(nRet == 0)
                {
                    [self ResetTheRemoteRecordAudioBuf];
                }
            }
            else if(pStreamHead->nCodecID==AV_CODECID_UNKNOWN)
            {
                NSLog(@"The callback stream is unknown");
            }
            else
            {
                NSLog(@"The callback stream have some error!");
            }
        }// end for if (m_nCurrentPlaybackID == nTempPlaybackID) {//only deal the same playback id
    }// end for if (nTempLivePlayback == 1) { //remote playback video stream
    //}}-- add by kongyulu at 20141217
    
    [pool drain];
    pool = nil;
    return m_iRet;
}
#pragma mark -- NVR logic }}

#pragma mark call back functions
static INT32 OnStreamCallback(CHAR* pDID, CHAR* pData, UINT32  nDataSize, VOID* pUserData)
{
    KYLCamera *pThis = (KYLCamera *) pUserData;
    if(pThis.m_nDeviceType == DEVICE_TYPE_NVR) {
        [pThis didReceivedStreamCallBackForNVR:pDID streamData:pData dataSize:nDataSize];
    }else {
        [pThis didReceivedStreamCallBack:pDID streamData:pData dataSize:nDataSize];
    }
    return 0L;
}

static INT32 OnRecvMsgCallback(
                               CHAR*   pDID,
                               UINT32  nMsgType,
                               CHAR*   pMsg,
                               UINT32  nMsgSize,
                               VOID*   pUserData)
{
    KYLCamera *pThis = (KYLCamera *) pUserData;
    if (pThis.m_nDeviceType == DEVICE_TYPE_IPC) {
        [pThis didReceivedMsgCallBack:pDID messageType:nMsgType messageData:pMsg dataSize:nMsgSize];
    }
    else if (pThis.m_nDeviceType == DEVICE_TYPE_NVR) {
        [pThis didReceivedMsgCallBackForNVR:pDID messageType:nMsgType messageData:pMsg dataSize:nMsgSize];
    }
    return 0L;
}

static INT32 OnEventCallback(
                             CHAR*   pDID,
                             UINT32  nEventType,
                             CHAR*   pEventData,
                             UINT32  nEventDataSize,
                             VOID*   pUserData)
{
    KYLCamera *pThis = (KYLCamera *) pUserData;
    if (pThis.m_nDeviceType == DEVICE_TYPE_IPC) {
        [pThis didReceivedEventCallBack:pDID eventData:pEventData dataSize:nEventDataSize eventType:nEventType];
    }
    else if (pThis.m_nDeviceType == DEVICE_TYPE_NVR) {
        [pThis didReceivedEventCallBackForNVR:pDID eventData:pEventData dataSize:nEventDataSize eventType:nEventType];
    }
    
    return 0L;
}

#pragma mark --- read the circle buf {{
- (int) AddOneFrameIntoVideoBuf:(char *) pData dataSize:(int) nDataSize
{
    [m_LockForVideoBuf lock];
    if(nil == m_pVideoBuf)
    {
        [m_LockForVideoBuf unlock];
        return  -1;
    }
    if(m_pVideoBuf && !m_pVideoBuf->IsBufCreateSucceed())
    {
        [m_LockForVideoBuf unlock];
        return -2;
    }
    int nRet = m_pVideoBuf->Write((void*)pData, nDataSize);
    if(nRet<= 0)
    {
        [m_LockForVideoBuf unlock];
        return 0;
    }
    [m_LockForVideoBuf unlock];
    return nRet;
}

- (int) GetAndRemoveOneFrameFromVideBuf:(char **) pbuf
{
    [m_LockForVideoBuf lock];
    if(nil == m_pVideoBuf)
    {
        [m_LockForVideoBuf unlock];
        return  -1;
    }
    if(m_pVideoBuf && !m_pVideoBuf->IsBufCreateSucceed())
    {
        [m_LockForVideoBuf unlock];
        return -2;
    }
    STREAM_HEAD avHead;
    memset(&avHead, 0, sizeof(avHead));
    int nRet=m_pVideoBuf->ReadByPeer(&avHead, sizeof(STREAM_HEAD));
    if(nRet>0 && avHead.nStreamDataLen<(UINT32)m_pVideoBuf->GetStock()){
        *pbuf = new char[sizeof(avHead)+avHead.nStreamDataLen];
        if(NULL == *pbuf)
        {
            [m_LockForVideoBuf unlock];
            return -3;
        }
        nRet=m_pVideoBuf->Read(*pbuf, sizeof(STREAM_HEAD)+avHead.nStreamDataLen);
        if(nRet == 0)
        {
            delete []*pbuf;
            *pbuf = NULL;
            [m_LockForVideoBuf unlock];
            return -4;
        }
    }
    else
    {
        nRet=0;
    }
    [m_LockForVideoBuf unlock];
    return nRet;
}

- (char* ) GetAndRemoveOneFrameFromVideBufWithLenth:(int &) nLen outStreamHead:(STREAM_HEAD &) videobufhead
{
    [m_LockForVideoBuf lock];
    if(nil == m_pVideoBuf)
    {
        [m_LockForVideoBuf unlock];
        return NULL;
    }
    if(m_pVideoBuf && !m_pVideoBuf->IsBufCreateSucceed())
    {
        [m_LockForVideoBuf unlock];
        return NULL;
    }
    STREAM_HEAD avHead;
    memset(&avHead, 0, sizeof(avHead));
    char *pTempbuf = NULL;
    int nRet=m_pVideoBuf->ReadByPeer(&avHead, sizeof(STREAM_HEAD));
    if(nRet>0 && avHead.nStreamDataLen<(UINT32)m_pVideoBuf->GetStock()){
        pTempbuf = new char[sizeof(avHead)+avHead.nStreamDataLen];
        if(NULL == pTempbuf)
        {
            [m_LockForVideoBuf unlock];
            return NULL;
        }
        nRet=m_pVideoBuf->Read(pTempbuf, sizeof(STREAM_HEAD)+avHead.nStreamDataLen);
        if(nRet == 0)
        {
            delete []pTempbuf;
            pTempbuf = NULL;
            nLen  = 0;
            [m_LockForVideoBuf unlock];
            return pTempbuf;
        }
        else
        {
            nLen=nRet-sizeof(STREAM_HEAD);
            memcpy((char*)&videobufhead, (char*)&avHead, sizeof(STREAM_HEAD));
            memcpy((char*)pTempbuf, (char*)pTempbuf+sizeof(STREAM_HEAD), avHead.nStreamDataLen);
        }
    }
    else
    {
        nLen  = 0;
        nRet=0;
    }
    [m_LockForVideoBuf unlock];
    return pTempbuf;
}

- (int) ResetTheVideoBuf
{
    [m_LockForVideoBuf lock];
    if(nil == m_pVideoBuf)
    {
        [m_LockForVideoBuf unlock];
        return NULL;
    }
    if(m_pVideoBuf && !m_pVideoBuf->IsBufCreateSucceed())
    {
        [m_LockForVideoBuf unlock];
        return NULL;
    }
    m_pVideoBuf->Reset();
    [m_LockForVideoBuf unlock];
    return 1;
}


- (int) AddOneFrameIntoRemoteVideoBuf:(char *) pData dataSize:(int) nDataSize
{
    [m_LockForRemoteVideoBuf lock];
    if(nil == m_pRemoteRecordPlayBackVideoBuf)
    {
        [m_LockForRemoteVideoBuf unlock];
        return  -1;
    }
    if(m_pRemoteRecordPlayBackVideoBuf && !m_pRemoteRecordPlayBackVideoBuf->IsBufCreateSucceed())
    {
        [m_LockForRemoteVideoBuf unlock];
        return -2;
    }
    int nRet = m_pRemoteRecordPlayBackVideoBuf->Write((void*)pData, nDataSize);
    if(nRet<= 0)
    {
        [m_LockForRemoteVideoBuf unlock];
        return 0;
    }
    [m_LockForRemoteVideoBuf unlock];
    return nRet;
}

- (int) GetAndRemoveOneFrameFromRemoteVideBuf:(char **) pbuf
{
    [m_LockForRemoteVideoBuf lock];
    if(nil == m_pRemoteRecordPlayBackVideoBuf){
        [m_LockForRemoteVideoBuf unlock];
        return  -1;
    }
    if(m_pRemoteRecordPlayBackVideoBuf && !m_pRemoteRecordPlayBackVideoBuf->IsBufCreateSucceed())
    {
        [m_LockForRemoteVideoBuf unlock];
        return -2;
    }
    STREAM_HEAD avHead;
    memset(&avHead, 0, sizeof(avHead));
    int nRet=m_pRemoteRecordPlayBackVideoBuf->ReadByPeer(&avHead, sizeof(STREAM_HEAD));
    if(nRet>0 && avHead.nStreamDataLen<(UINT32)m_pRemoteRecordPlayBackVideoBuf->GetStock()){
        *pbuf = new char[sizeof(avHead)+avHead.nStreamDataLen];
        if(NULL == *pbuf)
        {
            [m_LockForRemoteVideoBuf unlock];
            return -3;
        }
        nRet=m_pRemoteRecordPlayBackVideoBuf->Read(*pbuf, sizeof(STREAM_HEAD)+avHead.nStreamDataLen);
        if(nRet == 0)
        {
            delete []*pbuf;
            *pbuf = NULL;
            [m_LockForRemoteVideoBuf unlock];
            return -4;
        }
    }else nRet=0;
    [m_LockForRemoteVideoBuf unlock];
    return nRet;
}

- (char* ) GetAndRemoveOneFrameFromRemoteVideBufWithLenth:(int &) nLen outStreamHead:(STREAM_HEAD &) videobufhead
{
    [m_LockForRemoteVideoBuf lock];
    if(nil == m_pRemoteRecordPlayBackVideoBuf)
    {
        [m_LockForRemoteVideoBuf unlock];
        return NULL;
    }
    if(m_pRemoteRecordPlayBackVideoBuf && !m_pRemoteRecordPlayBackVideoBuf->IsBufCreateSucceed())
    {
        [m_LockForRemoteVideoBuf unlock];
        return NULL;
    }
    STREAM_HEAD avHead;
    memset(&avHead, 0, sizeof(avHead));
    char *pTempbuf = NULL;
    int nRet=m_pRemoteRecordPlayBackVideoBuf->ReadByPeer(&avHead, sizeof(STREAM_HEAD));
    
    if(nRet>0 && avHead.nStreamDataLen<(UINT32)m_pRemoteRecordPlayBackVideoBuf->GetStock()){
        pTempbuf = new char[sizeof(avHead)+avHead.nStreamDataLen];
        if(NULL == pTempbuf)
        {
            [m_LockForRemoteVideoBuf unlock];
            return NULL;
        }
        nRet=m_pRemoteRecordPlayBackVideoBuf->Read(pTempbuf, sizeof(STREAM_HEAD)+avHead.nStreamDataLen);
        //NSLog(@"m_pRemoteRecordPlayBackVideoBuf->Read() ret=%d",nRet);
        if(nRet == 0)
        {
            delete []pTempbuf;
            pTempbuf = NULL;
            nLen  = 0;
            [m_LockForRemoteVideoBuf unlock];
            return pTempbuf;
        }
        else
        {
            nLen=nRet-sizeof(STREAM_HEAD);
            memcpy((char*)&videobufhead, (char*)&avHead, sizeof(STREAM_HEAD));
            memcpy((char*)pTempbuf, (char*)pTempbuf+sizeof(STREAM_HEAD), avHead.nStreamDataLen);
        }
    }else{
        nLen  = 0;
        nRet=0;
    }
    [m_LockForRemoteVideoBuf unlock];
    return pTempbuf;
}

- (int) ResetTheRemoteVideoBuf
{
    [m_LockForRemoteVideoBuf lock];
    if(nil == m_pRemoteRecordPlayBackVideoBuf)
    {
        [m_LockForRemoteVideoBuf unlock];
        return NULL;
    }
    if(m_pRemoteRecordPlayBackVideoBuf && !m_pRemoteRecordPlayBackVideoBuf->IsBufCreateSucceed())
    {
        [m_LockForRemoteVideoBuf unlock];
        return NULL;
    }
    m_pRemoteRecordPlayBackVideoBuf->Reset();
    [m_LockForRemoteVideoBuf unlock];
    return 1;
}

- (int) IsTheRemoteRecordVideoBufHasFrameNum:(int ) nFrameNum
{
    [m_LockForRemoteVideoBuf lock];
    if(nil == m_pRemoteRecordPlayBackVideoBuf)
    {
        [m_LockForRemoteVideoBuf unlock];
        return 0;
    }
    if(m_pRemoteRecordPlayBackVideoBuf && !m_pRemoteRecordPlayBackVideoBuf->IsBufCreateSucceed())
    {
        [m_LockForRemoteVideoBuf unlock];
        return 0;
    }
    STREAM_HEAD avHead;
    memset(&avHead, 0, sizeof(avHead));
    int nRet=m_pRemoteRecordPlayBackVideoBuf->ReadByPeer(&avHead, sizeof(STREAM_HEAD));
    NSLog(@"m_pRemoteRecordPlayBackVideoBuf->ReadByPeer() nRet=%d, streamDataLen=%d, stock=%d",nRet,avHead.nStreamDataLen, m_pRemoteRecordPlayBackVideoBuf->GetStock());
    int nTempDataSize = nFrameNum * (avHead.nStreamDataLen + sizeof(STREAM_HEAD));
    if(nRet>0 && nTempDataSize<(UINT32)m_pRemoteRecordPlayBackVideoBuf->GetStock()){
        [m_LockForRemoteVideoBuf unlock];
        return nRet;
    }
    else
    {
        nRet=0;
    }
    [m_LockForRemoteVideoBuf unlock];
    return nRet;
}


// living stream audio buf

- (int) AddOneFrameIntoAudioBuf:(char *) pData dataSize:(int) nDataSize
{
    [m_LockForAudioBuf lock];
    if(nil == m_pAudioBuf)
    {
        [m_LockForAudioBuf unlock];
        return  -1;
    }
    if(m_pAudioBuf && !m_pAudioBuf->IsBufCreateSucceed())
    {
        [m_LockForAudioBuf unlock];
        return -2;
    }
    int nRet = m_pAudioBuf->Write((void*)pData, nDataSize);
    if(nRet<= 0)
    {
        [m_LockForAudioBuf unlock];
        return 0;
    }
    [m_LockForAudioBuf unlock];
    return nRet;
}

- (int) GetAndRemoveOneFrameFromAudioBuf:(char **) pbuf
{
    [m_LockForAudioBuf lock];
    if(nil == m_pAudioBuf)
    {
        [m_LockForAudioBuf unlock];
        return  -1;
    }
    if(m_pAudioBuf && !m_pAudioBuf->IsBufCreateSucceed())
    {
        [m_LockForAudioBuf unlock];
        return -2;
    }
    STREAM_HEAD avHead;
    memset(&avHead, 0, sizeof(avHead));
    int nRet=m_pAudioBuf->ReadByPeer(&avHead, sizeof(STREAM_HEAD));
    if(nRet>0 && avHead.nStreamDataLen<(UINT32)m_pAudioBuf->GetStock()){
        *pbuf = new char[sizeof(avHead)+avHead.nStreamDataLen];
        if(NULL == *pbuf)
        {
            [m_LockForAudioBuf unlock];
            return -3;
        }
        nRet=m_pAudioBuf->Read(*pbuf, sizeof(STREAM_HEAD)+avHead.nStreamDataLen);
        if(nRet == 0)
        {
            delete []*pbuf;
            *pbuf = NULL;
            [m_LockForAudioBuf unlock];
            return -4;
        }
    }
    else
    {
        nRet=0;
    }
    [m_LockForAudioBuf unlock];
    return nRet;
}

- (char* ) GetAndRemoveOneFrameFromAudioBufWithLenth:(int &) nLen outStreamHead:(STREAM_HEAD &) videobufhead
{
    [m_LockForAudioBuf lock];
    if(nil == m_pAudioBuf)
    {
        [m_LockForAudioBuf unlock];
        return NULL;
    }
    if(m_pAudioBuf && !m_pAudioBuf->IsBufCreateSucceed())
    {
        [m_LockForAudioBuf unlock];
        return NULL;
    }
    STREAM_HEAD avHead;
    memset(&avHead, 0, sizeof(avHead));
    char *pTempbuf = NULL;
    int nRet=m_pAudioBuf->ReadByPeer(&avHead, sizeof(STREAM_HEAD));
    if(nRet>0 && avHead.nStreamDataLen<(UINT32)m_pAudioBuf->GetStock()){
        pTempbuf = new char[sizeof(avHead)+avHead.nStreamDataLen];
        if(NULL == pTempbuf)
        {
            [m_LockForAudioBuf unlock];
            return NULL;
        }
        nRet=m_pAudioBuf->Read(pTempbuf, sizeof(STREAM_HEAD)+avHead.nStreamDataLen);
        if(nRet == 0)
        {
            delete []pTempbuf;
            pTempbuf = NULL;
            nLen  = 0;
            [m_LockForAudioBuf unlock];
            return pTempbuf;
        }
        else
        {
            nLen=nRet-sizeof(STREAM_HEAD);
            memcpy((char*)&videobufhead, (char*)&avHead, sizeof(STREAM_HEAD));
            memcpy((char*)pTempbuf, (char*)pTempbuf+sizeof(STREAM_HEAD), avHead.nStreamDataLen);
        }
    }
    else
    {
        nLen  = 0;
        nRet=0;
    }
    [m_LockForAudioBuf unlock];
    return pTempbuf;
}

- (int) ResetTheAudioBuf
{
    [m_LockForAudioBuf lock];
    if(nil == m_pAudioBuf)
    {
        [m_LockForAudioBuf unlock];
        return NULL;
    }
    if(m_pAudioBuf && !m_pAudioBuf->IsBufCreateSucceed())
    {
        [m_LockForAudioBuf unlock];
        return NULL;
    }
    m_pAudioBuf->Reset();
    [m_LockForAudioBuf unlock];
    return 1;
}


// playback stream audio buf

- (int) AddOneFrameIntoRemoteRecordAudioBuf:(char *) pData dataSize:(int) nDataSize
{
    [m_LockForRemoteAudioBuf lock];
    if(nil == m_pRemoteRecordPlayBackAudioBuf)
    {
        [m_LockForRemoteAudioBuf unlock];
        return  -1;
    }
    if(m_pRemoteRecordPlayBackAudioBuf && !m_pRemoteRecordPlayBackAudioBuf->IsBufCreateSucceed())
    {
        [m_LockForRemoteAudioBuf unlock];
        return -2;
    }
    int nRet = m_pRemoteRecordPlayBackAudioBuf->Write((void*)pData, nDataSize);
    if(nRet<= 0)
    {
        [m_LockForRemoteAudioBuf unlock];
        return 0;
    }
    [m_LockForRemoteAudioBuf unlock];
    return nRet;
}

- (int) GetAndRemoveOneFrameFromRemoteRecordAudioBuf:(char **) pbuf
{
    [m_LockForRemoteAudioBuf lock];
    if(nil == m_pRemoteRecordPlayBackAudioBuf)
    {
        [m_LockForRemoteAudioBuf unlock];
        return  -1;
    }
    if(m_pRemoteRecordPlayBackAudioBuf && !m_pRemoteRecordPlayBackAudioBuf->IsBufCreateSucceed())
    {
        [m_LockForRemoteAudioBuf unlock];
        return -2;
    }
    STREAM_HEAD avHead;
    memset(&avHead, 0, sizeof(avHead));
    int nRet=m_pRemoteRecordPlayBackAudioBuf->ReadByPeer(&avHead, sizeof(STREAM_HEAD));
    if(nRet>0 && avHead.nStreamDataLen<(UINT32)m_pRemoteRecordPlayBackAudioBuf->GetStock()){
        *pbuf = new char[sizeof(avHead)+avHead.nStreamDataLen];
        if(NULL == *pbuf)
        {
            [m_LockForRemoteAudioBuf unlock];
            return -3;
        }
        nRet=m_pRemoteRecordPlayBackAudioBuf->Read(*pbuf, sizeof(STREAM_HEAD)+avHead.nStreamDataLen);
        if(nRet == 0)
        {
            delete []*pbuf;
            *pbuf = NULL;
            [m_LockForRemoteAudioBuf unlock];
            return -4;
        }
    }
    else
    {
        nRet=0;
    }
    [m_LockForRemoteAudioBuf unlock];
    return nRet;
}

- (char* ) GetAndRemoveOneFrameFromRemoteRecordAudioBufWithLenth:(int &) nLen outStreamHead:(STREAM_HEAD &) videobufhead
{
    [m_LockForRemoteAudioBuf lock];
    if(nil == m_pRemoteRecordPlayBackAudioBuf)
    {
        [m_LockForRemoteAudioBuf unlock];
        return NULL;
    }
    if(m_pRemoteRecordPlayBackAudioBuf && !m_pRemoteRecordPlayBackAudioBuf->IsBufCreateSucceed())
    {
        [m_LockForRemoteAudioBuf unlock];
        return NULL;
    }
    STREAM_HEAD avHead;
    memset(&avHead, 0, sizeof(avHead));
    char *pTempbuf = NULL;
    int nRet=m_pRemoteRecordPlayBackAudioBuf->ReadByPeer(&avHead, sizeof(STREAM_HEAD));
    if(nRet>0 && avHead.nStreamDataLen<(UINT32)m_pRemoteRecordPlayBackAudioBuf->GetStock()){
        pTempbuf = new char[sizeof(avHead)+avHead.nStreamDataLen];
        if(NULL == pTempbuf)
        {
            [m_LockForRemoteAudioBuf unlock];
            return NULL;
        }
        nRet=m_pRemoteRecordPlayBackAudioBuf->Read(pTempbuf, sizeof(STREAM_HEAD)+avHead.nStreamDataLen);
        if(nRet == 0)
        {
            delete []pTempbuf;
            pTempbuf = NULL;
            nLen  = 0;
            [m_LockForRemoteAudioBuf unlock];
            return pTempbuf;
        }
        else
        {
            nLen=nRet-sizeof(STREAM_HEAD);
            memcpy((char*)&videobufhead, (char*)&avHead, sizeof(STREAM_HEAD));
            memcpy((char*)pTempbuf, (char*)pTempbuf+sizeof(STREAM_HEAD), avHead.nStreamDataLen);
        }
    }
    else
    {
        nLen  = 0;
    }
    [m_LockForRemoteAudioBuf unlock];
    return pTempbuf;
}

//----{{20150924
- (int) GetOneFrameFromRemoteRecordAudioBufWithLenth:(int &) nLen outStreamHead:(STREAM_HEAD &) videobufhead
{
    [m_LockForRemoteAudioBuf lock];
    if(nil == m_pRemoteRecordPlayBackAudioBuf)
    {
        [m_LockForRemoteAudioBuf unlock];
        return NULL;
    }
    if(m_pRemoteRecordPlayBackAudioBuf && !m_pRemoteRecordPlayBackAudioBuf->IsBufCreateSucceed())
    {
        [m_LockForRemoteAudioBuf unlock];
        return NULL;
    }
    STREAM_HEAD avHead;
    memset(&avHead, 0, sizeof(avHead));
    int nRet=m_pRemoteRecordPlayBackAudioBuf->ReadByPeer(&avHead, sizeof(STREAM_HEAD));
    if(nRet>0 && avHead.nStreamDataLen<(UINT32)m_pRemoteRecordPlayBackAudioBuf->GetStock()){
        memcpy((char*)&videobufhead, (char*)&avHead, sizeof(STREAM_HEAD));
    }
    [m_LockForRemoteAudioBuf unlock];
    return nRet;
}
//----}}20150924

- (int) IsTheRemoteRecordAudioBufHasFrameNum:(int ) nFrameNum
{
    [m_LockForRemoteAudioBuf lock];
    if(nil == m_pRemoteRecordPlayBackAudioBuf)
    {
        [m_LockForRemoteAudioBuf unlock];
        return 0;
    }
    if(m_pRemoteRecordPlayBackAudioBuf && !m_pRemoteRecordPlayBackAudioBuf->IsBufCreateSucceed())
    {
        [m_LockForRemoteAudioBuf unlock];
        return 0;
    }
    STREAM_HEAD avHead;
    memset(&avHead, 0, sizeof(avHead));
    int nRet=m_pRemoteRecordPlayBackAudioBuf->ReadByPeer(&avHead, sizeof(STREAM_HEAD));
    int nTempDataSize = nFrameNum * (avHead.nStreamDataLen + sizeof(STREAM_HEAD));
    if(nRet>0 && nTempDataSize<(UINT32)m_pRemoteRecordPlayBackAudioBuf->GetStock()){
        [m_LockForRemoteAudioBuf unlock];
        return nRet;
    }
    else
    {
        nRet=0;
    }
    [m_LockForRemoteAudioBuf unlock];
    return nRet;
}


- (int) ResetTheRemoteRecordAudioBuf
{
    [m_LockForRemoteAudioBuf lock];
    if(nil == m_pRemoteRecordPlayBackAudioBuf)
    {
        [m_LockForRemoteAudioBuf unlock];
        return NULL;
    }
    if(m_pRemoteRecordPlayBackAudioBuf && !m_pRemoteRecordPlayBackAudioBuf->IsBufCreateSucceed())
    {
        [m_LockForRemoteAudioBuf unlock];
        return NULL;
    }
    m_pRemoteRecordPlayBackAudioBuf->Reset();
    [m_LockForRemoteAudioBuf unlock];
    return 1;
}


// talk stream talk buf

- (int) AddOneFrameIntoTalkBuf:(char *) pData dataSize:(int) nDataSize
{
    [m_LockForTalkBuf lock];
    if(nil == m_pTalkAudioBuf)
    {
        [m_LockForTalkBuf unlock];
        return  -1;
    }
    if(m_pTalkAudioBuf && !m_pTalkAudioBuf->IsBufCreateSucceed())
    {
        [m_LockForTalkBuf unlock];
        return -2;
    }
    int nRet = m_pTalkAudioBuf->Write((void*)pData, nDataSize);
    //NSLog(@"m_pRemoteRecordPlayBackAudioBuf->Write() ret=%d",nRet);
    if(nRet<= 0)
    {
        [m_LockForTalkBuf unlock];
        return 0;
    }
    [m_LockForTalkBuf unlock];
    return nRet;
}

- (int) GetAndRemoveOneFrameFromTalkBuf:(char **) pbuf
{
    [m_LockForTalkBuf lock];
    if(nil == m_pTalkAudioBuf)
    {
        [m_LockForTalkBuf unlock];
        return  -1;
    }
    if(m_pTalkAudioBuf && !m_pTalkAudioBuf->IsBufCreateSucceed())
    {
        [m_LockForTalkBuf unlock];
        return -2;
    }
    STREAM_HEAD avHead;
    memset(&avHead, 0, sizeof(avHead));
    int nRet=m_pTalkAudioBuf->ReadByPeer(&avHead, sizeof(STREAM_HEAD));
    if(nRet>0 && avHead.nStreamDataLen<(UINT32)m_pTalkAudioBuf->GetStock()){
        *pbuf = new char[sizeof(avHead)+avHead.nStreamDataLen];
        if(NULL == *pbuf)
        {
            [m_LockForTalkBuf unlock];
            return -3;
        }
        nRet=m_pTalkAudioBuf->Read(*pbuf, sizeof(STREAM_HEAD)+avHead.nStreamDataLen);
        if(nRet == 0)
        {
            delete []*pbuf;
            *pbuf = NULL;
            [m_LockForTalkBuf unlock];
            return -4;
        }
    }
    else
    {
        nRet=0;
    }
    [m_LockForTalkBuf unlock];
    return nRet;
}

- (char* ) GetAndRemoveOneFrameFromTalkBufWithLenth:(int &) nLen outStreamHead:(STREAM_HEAD &) videobufhead
{
    [m_LockForTalkBuf lock];
    if(nil == m_pTalkAudioBuf)
    {
        [m_LockForTalkBuf unlock];
        return NULL;
    }
    if(m_pTalkAudioBuf && !m_pTalkAudioBuf->IsBufCreateSucceed())
    {
        [m_LockForTalkBuf unlock];
        return NULL;
    }
    STREAM_HEAD avHead;
    memset(&avHead, 0, sizeof(avHead));
    char *pTempbuf = NULL;
    int nRet=m_pTalkAudioBuf->ReadByPeer(&avHead, sizeof(STREAM_HEAD));
    //NSLog(@"m_pRemoteRecordPlayBackVideoBuf->ReadByPeer() nRet=%d, streamDataLen=%d, stock=%d",nRet,avHead.nStreamDataLen, m_pRemoteRecordPlayBackAudioBuf->GetStock());
    if(nRet>0 && avHead.nStreamDataLen<(UINT32)m_pTalkAudioBuf->GetStock()){
        pTempbuf = new char[sizeof(avHead)+avHead.nStreamDataLen];
        if(NULL == pTempbuf)
        {
            [m_LockForTalkBuf unlock];
            return NULL;
        }
        nRet=m_pTalkAudioBuf->Read(pTempbuf, sizeof(STREAM_HEAD)+avHead.nStreamDataLen);
        //NSLog(@"m_pRemoteRecordPlayBackAudioBuf->Read() ret=%d",nRet);
        if(nRet == 0)
        {
            delete []pTempbuf;
            pTempbuf = NULL;
            nLen  = 0;
            [m_LockForTalkBuf unlock];
            return pTempbuf;
        }
        else
        {
            nLen=nRet-sizeof(STREAM_HEAD);
            memcpy((char*)&videobufhead, (char*)&avHead, sizeof(STREAM_HEAD));
            memcpy((char*)pTempbuf, (char*)pTempbuf+sizeof(STREAM_HEAD), avHead.nStreamDataLen);
        }
    }
    else
    {
        nLen  = 0;
    }
    [m_LockForTalkBuf unlock];
    return pTempbuf;
}

- (int) IsTheTalkBufHasFrameNum:(int ) nFrameNum
{
    [m_LockForTalkBuf lock];
    if(nil == m_pTalkAudioBuf)
    {
        [m_LockForTalkBuf unlock];
        return 0;
    }
    if(m_pTalkAudioBuf && !m_pTalkAudioBuf->IsBufCreateSucceed())
    {
        [m_LockForTalkBuf unlock];
        return 0;
    }
    STREAM_HEAD avHead;
    memset(&avHead, 0, sizeof(avHead));
    int nRet=m_pTalkAudioBuf->ReadByPeer(&avHead, sizeof(STREAM_HEAD));
    //NSLog(@"m_pRemoteRecordPlayBackVideoBuf->ReadByPeer() nRet=%d, streamDataLen=%d, stock=%d",nRet,avHead.nStreamDataLen, m_pRemoteRecordPlayBackAudioBuf->GetStock());
    int nTempDataSize = nFrameNum * (avHead.nStreamDataLen + sizeof(STREAM_HEAD));
    if(nRet>0 && nTempDataSize<(UINT32)m_pTalkAudioBuf->GetStock()){
        [m_LockForTalkBuf unlock];
        return nRet;
    }
    else
    {
        nRet=0;
    }
    [m_LockForTalkBuf unlock];
    return nRet;
}

- (int) ResetTheTalkBuf
{
    [m_LockForTalkBuf lock];
    if(nil == m_pTalkAudioBuf)
    {
        [m_LockForTalkBuf unlock];
        return NULL;
    }
    if(m_pTalkAudioBuf && !m_pTalkAudioBuf->IsBufCreateSucceed())
    {
        [m_LockForTalkBuf unlock];
        return NULL;
    }
    m_pTalkAudioBuf->Reset();
    [m_LockForTalkBuf unlock];
    return 1;
}

#pragma mark --- read the circle buf }}


@end
