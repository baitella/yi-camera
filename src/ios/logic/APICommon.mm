//
//  APICommon.m
//  P2PCamera
//
//  Created by Tsang on 12-12-11.
//
//

#import "APICommon.h"

#import "SE_VideoCodec.h"

@implementation APICommon

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    NSData *dataImg = UIImageJPEGRepresentation(newImage, 1);
    UIImage *imgOK = [UIImage imageWithData:dataImg];
    
    // Return the new image.
    return imgOK;
}

+ (UIImage*) GetImageByNameFromImage: (NSString*)did filename:(NSString*)filename
{
    //NSLog(@"APICommon   GetImageByNameFromImage 11111111111");
    if (did == nil || filename == nil) {
        return nil;
    }
     
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:did];
    strPath = [strPath stringByAppendingPathComponent:filename];
    //NSLog(@"strPath: %@", strPath);
    
    UIImage *image = [UIImage imageWithContentsOfFile:strPath];
    
    return [self imageWithImage:image scaledToSize:CGSizeMake(75, 75)];
    
}

+ (UIImage*) GetImageByName: (NSString*)did filename:(NSString*)filename
{
    NSLog(@"GetImageByName did=%@ fileName=%@",did,filename);
    if (did == nil || filename == nil) {
        
        return nil;
    }
    
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:did];
    strPath = [strPath stringByAppendingPathComponent:filename];
    //NSLog(@"strPath: %@", strPath);
    
    // UIImage *image = [self GetFirstImageFromRecordFile:strPath];
    // if (image == nil) {
    //     NSLog(@"APICommon GetImageByName()  image==nil");
    //     return nil;
    // }
    
    
    // return [self imageWithImage:image scaledToSize:CGSizeMake(75, 75)];
    
}

#define RGB565_MASK_RED        0xF800
#define RGB565_MASK_GREEN                         0x07E0
#define RGB565_MASK_BLUE                         0x001F

void rgb565_2_rgb24(unsigned char *rgb24, unsigned short rgb565)
{
    //extract RGB
    rgb24[0] = (rgb565 & RGB565_MASK_RED) >> 11;
    rgb24[1] = (rgb565 & RGB565_MASK_GREEN) >> 5;
    rgb24[2] = (rgb565 & RGB565_MASK_BLUE);
    
    //plify the image
    rgb24[0] <<= 3;
    rgb24[1] <<= 2;
    rgb24[2] <<= 3;
}

void RGB565toRGB888(unsigned char *rgb565, unsigned char* rgb888, int width, int height)
{
    int i;
    int j;
    for (i = 0; i < height; i++) {
        unsigned char *pSrc = rgb565 + (width * 2) * i;
        unsigned char *pDes = rgb888 + (width * 3) * i;
        for (j = 0; j < width ; j++) {
            rgb565_2_rgb24(pDes + j * 3, *((unsigned short*)(pSrc + j * 2)));
        }
    }
    
}

+ (UIImage*) RGB888toImage: (Byte*)rgb888 width:(int)width height:(int)height
{
    @synchronized(self)
    {
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
        
        CFDataRef dataRef = CFDataCreate(kCFAllocatorDefault, rgb888, width*height*3);
        
        CGDataProviderRef provider = CGDataProviderCreateWithCFData(dataRef);
        
        //CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, rgb888, width*height*3, NULL);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGImageRef cgImage = CGImageCreate(width,
                                           height,
                                           8,
                                           24,
                                           width*3,
                                           colorSpace,
                                           bitmapInfo,
                                           provider,
                                           NULL,
                                           NO,
                                           kCGRenderingIntentDefault);
        CGColorSpaceRelease(colorSpace);
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        //UIImage *image = [[[UIImage alloc] initWithCGImage:cgImage] autorelease];
        
        CGImageRelease(cgImage);
        CGDataProviderRelease(provider);
        CFRelease(dataRef);
        
        //NSLog(@"width: %f, height: %f", image.size.width, image.size.height);
        return image;
    }
}

+ (UIImage*) YUV420ToImage: (Byte*)yuv inSize:(unsigned long) inLength width:(int)width height:(int)height
{
    @synchronized(self)
    {
        UCHAR *m_pVideoHandleH264 = NULL;
        
        int nRet = SEVideo_Create(VIDEO_CODE_TYPE_H264, &m_pVideoHandleH264);
        if(nRet <= 0) return nil;
        //UCHAR *pHandle = m_pVideoHandleH264;
        UCHAR *inRawData= (UCHAR *)yuv;
        unsigned long inLen = inLength;
        INT32 nWidth= width;
        INT32 nHeight = height;
        //int nRet=SEVideo_Decode2YUV(pHandle, inRawData, inLen, (UCHAR * )outYUV420, &in_outLen, &nWidth,&nHeight);
        
        ULONG outLen=nWidth * nHeight * 3;
        char *outRGB24=(char *)malloc(outLen);
        int tempwidth = nWidth;
        int tempheight = nHeight;
        nRet  = SEVideo_YUV420toRGB24((UCHAR *)inRawData, inLen, (UCHAR *)outRGB24, &outLen, tempwidth, tempheight);
        
        //rgb888-->image
        UIImage *image = nil;
        if (nRet > 0) {
            image = [self RGB888toImage:(Byte*)outRGB24 width:tempwidth height:tempheight];
        }
        
        //KYL_SAFE_DELETE_ARR(outRGB24);
        free(outRGB24);
        outRGB24 = NULL;
        
        //end add by kongyulu at 20140325
        if(m_pVideoHandleH264) {
            SEVideo_Destroy(&m_pVideoHandleH264);
            m_pVideoHandleH264=NULL;
        }
        return image;

    }

}


@end
