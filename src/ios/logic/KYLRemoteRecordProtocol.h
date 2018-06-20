//
//  KYLSetSDCardScheduleProtocol.h
//  P2PCamera
//
//
//

#ifndef P2PCamera_KYLSetSDCardScheduleProtocol_h
#define P2PCamera_KYLSetSDCardScheduleProtocol_h
#import <Foundation/Foundation.h>

@protocol KYLRemoteRecordProtocol<NSObject>

@optional

//remote record file playback
- (void) KYLRemoteRecordProtocol_didReceiveTheGetRemoteRecordDaysByMonth:(NSString *) strDID recordType:(int) nRecType yearMonth:(int) nYearMonth theRecordedDays:(NSArray *) dayList reserve:(NSString *) sReserve;
- (void) KYLRemoteRecordProtocol_didReceiveTheGetRemoteRecordFilesInOneDay:(NSString *) strDID
                                            result:(int) nResult
                                      fileTotalNum:(int) nFileTotalNum
                                 beginNofoThisTime:(int) nBeginNoOfThisTime
                                   endNoOfThisTime:(int) nEndNoOfThisTime
                                    theRecordFiles:(NSArray *) allRecordFilesByDayList;
- (void) KYLRemoteRecordProtocol_didReceiveTheGetOneRemoteRecordFileInOneDay:(NSString *) strDID
                                            filePath:(NSString *) sFilePath
                                           startTime:(NSString *) sStartTime
                                             endTime:(NSString *) sEndTime
                                      fileTimeLength:(int) nTimeLength
                                            fileSize:(int) nFileSize
                                          recordType:(int) nRecordType
                                             reserve:(NSString *) sReserve
                                       isTheLastItem:(BOOL) bLast;
- (void) KYLRemoteRecordProtocol_didReceiveTheStartPlayRemoteRecordFile:(NSString *) strDID
                                         result:(int) nResult
                                       filePath:(NSString *) sFilePath
                                     audipParam:(int) nAudioParam
                                       beginPos:(int) nBeginPosSec
                                     timeLenSec:(int) nTimeLenSec
                                       fileSize:(int) nFileSizeKB
                                     playbackID:(int) nPlayBackID
                                       reserve1:(NSString *) sReserve1
                                       reserve2:(NSString *) sReserve2;

- (void) KYLRemoteRecordProtocol_didReceiveTheStopPlayRemoteRecordFile:(NSString *) strDID result:(int) nResult filePath:(NSString *) sFilePath reserve1:(NSString *) sReserve1;
- (void) KYLRemoteRecordProtocol_didReceiveRemoteRecordPlaybackMJPEGImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp DID:(NSString *)did user:(void *) pUser;

- (void) KYLRemoteRecordProtocol_didReceiveRemoteRecordPlaybackOneVideoFrameYUVNotify: (char*) yuvdata length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did user:(void *) pUser;

- (void) KYLRemoteRecordProtocol_didReceiveRemoteRecordPlaybackOneVideoFrameRGB24Notify: (char*) rgb24data length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did user:(void *) pUser;

- (void) KYLRemoteRecordProtocol_didReceiveRemoteRecordPlaybackOneH264VideoFrameWithH264Data: (char*) h264Framedata length: (int) length type: (int) type timestamp: (NSInteger) timestamp DID:(NSString *)did user:(void *) pUser;


@end

#endif
