//
//  KYLCurrentPlayRecordInfo.m
//  SEP2PAppSDKDemo
//
//
//

#import "KYLCurrentPlayRecordInfo.h"

@implementation KYLCurrentPlayRecordInfo
@synthesize m_nResult;
@synthesize m_nAudioParam;
@synthesize m_sReserve1;
@synthesize m_nBeginPos_sec;
@synthesize m_sFilePath;
@synthesize m_nTimeLen_sec;
@synthesize m_nFileSize_KB;
@synthesize m_nPlaybackID;
@synthesize m_sReserve2;


- (void) dealloc
{
    self.m_sReserve1 = nil;
    self.m_sReserve2 = nil;
    self.m_sFilePath = nil;
    [super dealloc];
}

@end
