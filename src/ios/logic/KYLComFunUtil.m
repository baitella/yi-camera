//
//  KYLComFunUtil.m
//  P2PCamera
//
//
//

#import "KYLComFunUtil.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "sys/utsname.h"
#import <QuartzCore/QuartzCore.h>
#import "KYLDefine.h"
#import <sys/xattr.h>

@implementation KYLComFunUtil
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    
    return deviceString;
    return deviceString;
}

+ (NSString*)getCurrentDeviceTypeString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSArray *modelArray = @[
                            
                            @"i386", @"x86_64",
                            @"iPhone1,1",
                            @"iPhone1,2",
                            @"iPhone2,1",
                            @"iPhone3,1",
                            @"iPhone3,2",
                            @"iPhone3,3",
                            @"iPhone4,1",
                            @"iPhone5,1",
                            @"iPhone5,2",
                            @"iPhone5,3",
                            @"iPhone5,4",
                            @"iPhone6,1",
                            @"iPhone6,2",
                            
                            @"iPod1,1",
                            @"iPod2,1",
                            @"iPod3,1",
                            @"iPod4,1",
                            @"iPod5,1",
                            
                            @"iPad1,1",
                            @"iPad2,1",
                            @"iPad2,2",
                            @"iPad2,3",
                            @"iPad2,4",
                            @"iPad3,1",
                            @"iPad3,2",
                            @"iPad3,3",
                            @"iPad3,4",
                            @"iPad3,5",
                            @"iPad3,6",
                            
                            @"iPad2,5",
                            @"iPad2,6",
                            @"iPad2,7",
                            ];
    NSArray *modelNameArray = @[
                                
                                @"iPhone Simulator", @"iPhone Simulator",
                                
                                @"iPhone 2G",
                                @"iPhone 3G",
                                @"iPhone 3GS",
                                @"iPhone 4(GSM)",
                                @"iPhone 4(GSM Rev A)",
                                @"iPhone 4(CDMA)",
                                @"iPhone 4S",
                                @"iPhone 5(GSM)",
                                @"iPhone 5(GSM+CDMA)",
                                @"iPhone 5c(GSM)",
                                @"iPhone 5c(Global)",
                                @"iphone 5s(GSM)",
                                @"iphone 5s(Global)",
                                
                                @"iPod Touch 1G",
                                @"iPod Touch 2G",
                                @"iPod Touch 3G",
                                @"iPod Touch 4G",
                                @"iPod Touch 5G",
                                
                                @"iPad",
                                @"iPad 2(WiFi)",
                                @"iPad 2(GSM)",
                                @"iPad 2(CDMA)",
                                @"iPad 2(WiFi + New Chip)",
                                @"iPad 3(WiFi)",
                                @"iPad 3(GSM+CDMA)",
                                @"iPad 3(GSM)",
                                @"iPad 4(WiFi)",
                                @"iPad 4(GSM)",
                                @"iPad 4(GSM+CDMA)",
                                
                                @"iPad mini (WiFi)",
                                @"iPad mini (GSM)",
                                @"ipad mini (GSM+CDMA)"
                                ];
    NSInteger modelIndex = - 1;
    NSString *modelNameString = nil;
    modelIndex = [modelArray indexOfObject:deviceString];
    if (modelIndex >= 0 && modelIndex < [modelNameArray count]) {
        modelNameString = [modelNameArray objectAtIndex:modelIndex];
    }
    
    
    NSLog(@"----设备类型---%@",modelNameString);
    return modelNameString;
}




/***********************************
 iOS 设备现有的分辨率如下：
 iPhone/iPod Touch
 普通屏 320像素 x 480像素 iPhone 1、3G、3GS，iPod Touch 1、2、3
 3：2 Retina 屏 640像素 x 960像素 iPhone 4、4S，iPod Touch 4
 16：9 Retina 屏 640像素 x 1136像素 iPhone 5，iPod Touch 5
 
 iPad
 普通屏 768像素 x 1024像素 iPad 1， iPad2，iPad mini
 Retina屏 1536像素 x 2048像素 New iPad，iPad 4
 [[UIScreen mainScreen] bounds]
 ***********************************/
/******************************************************************************
 函数名称 : + (UIDeviceResolution) currentResolution
 函数描述 : 获取当前分辨率
 
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (int) currentResolution {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            result = CGSizeMake(result.width * [UIScreen mainScreen].scale, result.height * [UIScreen mainScreen].scale);
            if (result.height <= 480.0f)
                return UIDevice_iPhoneStandardRes;
            return (result.height > 960 ? UIDevice_iPhoneTallerHiRes : UIDevice_iPhoneHiRes);
        } else
            return UIDevice_iPhoneStandardRes;
    } else
        return (([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) ? UIDevice_iPadHiRes : UIDevice_iPadStandardRes);
}

/******************************************************************************
 函数名称 : + (UIDeviceResolution) currentResolution
 函数描述 : 当前是否运行在iPhone5端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone5{
    if ([self currentResolution] == UIDevice_iPhoneTallerHiRes) {
        return YES;
    }
    return NO;
}

/******************************************************************************
 函数名称 : + (BOOL)isRunningOniPhone
 函数描述 : 当前是否运行在iPhone端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}


/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (BOOL) isIPad
{
    BOOL isIPad = NO;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        isIPad = NO;
    }
    else
    {
        isIPad = YES;
    }
    return isIPad;
}

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
+ (UIImage *)getImageFromImage:(UIImage*) superImage subImageSize:(CGSize)subImageSize subImageRect:(CGRect)subImageRect {
    //    CGSize subImageSize = CGSizeMake(WIDTH, HEIGHT); //定义裁剪的区域相对于原图片的位置
    //    CGRect subImageRect = CGRectMake(START_X, START_Y, WIDTH, HEIGHT);
    CGImageRef imageRef = superImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* returnImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext(); //返回裁剪的部分图像
    
    // free memory
    CGImageRelease(subImageRef);
    return returnImage;
}

/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (UIImage *) getUIImage:(char *)buff Width:(NSInteger)width Height:(NSInteger)height
{
    if (buff <= 0) {
        return nil;
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buff, width * height * 3, NULL);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef imgRef = CGImageCreate(width, height, 8, 24, width * 3, colorSpace,
                                      kCGBitmapByteOrderDefault, provider, NULL, true,  kCGRenderingIntentDefault);
    
    //UIImage *img = [UIImage imageWithCGImage:imgRef];
    UIImage *img = [[[UIImage alloc] initWithCGImage:imgRef] autorelease];
    if (imgRef != nil) {
        CGImageRelease(imgRef);
        imgRef = nil;
    }
    
    if (colorSpace != nil) {
        CGColorSpaceRelease(colorSpace);
        colorSpace = nil;
    }
    
    if (provider != nil) {
        CGDataProviderRelease(provider);
        provider = nil;
    }
    
    return img;
}
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
//+ (void)showNotificationWithMsg:(NSString *) _msg withBgImage:(UIImage*) _bgImage inSuperView:(UIView *) _superView
//{
//    BDKNotifyHUD *_notify = [BDKNotifyHUD notifyHUDWithImage:_bgImage text:_msg];
//    _notify.center = CGPointMake(_superView.center.x, _superView.center.y - 20);
//
//    if (_notify.isAnimating) return;
//
//    [_superView addSubview:_notify];
//    [_notify presentWithDuration:1.0f speed:0.5f inView:_superView completion:^{
//        [_notify removeFromSuperview];
//    }];
//}


/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
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
 ***********************************/
+ (int) getCurrentLanguageType
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defaults objectForKey:@"AppleLanguages"];
    NSString* tmpStrCurrentLanguage = [languages objectAtIndex:0];
    
    int m_enumLanguage;
    if([tmpStrCurrentLanguage isEqualToString:@"zh-Hans"])//中文简体
    {
        m_enumLanguage = (int)Language_Chinese;
    }
    else if([tmpStrCurrentLanguage isEqualToString:@"zh-Hant"])//中文繁体
    {
        m_enumLanguage = (int)Language_Chinese_Complex;
    }
    else if([tmpStrCurrentLanguage isEqualToString:@"en"])//英文
    {
        m_enumLanguage = (int)Language_English;
    }
    else if([tmpStrCurrentLanguage isEqualToString:@"fa"])//法语
    {
        m_enumLanguage = (int)Language_French;
    }
    else if([tmpStrCurrentLanguage isEqualToString:@"pt"])//葡萄牙语
    {
        m_enumLanguage = (int)Language_Portuguese;
    }
    else if([tmpStrCurrentLanguage isEqualToString:@"ja"])//西班牙语
    {
        m_enumLanguage = (int)Language_Spanish;
    }
    else if([tmpStrCurrentLanguage isEqualToString:@"ko"])//韩语
    {
        m_enumLanguage = (int)Language_Korean;
    }
    else if([tmpStrCurrentLanguage isEqualToString:@"ru"])//俄语
    {
        m_enumLanguage = (int)Language_Russian;
    }
    else if([tmpStrCurrentLanguage isEqualToString:@"de"])//德语
    {
        m_enumLanguage = (int)Language_German;
    }
    else if([tmpStrCurrentLanguage isEqualToString:@"ja"])//日语
    {
        m_enumLanguage = (int)Language_Janpanse;
    }
    
    return (int)m_enumLanguage;
}

+ (NSString *) getTheEnglisMonthString:(int) nTempNumMonth
{
    
    NSString* strMonth = nil;
    switch (nTempNumMonth) {
        case 1:
        {
            strMonth = NSLocalizedString(@"January", nil);
        }
            break;
        case 2:
        {
            strMonth = NSLocalizedString(@"February", nil);
        }
            break;
        case 3:
        {
            strMonth = NSLocalizedString(@"March", nil);
        }
            break;
        case 4:
        {
            strMonth = NSLocalizedString(@"April", nil);
        }
            break;
        case 5:
        {
            strMonth = NSLocalizedString(@"May", nil);
        }
            break;
        case 6:
        {
            strMonth = NSLocalizedString(@"June", nil);
        }
            break;
        case 7:
        {
            strMonth = NSLocalizedString(@"July", nil);
        }
            break;
        case 8:
        {
            strMonth = NSLocalizedString(@"August", nil);
        }
            break;
        case 9:
        {
            strMonth = NSLocalizedString(@"September", nil);
        }
            break;
        case 10:
        {
            strMonth = NSLocalizedString(@"October", nil);
        }
            break;
        case 11:
        {
            strMonth = NSLocalizedString(@"November", nil);
        }
            break;
        case 12:
        {
            strMonth = NSLocalizedString(@"December", nil);
        }
            break;
            
            
        default:
            break;
    }
    return strMonth;
}





/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+  (NSMutableArray*)validateEmailsWithString:(NSString*)emails
{
    NSMutableArray *validEmails = [[NSMutableArray alloc] init];
    NSArray *emailArray = [emails componentsSeparatedByString:@","];
    for (NSString *email in emailArray)
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if ([emailTest evaluateWithObject:email])
            [validEmails addObject:email];
    }
    return [validEmails autorelease];
}
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+  (BOOL)validateSimplePhoneWithString:(NSString*)phone{
    NSRange badCharRange = [phone rangeOfCharacterFromSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789()-."] invertedSet]];
    if (badCharRange.location != NSNotFound) {
        return NO;
    }
    NSString* cleanPhoneNumber = [[phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]]
                                  componentsJoinedByString:@""];
    NSString *phoneRegex = @"[0-9]{10}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:cleanPhoneNumber];
    
}

/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (BOOL) isPasswordValid:(NSString *)input {
    if ( [input length]<6 || [input length]>32 ) return NO;  // too long or too short
    NSRange rang;
    rang = [input rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    if ( !rang.length ) return NO;  // no letter
    rang = [input rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    if ( !rang.length )  return NO;  // no number;
    return YES;
}
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (BOOL) isLength8More:(NSString *)input
{
    if ( [input length]>= 8)
        return YES;
    return NO;
}
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (BOOL) containsChar:(NSString *)input
{
    NSRange rang;
    rang = [input rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    if ( !rang.length )
        return NO;  // no letter
    else
        return YES;
}
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (BOOL) containsUpperAndLowerCase:(NSString *)input
{
    if ([input rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]].location != NSNotFound &&
        [input rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]].location != NSNotFound) {
        return YES;
    }
    return NO;
    //    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z]"
    //                                                                           options:NSRegularExpressionCaseInsensitive
    //                                                                             error:nil];
    //    NSUInteger num = [regex numberOfMatchesInString:input options:0 range:NSMakeRange(0, [input length])];
    //    if (num > 0) {
    //        return YES;
    //    }
    //    else
    //        return NO;
}
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (BOOL) containsDigit:(NSString *)input
{
    NSRange rang;
    rang = [input rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    if ( !rang.length )  return NO;  // no number;// no letter
    else
        return YES;
}
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (BOOL) containsSpecialChars:(NSString *)input {
    //    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"!$#"] invertedSet];
    //    if ([input rangeOfCharacterFromSet:set].location != NSNotFound) {
    //        return NO;
    //    }
    //    return YES;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                  @"[~!@#$%^&\\*_\\-\\+=`\\|\\\\(\\)\\{\\}\\[\\]:;\"'<>,\\.\\?/]"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSUInteger num = [regex numberOfMatchesInString:input options:0 range:NSMakeRange(0, [input length])];
    
    if (num > 0) {
        return YES;
    }
    else
        return NO;
}
/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (BOOL) isValidPasswordChars:(NSString *)input{
    
    NSCharacterSet * allowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLKMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789~!@#$%^&*_-+=`|\(){}[]:;\"'<>,.?/"] invertedSet];
    if ([input rangeOfCharacterFromSet:allowedChars].location == NSNotFound){
        return YES;
    }else{
        return NO;
    }
}

/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (NSString *) pathForDocumentsResource:(NSString *) relativePath {
    
    static NSString* documentsPath = nil;
    
    if (nil == documentsPath) {
        
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsPath = [[dirs objectAtIndex:0] retain];
    }
    
    return [documentsPath stringByAppendingPathComponent:relativePath];
}





/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
+ (BOOL) createThePlistFile:(NSString *) fileName
{
    BOOL m_bResult = FALSE;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString *filenames = [NSString stringWithFormat:@"%@.plist",fileName];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    //判断是否以创建文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        //此处可以自己写显示plist文件内容
        NSLog(@"文件已存在");
    }
    else
    {
        //如果没有plist文件就自动创建
        NSMutableDictionary *dictplist = [[[NSMutableDictionary alloc ] init] autorelease];
        NSMutableDictionary *dicttxt = [[NSMutableDictionary alloc ] init] ;
        [dictplist setObject:dicttxt forKey:@"kongyulu"];
        [dicttxt release];
        //写入文件
        [dictplist writeToFile:plistPath atomically:YES];
    }
    
    return m_bResult;
}



/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
//写入数据到plist文件
+(NSMutableDictionary*)Modify:(NSString *)getvalue :(NSString *)key inFile:(NSString *) fileName
{
    /*
     注意：此方法更新和写入是共用的
     */
    //获取路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:fileName];
    NSMutableDictionary *applist = [[[NSMutableDictionary alloc]initWithContentsOfFile:path] autorelease];
    NSMutableDictionary *info = [applist objectForKey:@"kongyulu"];
    NSString *name1 = nil;
    name1 = getvalue;
    [info setValue:name1 forKey:key];
    [applist setValue:info forKey:@"kongyulu"];
    //写入文件
    [applist writeToFile:path atomically:YES];
    
    NSLog(@"key = %@",key);
    NSLog(@"txt = %@",getvalue);
    
    return applist;
}


/***********************************
 函数名称：
 函数功能：
 输入参数：
 输出参数：
 返回参数：
 作者：
 修改日期：
 ***********************************/
//删除一行数据
+(NSMutableDictionary*)Delete:(NSString *)key inFile:(NSString *) fileName
{
    //获取路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:fileName];
    NSMutableDictionary *applist = [[[NSMutableDictionary alloc]initWithContentsOfFile:path] autorelease];
    NSMutableDictionary *info = [applist objectForKey:@"kongyulu"];
    [info removeObjectForKey:key];
    [applist setValue:info forKey:@"kongyulu"];
    //写入文件
    [applist writeToFile:path atomically:YES];
    
    return applist;
    
}


/*********************************************************************
 函数名称 : getMacAddress
 函数描述 : 获取本机MAC地址
 参数 :
 返回值 :   NSString
 *********************************************************************/
+ (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = (char*)malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        free(msgBuffer);
        msgBuffer = NULL;
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%.2X:%.2X:%.2X:%.2X:%.2X:%.2X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}






/*********************************************************************
 函数名称 : stringToNSDate
 函数描述 : 将NSString转换为NSDate
 参数 :
 返回值 :   NSDate
 *********************************************************************/
+ (NSDate *)stringToNSDate:(NSString*)dateString
{
    NSDate *dateFromString = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZZ"];
    dateFromString = [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    return dateFromString;
}

/*********************************************************************
 函数名称 : dateToNSString
 函数描述 : 将NSDate转换为NSString
 参数 :
 返回值 :   NSString
 *********************************************************************/
+ (NSString*)dateToNSString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh-mm-ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return strDate;
}


/*********************************************************************
 函数名称 : colorWithHexString
 函数描述 : 将十六进制颜色值转位UIColor,如#66000000
 参数 :
 返回值 :   UIColor
 *********************************************************************/
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

//字符串转颜色
+ (UIColor *) colorWithHexString2: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return [UIColor clearColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//颜色转字符串
+ (NSString *) changeUIColorToRGB:(UIColor *)color{
    
    
    const CGFloat *cs=CGColorGetComponents(color.CGColor);
    
    
    NSString *r = [NSString stringWithFormat:@"%@",[KYLComFunUtil  ToHex:cs[0]*255]];
    NSString *g = [NSString stringWithFormat:@"%@",[KYLComFunUtil  ToHex:cs[1]*255]];
    NSString *b = [NSString stringWithFormat:@"%@",[KYLComFunUtil  ToHex:cs[2]*255]];
    return [NSString stringWithFormat:@"#%@%@%@",r,g,b];
    
    
}


//十进制转十六进制
+ (NSString *)ToHex:(int)tmpid
{
    NSString *endtmp=@"";
    NSString *nLetterValue;
    NSString *nStrat;
    int ttmpig=tmpid%16;
    int tmp=tmpid/16;
    switch (ttmpig)
    {
        case 10:
            nLetterValue =@"A";break;
        case 11:
            nLetterValue =@"B";break;
        case 12:
            nLetterValue =@"C";break;
        case 13:
            nLetterValue =@"D";break;
        case 14:
            nLetterValue =@"E";break;
        case 15:
            nLetterValue =@"F";break;
        default:nLetterValue=[[[NSString alloc]initWithFormat:@"%i",ttmpig] autorelease];
            
    }
    switch (tmp)
    {
        case 10:
            nStrat =@"A";break;
        case 11:
            nStrat =@"B";break;
        case 12:
            nStrat =@"C";break;
        case 13:
            nStrat =@"D";break;
        case 14:
            nStrat =@"E";break;
        case 15:
            nStrat =@"F";break;
        default:nStrat=[[[NSString alloc]initWithFormat:@"%i",tmp] autorelease];
            
    }
    endtmp=[[[NSString alloc]initWithFormat:@"%@%@",nStrat,nLetterValue] autorelease];
    return endtmp;
}

/*!
 @method
 @abstract .
 @discussion .
 @param  .
 @param .
 @result .
 */
+ (NSString*)userDocPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *userFolderPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/",@"SavechatLog"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:userFolderPath]) {
        [fileManager createDirectoryAtPath:userFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return userFolderPath;
}

/*!
 @method
 @abstract .
 @discussion .
 @param  .
 @param .
 @result .
 */
+  (BOOL) deleteWithContentPath:(NSString *)thePath{
    NSError *error=nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:thePath]) {
        [fileManager removeItemAtPath:thePath error:&error];
    }
    if (error) {
        NSLog(@"删除文件时出现问题:%@",[error localizedDescription]);
        return NO;
    }
    return YES;
}

/*!
 @method
 @abstract .
 @discussion .
 @param  .
 @param .
 @result .
 */

+ (NSString*)chatCachePathWithFriendId:(NSString*)theFriendId andType:(NSInteger)theType
{
    NSString *userChatFolderPath = [[self userDocPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"chatLog/%@/",theFriendId]];
    switch (theType) {
        case 1:
            userChatFolderPath = [userChatFolderPath stringByAppendingPathComponent:@"voice/"];
            break;
        case 2:
            userChatFolderPath = [userChatFolderPath stringByAppendingPathComponent:@"image/"];
            break;
        default:
            break;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:userChatFolderPath]) {
        [fileManager createDirectoryAtPath:userChatFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return userChatFolderPath;
}

/*!
 @method
 @abstract .
 @discussion .
 @param  .
 @param .
 @result .
 */

+  (void)deleteFriendChatCacheWithFriendId:(NSString*)theFriendId
{
    NSString *userChatFolderPath = [[self userDocPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"chatLog/%@/",theFriendId]];
    
    [[NSFileManager defaultManager] removeItemAtPath:userChatFolderPath error:nil];
}

/*!
 @method
 @abstract .
 @discussion .
 @param  .
 @param .
 @result .
 */

+ (void)deleteAllFriendChatDoc
{
    NSString *userChatFolderPath = [[self userDocPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"chatLog/"]];
    
    [[NSFileManager defaultManager] removeItemAtPath:userChatFolderPath error:nil];
    
}

/*!
 @method
 @abstract is43Version 是否是IOS4.3系统.
 @discussion .
 @param  .
 @param .
 @result .
 */
+(BOOL)is43Version{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    // NSLog(@"version=%f",version);
    BOOL b=NO;
    if (version<4.5) {
        
        b=YES;
    }
    return b;
}

/*!
 @method
 @abstract 获取系统剩余空间大小 .
 @discussion .
 @param  .
 @param .
 @result .
 */
+ (NSString *) getsystempFreeSpace{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
    NSFileManager* fileManager = [[NSFileManager alloc ]init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    
    //NSLog(@"freeSpace=%f  totalSpace=%f",([freeSpace longLongValue])/1024.0/1024.0/1024,([totalSpace longLongValue])/1024.0/1024/1024);
    NSString *strFormat = [NSString stringWithFormat:@"freeSpace=%f G totalSpace=%f G",([freeSpace longLongValue])/1024.0/1024.0/1024,([totalSpace longLongValue])/1024.0/1024/1024];
    [fileManager release];
    return strFormat;
}
/*!
 @method
 @abstract 获取系统剩余空间大小 单位为G.
 @discussion .
 @param  .
 @param .
 @result .
 */
+ (long) getSystemFreeSpace{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
    NSFileManager* fileManager = [[NSFileManager alloc ]init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    //NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    
    //NSLog(@"freeSpace=%f  totalSpace=%f",([freeSpace longLongValue])/1024.0/1024.0/1024,([totalSpace longLongValue])/1024.0/1024/1024);
    
    long lFreeSpace = ([freeSpace longLongValue])/1024.0/1024.0/1024;
    [fileManager release];
    return lFreeSpace;
}

/*!
 @method
 @abstract 获取系统总空间大小 单位为G.
 @discussion .
 @param  .
 @param .
 @result .
 */
+ (long) getSystemTotalSpace{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
    NSFileManager* fileManager = [[NSFileManager alloc ]init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    //NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    
    
    long lTotalSpace = ([totalSpace longLongValue])/1024.0/1024.0/1024;
    [fileManager release];
    
    return lTotalSpace;
}

+ (UIImage*) GetCameraSnapshotImage: (NSString*) strDID
{
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:strDID];
    //NSLog(@"strPath: %@", strPath);
    
    strPath = [strPath stringByAppendingPathComponent:@KYL_CAMERA_COVER_IMAGE];
    //NSLog(@"strPath: %@", strPath);
    
    UIImage *imgRead = [UIImage imageWithContentsOfFile:strPath];
    
    return imgRead;
}

#pragma mark -  Excluding a File from Backups on iOS 5.1

+ (BOOL)addSkipBackupAttributeToItemAtURL_iOS5_1:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

#pragma mark - Setting the Extended Attribute on iOS 5.0.1

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

+ (NSURL *) getTheSystemDocumentDirPath
{
    NSURL *urlDefault = nil;

    NSString *strVersion = [[UIDevice currentDevice] systemVersion];
    float fVersion = 0.0;
    if(strVersion.length > 0)
        fVersion = [strVersion floatValue];
    
    // 获取沙盒主目录路径
    //NSString *homeDir = NSHomeDirectory();
    // 获取Documents目录路径
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths1 objectAtIndex:0];
    // 获取Caches目录路径
//        NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        NSString *cachesDir = [paths2 objectAtIndex:0];
    // 获取tmp目录路径
    //NSString *tmpDir = NSTemporaryDirectory();
    
    urlDefault = [NSURL fileURLWithPath:docDir];
    
    if (fVersion > 5.0 && fVersion < 5.1)
        [self addSkipBackupAttributeToItemAtURL:urlDefault];
    else if (fVersion >= 5.0)
        [self addSkipBackupAttributeToItemAtURL_iOS5_1:urlDefault];
    
    return urlDefault;
}

+ (NSURL *) getTheSystemLibraryCacheDirPath
{
    NSURL *urlDefault = nil;
    
    NSString *strVersion = [[UIDevice currentDevice] systemVersion];
    float fVersion = 0.0;
    if(strVersion.length > 0)
        fVersion = [strVersion floatValue];
    // 获取Caches目录路径
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths2 objectAtIndex:0];
    urlDefault = [NSURL fileURLWithPath:cachesDir];
    
    if (fVersion > 5.0 && fVersion < 5.1)
        [self addSkipBackupAttributeToItemAtURL:urlDefault];
    else if (fVersion >= 5.0)
        [self addSkipBackupAttributeToItemAtURL_iOS5_1:urlDefault];
    return urlDefault;
}

+ (NSURL *)getDefaultDownFileDir
{
    NSURL *urlDefault = nil;
    NSString *strDic = nil;
    
    NSString *strVersion = [[UIDevice currentDevice] systemVersion];
    float fVersion = 0.0;
    if(strVersion.length > 0)
        fVersion = [strVersion floatValue];
    
    if (fVersion == 5.0) {
        strDic = [NSString stringWithFormat:@"%@/Library/Caches/",
                  NSHomeDirectory()];
    } else {
        strDic = [NSString stringWithFormat:@"%@/Library/%@/",
                  NSHomeDirectory(),
                  [[NSBundle mainBundle] bundleIdentifier]];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:strDic]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:strDic withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    urlDefault = [NSURL fileURLWithPath:strDic];
    
    if (fVersion > 5.0 && fVersion < 5.1)
        [self addSkipBackupAttributeToItemAtURL:urlDefault];
    else if (fVersion >= 5.0)
        [self addSkipBackupAttributeToItemAtURL_iOS5_1:urlDefault];
    
    return urlDefault;
}

+ (NSString *)getDefaultFolderInDocumentForDid:(NSString *) sDID
{
    NSString *path = nil;
    NSURL *urlDefault = nil;

    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths1 objectAtIndex:0];
    NSString *strPath = [docDir stringByAppendingPathComponent:sDID];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:strPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    urlDefault = [NSURL fileURLWithPath:strPath];
    
    NSString *strVersion = [[UIDevice currentDevice] systemVersion];
    float fVersion = 0.0;
    if(strVersion.length > 0)
        fVersion = [strVersion floatValue];
    if (fVersion > 5.0 && fVersion < 5.1)
        [self addSkipBackupAttributeToItemAtURL:urlDefault];
    else if (fVersion >= 5.0)
        [self addSkipBackupAttributeToItemAtURL_iOS5_1:urlDefault];
    
    path = [urlDefault path];
    
    return path;
}

+ (NSString *)getDefaultFolderInLibraryCacheForDid:(NSString *) sDID
{
    NSString *path = nil;
    NSURL *urlDefault = nil;
    
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths1 objectAtIndex:0];
    NSString *strPath = [docDir stringByAppendingPathComponent:sDID];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:strPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    urlDefault = [NSURL fileURLWithPath:strPath];
    
    NSString *strVersion = [[UIDevice currentDevice] systemVersion];
    float fVersion = 0.0;
    if(strVersion.length > 0)
        fVersion = [strVersion floatValue];
    if (fVersion > 5.0 && fVersion < 5.1)
        [self addSkipBackupAttributeToItemAtURL:urlDefault];
    else if (fVersion >= 5.0)
        [self addSkipBackupAttributeToItemAtURL_iOS5_1:urlDefault];
    
    path = [urlDefault path];
    
    return path;
}


+ (BOOL) isStringContainSpecailChar:(NSString *) str
{
    BOOL bResult = NO;
    NSString *strSpecail1 = @"&";
    NSString *strSpecail2= @"\\";
    NSString *strSpecail3 = @"\'";
    NSString *strSpecail4 = @"\"";
    if ([str rangeOfString:strSpecail1].location !=NSNotFound
        ||[str rangeOfString:strSpecail2].location !=NSNotFound
        ||[str rangeOfString:strSpecail3].location !=NSNotFound
        ||[str rangeOfString:strSpecail4].location !=NSNotFound
        ) {
        bResult = YES;
    }
    return bResult;
}

+ (BOOL) isStringContainSpecailChar2:(NSString *) str
{
    BOOL bResult = NO;
    NSString *strSpecail1 = @"&";
    //NSString *strSpecail2= @"\\";
    NSString *strSpecail3 = @"\'";
    //NSString *strSpecail4 = @"\"";
    if ([str rangeOfString:strSpecail1].location !=NSNotFound
        //||[str rangeOfString:strSpecail2].location !=NSNotFound
        ||[str rangeOfString:strSpecail3].location !=NSNotFound
        //||[str rangeOfString:strSpecail4].location !=NSNotFound
        ) {
        bResult = YES;
    }
    return bResult;
}

//获取设备的状态
+ (NSString *) getP2PCameraStatusString:(NSInteger) _iStatus
{
    NSString *strPPPPStatus = nil;
    switch (_iStatus) {
        case CONNECT_STATUS_UNKNOWN:
            strPPPPStatus = NSLocalizedString(@"PPPPStatusUnknown",  nil);
            break;
        case CONNECT_STATUS_CONNECTING:
            strPPPPStatus = NSLocalizedString(@"PPPPStatusConnecting", nil);
            break;
        case CONNECT_STATUS_INITIALING:
            strPPPPStatus = NSLocalizedString(@"PPPPStatusInitialing",  nil);
            break;
        case CONNECT_STATUS_CONNECT_FAILED:
            strPPPPStatus = NSLocalizedString(@"PPPPStatusConnectFailed",  nil);
            break;
        case CONNECT_STATUS_DISCONNECT:
            strPPPPStatus = NSLocalizedString(@"PPPPStatusDisconnected",  nil);
            break;
        case CONNECT_STATUS_INVALID_ID:
            strPPPPStatus = NSLocalizedString(@"PPPPStatusInvalidID", nil);
            break;
        case CONNECT_STATUS_ONLINE:
            //strPPPPStatus = NSLocalizedString(@"PPPPStatusOnline", nil);
            //{{-- kongyulu at 20140806
            strPPPPStatus = NSLocalizedString(@"PPPPStatusConnecting", nil);
            //}}-- kongyulu at 20140806
            break;
        case CONNECT_STATUS_CONNECTED:
            //strPPPPStatus = NSLocalizedString(@"PPPPStatusConnected", nil);
            //{{-- kongyulu at 20140806
            strPPPPStatus = NSLocalizedString(@"PPPPStatusOnline", nil);
            //}}-- kongyulu at 20140806
            break;
        case CONNECT_STATUS_DEVICE_NOT_ONLINE:
            strPPPPStatus = NSLocalizedString(@"CameraIsNotOnline", nil);
            break;
        case CONNECT_STATUS_CONNECT_TIMEOUT:
            strPPPPStatus = NSLocalizedString(@"PPPPStatusConnectTimeout", nil);
            break;
        case CONNECT_STATUS_WRONG_USER_PWD:
            strPPPPStatus= NSLocalizedString(@"PPPPStatusInvalidUserPwd", nil);
            break;
            //{{--begin add by kongyulu at 20140331
        case CONNECT_STATUS_INVALID_REQ:
            strPPPPStatus= NSLocalizedString(@"PPPPStatusInvalidApp", nil);
            break;
        case CONNECT_STATUS_EXCEED_MAX_USER:
            strPPPPStatus= NSLocalizedString(@"PPPPStatusExceedMaxUser", nil);
            break;
            //}}--end add by kongyulu at 20140331
        default:
            strPPPPStatus = NSLocalizedString(@"PPPPStatusUnknown", nil);
            break;
    }
    return strPPPPStatus;
    
}


@end
