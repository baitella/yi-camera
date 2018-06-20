package com.euroart93.cordova.camera;

import android.util.Log;

import com.smarteye.SEAT_API;

public class CameraWifi {
    private static final String TAG = "CameraWifi";

    private SEAT_API api = new SEAT_API();
    private int[] audioHandle = new int[1];

    private boolean initialized = false;

    public boolean isInitialized() {
        return initialized;
    }

    public boolean initialize() {
        if (initialized) {
            Log.e("TAG", "Already initialized");
            return false;
        }

        int status = -1;

        try {
            status = api.SEAT_Init(SEAT_API.SAMPLE_RATE_16K, SEAT_API.TRANSMIT_TYPE_WIFI_PWD);
            Log.d(TAG, "SEAT_Init: " + status);
            if (status < 0) {
                return false;
            }

            status = api.SEAT_Create(audioHandle, SEAT_API.AT_PLAYER, SEAT_API.CPU_PRIORITY);
            Log.d(TAG, "SEAT_Create: " + status);
            if (status < 0) {
                return false;
            }

            // TODO find out what the hell does this do
            status = api.SEAT_SetCallback(audioHandle[0], 100);
            Log.d(TAG, "SEAT_SetCallback: " + status);
        } catch (UnsatisfiedLinkError ulex) {
            Log.e(TAG, "Cannot initialize cameraWifi: " + ulex.getMessage());
            initialized = false;
            return false;
        }
        Log.e("TAG", "camerawifi------- initialized");

        initialized = true;
        return true;
    }

    public void deinitialize() {
        if (!initialized) {
            Log.w(TAG, "Not initialized, ignoring call to deinitialize");
            return;
        }

        api.SEAT_Destroy(audioHandle);
        api.SEAT_DeInit();

        initialized = false;
    }

    public void serializeToAir(String ssid, String password, int securityMode) {

        if (!initialized) {
            Log.w(TAG, "Not initialized, ignoring call to serializeToAir");
            return;
        }

        byte[] byteSSID = ssid.getBytes();
        byte[] bytePassword = password.getBytes();
        int status;

        status = api.SEAT_Start(audioHandle[0]);
        Log.d(TAG, "SEAT_Start: " + status);

        status = api.SEAT_WriteSSIDWiFi(
            audioHandle[0],
            0,
            byteSSID,
            byteSSID.length,
            bytePassword,
            bytePassword.length,
            securityMode,
            null
        );
        Log.d(TAG, "SEAT_WriteSSIDWifi: " + status);

        status = api.SEAT_Stop(audioHandle[0]);
        Log.d(TAG, "SEAT_Stop: " + status);
    }
}
