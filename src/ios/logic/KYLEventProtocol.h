//
//  KYLEventProtocol.h
//  P2PCamera
//
//
//

#ifndef P2PCamera_KYLEventProtocol_h
#define P2PCamera_KYLEventProtocol_h
#import <Foundation/Foundation.h>

@protocol KYLEventProtocol <NSObject>

@optional

- (void) KYLEventProtocol_didSucceedGetCameraHardVerson:(NSString *) strDID
                            p2papi_ver:(NSString *) p2papi_ver
                        fwp2p_app_ver :(NSString *)fwp2p_app_ver  fwp2p_app_buildtime :(NSString *)fwp2p_app_buildtime fwddns_app_ver:(NSString *)fwddns_app_ver
                            fwhard_ver:(NSString *)fwhard_ver
                                vendor:(NSString *)vendor
                               product:(NSString *)product
                               reserve: (NSString *)reserve  user:(void *) pUser;

-  (void) KYLEventProtocol_didReceiveCameraStatus:(NSString *) did status:(int) status reserve:(NSString *) reserve1 user:(void *) pUser;

@end

#endif
