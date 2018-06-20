//
//  KYLSetWifiProtocol.h
//  P2PCamera
//
//
//

#ifndef P2PCamera_KYLSetWifiProtocol_h
#define P2PCamera_KYLSetWifiProtocol_h

#import <Foundation/Foundation.h>

@protocol KYLSetWifiProtocol <NSObject>

@optional

- (void) KYLSetWifiProtocol_didReceiveGetWifiParams: (NSString*)strDID enable:(NSInteger)enable ssid:(NSString*)strSSID channel:(NSInteger)channel mode:(NSInteger)mode authtype:(NSInteger)authtype encryp:(NSInteger)encryp keyformat:(NSInteger)keyformat defkey:(NSInteger)defkey strKey1:(NSString*)strKey1 strKey2:(NSString*)strKey2 strKey3:(NSString*)strKey3 strKey4:(NSString*)strKey4 key1_bits:(NSInteger)key1_bits key2_bits:(NSInteger)key2_bits key3_bits:(NSInteger)key3_bits key4_bits:(NSInteger)key4_bits wpa_psk:(NSString*)wpa_psk user:(void *) pUser;

- (void) KYLSetWifiProtocol_didSucceedSetWifiParams: (NSString*)strDID enable:(NSInteger)enable ssid:(NSString*)strSSID channel:(NSInteger)channel mode:(NSInteger)mode authtype:(NSInteger)authtype encryp:(NSInteger)encryp keyformat:(NSInteger)keyformat defkey:(NSInteger)defkey strKey1:(NSString*)strKey1 strKey2:(NSString*)strKey2 strKey3:(NSString*)strKey3 strKey4:(NSString*)strKey4 key1_bits:(NSInteger)key1_bits key2_bits:(NSInteger)key2_bits key3_bits:(NSInteger)key3_bits key4_bits:(NSInteger)key4_bits wpa_psk:(NSString*)wpa_psk user:(void *) pUser;

- (void) KYLSetWifiProtocol_didSucceedGetOneWifiScanResult: (NSString*)strDID ssid:(NSString*)strSSID mac:(NSString*)strMac security:(NSInteger)security db0:(NSString*)db0 db1:(NSString*)db1 mode:(NSInteger)mode channel:(NSInteger)channel bEnd:(NSInteger)bEnd user:(void *) pUser;

- (void) KYLSetWifiProtocol_didSetWifiFinish:(NSString *) did result:(int) nResult reserver:(NSString *) sReserver  user:(void *) pUser;


@end

#endif
