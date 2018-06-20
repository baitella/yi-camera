//
//  KYLDefine.h
//  P2PCamera
//
//
//

#import <Foundation/Foundation.h>

#import "SEP2P_Type.h"
#import "SEP2P_Define.h"
#import "SEP2P_Error.h"


#ifdef DEBUG
# define DebugLog(fmt, ...) NSLog((@"\n""[函数名:%s]\n""[行号:%d] \n\n" fmt),  __FUNCTION__, __LINE__, ##__VA_ARGS__);
# define DebugLog2(fmt, ...) NSLog((@"\n[文件名:%s]\n""[函数名:%s]\n""[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DebugLog(...);
#endif


#define KYL_BUTTON_START_RECORD_AUDIO_WIDTH (100)
#define KYL_BUTTON_START_RECORD_AUDIO_HEIGHT (100)

#define KYL_QUICK_START_HELP_VIDEO @"http://www.dbpower.co.uk/product/700GB.html" //指导视频地址
#define KYL_FACE_BOOK_URL @"https://www.facebook.com/DBPOWER.US"
#define KYL_CONTACT_US_URL @"http://www.dbpower.co.uk/" 
#define KYL_COUPON_URL @"http://www.dbpower.co.uk/"

#define KYL_DEFAULT_ACCOUNT @"admin" //默认用户名
#define KYL_DEFAULT_PASSWORD @"123456" //默认密码

#define KYL_NAV_BAR_BG_IMAGE ("icon_nav_back.png") 

#define STR_SPERATOR_FOR_DID_CHANNEL "__AND__"

#define KYL_MOVE_DETECTION_VIDEO_FRAME_MAX_WIDTH (1280)
#define KYL_MOVE_DETECTION_VIDEO_FRAME_MAX_HEIGHT (720)

//定义数据库名称，数据库表
#define DB_FILE_NAME "DB_ISMARTVIEWPRO" //数据库名称
#define DB_TBALE_NAME_CAMERA_INFO "TB_CAMERA_INFO" //设备信息表名
#define DB_TBALE_NAME_PIC_INFO "TB_PICTURE_INFO" //抓拍图片信息表名
#define DB_TBALE_NAME_REC_INFO "TB_RECORD_INFO" //本地录像信息表名
#define DB_TBALE_NAME_ALARM_LOG_INFO "TB_ALARM_LOG_INFO" //本地报警日志信息表名

//定义原来老的数据库名称，数据库表
#define OLD_DB_FILE_NAME "OBJ_P2P_CAMERA_DB" //数据库名称
#define OLD_DB_TBALE_NAME_CAMERA_INFO "OBJ_P2P_CAMERA_TBL" //设备信息表名
#define OLD_DB_TBALE_NAME_PIC_INFO "OBJ_P2P_PICPATH_TABLE" //抓拍图片信息表名
#define OLD_DB_TBALE_NAME_REC_INFO "OBJ_P2P_RECPATH_TABLE" //本地录像信息表名

#define KYL_MAX_SDCARD_RECORD_MONTH_NUM (12)

#define K_NavigationBar_Background_image @"top_bg_blue_2_44.png"

#define DEVICE_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define DEVICE_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define SYSTEM_DOCUMENT_PATH ( [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] )
#define SYSTEM_LIBRARY_CACHE_PATH ( [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] )

#define DEVICE_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define DEVICE_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define IS_IPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#define RELEASE_OBJECT(obj)  if(obj != nil) { [obj release]; obj = nil; }

#define KYL_CAMERA_COVER_IMAGE ("snapshot.jpg")

//定义自定义通知
#define KYL_NOTIFICATION_DEVICE_STATUS_CHANGE ("KYL_NOTIFICATION_DEVICE_STATUS_CHANGED")//设置状态改变
#define KYL_NOTIFICATION_SET_DEVICE_PASSWORD_SUCCEED ("KYL_NOTIFICATION_SET_DEVICE_PASSWORD_SUCCEED") //设置密码成功
#define KYL_NOTIFICATION_SUCCEED_GET_ONE_SNAP_IMAGE ("KYL_NOTIFICATION_SUCCEED_GET_ONE_SNAP_IMAGE")//成功获取到一张设备图片
#define KYL_NOTIFICATION_SUCCEED_REBOOT_DEVICE ("KYL_NOTIFICATION_SUCCEED_REBOOT_DEVICE")//成功重启设备
#define KYL_NOTIFICATION_RECEIVE_CAMERA_EVENT ("KYL_NOTIFICATION_RECEIVE_CAMERA_EVENT")//接收到事件通知


#define KYL_NOTIFICATION_RECEIVE_CAMERA_PUSH_FUNCTION_CHANGE ("KYL_NOTIFICATION_RECEIVE_CAMERA_PUSH_FUNCTION_CHANGE")//摄像机推送告警功能状态变化
#define KYL_NOTIFICATION_RECEIVE_CAMERA_DB_INFO_CHANGE ("KYL_NOTIFICATION_RECEIVE_CAMERA_DB_INFO_CHANGE")//摄像机DB信息变化


#define APP_DownloadURL @"http://itunes.apple.com/app/id834791071?mt=8" //换成你自己的APP地址

#define APP_LOOKUP_URL @"http://itunes.apple.com/lookup?id=834791071" //itunes.apple.com/lookup?id=你的应用程序的ID

//#define APP_LOOKUP_URL @"http://itunes.apple.com/lookup?id=625683178" //itunes.apple.com/lookup?id=你的应用程序的ID

#define KYL_APPIRATER_APP_ID_GiveScore  @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=834791071"

enum {
    // iPhone 1,3,3GS 标准分辨率(320x480px)
    UIDevice_iPhoneStandardRes      = 1,
    // iPhone 4,4S 高清分辨率(640x960px)
    UIDevice_iPhoneHiRes            = 2,
    // iPhone 5 高清分辨率(640x1136px)
    UIDevice_iPhoneTallerHiRes      = 3,
    // iPad 1,2 标准分辨率(1024x768px)
    UIDevice_iPadStandardRes        = 4,
    // iPad 3 High Resolution(2048x1536px)
    UIDevice_iPadHiRes              = 5
};

typedef enum enum_SystemCalendarType
{
    Calendar_FoLi = 1,
    Calendar_Janpanse =2,
    Calendar_GongLi =3,
    
}SystemCalendarType;


typedef NSUInteger UIDeviceResolution;



/*!
 @enum Direction
 @abstract 云台转动方向0：未知，1-上，2-下，3-左, 4-右.
 @constant DirectionNone = 0 未知状态.
 @constant DirectionUp = 1 向上移动.
 @constant DirectionDown = 2 向下移动.
 @constant DirectionLeft = 3 向左移动.
 @constant DirectionRight = 4 向右移动.
 @discussion Direction定义了云台转动方向.
 Lorem ipsum....
 */

typedef enum
{
    DirectionNone = 0,
    DirectionUp = 1,
    DirectionDown = 2,
    DirectionLeft = 3,
    DirectionRight = 4,
} Direction;


//当前视频状态0：未知状态，1-停止状态，2-正在播放状态，3-正在停止状态, 4-正在加载视频
typedef enum VIDEO_STATUS
{
    VIDEO_UNKNOWN = 0,  //未知状态
    VIDEO_PAUSE = 1,    //视频处于暂停状态
    VIDEO_PLAYING = 2,  //视频处于正在播放状态
    VIDEO_STOPING = 3,   //视频处于正在停止状态
    VIDEO_LOADING = 4,   //视频处于正在加载视频
    VIDEO_STOPED= 5,   //视频处于已经停止状态
    
} VideoStatus;

//当前声音状态0：未知状态，1-停止状态，2-正在播放状态，3-正在停止状态，4-正在开启声音
typedef enum AUDIO_STATUS
{
    AUDIO_UNKNOWN = 0,  //未知状态
    AUDIO_PAUSE = 1,    //声音处于暂停状态
    AUDIO_PLAYING = 2,  //声音处于正在播放状态
    AUDIO_STOPING = 3,  //声音处于正在停止状态
    AUDIO_OPENING = 4,  //声音处于正在开启声音
    AUDIO_STOPED= 5,   //声音处于已经停止状态
    
} AudioStatus;

//当前对讲状态0：未知状态，1-停止状态，2-正在播放状态，3-正在停止对讲状态， 4-正在启动对讲
typedef enum TALK_STATUS
{
    TALK_UNKNOWN = 0,  //未知状态
    TALK_PAUSE = 1,    //对讲处于暂停状态
    TALK_PLAYING = 2,  //对讲处于正在播放状态
    TALK_STOPING = 3,  //对讲处于正在停止对讲状态
    TALK_OPENING = 4,  //对讲处于正在启动对讲
    TALK_STOPED= 5,   //对讲处于已经停止状态
    
} TalkStatus;

/*!
 @enum CAMERA_TYPE
 @abstract 摄影机类型.
 @constant CAMERA_TYPE_UNKNOWN = 0 未知.
 @constant CAMERA_TYPE_LAN = 1,  通过域名访问摄影机.
 @constant CAMERA_TYPE_P2P = 2 P2P摄影机.
 @discussion 摄影机类型.
 Lorem ipsum....
 */
typedef enum CAMERA_TYPE
{
    CAMERA_TYPE_UNKNOWN = 0,  //未知
    CAMERA_TYPE_LAN     = 1,  //通过域名访问摄影机
    CAMERA_TYPE_P2P     = 2   //P2P摄影机
} CameraType;


typedef enum CAMERA_USER_TYPE
{
    CAMERA_USER_TYPE_UNKNOWN= 0, //未知
    CAMERA_USER_TYPE_ADMIN  = 1, //admin
    CAMERA_USER_TYPE_GUESS  = 2, //guess
    CAMERA_USER_TYPE_USER   = 3  //普通用户
} CameraUserType;

#define ZOOM_MAX_SCALE  5.0
#define ZOOM_MIN_SCALE  1.0
#define degreeToRadians(x) (M_PI * (x) / 180.0)




#define KYL_VBUF_SIZE      2*1024*1024
#define KYL_VBUF_SIZE_L    1*1024*1024
#define KYL_VBUF_SIZE_M    1*1024*1024
#define KYL_VBUF_SIZE_X    2*1024*1024

#define KYL_VBUF_SIZE_SD_RECORD_L      1*1024*1024
#define KYL_VBUF_SIZE_SD_RECORD_M      1*1024*1024
#define KYL_VBUF_SIZE_SD_RECORD_X      2*1024*1024

#define KYL_VBUF_SIZE_SD_RECORD_AV_X   4*1024*1024

#define KYL_ABUF_SIZE                  1*1024*1024
#define KYL_ABUF_SIZE_SD_RECORD        3*1024*1024

#define KYL_MAX_SIZE_YUV      4478976 //2304*1296*3/2
#define KYL_MAX_SIZE_RGB24    8957952 //2304*1296*3

#define KYL_MIN_PCM_AUDIO_SIZE          1024
#define KYL_MIN_PCM_AUDIO_SIZE_g726     960
#define KYL_MIN_PCM_AUDIO_SIZE_g711     320
#define KYL_MIN_PCM_AUDIO_SIZE_gAAC     1024

#define KYL_TALK_WRITE_BUFFER_MAX_SIZE  32*1024

#define MAX_LEN_DID				17
#define MAX_SIZE_TMP_TALK		1024

#define  ERR_P2PAPI_BASE				-400
#define  ERR_P2PAPI_ALREADY_OPEN_AUDIO	(ERR_P2PAPI_BASE-1)

#define KYL_AVCODEC_MAX_AUDIO_FRAME_SIZE  160 //160  //juju1
#define KYL_AVCODEC_MAX_AUDIO_FRAME_SIZE2  640 //160  //juju1
//#define KYL_AVCODEC_MAX_AUDIO_FRAME_SIZE  1280 //1280  //kongyulu20141114

#define KYL_AUDIO_SAMPLE_RATE_X  16000
#define KYL_AUDIO_SAMPLE_RATE_M  8000
#define KYL_AUDIO_SAMPLE_RATE_L  8000

#define KYL_AUDIO_DECODE_BUFFER_SIZE 4096

#define KYL_LOCAL_RECORD_MAX_TIME_LENGTH (3600000) //60*60*1000 (1h)



#ifndef KYL_SAFE_DELETE
#define KYL_SAFE_DELETE(p)\
{\
    if((p) != NULL)\
    {\
        delete (p);\
        (p) = NULL;\
    }\
}

#endif

#ifndef KYL_SAFE_DELETE_ARR
#define KYL_SAFE_DELETE_ARR(p)\
{\
    if((p) != NULL)\
    {\
        delete [](p);\
        (p) = NULL;\
    }\
}
#endif


#define KYL_BTN_NORMAL_RED          0
#define KYL_BTN_NORMAL_GREEN        0x4e
#define KYL_BTN_NORMAL_BLUE         0x93
#define KYL_BTN_NORMAL_RED_IOS7     255
#define KYL_BTN_NORMAL_GREEN_IOS7   255
#define KYL_BTN_NORMAL_BLUE_IOS7    255

//定义字体白色的RGB
#define KYL_FONT_COLOR_R (255)
#define KYL_FONT_COLOR_G (255)
#define KYL_FONT_COLOR_B (255)


//定义按钮绿色的RGB
#define KYL_BUTTON_COLOR_R (57)
#define KYL_BUTTON_COLOR_G (179)
#define KYL_BUTTON_COLOR_B (130)

//定义灰色线条的RGB
#define KYL_LINE_COLOR_R (172)
#define KYL_LINE_COLOR_G (174)
#define KYL_LINE_COLOR_B (171)

#define KYL_CameraEditController_TableSection_CameraInfo    0
#define KYL_CameraEditController_TableSection_AdvanceSet    1
#define KYL_CameraEditController_TableSection_LanSearch     2
#define KYL_CameraEditController_TableSection_QRScan        3

#define KYL_TAG_CAMERA_NAME 0
#define KYL_TAG_CAMERA_ID   1
#define KYL_TAG_USER_NAME   2
#define KYL_TAG_PASSWORD    3
#define KYL_STR_DEFAULT_CAMERA_NAME "P2PWIFICAM"
#define KYL_STR_DEFAULT_USER_NAME "admin"


#define mainHeight     [[UIScreen mainScreen] bounds].size.height
#define mainWidth      [[UIScreen mainScreen] bounds].size.width
#define navBarHeight   self.navigationController.navigationBar.frame.size.height

#define mainColor                   [UIColor hexFloatColor:@"ff6600"]

// bg related
#define KYL_TABBAR_BG_COLOR         RGB(57,179,130)
#define BG_COLOR                    RGB(248,248,248)
#define BG_GRAY_COLOR               RGB(242,242,242)
#define NAVBAR_COLOR                [UIColor hexFloatColor:@"f68e49"]

#define TABBAR_TEXT_NOR_COLOR       RGB(153, 153, 153)
#define TABBAR_TEXT_HLT_COLOR       mainColor

@interface KYLDefine : NSObject

@end
