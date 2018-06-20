//
//  KYLSetAlarmInfoProtocol.h
//  P2PCamera
//
//
//

#ifndef P2PCamera_KYLSetAlarmInfoProtocol_h
#define P2PCamera_KYLSetAlarmInfoProtocol_h

#import <Foundation/Foundation.h>

@protocol KYLSetAlarmInfoProtocol <NSObject>

@optional

- (void) KYLSetAlarmInfoProtocol_didSucceedGetAlarmProtocolResult:(NSString*) strDID
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

- (void) KYLSetAlarmInfoProtocol_didSucceedGetAlarmProtocolResult2:(NSString*) strDID result:(MSG_GET_ALARM_INFO_RESP *) pResp;

- (void) KYLSetAlarmInfoProtocol_didSetCameraAlarmInfoFinish:(NSString *) did result:(int) nResult reserver:(NSString *) sReserver  user:(void *) pUser;

@end

#endif
