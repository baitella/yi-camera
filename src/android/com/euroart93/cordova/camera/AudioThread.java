package com.euroart93.cordova.camera;

import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.util.Log;

import com.p2p.STREAM_HEAD;

import java.util.concurrent.ConcurrentLinkedQueue;

public class AudioThread extends MediaThread {
    private static final String TAG = "AudioThread";

    private boolean play = true;
    private ConcurrentLinkedQueue<byte[]> audioQueue;
    private AudioDecoder audioDecoder = null;
    private AudioTrack audioTrack = null;

    public AudioThread(ConcurrentLinkedQueue<byte[]> audioQueue) {
        this.audioQueue = audioQueue;
        this.audioDecoder = new AudioDecoder();
    }

    public void stopAll() {
        Log.d(TAG, "stopAll");
        play = false;

        if (this.isAlive()) {
            try {
                this.join();
                Log.d(TAG, "joined");
                audioDecoder.destroy();
                audioDecoder = null;
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
            if (!audioQueue.isEmpty()) {
                byte[] data = audioQueue.poll();

                if (audioTrack == null) {
                    // Do not get codec, sample rate, bitrate and channels from stream head,
                    // they are not correct. Use values received on camera initialisation.
                    //
                    // Currently they are hardcoded to default values.
                    int sampleRateInHz = AudioDecoder.AUDIO_SAMPLE_RATE;
                    int channelConfig = AudioFormat.CHANNEL_OUT_MONO;
                    int audioFormat = AudioFormat.ENCODING_PCM_16BIT;
                    int bufferSize = AudioTrack.getMinBufferSize(
                        sampleRateInHz,
                        channelConfig,
                        audioFormat
                    );

                    audioTrack = new AudioTrack(
                        AudioManager.STREAM_MUSIC,
                        sampleRateInHz,
                        channelConfig,
                        audioFormat,
                        bufferSize,
                        AudioTrack.MODE_STREAM
                    );
                    audioTrack.play();
                }

                byte[] sample = audioDecoder.decodeAudioFrame(data);

                audioTrack.write(sample, 0, sample.length);

                if (isRecording()) {
                    STREAM_HEAD streamHead = new STREAM_HEAD(data);

                    addFrame(
                        new MediaRecorderFrame.MediaRecorderAudioFrame(
                            sample,
                            streamHead.getTimestamp()
                        )
                    );
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
