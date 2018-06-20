//
//  KYLComFunUtil.h
//  P2PCamera
//
//
//

#import <Foundation/Foundation.h>

typedef enum ENUM_LANGUAGE_TYPE
{
    Language_Chinese = 0,        //中文简体
    Language_Chinese_Complex = 1,//中文繁体
    Language_English = 2,        //英文
    Language_French = 3,         //法语
    Language_Portuguese = 4,         //葡萄牙语
    Language_Spanish = 5,         //西班牙语
    Language_Korean = 6,         //韩语
    Language_Russian = 7,         //俄语
    Language_German = 8,         //德语
    Language_Janpanse = 9        //日语
    
}enum_CurrentLanguage;


@interface KYLComFunUtil : NSObject

/******************************************************************************
 函数名称 : + (UIDeviceResolution) currentResolution
 函数描述 : 当前是否运行在iPhone5端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone5;

/******************************************************************************
 函数名称 : + (BOOL)isRunningOniPhone
 函数描述 : 当前是否运行在iPhone端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone;



/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (BOOL) isIPad;
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (NSString*)deviceString;//获取当前的设备类型

+ (NSString* )getCurrentDeviceTypeString;
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
//图片裁剪
+ (UIImage *)getImageFromImage:(UIImage*) superImage subImageSize:(CGSize)subImageSize subImageRect:(CGRect)subImageRect;

/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (UIImage *) getUIImage:(char *)buff Width:(NSInteger)width Height:(NSInteger)height;//根据字节流获得图片
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (int)getCurrentLanguageType;//获取当前语言的类型
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (NSString *) getTheEnglisMonthString:(int) nTempNumMonth;

/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (BOOL)validateEmailWithString:(NSString*)email;
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+  (NSMutableArray*)validateEmailsWithString:(NSString*)emails;
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+  (BOOL)validateSimplePhoneWithString:(NSString*)phone;
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (BOOL) isLength8More:(NSString *)input;
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (BOOL) containsChar:(NSString *)input;
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (BOOL) containsUpperAndLowerCase:(NSString *)input;
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (BOOL) containsDigit:(NSString *)input ;
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (BOOL) containsSpecialChars:(NSString *)input;
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (BOOL) isValidPasswordChars:(NSString *)input;
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 修改日期：
 ***********************************/
+ (NSString *) pathForDocumentsResource:(NSString *) relativePath;


/*********************************************************************
 函数名称 : getMacAddress
 函数描述 : 获取本机MAC地址
 参数 :
 返回值 :   NSString
 *********************************************************************/
+ (NSString *)getMacAddress;

/*********************************************************************
 函数名称 : colorWithHexString
 函数描述 : 将十六进制颜色值转位UIColor,如#66000000
 参数 :
 返回值 :   UIColor
 *********************************************************************/
+ (UIColor *) colorWithHexString: (NSString *)color;

/*!
 @method
 @abstract is43Version 是否是IOS4.3系统.
 @discussion .
 @param  .
 @param .
 @result .
 */
+(BOOL)is43Version;

/*!
 @method
 @abstract 获取系统剩余空间大小 .
 @discussion .
 @param  .
 @param .
 @result .
 */
+ (NSString *) getsystempFreeSpace;

/*!
 @method
 @abstract 获取系统剩余空间大小 单位为G.
 @discussion .
 @param  .
 @param .
 @result .
 */
+ (long) getSystemFreeSpace;

/*!
 @method
 @abstract 获取系统总空间大小 单位为G.
 @discussion .
 @param  .
 @param .
 @result .
 */
+ (long) getSystemTotalSpace;


+ (UIImage*) GetCameraSnapshotImage: (NSString*) strDID;

+ (NSURL *) getTheSystemDocumentDirPath;
+ (NSURL *) getTheSystemLibraryCacheDirPath;
+ (NSString *)getDefaultFolderInDocumentForDid:(NSString *) sDID;
+ (NSString *)getDefaultFolderInLibraryCacheForDid:(NSString *) sDID;


+ (BOOL) isStringContainSpecailChar:(NSString *) str;
+ (BOOL) isStringContainSpecailChar2:(NSString *) str;

+ (NSString *) getP2PCameraStatusString:(NSInteger) _iStatus;

@end
