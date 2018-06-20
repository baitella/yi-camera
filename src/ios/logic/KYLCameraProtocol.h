//
//  KYLCameraProtocol.h
//  SEP2PAppSDKDemo
//


#import <Foundation/Foundation.h>



/*!
 @protocol
 @abstract KYLCameraProtocol
 @discussion KYLCameraProtocol use to call back the caller for the sdk excute result return.
 */
@protocol KYLCameraProtocol <NSObject>



@optional

// camera's status notification
-  (void) didReceiveCameraStatus:(NSString *) did status:(int) status reserve:(NSString *) reserve1 user:(void *) pUser;

// get camera's params
- (void) didReceiveGetCameraParams:(NSString *)did resolution:(int) nResultion bright:(int) nBright contrast:(int) nContrast hue:(int) nHue saturation:(int) nSaturation osd:(int) bOSD mode:(int) nMode flip:(int) nFlip reserve1:(NSString *) strReserve1 irLed:(int) nIRLed reserver2:(NSString *) strReserver2 user:(void *) pUser;

- (void) didSetCameraParamsFinish:(NSString *) did result:(int) nResult reserver:(NSString *) sReserver  bitMaskToSet:(int) nBitMaskToSet  user:(void *) pUser;
- (void) didSetDefaultCameraParamsFinish:(NSString *) did result:(int) nResult reserver:(NSString *) sReserver  user:(void *) pUser;
// search device in lan network

- (void) didSucceedGetOneSearchCameraResult:(NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:(NSString *)port DID:(NSString*)did user:(void *) pUser;


// set user information

- (void) didReceiveGetUserPwdResult:(NSString *)did admin:(NSString*)strAdmin adminPwd:(NSString*)strAdminPwd vistor:(NSString*)strVistor vistorPwd:(NSString*)strVistorPwd resever:(NSString*)strReserver user:(void *) pUser;

- (void) didSetUserInfoFinish:(NSString *) did result:(int) nResult reserver:(NSString *) sReserver  user:(void *) pUser;

//set wifi, get wifi list

- (void) didReceiveGetWifiParams: (NSString*)strDID enable:(NSInteger)enable ssid:(NSString*)strSSID channel:(NSInteger)channel mode:(NSInteger)mode authtype:(NSInteger)authtype encryp:(NSInteger)encryp keyformat:(NSInteger)keyformat defkey:(NSInteger)defkey strKey1:(NSString*)strKey1 strKey2:(NSString*)strKey2 strKey3:(NSString*)strKey3 strKey4:(NSString*)strKey4 key1_bits:(NSInteger)key1_bits key2_bits:(NSInteger)key2_bits key3_bits:(NSInteger)key3_bits key4_bits:(NSInteger)key4_bits wpa_psk:(NSString*)wpa_psk user:(void *) pUser;

- (void) didSucceedSetWifiParams: (NSString*)strDID enable:(NSInteger)enable ssid:(NSString*)strSSID channel:(NSInteger)channel mode:(NSInteger)mode authtype:(NSInteger)authtype encryp:(NSInteger)encryp keyformat:(NSInteger)keyformat defkey:(NSInteger)defkey strKey1:(NSString*)strKey1 strKey2:(NSString*)strKey2 strKey3:(NSString*)strKey3 strKey4:(NSString*)strKey4 key1_bits:(NSInteger)key1_bits key2_bits:(NSInteger)key2_bits key3_bits:(NSInteger)key3_bits key4_bits:(NSInteger)key4_bits wpa_psk:(NSString*)wpa_psk user:(void *) pUser;

- (void) didSucceedGetOneWifiScanResult: (NSString*)strDID ssid:(NSString*)strSSID mac:(NSString*)strMac security:(NSInteger)security db0:(NSString*)db0 db1:(NSString*)db1 mode:(NSInteger)mode channel:(NSInteger)channel bEnd:(NSInteger)bEnd user:(void *) pUser;

- (void) didSetWifiFinish:(NSString *) did result:(int) nResult reserver:(NSString *) sReserver  user:(void *) pUser;

// get datetime information
- (void) didReceiveGetDateTimeParams:(NSString *) strDID now:(int) now tz:(int) tz ntpEnable:(int) ntpEnable ntpServer:(NSString *) ntpSvr indexOfTimeZoneTable:(int) nIndex user:(void *) pUser;

- (void) didSetDatetimeInfoFinish:(NSString *) did result:(int) nResult reserver:(NSString *) sReserver  user:(void *) pUser;

// snap picture

- (void) didSucceedSnapshotNotify: (NSString*) strDID data:(char*) data length:(int) length user:(void *) pUser;

- (void) didSucceedSnapshotNotify: (NSString*) strDID image:(UIImage *) image user:(void *) pUser;


// set sdcard schedule
-(void)didSucceedGetSdcardScheduleParams:(NSString *)did
                     bRecordCoverInSDCard:(int)bRecordCoverInSDCard
                            nRecordTimeLen:(int)nRecordTimeLen
                             reserve1:(int)reserve1
                      bRecordTime:(int) bRecordTime
                        reserve2:(NSString *)reserve2
                                 nSDCardStatus:(int)nSDCardStatus
                                 nSDTotalSpace:(int)nSDTotalSpace
                                  nSDFreeSpace:(int)nSDFreeSpace user:(void *) pUser;
- (void) didSetCameraSDCardRecordScheduleParamsFinish:(NSString *) did result:(int) nResult reserver:(NSString *) sReserver  user:(void *) pUser;




// set email information

- (void) didSucceedGetMailParam:(NSString*) strDID server:(NSString *) server user:(NSString*)user pwd:(NSString*)pwd sender:(NSString *) sender recv1:(NSString*)recv1 recv2:(NSString*)recv2 recv3:(NSString*)recv3 recv4:(NSString*)recv4  subject:(NSString *) strSubject port:(int) port ssl:(int)ssl  user:(void *) pUser;

- (void) didSetCameraEmailInfoFinish:(NSString *) did result:(int) nResult reserver:(NSString *) sReserver  user:(void *) pUser;


// set ftp information

- (void) didSucceedGetFtpParam:(NSString*) strDID ftpserver: (NSString*) svr user:(NSString*) user pwd:(NSString*) pwd dir:(NSString*)dir port:(int)port uploadinterval: (int) uploadinterval mode:(int)mode user:(void *) pUser;

- (void) didSetCameraFTPInfoFinish:(NSString *) did result:(int) nResult reserver:(NSString *) sReserver  user:(void *) pUser;


// get camera hard soft version informat
- (void) didSucceedGetCameraHardVerson:(NSString *) strDID
                            p2papi_ver:(NSString *) p2papi_ver
                        fwp2p_app_ver :(NSString *)fwp2p_app_ver  fwp2p_app_buildtime :(NSString *)fwp2p_app_buildtime fwddns_app_ver:(NSString *)fwddns_app_ver
                            fwhard_ver:(NSString *)fwhard_ver
                                vendor:(NSString *)vendor
                               product:(NSString *)product
                               reserve: (NSString *)reserve  user:(void *) pUser;


// set alarm information
- (void) didSucceedGetAlarmProtocolResult:(NSString*) strDID
                               bMDEnable:(int)bMDEnable
          nMDSensitivity:(int)nMDSensitivity
                 bInputAlarm:(int)bInputAlarm
                  nInputAlarmMode:(int)nInputAlarmMode
              bIOLinkageWhenAlarm:(int)bIOLinkageWhenAlarm
                   reserve1:(int)reserve1
                 nPresetbitWhenAlarm:(int)nPresetbitWhenAlarm
                        bMailWhenAlarm:(int)bMailWhenAlarm
                    bSnapshotToSDWhenAlarm:(int)bSnapshotToSDWhenAlarm
             bRecordToSDWhenAlarm:(int)bRecordToSDWhenAlarm
                      bSnapshotToFTPWhenAlarm:(int)bSnapshotToFTPWhenAlarm
                bRecordToFTPWhenAlarm:(int)bRecordToFTPWhenAlarm
                  strreserve2:(NSString *)strreserve2 user:(void *) pUser;



- (void) didSetCameraAlarmInfoFinish:(NSString *) did result:(int) nResult reserver:(NSString *) sReserver  user:(void *) pUser;

// video stream

- (void) didReceiveMJPEGImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp DID:(NSString *)did user:(void *) pUser;

- (void) didReceiveOneVideoFrameYUVNotify: (char*) yuvdata length:(unsigned long)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did user:(void *) pUser;



- (void) didReceiveOneVideoFrameRGB24Notify: (char*) rgb24data length:(unsigned long)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did user:(void *) pUser;

- (void) didReceiveOneH264VideoFrameWithH264Data: (char*) h264Framedata length: (unsigned long) length type: (int) type timestamp: (NSInteger) timestamp DID:(NSString *)did user:(void *) pUser;


// audio stream


// talk stream


// talk request response
- (void) didReceiveTheTalkResponseNotify:(NSString *) strDID talkStatus:(int) nTalkStatus reserver:(NSString *) sReserve;


//remote record file playback
- (void) didReceiveTheGetRemoteRecordDaysByMonth:(NSString *) strDID recordType:(int) nRecType yearMonth:(int) nYearMonth theRecordedDays:(NSArray *) dayList reserve:(NSString *) sReserve;
- (void) didReceiveTheGetRemoteRecordFilesInOneDay:(NSString *) strDID
                                            result:(int) nResult
                                      fileTotalNum:(int) nFileTotalNum
                                 beginNofoThisTime:(int) nBeginNoOfThisTime
                                   endNoOfThisTime:(int) nEndNoOfThisTime
                                    theRecordFiles:(NSArray *) allRecordFilesByDayList;
- (void) didReceiveTheGetOneRemoteRecordFileInOneDay:(NSString *) strDID
                                       filePath:(NSString *) sFilePath
                                           startTime:(NSString *) sStartTime
                                             endTime:(NSString *) sEndTime
                                             fileTimeLength:(int) nTimeLength
                                            fileSize:(int) nFileSize
                                          recordType:(int) nRecordType
                                             reserve:(NSString *) sReserve
                                            isTheLastItem:(BOOL) bLast;
- (void) didReceiveTheStartPlayRemoteRecordFile:(NSString *) strDID
                                         result:(int) nResult
                                       filePath:(NSString *) sFilePath
                                     audipParam:(int) nAudioParam
                                       beginPos:(int) nBeginPosSec
                                     timeLenSec:(int) nTimeLenSec
                                       fileSize:(int) nFileSizeKB
                                     playbackID:(int) nPlayBackID
                                      reserve1:(NSString *) sReserve1
                                       reserve2:(NSString *) sReserve2;

- (void) didReceiveTheStopPlayRemoteRecordFile:(NSString *) strDID result:(int) nResult filePath:(NSString *) sFilePath reserve1:(NSString *) sReserve1;
- (void) didReceiveRemoteRecordPlaybackMJPEGImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp DID:(NSString *)did user:(void *) pUser;

- (void) didReceiveRemoteRecordPlaybackOneVideoFrameYUVNotify: (char*) yuvdata length:(unsigned long)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did user:(void *) pUser;

- (void) didReceiveRemoteRecordPlaybackOneVideoFrameRGB24Notify: (char*) rgb24data length:(unsigned long)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did user:(void *) pUser;

- (void) didReceiveRemoteRecordPlaybackOneH264VideoFrameWithH264Data: (char*) h264Framedata length: (unsigned long) length type: (int) type timestamp: (NSInteger) timestamp DID:(NSString *)did user:(void *) pUser;



@end