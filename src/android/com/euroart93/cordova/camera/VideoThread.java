package com.euroart93.cordova.camera;

import android.graphics.Bitmap;
import android.util.Log;

import com.p2p.STREAM_HEAD;

import java.util.Arrays;
import java.util.concurrent.ConcurrentLinkedQueue;

public class VideoThread extends MediaThread {
    private static final String TAG = "VideoThread";

    interface ImageShowRunnable {
        void run(Bitmap bitmap);
    }

    private ConcurrentLinkedQueue<byte[]> videoQueue;

    private boolean play = true;
    private VideoDecoder videoDecoder;
    private ImageShowRunnable imageShowCallback;


    public VideoThread(ImageShowRunnable imageShowCallback, ConcurrentLinkedQueue<byte[]> videoQueue) {
        Log.d(TAG, "VideoThread constructor");

        this.imageShowCallback = imageShowCallback;
        this.videoQueue = videoQueue;
        this.videoDecoder = new VideoDecoder();
    }

    public void stopAll() {
        Log.d(TAG, "stopAll");
        play = false;

        if (this.isAlive()) {
            try {
                this.join();
                Log.d(TAG, "joined");
                videoDecoder.destroy();
                videoDecoder = null;
            } catch (InterruptedException ex) {
                Log.i(TAG, ex.getMessage());
            }
        }
    }

    @Override
    public void run() {
        super.run();

        Log.i(TAG, "thread running...");
        play = true;

        while (play) {
            if (!videoQueue.isEmpty()) {
                // unit is STREAM_HEAD + H264 NAL unit
                byte[] unit = videoQueue.poll();

                STREAM_HEAD streamHead = new STREAM_HEAD(unit);

                byte[] nalu = Arrays.copyOfRange(unit, STREAM_HEAD.MY_LEN, unit.length);
                boolean isIFrame = streamHead.getParameter() == STREAM_HEAD.VIDEO_FRAME_FLAG_I;

                final Bitmap bitmap = videoDecoder.decodeVideoFrame(nalu, streamHead.getTimestamp(), isIFrame);

                imageShowCallback.run(bitmap);

                if (isRecording()) {
                    addFrame(
                        new MediaRecorderFrame.MediaRecorderVideoFrame(
                            nalu,
                            streamHead.getTimestamp(),
                            isIFrame
                        )
                    );
                    //videoRecorder.saveFrame(nalu, streamHead.getTimestamp(), isIFrame);
                }
            }
            else {
                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    Log.i(TAG, ex.getMessage());
                }
            }
        }
    }
}
