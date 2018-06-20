//
//  KYLSetUserInfoProtocol.h
//  P2PCamera
//
//
//


#ifndef P2PCamera_KYLSetUserInfoProtocol_h
#define P2PCamera_KYLSetUserInfoProtocol_h

#import <Foundation/Foundation.h>

@protocol KYLSetUserInfoProtocol <NSObject>

@optional
- (void) KYLSetUserInfoProtocol_didReceiveGetUserPwdResult:(NSString *)did admin:(NSString*)strAdmin adminPwd:(NSString*)strAdminPwd vistor:(NSString*)strVistor vistorPwd:(NSString*)strVistorPwd resever:(NSString*)strReserver user:(void *) pUser;

- (void) KYLSetUserInfoProtocol_didSetUserInfoFinish:(NSString *) did result:(int) nResult reserver:(NSString *) sReserver  user:(void *) pUser;



@end

#endif
