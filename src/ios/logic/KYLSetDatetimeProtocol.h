//
//  KYLSetDatetimeProtocol.h
//  P2PCamera
//
//
//

#ifndef P2PCamera_KYLSetDatetimeProtocol_h
#define P2PCamera_KYLSetDatetimeProtocol_h

#import <Foundation/Foundation.h>

@protocol KYLSetDatetimeProtocol <NSObject>

@optional

- (void) KYLSetDatetimeProtocol_didReceiveGetDateTimeParams:(NSString *) strDID now:(int) now tz:(int) tz ntpEnable:(int) ntpEnable ntpServer:(NSString *) ntpSvr  indexOfTimeZoneTable:(int) nIndex  user:(void *) pUser;

- (void) KYLSetDatetimeProtocol_didSetDatetimeInfoFinish:(NSString *) did result:(int) nResult reserver:(NSString *) sReserver  user:(void *) pUser;


@end

#endif
