//
//  KYLSearchTool.h
//  SEP2PAppSDKDemo
//


#import <Foundation/Foundation.h>
#import "KYLSearchProtocol.h"

@interface KYLSearchTool : NSObject
{
    
}

@property (nonatomic, assign) id<KYLSearchProtocol> delegate;

/*!
 @method
 @abstract startSearch.
 @discussion start search all device in LAN network.
 @result >=0: means that excute successfully, other wise means excute failed .
 */
- (int ) startSearch;

/*!
 @method
 @abstract stopSearch.
 @discussion stop search all device in LAN network.
 @result >=0: means that excute successfully, other wise means excute failed . .
 */
- (int) stopSearch;

@end
