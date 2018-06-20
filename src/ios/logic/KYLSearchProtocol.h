//
//  KYLSearchProtocol.h
//  SEP2PAppSDKDemo
//


#import <Foundation/Foundation.h>


@protocol KYLSearchProtocol <NSObject>

@optional
- (void) didSucceedSearchOneDevice: (NSString *) chDID ip:(NSString *) ip port:(int) port devName:(NSString *) devName macaddress:(NSString *) mac productType:(NSString *) productType;

@end