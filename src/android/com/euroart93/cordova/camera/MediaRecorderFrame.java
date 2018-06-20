package com.euroart93.cordova.camera;

public class MediaRecorderFrame {
    public static final int VIDEO_FRAME = 0;
    public static final int AUDIO_FRAME = 1;

    public int type;
    public byte[] data;
    public long timestamp;

    public static class MediaRecorderVideoFrame extends MediaRecorderFrame {
        public boolean isIFrame;

        public MediaRecorderVideoFrame(byte[] data, long timestamp, boolean isIFrame) {
            super(VIDEO_FRAME, data, timestamp);
            this.isIFrame = isIFrame;
        }
    }

    public static class MediaRecorderAudioFrame extends MediaRecorderFrame {
        public MediaRecorderAudioFrame(byte[] data, long timestamp) {
            super(AUDIO_FRAME, data, timestamp);
        }
    }

    public MediaRecorderFrame(int type, byte[] data, long timestamp) {
        this.type = type;
        this.data = data;
        this.timestamp = timestamp;
    }
}
