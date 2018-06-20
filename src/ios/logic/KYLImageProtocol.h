//
//  KYLImageProtocol.h
//  P2PCamera
//
//
//

#ifndef P2PCamera_KYLImageProtocol_h
#define P2PCamera_KYLImageProtocol_h
#import <Foundation/Foundation.h>

@protocol KYLImageProtocol <NSObject>

@optional


- (void) KYLImageProtocol_didReceiveMJPEGImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp DID:(NSString *)did user:(void *) pUser;

- (void) KYLImageProtocol_didReceiveOneVideoFrameYUVNotify: (char*) yuvdata length:(unsigned long)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did user:(void *) pUser;

- (void) KYLImageProtocol_didReceiveOneVideoFrameRGB24Notify: (char*) rgb24data length:(unsigned long)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did user:(void *) pUser;

- (void) KYLImageProtocol_didReceiveOneH264VideoFrameWithH264Data: (char*) h264Framedata length: (unsigned long) length type: (int) type timestamp: (NSInteger) timestamp DID:(NSString *)did user:(void *) pUser;

//RemoteRecordPlayback
- (void) KYLImageProtocol_didReceiveRemoteRecordPlaybackMJPEGImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp DID:(NSString *)did user:(void *) pUser;

- (void) KYLImageProtocol_didReceiveRemoteRecordPlaybackOneVideoFrameYUVNotify: (char*) yuvdata length:(unsigned long)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did user:(void *) pUser;

- (void) KYLImageProtocol_didReceiveRemoteRecordPlaybackOneVideoFrameRGB24Notify: (char*) rgb24data length:(unsigned long)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did user:(void *) pUser;

- (void) KYLImageProtocol_didReceiveRemoteRecordPlaybackOneH264VideoFrameWithH264Data: (char*) h264Framedata length: (unsigned long) length type: (int) type timestamp: (NSInteger) timestamp DID:(NSString *)did user:(void *) pUser;

@end

#endif
