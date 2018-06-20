//
//  KYLCameraPushFunctionSetProtocol.h
//  P2PCamera
//
//
//

#ifndef P2PCamera_KYLCameraPushFunctionSetProtocol_h
#define P2PCamera_KYLCameraPushFunctionSetProtocol_h

#import <Foundation/Foundation.h>

@protocol KYLCameraPushFunctionSetProtocol<NSObject>

@optional

-  (void) didKYLCameraPushFunctionSetProtocolSetFinished:(NSString *) did result:(int) nResult enable:(int) bEnable reserve:(NSString *) reserve  user:(void *) pUser;

-  (void) didKYLCameraPushFunctionSetProtocolGetPushStatusFinished:(NSString *) did result:(int) nResult enable:(int) bEnable reserve:(NSString *) reserve  user:(void *) pUser;

@end

#endif
