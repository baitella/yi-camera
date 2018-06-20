//
//  KYLDeviceStatusChangedProtocol.h
//  P2PCamera
//
//
//

#ifndef P2PCamera_KYLDeviceStatusChangedProtocol_h
#define P2PCamera_KYLDeviceStatusChangedProtocol_h

#import <Foundation/Foundation.h>

@protocol KYLDeviceStatusChangedProtocol<NSObject>

@optional

//remote record file playback
// camera's status notification
-  (void) didReceiveCameraStatus_KYLDeviceStatusChangedProtocol:(NSString *) did status:(int) status reserve:(NSString *) reserve1 user:(void *) pUser;



@end

#endif
