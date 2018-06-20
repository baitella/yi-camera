//
//  KYLSetCameraParamsProtocol.h
//  P2PCamera
//
//
//

#ifndef P2PCamera_KYLSetCameraParamsProtocol_h
#define P2PCamera_KYLSetCameraParamsProtocol_h
#import <Foundation/Foundation.h>

@protocol KYLSetCameraParamsProtocol <NSObject>

@optional
// get camera's params
- (void) KYLSetCameraParamsProtocol_didReceiveGetCameraParams:(NSString *)did resolution:(int) nResultion bright:(int) nBright contrast:(int) nContrast hue:(int) nHue saturation:(int) nSaturation osd:(int) bOSD mode:(int) nMode flip:(int) nFlip reserve1:(NSString *) strReserve1 irLed:(int) nIRLed reserver2:(NSString *) strReserver2 user:(void *) pUser;

- (void) KYLSetCameraParamsProtocol_didSetCameraParamsFinish:(NSString *) did result:(int) nResult reserver:(NSString *) sReserver  bitMaskToSet:(int) nBitMaskToSet  user:(void *) pUser;
- (void) KYLSetCameraParamsProtocol_didSetDefaultCameraParamsFinish:(NSString *) did result:(int) nResult reserver:(NSString *) sReserver  user:(void *) pUser;

@end

#endif
