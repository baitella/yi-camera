#import "SEAT_API.h"

@interface CPCCameraWifi : NSObject {
    UCHAR *handle;
    
    bool initialized;
}

- (id)init;
- (bool)initialize;
- (void)deinitialize;
- (void)serializeToAir:(NSString *)ssid withPassword:(NSString *)password andSecurify:(int)securityMode;

@end