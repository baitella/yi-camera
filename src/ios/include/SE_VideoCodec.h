//
//  SE_VideoCodec.h
//  SE_VideoCodec
//



/*!
 @header SE_VideoCodec
 @abstract This file define all the interface that decode video data. Must add libz.dylib and libbz2.dylib in iOS project.
 @author
 @version 1.00 2014/05/05
 */

#ifndef ____war__SE_VideoCodec__
#define ____war__SE_VideoCodec__

#ifdef WIN32DLL
	#define SEP2P_CALLBACK	  __stdcall
	#ifdef SE_VIDEOCODEC_EXPORTS
		#define SE_VIDEOCODEC_API  __declspec(dllexport)
	#else
		#define SE_VIDEOCODEC_API __declspec(dllimport)
	#endif

#else
    #define SE_VIDEOCODEC_API 

#endif //// #ifdef WIN32DLL



//#if defined WIN32DLL || defined LINUX
typedef int				INT32;
typedef unsigned int	UINT32;
//#endif

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
 @enum EP_ENUM_VIDEO_CODE_TYPE
 @abstract EP_ENUM_VIDEO_CODE_TYPE, define the video code type
 @constant VIDEO_CODE_TYPE_H264 = 1 means that audio encode or decode type is H264.
 @discussion define the video code type
 */
typedef enum tag_SE_ENUM_VIDEO_CODE_TYPE
{
    VIDEO_CODE_TYPE_H264 = 1
    
}EP_ENUM_VIDEO_CODE_TYPE;


#ifdef __cplusplus
extern "C"
{
#endif
    
    /*!
     @method
     @abstract SEVideo_GetSdkVer(CHAR *chDesc, INT32 nDescMaxSize).
     @discussion Get the sdk version information.
     @param chDesc   the buffer for store the version infformation.
     @param nDescMaxSize   the size of chDesc buffer.
     @result void.
     */
    SE_VIDEOCODEC_API UINT32 SEVideo_GetSdkVer(CHAR *chDesc, INT32 nDescMaxSize);
    
    
    /*!
     @method
     @abstract SEVideo_Create(CHAR type, UCHAR **ppHandle).Get the video encode manager handle,create a handle
     @discussion Get the video encode manager handle,create a handle.
     @param type   char type, the type that is video data type which you want encode or decode.
     @param ppHandle  unsigned char **ppHandle the output param, return the created handle.
     @result Returns an integer indicates whether the function performed successfully， The number 0 indicates that the function performed failure，The number more than 0 indicates that the function performed successfully.
     */
    SE_VIDEOCODEC_API UINT32 SEVideo_Create(CHAR type, UCHAR **ppHandle);
    
    
    /*!
     @method
     @abstract SEVideo_Destroy(UCHAR **ppHandle).
     @discussion Destroy the handle that SEP_video_create() function have created.
     @param ppHandle   unsigned char **ppHandle.
     @result void.
     */
    SE_VIDEOCODEC_API VOID SEVideo_Destroy(UCHAR **ppHandle);    
       
    
    /*!
     @method
     @abstract SEVideo_Decode2YUV(UCHAR *pHandle, UCHAR *inRawData, unsigned long inLen, UCHAR *outYUV420, unsigned long *in_outLen, UINT32 *videoWidth, UINT32 *videoHeight).
     @discussion Decode the video data.
     @param pHandle unsigned char *pHandle, the encode manager handle that create by the function :SEP_video_create().
     @param inRawData unsigned char *inRawData, the origial video data that want to be decode.
     @param inLen unsigned long inLen the origial video data's size, .
     @param outYUV420 unsigned char *outYUV420, the finally video data being decode (yuv420 planar), a piece of memory space that user allocated.
     @param in_outLen  unsigned long *in_outLen the max size of the outYUV420 buffer before calling, the output data's size after calling.
     @param videoWidth  the video width after decode.
     @param videoHeight  the video height after decode.
     @result Returns an integer indicates whether the function performed successfully, The number 0 indicates that the function performed failure,The number more than 0 indicates that the function performed successfully.
     */
    SE_VIDEOCODEC_API UINT32 SEVideo_Decode2YUV(UCHAR *pHandle, UCHAR *inRawData, unsigned long inLen, UCHAR *outYUV420, unsigned long *in_outLen, INT32 *videoWidth, INT32 *videoHeight);
    
	SE_VIDEOCODEC_API UINT32 SEVideo_YUV420toRGB565(UCHAR *pHandle,UCHAR *inYUV420Planar, UCHAR *outRGB565, UINT32 *in_outLen, INT32 videoWidth, INT32 videoHeight);

    /*!
     @method
     @abstract SEVideo_Decode2RGB565(UCHAR *pHandle, UCHAR *inRawData, unsigned long inLen, UCHAR *outRGB565, unsigned long *in_outLen, UINT32 *videoWidth, UINT32 *videoHeight).
     @discussion Decode the video data.
     @param pHandle unsigned char *pHandle, the encode manager handle that create by the function :SEP_video_create().
     @param inRawData unsigned char *inRawData, the origial video data that want to be decode.
     @param inLen unsigned long inLen the origial video data's size, .
     @param outRGB565 unsigned char *outRGB565, the finally video data being decode (RGB565), a piece of memory space that user allocated.
     @param in_outLen  unsigned long *in_outLen the max size of the outRGB565 buffer before calling, the output data's size after calling.
     @param videoWidth  the video width after decode.
     @param videoHeight  the video height after decode.
     @result Returns an integer indicates whether the function performed successfully, The number 0 indicates that the function performed failure,The number more than 0 indicates that the function performed successfully.
     */
    SE_VIDEOCODEC_API UINT32 SEVideo_Decode2RGB565(UCHAR *pHandle, UCHAR *inRawData, unsigned long inLen, UCHAR *outRGB565, unsigned long *in_outLen, INT32 *videoWidth, INT32 *videoHeight);
	
	/*!
     @method
     @abstract SEVideo_YUV420toRGB24(UCHAR *pHandle, UCHAR *inYUV420Planar, unsigned long inLen, UCHAR *outRGB24, unsigned long *in_outLen)
     @discussion Convert the video data.
     @param inYUV420Planar unsigned char *inYUV420Planar, the yuv420 planar format video data.
     @param inLen unsigned long inLen the yuv420 video data's size, .
     @param outRGB24 unsigned char *outRGB24, the finally video data being converted (RGB565), a piece of memory space that user allocated.
     @param in_outLen  unsigned long *in_outLen the max size of the outRGB565 buffer before calling, the output data's size after calling.
     @result Returns an integer indicates whether the function performed successfully, The number 0 indicates that the function performed failure,The number more than 0 indicates that the function performed successfully.
     */
    SE_VIDEOCODEC_API UINT32 SEVideo_YUV420toRGB24(UCHAR *inYUV420Planar, unsigned long inLen, UCHAR *outRGB24, unsigned long *in_outLen, INT32 videoWidth, INT32 videoHeight);

#ifdef __cplusplus
}
#endif

#endif /* defined(____war__SE_VideoCodec__) */