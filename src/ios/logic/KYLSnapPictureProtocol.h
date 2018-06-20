//
//  KYLSnapPictureProtocol.h
//  P2PCamera
//
//
//

#ifndef P2PCamera_KYLSnapPictureProtocol_h
#define P2PCamera_KYLSnapPictureProtocol_h
#import <Foundation/Foundation.h>
@protocol KYLSnapPictureProtocol <NSObject>

@optional

- (void) KYLSnapPictureProtocol_didSucceedSnapshotNotify: (NSString*) strDID data:(char*) data length:(int) length user:(void *) pUser;

- (void) KYLSnapPictureProtocol_didSucceedSnapshotNotify: (NSString*) strDID image:(UIImage *) image user:(void *) pUser;


@end

#endif
