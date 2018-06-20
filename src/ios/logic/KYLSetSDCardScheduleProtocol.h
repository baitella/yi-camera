//
//  KYLSetSDCardScheduleProtocol.h
//  P2PCamera
//
//
//

#ifndef P2PCamera_KYLSetSDCardScheduleProtocol_h
#define P2PCamera_KYLSetSDCardScheduleProtocol_h
#import <Foundation/Foundation.h>

@protocol KYLSetSDCardScheduleProtocol <NSObject>

@optional

-(void)KYLSetSDCardScheduleProtocol_didSucceedGetSdcardScheduleParams:(NSString *)did
                    bRecordCoverInSDCard:(int)bRecordCoverInSDCard
                          nRecordTimeLen:(int)nRecordTimeLen
                                reserve1:(int)reserve1
                             bRecordTime:(int) bRecordTime
                                reserve2:(NSString *)reserve2
                           nSDCardStatus:(int)nSDCardStatus
                           nSDTotalSpace:(int)nSDTotalSpace
                            nSDFreeSpace:(int)nSDFreeSpace user:(void *) pUser;
- (void) KYLSetSDCardScheduleProtocol_didSetCameraSDCardRecordScheduleParamsFinish:(NSString *) did result:(int) nResult reserver:(NSString *) sReserver  user:(void *) pUser;

@end

#endif
