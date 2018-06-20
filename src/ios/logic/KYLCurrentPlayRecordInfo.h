//
//  KYLCurrentPlayRecordInfo.h
//  SEP2PAppSDKDemo
//
//
//

#import <Foundation/Foundation.h>

@interface KYLCurrentPlayRecordInfo : NSObject
{
    int  m_nResult;	//0:OK; 1:playback end;    Error:[11:already playback; 12:failed to open file; 13:playback fail;]
    int  m_nAudioParam; //-1 no audio; >=0 with audio:[samplerate << 2) | (databits << 1) | (channel)], samplerate refer to SEP2P_ENUM_AUDIO_SAMPLERATE; databits refer to SEP2P_ENUM_AUDIO_DATABITS; channel refer to SEP2P_ENUM_AUDIO_CHANNEL
    NSString  *m_sReserve1;
    int m_nBeginPos_sec;	//unit: second
    NSString  * m_sFilePath;
    int m_nTimeLen_sec;		//unit: second, record file playback total time
    int m_nFileSize_KB;		//unit: KBytes, record file size in byte
    int m_nPlaybackID;		//this id will assign to STREAM_HEAD.reserve2[2] ~ STREAM_HEAD.reserve2[5]
    NSString  *m_sReserve2;
}

@property (nonatomic, assign) int  m_nResult;	//0:OK; 1:playback end;    Error:[11:already playback; 12:failed to open file; 13:playback fail;]
@property (nonatomic, assign) int  m_nAudioParam; //-1 no audio; >=0 with audio:[samplerate << 2) | (databits << 1) | (channel)], samplerate refer to SEP2P_ENUM_AUDIO_SAMPLERATE; databits refer to SEP2P_ENUM_AUDIO_DATABITS; channel refer to SEP2P_ENUM_AUDIO_CHANNEL
@property (nonatomic, retain) NSString  *m_sReserve1;
@property (nonatomic, assign) int m_nBeginPos_sec;	//unit: second
@property (nonatomic, retain) NSString  *m_sFilePath;
@property (nonatomic, assign) int m_nTimeLen_sec;		//unit: second, record file playback total time
@property (nonatomic, assign) int m_nFileSize_KB;		//unit: KBytes, record file size in byte
@property (nonatomic, assign) int m_nPlaybackID;		//this id will assign to STREAM_HEAD.reserve2[2] ~ STREAM_HEAD.reserve2[5]
@property (nonatomic, retain) NSString  *m_sReserve2;

@end
