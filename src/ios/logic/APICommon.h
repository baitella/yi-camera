//
//  APICommon.h
//  P2PCamera
//
//  Created by Tsang on 12-12-11.
//
//

#import <Foundation/Foundation.h>

@interface APICommon : NSObject

+ (UIImage*) GetImageByName: (NSString*)did filename:(NSString*)filename;
+ (UIImage*) GetImageByNameFromImage: (NSString*)did filename:(NSString*)filename;
+ (UIImage*) YUV420ToImage: (Byte*)yuv inSize:(unsigned long) inLength width:(int)width height:(int)height;
+ (UIImage*) RGB888toImage: (Byte*)rgb888 width:(int)width height:(int)height;

@end
