//
//  KYLSetFTPInfoProtocol.h
//  P2PCamera
//
//
//

#ifndef P2PCamera_KYLSetFTPInfoProtocol_h
#define P2PCamera_KYLSetFTPInfoProtocol_h

#import <Foundation/Foundation.h>


@protocol KYLSetFTPInfoProtocol <NSObject>

@optional

- (void) KYLSetFTPInfoProtocol_didSucceedGetFtpParam:(NSString*) strDID ftpserver: (NSString*) svr user:(NSString*) user pwd:(NSString*) pwd dir:(NSString*)dir port:(int)port uploadinterval: (int) uploadinterval mode:(int)mode user:(void *) pUser;

- (void) KYLSetFTPInfoProtocol_didSetCameraFTPInfoFinish:(NSString *) did result:(int) nResult reserver:(NSString *) sReserver  user:(void *) pUser;


@end

#endif
