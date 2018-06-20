#import "KYLCamera.h"
#import "KYLCameraMonitor.h"
#import "CPCQRReader.h"
#import "CPCCameraWifi.h"
#import "KYLSearchTool.h"

@interface CPCCameraPlugin : CDVPlugin <AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
    NSString *videoTapCallbackId;
}


@property (strong, nonatomic) NSArray *originalSupportedOrientations;

@property (nonatomic, retain) NSMutableDictionary *cameras;
@property (nonatomic, retain) UIImageView *videoView;
@property (nonatomic, retain) UIImageView *moveUpView;
@property (nonatomic, retain) UIImageView *moveDownView;
@property (nonatomic, retain) UIImageView *moveLeftView;
@property (nonatomic, retain) UIImageView *moveRightView;
@property (nonatomic, retain) UIImageView *exitVideoView;
@property (nonatomic, retain) UIImageView *audioView;
@property (nonatomic, retain) UIImageView *talkView;
@property (nonatomic, retain) UIImageView *greyFrameView;
@property (nonatomic, retain) UIImageView *greyFrameViewTop;

@property (retain, nonatomic) NSString *commandDid;
@property (nonatomic, retain) KYLCamera *m_pCamera;
@property (nonatomic, retain) KYLCameraMonitor *pCameraMonitor;
@property (nonatomic, retain)  UIImageView *imgViewShowVideo;
@property (nonatomic, assign) IBOutlet id<KYLMontiorTouchProtocol> delegate;
@property(null_resettable, nonatomic,strong) UIView *view;
@property(nonatomic, retain) NSString* isAudio;
@property(nonatomic, retain) NSString* isTalk;
@property(nonatomic, retain) NSString* cameraName;
@property (nonatomic) CPCQRReader *qrReader;
@property (nonatomic) CPCCameraWifi *cameraWifi;
@property (nonatomic, retain) NSMutableArray *m_listAllSearchDevice;
@property (nonatomic, retain) KYLSearchTool *m_pSearchTool;
@property (nonatomic, retain) NSMutableArray *lanCameraArray;
@property (nonatomic, retain) UILabel *cameraNameTxt;

@property(nonatomic, retain) UILongPressGestureRecognizer* longUp;
@property(nonatomic, retain) UILongPressGestureRecognizer* longDown;
@property(nonatomic, retain) UILongPressGestureRecognizer* longLeft;
@property(nonatomic, retain) UILongPressGestureRecognizer* longRight;


- (void)screenOrientation:(CDVInvokedUrlCommand *)command;
- (void)get_version:(CDVInvokedUrlCommand *)command;
- (void)connect:(CDVInvokedUrlCommand *)command;
- (void)disconnect:(CDVInvokedUrlCommand *)command;
- (void)move_stop:(CDVInvokedUrlCommand *)command;
- (void)move_up:(CDVInvokedUrlCommand *)command;
- (void)move_down:(CDVInvokedUrlCommand *)command;
- (void)move_left:(CDVInvokedUrlCommand *)command;
- (void)move_right:(CDVInvokedUrlCommand *)command;
- (void)video_stream_start:(CDVInvokedUrlCommand *)command;
- (void)video_stream_stop:(CDVInvokedUrlCommand *)command;
- (void)send_wifi_setup:(CDVInvokedUrlCommand *)command;
- (void)scan_qr:(CDVInvokedUrlCommand *)command;
- (void)check_camera_status:(CDVInvokedUrlCommand *)command;
- (void)start_lan_search:(CDVInvokedUrlCommand *)command;

- (void)recording_start:(CDVInvokedUrlCommand *)command;
- (void)recording_stop:(CDVInvokedUrlCommand *)command;
- (void)register_video_click_callback:(CDVInvokedUrlCommand *)command;
- (void)unregister_video_click_callback:(CDVInvokedUrlCommand *)command;

- (void)processStatus:(int)status withCallbackId:(NSString *)callbackId;
- (id)getCamera:(NSString *)did;
- (void)showVideo;
- (void)hideVideo;
- (void)setCommands;
- (void)videoViewTapHandler:(UITapGestureRecognizer *)recognizer;
- (void)moveUpTap:(UITapGestureRecognizer *)recognizer;
- (void)moveDownTap:(UITapGestureRecognizer *)recognizer;
- (void)moveLeftTap:(UITapGestureRecognizer *)recognizer;
- (void)moveRightTap:(UITapGestureRecognizer *)recognizer;
- (void)exitVideoTap:(UITapGestureRecognizer *)recognizer;

@end

