//
//  CBBopenALsound.m
//  IOTCamViewer
//
//  Created by tutk on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "KYLOpenALPlayer.h"

#ifdef DEBUG
//#   define LOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define LOG(fmt, ...) NSLog((@"" fmt), ##__VA_ARGS__);
#else
#define LOG(...)
#endif

@implementation KYLOpenALPlayer

@synthesize audioFormat;
@synthesize mDevice;
@synthesize mContext;
@synthesize soundDictionary;
@synthesize bufferStorageArray;

#pragma mark - openal function
-(void)initOpenAL:(int)format :(int)sampleRate_
{
    //processed =0;
    //queued =0;
    
    audioFormat = format;
    sampleRate = sampleRate_;
    
    //init the device and context
    mDevice=alcOpenDevice(NULL);
    if (mDevice) {
        mContext=alcCreateContext(mDevice, NULL);
        alcMakeContextCurrent(mContext);
    }
    
    //soundDictionary = [[NSMutableDictionary alloc]init];// not used
    //bufferStorageArray = [[NSMutableArray alloc]init];// not used
    
    alGenSources(1, &outSourceID);
    alSpeedOfSound(1.0);
    alDopplerVelocity(1.0);
    alDopplerFactor(1.0);
    alSourcef(outSourceID, AL_PITCH, 1.0f);
    alSourcef(outSourceID, AL_GAIN, 1.0f);
    alSourcei(outSourceID, AL_LOOPING, AL_FALSE);
    alSourcef(outSourceID, AL_SOURCE_TYPE, AL_STREAMING);
    
    //alSourcef(outSourceID, AL_BUFFERS_QUEUED, 29);
    
    /*
     updateBufferTimer = [NSTimer scheduledTimerWithTimeInterval: 1/58.0
     target:self
     selector:@selector(updateQueueBuffer)
     userInfo: nil
     repeats:YES];
     */
    
    //begin add by kongyulu at 20140229
    //    int aSampleRate,aBit,aChannel;
    //    aSampleRate = 8000;//temp->sampleRates;
    //    aBit = 16;//temp->aBits;
    //    aChannel =1;// temp->Channels;
    //
    //    ALenum format1;
    //
    //    if (aBit == 8) {
    //        if (aChannel == 1)
    //            format1 = AL_FORMAT_MONO8;
    //        else if(aChannel == 2)
    //            format1 = AL_FORMAT_STEREO8;
    //        else if( alIsExtensionPresent( "AL_EXT_MCFORMATS" ) )
    //        {
    //            if( aChannel == 4 )
    //            {
    //                format1 = alGetEnumValue( "AL_FORMAT_QUAD8" );
    //            }
    //            if( aChannel == 6 )
    //            {
    //                format1 = alGetEnumValue( "AL_FORMAT_51CHN8" );
    //            }
    //        }
    //    }
    //
    //    if( aBit == 16 )
    //    {
    //        if( aChannel == 1 )
    //        {
    //            format1 = AL_FORMAT_MONO16;
    //        }
    //        if( aChannel == 2 )
    //        {
    //            // NSLog(@"achhenl= 2!!!!!");
    //            format1 = AL_FORMAT_STEREO16;
    //        }
    //        if( alIsExtensionPresent( "AL_EXT_MCFORMATS" ) )
    //        {
    //            if( aChannel == 4 )
    //            {
    //                format1 = alGetEnumValue( "AL_FORMAT_QUAD16" );
    //            }
    //            if( aChannel == 6 )
    //            {
    //                NSLog(@"achannel = 6!!!!!!");
    //                format1 = alGetEnumValue( "AL_FORMAT_51CHN16" );
    //            }
    //        }
    //    }
    //    audioFormat = format1;
    //    sampleRate = aSampleRate;
    //end add by kongyulu at 20140229
}


- (BOOL) updateQueueBuffer
{
    ALint stateVaue;
    int processed, queued;
    
    
    alGetSourcei(outSourceID, AL_SOURCE_STATE, &stateVaue);
    
    if (stateVaue == AL_STOPPED /*||
                                 stateVaue == AL_PAUSED ||
                                 stateVaue == AL_INITIAL*/)
    {
        //[self playSound];
        return NO;
    }
    
    alGetSourcei(outSourceID, AL_BUFFERS_PROCESSED, &processed);
    alGetSourcei(outSourceID, AL_BUFFERS_QUEUED, &queued);
    
    while(processed--)
    {
        alSourceUnqueueBuffers(outSourceID, 1, &buff);
        alDeleteBuffers(1, &buff);
    }
    
    return YES;
}

- (void)openAudioFromQueue:(NSData *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSCondition* ticketCondition= [[NSCondition alloc] init];
    [ticketCondition lock];
    
    [self updateQueueBuffer];
    
    
    ALuint bufferID = 0;
    alGenBuffers(1, &bufferID);
    
    alBufferData(bufferID, audioFormat, [data bytes], (int)[data length], sampleRate);
    alSourceQueueBuffers(outSourceID, 1, &bufferID);
    
    ALint stateVaue;
    alGetSourcei(outSourceID, AL_SOURCE_STATE, &stateVaue);
    
    if (stateVaue != AL_PLAYING)
    {
        alSourcePlay(outSourceID);
    }
    
    [ticketCondition unlock];
    [ticketCondition release];
    ticketCondition = nil;
    
    [pool release];
    pool = nil;
}

#pragma mark - play/stop/clean function
-(void)playSound
{
    //alSourcePlay(outSourceID);
}

-(void)stopSound
{
    LOG(@"alSourceStop");
    alSourceStop(outSourceID);
}

-(void)cleanUpOpenAL
{
    int processed = 0;
    LOG(@"alGetSourcei");
    alGetSourcei(outSourceID, AL_BUFFERS_PROCESSED, &processed);
    
    while(processed--) {
        alSourceUnqueueBuffers(outSourceID, 1, &buff);
        alDeleteBuffers(1, &buff);
    }
    
    LOG(@"alDeleteSources");
    alDeleteSources(1, &outSourceID);
    
    alcMakeContextCurrent(NULL);
    
    LOG(@"alcDestroyContext");
    alcDestroyContext(mContext);
    
    LOG(@"alcCloseDevice");
    alcCloseDevice(mDevice);
    LOG(@"alcCloseDevice ---");
    
}

#pragma mark - 供参考  play/stop/clean

// the main method: grab the sound ID from the library
// and start the source playing
- (void)playSound:(NSString*)soundKey
{
    NSNumber* numVal = [soundDictionary objectForKey:soundKey];
    if (numVal == nil)
        return;
    
    unsigned int sourceID = [numVal unsignedIntValue];
    alSourcePlay(sourceID);
}

- (void)stopSound:(NSString*)soundKey
{
    NSNumber* numVal = [soundDictionary objectForKey:soundKey];
    if (numVal == nil)
        return;
    
    unsigned int sourceID = [numVal unsignedIntValue];
    alSourceStop(sourceID);
}


-(void)cleanUpOpenAL:(id)sender
{
    // delete the sources
    for (NSNumber* sourceNumber in [soundDictionary allValues])
    {
        unsigned int sourceID = [sourceNumber unsignedIntValue];
        alDeleteSources(1, &sourceID);
    }
    
    [soundDictionary removeAllObjects];
    // delete the buffers
    for (NSNumber* bufferNumber in bufferStorageArray)
    {
        unsigned int bufferID = [bufferNumber unsignedIntValue];
        alDeleteBuffers(1, &bufferID);
    }
    [bufferStorageArray removeAllObjects];
    
    // destroy the context
    alcDestroyContext(mContext);
    // close the device
    alcCloseDevice(mDevice);
}


#pragma mark - unused function
////////////////////////////////////////////
//crespo study openal function,need import audiotoolbox framework and 2 header file
////////////////////////////////////////////


// open the audio file
// returns a big audio ID struct
-(AudioFileID)openAudioFile:(NSString*)filePath
{
    AudioFileID outAFID;
    // use the NSURl instead of a cfurlref cuz it is easier
    NSURL * afUrl = [NSURL fileURLWithPath:filePath];
    // do some platform specific stuff..
#if TARGET_OS_IPHONE
    OSStatus result = AudioFileOpenURL((CFURLRef)afUrl, kAudioFileReadPermission, 0, &outAFID);
#else
    OSStatus result = AudioFileOpenURL((CFURLRef)afUrl, fsRdPerm, 0, &outAFID);
#endif
    if (result != 0)
        LOG(@"cannot openf file: %@",filePath);
    
    return outAFID;
}


// find the audio portion of the file
// return the size in bytes
-(UInt32)audioFileSize:(AudioFileID)fileDescriptor
{
    UInt64 outDataSize = 0;
    UInt32 thePropSize = sizeof(UInt64);
    OSStatus result = AudioFileGetProperty(fileDescriptor, kAudioFilePropertyAudioDataByteCount, &thePropSize, &outDataSize);
    if(result != 0)
        LOG(@"cannot find file size");
    
    return (UInt32)outDataSize;
}


-(void)dealloc
{
    // NSLog(@"openal sound dealloc");
    [soundDictionary release];
    [bufferStorageArray release];
    [super dealloc];
}

@end
