package com.euroart93.cordova.camera;

import android.graphics.Bitmap;
import android.util.Log;

import com.utility.SE_VideoCodec;

import java.nio.ByteBuffer;

public class VideoDecoder {
    private static final String TAG = "VideoDecoder";

    public static final int MAXRGB565LENGTH = 4147200;


    private int[] videoHandle = new int[1];

    public VideoDecoder() {
        int status = SE_VideoCodec.SEVideo_Create(
            SE_VideoCodec.VIDEO_CODE_TYPE_H264,
            videoHandle
        );
        Log.d(TAG, "Creating video decoder: " + status);

    }

    public void destroy() {
        Log.d(TAG, "Destroying video decoder");

        if (videoHandle[0] > -1) {
            SE_VideoCodec.SEVideo_Destroy(videoHandle);
            videoHandle[0] = -1;
        }
    }

    public Bitmap getBitmapFromRGB565Data(byte[] data, int width, int height) {
        Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.RGB_565);

        bitmap.copyPixelsFromBuffer(ByteBuffer.wrap(data, 0, width * height * 2));

        return bitmap;
    }

    public Bitmap decodeVideoFrame(byte[] data, long timestamp, boolean isIFrame) {
        Bitmap bitmap = null;

        int[] width = new int[1];
        int[] height = new int[1];
        byte[] dataRGB = new byte[MAXRGB565LENGTH];
        int[] rgbSize = new int[1];

        rgbSize[0] = MAXRGB565LENGTH;

        int status = SE_VideoCodec.SEVideo_Decode2RGB565(
            videoHandle[0], data, data.length, dataRGB, rgbSize, width, height
        );

        if (status > 0) {
            bitmap = getBitmapFromRGB565Data(dataRGB, width[0], height[0]);

            if (bitmap == null) {
                Log.e(TAG, "Bitmap is null");
            }
        }
        else {
            Log.e(TAG, "Failed to decode to bmp565: " + status);
        }

        return bitmap;
    }
}
