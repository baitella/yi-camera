//
//  SE_AudioCodec.h
//  SE_AudioCodec
//


/*!
 @header SE_AudioCodec
 @abstract This file define all the interface that encode or decode audio data.
 @author
 @version 1.00 2014/05/05
 */

#ifndef ____war__SE_AudioCodec__
#define ____war__SE_AudioCodec__

#ifdef WIN32DLL
	#define SEP2P_CALLBACK	  __stdcall
	#ifdef SE_AUDIOCODEC_EXPORTS
		#define SE_AUDIOCODEC_API  __declspec(dllexport)
	#else
		#define SE_AUDIOCODEC_API __declspec(dllimport)
	#endif

#else
    #define SE_AUDIOCODEC_API 

#endif //// #ifdef WIN32DLL


typedef int				INT32;
typedef unsigned int	UINT32;

typedef short			INT16;
typedef unsigned short	UINT16;

typedef char			CHAR;
typedef signed char		SCHAR;
typedef unsigned char	UCHAR;

typedef long			LONG;
typedef unsigned long	ULONG;

#ifndef VOID
	typedef void		VOID;
#endif

/*!
 @enum EP_ENUM_AUDIO_CODE_TYPE
 @abstract EP_ENUM_AUDIO_CODE_TYPE, define the audio code type
 @constant AUDIO_CODE_TYPE_ADPCM = 1 means that audio encode or decode type is adpcm.
 @constant AUDIO_CODE_TYPE_G726 = 2 means that audio encode or decode type is g726.
 @constant AUDIO_CODE_TYPE_MP3 = 6 means that audio encode or decode type is mp3.
 @discussion define the audio code type
 */
typedef enum tag_SE_ENUM_AUDIO_CODE_TYPE
{
	AUDIO_CODE_TYPE_ADPCM = 1,
	AUDIO_CODE_TYPE_G726  = 2,
	AUDIO_CODE_TYPE_G711A = 3,
    AUDIO_CODE_TYPE_AAC   = 4
    
}EP_ENUM_AUDIO_CODE_TYPE;


#ifdef __cplusplus
extern "C"
{
#endif
    
    /*!
     @method
     @abstract UINT32 SEAudio_GetSdkVer(CHAR *chDesc, INT32 nDescMaxSize).
     @discussion Get the sdk version information.
     @param chDesc   the buffer for store the version infformation.
     @param nDescMaxSize   the size of chDesc buffer.
     @result void.
     */
    SE_AUDIOCODEC_API UINT32 SEAudio_GetSdkVer(CHAR *chDesc, INT32 nDescMaxSize);
    
    /*!
     @method
     @abstract UINT32 SEAudio_Create(CHAR type, UCHAR **ppHandle).Get the audio encode manager handle,create a handle
     @discussion Get the audio encode manager handle,create a handle the audiocodec only can used for code type such as 	AUDIO_CODE_TYPE_ADPCM = 1,AUDIO_CODE_TYPE_G726 = 2.
     @param type   char type, the type that is audio data type which you want encode or decode.
     @param ppHandle  unsigned char **ppHandle the output param, return the created handle.
     @result Returns an integer indicates whether the function performed successfully， The number 0 indicates that the function performed failure，The number  bigger than 0  indicates that the function performed successfully.
     */
    SE_AUDIOCODEC_API UINT32 SEAudio_Create(CHAR type, UCHAR **ppHandle);
    
    
    
    /*!
     @method
     @abstract SEAudio_Destroy(unsigned char **ppHandle).
     @discussion Destroy the handle that SEP_audio_create() function have created.
     @param ppHandle   unsigned char **ppHandle.
     @result void.
     */
    SE_AUDIOCODEC_API VOID SEAudio_Destroy(UCHAR **ppHandle);
    
    
    
    /*!
     @method
     @abstract SEAudio_Encode(UCHAR *pHandle, UCHAR *inBuf, UINT32 inLen, UCHAR *outBuf, UINT32 *outLen).
     @discussion encode the audio .
     @param pHandle unsigned char *pHandle, the encode manager handle that create by the function :SEP2P_audio_state_create.
     @param inBuf unsigned char *inBuf, the origial audio data that want to be encode.
     @param inLen unsigned long inLen the origial audio data's size, .
     @param outBuf unsigned char *outBuf, the finally audio data being encode.
     @param outLen  unsigned long *outLen the output data's size.
     @result Returns an integer indicates whether the function performed successfully, The number 0 indicates that the function performed failure，The number bigger than 0 indicates that the function performed successfully.
     */

	//for AAC
	//		The inLen may be any size. the last 2K pcm will be lost. The outBuf is 1K buffer at least
	//	  return:
	//		>0: success
	//		-1: parameter error(return -1 when outBuf==NULL || outLen==NULL || inLen>2048)
    SE_AUDIOCODEC_API INT32 SEAudio_Encode(UCHAR *pHandle, UCHAR *inBuf, UINT32 inLen, UCHAR *outBuf, UINT32 *outLen);
    
    
    
    /*!
     @method
     @abstract UINT32 SEAudio_Decode(UCHAR *pHandle, UCHAR *inBuf, UINT32 inLen, UCHAR *outBuf, UINT32 *outLen).
     @discussion Decode the audio data.
     @param pHandle unsigned char *pHandle, the encode manager handle that create by the function :SEP2P_audio_state_create.
     @param inBuf unsigned char *inBuf, the origial audio data that want to be decode.
     @param inLen unsigned long inLen the origial audio data's size, .
     @param outBuf unsigned char *outBuf, the finally audio data being decode.
     @param outLen  unsigned long *outLen the output data's size.
     @result Returns an integer indicates whether the function performed successfully， The number 0 indicates that the function performed failure，The number bigger than 0 indicates that the function performed successfully.
     */
	//for AAC:
	//	<=0 fail
	//		-1 when m_pDecodedFrame alloced fail
	//		-2 when *inLen>1056 bytes
	//		-3 when decoding AAC fail
	//		-4 when av_samples_get_buffer_size(...)<0
	//		-5 when converting context init fail
	//		-6 when converting PCM format fail
	//		-7 when *outLen is too small. at least 4KBytes
    SE_AUDIOCODEC_API INT32 SEAudio_Decode(UCHAR *pHandle, UCHAR *inBuf, UINT32 inLen, UCHAR *outBuf, UINT32 *outLen);
    
    
    
#ifdef __cplusplus
}
#endif

#endif /* defined(____war__SE_AudioCodec__) */