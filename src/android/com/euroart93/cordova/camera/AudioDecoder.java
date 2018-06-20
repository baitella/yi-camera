package com.euroart93.cordova.camera;

import android.util.Log;

import com.p2p.STREAM_HEAD;
import com.utility.SE_AudioCodec;

import java.util.Arrays;

public class AudioDecoder {
    private static final String TAG = "AudioDecoder";

    public static final int MAXAUDIOLENGTH = 3200;
    public static final int AUDIO_SAMPLE_RATE = 16000;
    public static final short AUDIO_CODEC = SE_AudioCodec.AUDIO_CODE_TYPE_AAC;
    public static final int AUDIO_CHANNELS = 1;

    private int[] audioHandle = new int[1];

    public AudioDecoder() {
        int status = SE_AudioCodec.SEAudio_Create(AUDIO_CODEC, audioHandle);
        Log.d(TAG, "Creating audio decoder: " + status);
    }

    public void destroy() {
        Log.d(TAG, "Destoying audio decoder");
        if (audioHandle[0] > -1) {
            SE_AudioCodec.SEAudio_Destroy(audioHandle);
            audioHandle[0] = -1;
        }
    }

    public byte[] decodeAudioFrame(byte[] data) {
        byte[] sample = new byte[MAXAUDIOLENGTH];
        int[] sampleLength = new int[1];

        sampleLength[0] = MAXAUDIOLENGTH;

        byte[] buffer = Arrays.copyOfRange(data, STREAM_HEAD.MY_LEN, data.length);
        int status = SE_AudioCodec.SEAudio_Decode(
            audioHandle[0], buffer, buffer.length, sample, sampleLength
        );

        if (status <= 0) {
            Log.e(TAG, "Failed to decode audio frame");
            return null;
        }

        return Arrays.copyOfRange(sample, 0, sampleLength[0]);
    }
}
