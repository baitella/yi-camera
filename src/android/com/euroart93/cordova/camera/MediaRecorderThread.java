package com.euroart93.cordova.camera;

import android.util.Log;

import com.utility.SE_MP4;

import java.util.concurrent.ConcurrentLinkedQueue;

public class MediaRecorderThread extends Thread {
    private static final String TAG = "MediaRecorderThread";

    private int[] handle = new int[1];
    private boolean gotIFrame = false;
    private boolean running = false;
    private ConcurrentLinkedQueue<MediaRecorderFrame> frameQueue;

    public MediaRecorderThread(String filename) {
        this.gotIFrame = false;
        this.frameQueue = new ConcurrentLinkedQueue<MediaRecorderFrame>();

        int status = SE_MP4.SEMP4_Open(
            handle,
            filename,
            0,
            0,
            SE_MP4.MP4_AV_CODECID_VIDEO_H264,
            AudioDecoder.AUDIO_SAMPLE_RATE,
            AudioDecoder.AUDIO_CHANNELS,
            SE_MP4.MP4_AV_CODECID_AUDIO_AAC
        );

        Log.d(TAG, "Creating video recorder: " + status);
    }

    public ConcurrentLinkedQueue<MediaRecorderFrame> getFrameQueue() {
        return frameQueue;
    }

    public void stopAll() {
        Log.d(TAG, "Stopping video recorder");
        running = false;

        if (this.isAlive()) {
            try {
                this.join();
                Log.d(TAG, "joined");
                if (handle[0] >= 0) {
                    SE_MP4.SEMP4_Close(handle);
                    handle[0] = -1;
                }
            } catch (InterruptedException ex) {
                Log.i(TAG, ex.getMessage());
            }
        }
    }

    public void saveVideoFrame(byte[] data, long timestamp, boolean isIFrame) {
        if (!gotIFrame) {
            if (!isIFrame) {
                Log.d(TAG, "Video waiting for I frame");
                return;
            }
            else {
                gotIFrame = true;
            }
        }

        int status = SE_MP4.SEMP4_AddVideoFrame(
            handle[0],
            data,
            data.length,
            timestamp,
            isIFrame ? 1 : 0
        );

        if (status < 0) {
            Log.d(TAG, "Failed to save video frame: " + status);
        }
    }

    public void saveAudioFrame(byte[] data, long timestamp) {
        if (!gotIFrame) {
            Log.d(TAG, "Audio waiting on video");
            return;
        }

        int status = SE_MP4.SEMP4_AddAudioFrame(
            handle[0],
            data,
            data.length,
            timestamp
        );

        if (status < 0) {
            Log.d(TAG, "Failed to save audio frame: " + status);
        }
    }

    @Override
    public void run() {
        super.run();

        running = true;

        while (running) {
            if (!frameQueue.isEmpty()) {
                MediaRecorderFrame frame = frameQueue.poll();
                switch (frame.type) {
                    case MediaRecorderFrame.VIDEO_FRAME:
                        MediaRecorderFrame.MediaRecorderVideoFrame videoFrame =
                            (MediaRecorderFrame.MediaRecorderVideoFrame)frame;

                        this.saveVideoFrame(
                            videoFrame.data,
                            videoFrame.timestamp,
                            videoFrame.isIFrame
                        );
                        break;

                    case MediaRecorderFrame.AUDIO_FRAME:
                        MediaRecorderFrame.MediaRecorderAudioFrame audioFrame =
                            (MediaRecorderFrame.MediaRecorderAudioFrame)frame;

                        this.saveAudioFrame(
                            audioFrame.data,
                            audioFrame.timestamp
                        );
                        break;

                    default:
                        Log.e(TAG, "Unknown frame type: " + frame.type);
                        break;
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
