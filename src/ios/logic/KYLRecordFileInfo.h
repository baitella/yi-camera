//
//  KYLRecordFileInfo.h
//  SEP2PAppSDKDemo
//
//
//

#import <Foundation/Foundation.h>

@interface KYLRecordFileInfo : NSObject
{
    int m_nRecordType;
    NSString  *m_sFilePath;
    NSString *m_sStartTime;
    NSString *m_sEndTime;
    int m_nTimeLength_Sec;
    int m_nFileSize_KB;
    NSString *m_sReserve;
}

@property (nonatomic, assign) int m_nRecordType;
@property (nonatomic, retain) NSString *m_sFilePath;
@property (nonatomic, retain) NSString *m_sStartTime;
@property (nonatomic, retain) NSString *m_sEndTime;
@property (nonatomic, assign) int m_nTimeLength_Sec;
@property (nonatomic, assign) int m_nFileSize_KB;
@property (nonatomic, retain) NSString *m_sReserve;
@end
