//
//  KYLRemoteRecordPlayImageProtocol.h
//  P2PCamera
//
//

#ifndef P2PCamera_KYLRemoteRecordPlayImageProtocol_h
#define P2PCamera_KYLRemoteRecordPlayImageProtocol_h

#import <Foundation/Foundation.h>

@protocol KYLRemoteRecordPlayImageProtocol<NSObject>

@optional

//remote record file playback

- (void) KYLRemoteRecordPlayImageProtocol_didReceiveTheStartPlayRemoteRecordFile:(NSString *) strDID
                                                                     result:(int) nResult
                                                                   filePath:(NSString *) sFilePath
                                                                 audipParam:(int) nAudioParam
                                                                   beginPos:(int) nBeginPosSec
                                                                 timeLenSec:(int) nTimeLenSec
                                                                   fileSize:(int) nFileSizeKB
                                                                 playbackID:(int) nPlayBackID
                                                                   reserve1:(NSString *) sReserve1
                                                                   reserve2:(NSString *) sReserve2;

- (void) KYLRemoteRecordPlayImageProtocol_didReceiveTheStopPlayRemoteRecordFile:(NSString *) strDID result:(int) nResult filePath:(NSString *) sFilePath reserve1:(NSString *) sReserve1;

- (void) KYLRemoteRecordPlayImageProtocol_didReceiveRemoteRecordPlaybackMJPEGImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp   timeProgressSec:(int) nTimeProgressSec DID:(NSString *)did user:(void *) pUser;

- (void) KYLRemoteRecordPlayImageProtocol_didReceiveRemoteRecordPlaybackOneVideoFrameYUVNotify: (char*) yuvdata length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp   timeProgressSec:(int) nTimeProgressSec DID:(NSString *)did user:(void *) pUser;

- (void) KYLRemoteRecordPlayImageProtocol_didReceiveRemoteRecordPlaybackOneVideoFrameRGB24Notify: (char*) rgb24data length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp   timeProgressSec:(int) nTimeProgressSec DID:(NSString *)did user:(void *) pUser;

- (void) KYLRemoteRecordPlayImageProtocol_didReceiveRemoteRecordPlaybackOneH264VideoFrameWithH264Data: (char*) h264Framedata length: (int) length type: (int) type timestamp: (NSInteger) timestamp   timeProgressSec:(int) nTimeProgressSec DID:(NSString *)did user:(void *) pUser;

- (void) KYLRemoteRecordPlayImageProtocol_didReceiveRemoteRecordPlaybackDataFinishedWithTimestamp: (NSInteger) timestamp   timeProgressSec:(int) nTimeProgressSec DID:(NSString *)did user:(void *) pUser;


@end

#endif
