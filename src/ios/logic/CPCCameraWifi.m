#import <Foundation/Foundation.h>
#import "CPCCameraWifi.h"
#import "SEAT_API.h"

@implementation CPCCameraWifi

- (id)init {
    self = [super init];
    if (self) {
        initialized = false;
        handle = NULL;
    }
    return self;
}

- (bool)initialize
{
    if (initialized) {
        NSLog(@"Already initalized");
        return false;
    }
    
    int status = -1;
    
    status = SEAT_Init(SAMPLE_RATE_16K, TRANSMIT_TYPE_WIFI_PWD);
    NSLog(@"SEAT_Init: %d", status);
    if (status < 0) {
        return false;
    }
    
    status = SEAT_Create(&handle, AT_PLAYER, CPU_PRIORITY);
    NSLog(@"SEAT_Create: %d", status);
    if (status < 0) {
        return false;
    }

    status = SEAT_SetCallback(handle, (__bridge void *)self, onBegin, onEnd);
    NSLog(@"SEAT_SetCallback: %d", status);
    
    initialized = true;

    return true;
}

- (void)deinitialize
{
    SEAT_Destroy(&handle);
    SEAT_DeInit();
}

- (void)serializeToAir:(NSString *)ssid withPassword:(NSString *)password andSecurify:(int)securityMode
{
    int status;
    
    status = SEAT_Start(handle);
    NSLog(@"SEAT_Start: %d", status);
    
    status = SEAT_WriteSSIDWiFi(handle,
                                0,
                                (char *)[ssid UTF8String],
                                (INT32)[ssid length],
                                (char *)[password UTF8String],
                                (INT32)[password length],
                                securityMode,
                                NULL);
    NSLog(@"SEAT_WriteSSIDWifi: %d", status);
    
    status = SEAT_Stop(handle);
    NSLog(@"SEAT_Stop: %d", status);
}

void onBegin(void *userData, int atType, float soundTime)
{
    NSLog(@"CameraWifi:onBegin");
}
           
void onEnd(void *userData, int atType, float soundTime, int result, char *data, int dataLen)
{
    NSLog(@"CameraWifi:onEnd");
}

@end