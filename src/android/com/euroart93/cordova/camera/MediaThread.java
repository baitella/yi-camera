package com.euroart93.cordova.camera;

import android.util.Log;

import java.util.concurrent.ConcurrentLinkedQueue;

public abstract class MediaThread extends Thread {
    private static final String TAG = "MediaThread";

    private ConcurrentLinkedQueue<MediaRecorderFrame> frameQueue = null;

    public void startRecording(ConcurrentLinkedQueue<MediaRecorderFrame> frameQueue) {
        this.frameQueue = frameQueue;
    }

    public void stopRecording() {
        this.frameQueue = null;
    }

    public boolean isRecording() {
        return this.frameQueue != null;
    }

    public void addFrame(MediaRecorderFrame frame) {
        frameQueue.add(frame);
    }

    public abstract void stopAll();
}
