//
//  KYLSetEmailProtocol.h
//  P2PCamera
//
//
//

#ifndef P2PCamera_KYLSetEmailProtocol_h
#define P2PCamera_KYLSetEmailProtocol_h
#import <Foundation/Foundation.h>

@protocol KYLSetEmailProtocol <NSObject>

@optional

- (void) KYLSetEmailProtocol_didSucceedGetMailParam:(NSString*) strDID server:(NSString *) server user:(NSString*)user pwd:(NSString*)pwd sender:(NSString *) sender recv1:(NSString*)recv1 recv2:(NSString*)recv2 recv3:(NSString*)recv3 recv4:(NSString*)recv4  subject:(NSString *) strSubject port:(int) port ssl:(int)ssl  user:(void *) pUser;

- (void) KYLSetEmailProtocol_didSetCameraEmailInfoFinish:(NSString *) did result:(int) nResult reserver:(NSString *) sReserver  user:(void *) pUser;


@end

#endif
