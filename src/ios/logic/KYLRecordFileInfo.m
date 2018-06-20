//
//  KYLRecordFileInfo.m
//  SEP2PAppSDKDemo
//
//
//

#import "KYLRecordFileInfo.h"

@implementation KYLRecordFileInfo
@synthesize m_nRecordType;
@synthesize m_sFilePath;
@synthesize m_sStartTime;
@synthesize m_sEndTime;
@synthesize m_nTimeLength_Sec;
@synthesize m_nFileSize_KB;
@synthesize m_sReserve;

- (void) dealloc
{
    self.m_sFilePath = nil;
    self.m_sStartTime = nil;
    self.m_sEndTime = nil;
    self.m_sReserve = nil;
    [super dealloc];
}

@end
