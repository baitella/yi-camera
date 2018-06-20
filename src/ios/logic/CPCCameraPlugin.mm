#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
#import "CPCCameraPlugin.h"
#import "KYLCamera.h"
#import "SEP2P_API.h"
#import "SEP2P_Type.h"
#import "SEP2P_Define.h"
#import "SEP2P_Error.h"
#import <AVFoundation/AVFoundation.h>

@protocol KYLSearchProtocol <NSObject>

@optional
- (void) didSucceedSearchOneDevice: (NSString *) chDID ip:(NSString *) ip port:(int) port devName:(NSString *) devName macaddress:(NSString *) mac productType:(NSString *) productType;

@end


AVAudioRecorder *recorder;

#import <Cordova/CDVViewController.h>

@interface CDVViewController (UpdateSupportedOrientations)

- (void)updateSupportedOrientations:(NSArray *)orientations;

@end

#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVViewController.h>

@interface YoikScreenOrientation : CDVPlugin

- (void)screenOrientation:(CDVInvokedUrlCommand *)command;
@property (strong, nonatomic) NSArray *originalSupportedOrientations;

@end

@interface ForcedViewController : UIViewController

@property (strong, nonatomic) NSString *calledWith;

@end

@implementation CPCCameraPlugin
@synthesize m_pCamera;
@synthesize  imgViewShowVideo;
@synthesize delegate;


- (int ) startSearch
{
    int m_iRet = SEP2P_StartSearch(OnLANSearchCallback, self);
    if (m_iRet==ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"%s the function: startSearchAllCameraInLAN() excute succeed", __FILE__);
    }
    else
    {
        NSLog(@"%s the function: startSearchAllCameraInLAN() excute failed", __FILE__);
    }
    return m_iRet;
}


/*!
 @method
 @abstract stopSearch.
 @discussion stop search all device in LAN network.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */
- (int) stopSearch
{
    int m_iRet = SEP2P_StopSearch();;
    if (m_iRet==ERR_SEP2P_SUCCESSFUL) {
        NSLog(@"%s the function: stopSearch() excute succeed", __FILE__);
    }
    else
    {
        NSLog(@"%s the function: stopSearch() excute failed", __FILE__);
    }
    
    return m_iRet;
}


/*!
 @method
 @abstract OnLANSearchCallback.
 @discussion The static function used for received the LAN network search result call back.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */

static INT32 OnLANSearchCallback(
                                 CHAR*  pData,
                                 UINT32  nDataSize,
                                 VOID*  pUserData)
{
    NSLog(@"OnLANSearchCallback ---");
    KYLSearchTool *pThis = (KYLSearchTool *) pUserData;
    [pThis didReceivedLanSearchCallBack:pData dataSize:nDataSize];
    return 0L;
}



/*!
 @method
 @abstract didReceivedLanSearchCallBack.
 @discussion didReceivedLanSearchCallBack:(CHAR *) pData dataSize:(UINT32) nDataSizeÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂÄÂĂÂÄÂĂÂĂÂĂÂÄÂĂÂ The  function used for deal with the result from call back function, it return the result to the object that implement the delegate.
 @null .
 */

- (void) didReceivedLanSearchCallBack:(CHAR *) pData dataSize:(UINT32) nDataSize
{
    SEARCH_RESP *pSearchResp=(SEARCH_RESP *)pData;
    NSString *strIP = [[NSString alloc] initWithCString:pSearchResp->szIpAddr encoding:NSUTF8StringEncoding];
    NSString *strDID = [[NSString alloc] initWithCString:pSearchResp->szDeviceID encoding:NSUTF8StringEncoding];
    NSString *strMac = [[NSString alloc] initWithCString:pSearchResp->szMacAddr encoding:NSUTF8StringEncoding];
    NSString *strDevName = [[NSString alloc] initWithCString:pSearchResp->szDevName encoding:NSUTF8StringEncoding];
    NSString *strProductType = [[NSString alloc] initWithCString:pSearchResp->product_type encoding:NSUTF8StringEncoding];
    int port = pSearchResp->nPort;
    NSLog(@"search one device DID =%@, IP = %@, mac=%@, devname=%@, producttype=%@",strDID, strIP,strMac,strDevName, strProductType);
    
    
    NSLog(@"lancamera array --------> %lu", [self.lanCameraArray containsObject:strDID]);
    if (strDID) {
        if ([self.lanCameraArray containsObject:strDID] == 0) {
            NSLog(@"add ip in array ============> %@ " , strDID);
            [self.lanCameraArray addObject:strDID];
             
        }
    }
    
    if (delegate && [delegate respondsToSelector:@selector(didSucceedSearchOneDevice:ip:port:devName:macaddress:productType:)])
    {
//        [KYLSearchProtocol.didSucceedSearchOneDevice:strDID ip:strIP port:port devName:strDevName macaddress:strMac productType:strProductType];
    }
    
    [strIP release];
    [strDID release];
    [strMac release];
    [strDevName release];
    [strProductType release];
}




- (void)pluginInitialize
{
    [super pluginInitialize];
    self.isAudio = @"false";
    videoTapCallbackId = nil;
    NSLog(@"Setting up camera ");
    self.m_pCamera = [[[KYLCamera alloc] init] autorelease];
    ST_InitStr init_str;
    memset(&init_str, 0, sizeof(init_str));
    strcpy(init_str.chInitStr, "EBGDEKBKKHJLGHJIEJGEFGEBHHNNHKNGHGFMBACGAAJELKLBDNAICGOKGMLJJDLPALMLLMDIODMFBPCIJLMP");
    strcpy(init_str.chPrefix, "VIEW");
    INT32 nRet = SEP2P_Initialize(&init_str, 1);
    INT32 audioRet = [self.m_pCamera startAudio];
    INT32 talkRet = [self.m_pCamera startTalk];
    if (audioRet < 0)
    {
        self.isAudio = @"false";
    }

    if (talkRet < 0)
    {
        self.isTalk = @"false";
    }
    self.lanCameraArray = [[NSMutableArray alloc] init];
    self.m_pSearchTool = nil;
    self.m_listAllSearchDevice = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    if (nil == self.m_pSearchTool)
    {
        self.m_pSearchTool = [[KYLSearchTool alloc] init];
        //        self.m_pSearchTool.delegate = self;
    }
    
    
    self.cameraWifi = [[CPCCameraWifi alloc] init];
    [self.cameraWifi initialize];
    self.qrReader = [[CPCQRReader alloc] initWithView:self.webView.superview];
}

- (void) initTheCameraMonitor
{
    // show the video image
    
    self.videoView = [[UIImageView alloc] init];
    
    [self.videoView setBackgroundColor:[UIColor blackColor]];
    [self.videoView setHidden:YES];
    self.videoView.layer.zPosition = 0;
    [self.videoView setUserInteractionEnabled:YES];
    [self.videoView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.videoView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self
                                             action:@selector(videoViewTapHandler:)
      ]
     ];
    
    
    [self.webView.superview addSubview:self.videoView];
    [self setCommands];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIImageView *imgVideo=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    imgVideo.backgroundColor = [UIColor blackColor];
    self.imgViewShowVideo = imgVideo;
    
    self.pCameraMonitor = [[[KYLCameraMonitor alloc] initWithFrame:self.imgViewShowVideo.frame] autorelease];
    self.pCameraMonitor.m_pCameraObj = self.m_pCamera;
    [self.videoView addSubview:self.pCameraMonitor];
    [self.videoView setHidden:YES];
    //    self.pCameraMonitor.delegate = self;
    self.pCameraMonitor.userInteractionEnabled = YES;
    
}

- (void)send_wifi_setup:(CDVInvokedUrlCommand *)command
{
    NSLog(@"send wifi setup");
    [self.cameraWifi serializeToAir:command.arguments[0]
                       withPassword:command.arguments[1]
                        andSecurify:6];
    [self lan_search:command.callbackId];
}

-(void)start_lan_search:(CDVInvokedUrlCommand *)command
{
    [self lan_search:command.callbackId];
}

-(void)lan_search:(NSString *)callbackId
{
    [self startSearch];

    double delayInSeconds2 = 1.5;
    
    dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds2 * NSEC_PER_SEC));
    dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
        [self lanDiscovery:callbackId];
    });
    
    double delayInSeconds3 = 2.0;
    
    dispatch_time_t popTime3 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds3 * NSEC_PER_SEC));
    dispatch_after(popTime3, dispatch_get_main_queue(), ^(void){
        [self.lanCameraArray removeAllObjects];
        [self stopSearch];
    });
}

- (void)lanDiscovery:(NSString *)callbackId
{
   
    NSLog(@"lanDiscovery callback");
    [self.commandDelegate runInBackground:^{
        
        CDVPluginResult* pluginResult = nil;
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:self.lanCameraArray];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
        
    }];
}

- (void)setCommands
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGFloat startOffset = ((screenWidth - ((7*50)+(7*10)))/2);
    
    UIColor* color = [UIColor colorWithRed:(23/255.0) green:(23/255.0) blue:(23/255.0) alpha:0.6];
    
    self.greyFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.webView.bounds) - 50, screenWidth,screenHeight)];
    self.greyFrameView.backgroundColor = color;
    [self.greyFrameView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];

    self.greyFrameViewTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth,50)];
    self.greyFrameViewTop.backgroundColor = color;
    [self.greyFrameViewTop setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];

    UILabel *cameraNameTxt = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenWidth, 50)];
    self.cameraNameTxt = cameraNameTxt;
    self.cameraNameTxt.textAlignment = NSTextAlignmentCenter;
    self.cameraNameTxt.textColor = [UIColor whiteColor];
    self.cameraNameTxt.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    self.cameraNameTxt.backgroundColor=[UIColor colorWithRed:0. green:0.39 blue:0.106 alpha:0.];
    if (self.cameraName){
        self.cameraNameTxt.text = self.cameraName;
    }else{
        self.cameraNameTxt.text = @"Basic camera";
    }
    
    UIImage * upImage = [UIImage imageNamed: @"up.png"];
    self.moveUpView = [[UIImageView alloc] initWithImage:upImage];
    self.moveUpView.frame = CGRectMake(startOffset, CGRectGetHeight(self.webView.bounds) - 50, 50,50);
    [self.moveUpView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    
    self.longUp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveUpTap:)];
    self.longUp.minimumPressDuration = 0;
    [self.moveUpView addGestureRecognizer:self.longUp];
    [self.moveUpView setUserInteractionEnabled:YES];
    
    UIImage * downImage = [UIImage imageNamed: @"down.png"];
    self.moveDownView = [[UIImageView alloc] initWithImage:downImage];
    self.moveDownView.frame = CGRectMake(startOffset + 60, CGRectGetHeight(self.webView.bounds) - 50, 50,50);
    [self.moveDownView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    self.longDown = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveDownTap:)];
    self.longDown.minimumPressDuration = 0;
    [self.moveDownView addGestureRecognizer:self.longDown];
    [self.moveDownView setUserInteractionEnabled:YES];
    
    UIImage * leftImage = [UIImage imageNamed: @"left.png"];
    self.moveLeftView = [[UIImageView alloc] initWithImage:leftImage];
    self.moveLeftView.frame = CGRectMake(startOffset + 120, CGRectGetHeight(self.webView.bounds) - 50, 50,50);
    [self.moveLeftView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    self.longLeft = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveLeftTap:)];
    self.longLeft.minimumPressDuration = 0;
    [self.moveLeftView addGestureRecognizer:self.longLeft];
    [self.moveLeftView setUserInteractionEnabled:YES];
    
    UIImage * rightImage = [UIImage imageNamed: @"right.png"];
    self.moveRightView = [[UIImageView alloc] initWithImage:rightImage];
    self.moveRightView.frame = CGRectMake(startOffset + 180, CGRectGetHeight(self.webView.bounds) - 50, 50,50);
    [self.moveRightView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    self.longRight = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveRightTap:)];
    self.longRight.minimumPressDuration = 0;
    [self.moveRightView addGestureRecognizer:self.longRight];
    [self.moveRightView setUserInteractionEnabled:YES];
    
    // if ([isAudio == @"true"]){
    //     UIImage * audioImage = [UIImage imageNamed: @"sound.png"];
    // }else{
        UIImage * audioImage = [UIImage imageNamed: @"soundoff.png"];
    // }
    self.audioView = [[UIImageView alloc] initWithImage:audioImage];
    self.audioView.frame = CGRectMake(startOffset + 240, CGRectGetHeight(self.webView.bounds) - 50, 50,50);
    [self.audioView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [self.audioView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self
                                             action:@selector(audioTap:)]];
    [self.audioView setUserInteractionEnabled:YES];
    
    // if ([self.isTalk isEqual: @"true"]){
    //     UIImage * audioImage = [UIImage imageNamed: @"micon.png"];
    // }else{
        UIImage * micImage = [UIImage imageNamed: @"micoff.png"];
    // }
    self.talkView = [[UIImageView alloc] initWithImage:micImage];
    self.talkView.frame = CGRectMake(startOffset + 300, CGRectGetHeight(self.webView.bounds) - 50, 50,50);
    [self.talkView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [self.talkView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self
                                             action:@selector(startTalkTap:)]];
    [self.talkView setUserInteractionEnabled:YES];
    
    UIImage * quitImage = [UIImage imageNamed: @"quit.png"];
    self.exitVideoView = [[UIImageView alloc] initWithImage:quitImage];
    self.exitVideoView.frame = CGRectMake(30, 0, 50,50);
    [self.exitVideoView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [self.exitVideoView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self
                                             action:@selector(exitVideoTap:)]];
    [self.exitVideoView setUserInteractionEnabled:YES];
    
    [self.webView.superview addSubview:self.greyFrameView];
    [self.webView.superview addSubview:self.greyFrameViewTop];
    [self.webView.superview addSubview:self.cameraNameTxt];
    [self.webView.superview addSubview:self.moveUpView];
    [self.webView.superview addSubview:self.moveDownView];
    [self.webView.superview addSubview:self.moveLeftView];
    [self.webView.superview addSubview:self.moveRightView];
    [self.webView.superview addSubview:self.exitVideoView];
    [self.webView.superview addSubview:self.audioView];
    [self.webView.superview addSubview:self.talkView];
    
    [self.greyFrameView setHidden:YES];
    [self.greyFrameViewTop setHidden:YES];
    [self.cameraNameTxt setHidden:YES];
    [self.moveUpView setHidden:YES];
    [self.moveDownView setHidden:YES];
    [self.moveLeftView setHidden:YES];
    [self.moveRightView setHidden:YES];
    [self.exitVideoView setHidden:YES];
    [self.audioView setHidden:YES];
    [self.talkView setHidden:YES];
}

- (void)get_version:(CDVInvokedUrlCommand *)command
{
    char desc[256] = {0};
    
    UINT32 status = SEP2P_GetSDKVersion(desc, sizeof(desc));
    
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                messageAsInt:status]
                                callbackId:command.callbackId];
}

- (void)showVideo
{
    if (nil == self.m_pCamera) {
        return;
    }
    int nRet = -1;
    if ([self.m_pCamera.onlineCameras containsString:self.m_pCamera.m_sDID]) {
        NSLog(@"string does  contain bla");
        
    } else {
       
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tips" message:@"You should make sure connected to device first!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        [self.videoView setHidden:YES];
        [self.m_pCamera stopVideo];
        [self changeOrientation:@"portrait"];
        return;
    }
    
    nRet = [self.pCameraMonitor startVideo];
    [self.greyFrameView setHidden:NO];
    [self.greyFrameViewTop setHidden:NO];
    [self.cameraNameTxt setHidden:NO];
    [self.moveUpView setHidden:NO];
    [self.moveDownView setHidden:NO];
    [self.moveLeftView setHidden:NO];
    [self.moveRightView setHidden:NO];
    [self.exitVideoView setHidden:NO];
    [self.audioView setHidden:NO];
    [self.talkView setHidden:NO];
    [self.videoView setHidden:NO];
}

- (void)check_camera_status:(CDVInvokedUrlCommand* )command
{
    // [self processStatus:self.m_pCamera.onlineCameras  withCallbackId:command.callbackId]; 
    
    NSString *did = command.arguments[0]; 
    self.m_pCamera.m_sDID = did;

    CDVPluginResult* pluginResult = nil;
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:self.m_pCamera.onlineCameras];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    
}

- (void)processStatus:(int)status withCallbackId:(NSString *)callbackId
{
    CDVCommandStatus cmdStatus;
    
    if (status < 0) {
        cmdStatus = CDVCommandStatus_ERROR;
    }
    else {
        cmdStatus = CDVCommandStatus_OK;
    }
    
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:cmdStatus
                                                                messageAsInt:status]
                                callbackId:callbackId];
}



- (void)video_stream_start:(CDVInvokedUrlCommand *)command
{
    
    if ([self.isAudio isEqual: @"true"]){
        UIImage * audioImage = [UIImage imageNamed: @"sound.png"];
        [self.audioView setImage:audioImage];

    }else{
        UIImage * audioImage = [UIImage imageNamed: @"soundoff.png"];
        [self.audioView setImage:audioImage];
    }
    if ([self.isTalk isEqual: @"true"]){
        UIImage * micImage = [UIImage imageNamed: @"micon.png"];
        [self.talkView setImage:micImage];
    }else{
        UIImage * micImage = [UIImage imageNamed: @"micoff.png"];
        [self.talkView setImage:micImage];
    }
    [self changeOrientation:@"landscape"];

    
}

- (void)connect:(CDVInvokedUrlCommand *)command
{
    NSString *did = command.arguments[0];
    NSString *username = command.arguments[1];
    NSString *password = command.arguments[2];
    NSString *cammName = command.arguments[3];
    self.m_pCamera.m_sDID = did;
    self.m_pCamera.m_sUsername = username;
    self.m_pCamera.m_sPassword = password;
    NSLog(@"camera name -111------> %@", cammName);
    self.cameraName = cammName;
    NSLog(@"begin connecting!");
    // [self.m_pCamera connect];
    
    int ret = [self.m_pCamera connect];
    if (ret == 0) {
        NSLog(@"connected ok!");
    }
    
    [self processStatus:ret  withCallbackId:command.callbackId];
    
}

- (void)disconnect:(CDVInvokedUrlCommand *)command
{
    NSString *did = command.arguments[0];
    NSString *username = command.arguments[1];
    NSString *password = command.arguments[2];
    self.m_pCamera.m_sDID = did;
    self.m_pCamera.m_sUsername = username;
    self.m_pCamera.m_sPassword = password;
    NSLog(@"begin dissconecting!");
    [self.m_pCamera stopAudio];
    [self.m_pCamera stopTalk];
    [self.m_pCamera stopVideo];
    int ret = [self.m_pCamera disconnect];
    if (ret == 0) {
        NSLog(@"disconnect ok!");
    }
    
    [self processStatus:ret  withCallbackId:command.callbackId];
    
}


- (void)startTalk
{
    [self.m_pCamera startTalk];
    NSLog(@"start talk");
    
}

- (void)startAudio
{
    [self.m_pCamera startAudio];
    NSLog(@"start audio");
}


- (void)moveUpTap:(UILongPressGestureRecognizer *)recognizer
{
    
    NSLog(@"move up %@ ", recognizer);
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        [self.m_pCamera up];
    }
    //as you release the button this would fire
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        [self.m_pCamera stopPTZGo];
    }
    
}

- (void)moveDownTap:(UILongPressGestureRecognizer *)recognizer
{
    NSLog(@"move down %@ ", recognizer);
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self.m_pCamera down];
    //as you release the button this would fire
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        [self.m_pCamera stopPTZGo];
    }
    
    
}

- (void)moveLeftTap:(UILongPressGestureRecognizer *)recognizer
{
    NSLog(@"move left ");

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        [self.m_pCamera left];
    }
    
    //as you release the button this would fire
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        [self.m_pCamera stopPTZGo];
    }
    
}

- (void)moveRightTap:(UILongPressGestureRecognizer *)recognizer
{

        NSLog(@"move right:");
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        [self.m_pCamera right];
    }
    
    //as you release the button this would fire
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        [self.m_pCamera stopPTZGo];
    }
}

- (void)audioTap:(UITapGestureRecognizer *)recognizer
{
    UIImage *imgAudio = [UIImage imageNamed: @"sound.png"];
    UIImage *imgNotAudio = [UIImage imageNamed: @"soundoff.png"];
    if ([self.isAudio  isEqual: @"true"]) {
        NSLog(@"stop audio:");
        [self.m_pCamera stopAudio];
        self.isAudio = @"false";
        [self.audioView setImage:imgNotAudio];
    }else{
        [self.m_pCamera startAudio];
        self.isAudio = @"true";
        [self.audioView setImage:imgAudio];
        NSLog(@"start audio:");
    }
}

- (void)startTalkTap:(UITapGestureRecognizer *)recognizer
{
    UIImage *imgTalking = [UIImage imageNamed: @"micon.png"];
    UIImage *imgNotTalking = [UIImage imageNamed: @"micoff.png"];
    if ([self.isTalk  isEqual: @"true"]) {
        NSLog(@"stop Talk:");
        [self.m_pCamera stopTalk];
        self.isTalk = @"false";
        [self.talkView setImage:imgNotTalking];
    }else{
        [self.m_pCamera startTalk];
        self.isTalk = @"true";
        [self.talkView setImage:imgTalking];
        NSLog(@"start Talk:");
    }
}


- (void)exitVideoTap:(UITapGestureRecognizer *)recognizer
{
    
    [self changeOrientation:@"portrait"];
}

- (void)scan_qr:(CDVInvokedUrlCommand *)command
{
    QRReaderFailBlock fblock = ^{
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR]
                                    callbackId:command.callbackId];
    };
    QRReaderSuccessBlock sblock = ^(NSString *msg) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                 messageAsString:msg]
                                    callbackId:command.callbackId];
    };
    
    [self.qrReader startReadingWithFailBlock:fblock
                             andSuccessBlock:sblock];
}


- (void) exitVideo
{
    
    NSLog(@"exit video");
    [self.m_pCamera stopAudio];
    [self.m_pCamera stopTalk];
    [self.m_pCamera stopVideo];
    
    [self.greyFrameView setHidden:YES];
    [self.greyFrameViewTop setHidden:YES];
    [self.cameraNameTxt setHidden:YES];
    [self.moveUpView setHidden:YES];
    [self.moveDownView setHidden:YES];
    [self.moveLeftView setHidden:YES];
    [self.moveRightView setHidden:YES];
    [self.exitVideoView setHidden:YES];
    [self.audioView setHidden:YES];
    [self.talkView setHidden:YES];
    [self.videoView setHidden:YES];
}

- (void) enterVideo
{
    [self initTheCameraMonitor];
    [self.videoView setHidden:NO];
    [self showVideo];
}


- (void)changeOrientation:(NSString *) orientation
{
    
    ForcedViewController *vc = [[ForcedViewController alloc] init];
    vc.calledWith = orientation;
    
    
    // backgound should be transparent as it is briefly visible
    // prior to closing.
    vc.view.backgroundColor = [UIColor clearColor];
    // vc.view.alpha = 0.0;
    vc.view.opaque = YES;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    // This stops us getting the black application background flash, iOS8
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
#endif
    if ([orientation  isEqual: @"portrait"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.viewController presentViewController:vc animated:NO completion:^{[self exitVideo];}];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.viewController presentViewController:vc animated:NO completion:^{[self enterVideo];}];
        });
    }
    
}


@end

@implementation CDVViewController (UpdateSupportedOrientations)

- (void)updateSupportedOrientations:(NSArray *)orientations {
    
    [self setValue:orientations forKey:@"supportedOrientations"];
    
}

@end

@implementation ForcedViewController

-(void) viewDidAppear:(BOOL)animated {
    CDVViewController *presenter = (CDVViewController*)self.presentingViewController;
    
    if ([self.calledWith rangeOfString:@"portrait"].location != NSNotFound) {
        [presenter updateSupportedOrientations:@[[NSNumber numberWithInt:UIInterfaceOrientationPortrait]]];
        
    } else if([self.calledWith rangeOfString:@"landscape"].location != NSNotFound) {
        [presenter updateSupportedOrientations:@[[NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft], [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight]]];
    } else {
        [presenter updateSupportedOrientations:@[[NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft], [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight], [NSNumber numberWithInt:UIInterfaceOrientationPortrait]]];
    }
    [presenter dismissViewControllerAnimated:NO completion:nil];
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    if ([self.calledWith rangeOfString:@"portrait"].location != NSNotFound) {
        return UIInterfaceOrientationMaskPortrait;
    } else if([self.calledWith rangeOfString:@"landscape"].location != NSNotFound) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskAll;
}
@end