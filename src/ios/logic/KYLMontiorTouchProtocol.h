//
//  KYLMontiorTouchProtocol.h
//  P2PCamera
//
//
//

#ifndef P2PCamera_KYLMontiorTouchProtocol_h
#define P2PCamera_KYLMontiorTouchProtocol_h

#import <Foundation/Foundation.h>
#import "KYLDefine.h"


@protocol KYLMontiorTouchProtocol <NSObject>

@optional
- (void)KYLMontiorTouchProtocolDidGestureSwiped:(Direction)direction user:(void *) pUser;
- (void)KYLMontiorTouchProtocolDidGesturePinched:(CGFloat)scale user:(void *) pUser;
- (void)KYLMontiorTouchProtocolDidGestureOneTap:(void *) pUser;
- (void)KYLMontiorTouchProtocolDidGestureDoubleTap:(void *) pUser;
- (void)KYLMontiorTouchProtocolDidGestureLongPressed:(void *) pUser;


@end

#endif
