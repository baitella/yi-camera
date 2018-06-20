package com.euroart93.cordova.camera;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Binder;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;

import com.p2p.SEP2P_AppSDK;

import java.lang.Override;
import java.util.LinkedList;

public class CameraService extends Service {
    private static final String TAG = "CameraService";

    private NotificationManager notificationManager;
    private Notification notification;
    private static LinkedList<IMsg> msgList = new LinkedList<IMsg>();
    private static LinkedList<IStream> streamList = new LinkedList<IStream>();
    private static ILANSearch lanSearch = null;
    private static IEvent event = null;
    public class ControllerBinder extends Binder {
        public CameraService getBridgeService() {
            return CameraService.this;
        }
    }

    public static void regMessage(IMsg message) {
        Log.i(TAG, "regMessage");
        synchronized (msgList) {
            if (message != null && !msgList.contains(message)) {
                msgList.addLast(message);
            }
        }
    }

    public static void unregMessage(IMsg message) {
        Log.i(TAG, "unregMessage");
        synchronized (msgList) {
            if (message != null && msgList.contains(message)) {
                msgList.remove(message);
            }
        }
    }

    public static void regStream(IStream stream) {
        Log.i(TAG, "regStream");
        synchronized (streamList) {
            if (stream != null && !streamList.contains(stream)) {
                streamList.addLast(stream);
            }
        }
    }

    public static void unregStream(IStream stream) {
        Log.i(TAG, "unregStream");
        synchronized (streamList) {
            if (stream != null && streamList.contains(stream)) {
                streamList.remove(stream);
            }
        }
    }

    public static void setLanSearch(ILANSearch ls) {
        Log.i(TAG, "setLanSearch");
        lanSearch = ls;
    }

    public static void setEvent(IEvent e) {
        Log.i(TAG, "setEvent");
        event = e;
    }

    @Override
    public IBinder onBind(Intent intent) {
        Log.i(TAG, "onBind");
        return new ControllerBinder();
    }

    @Override
    public void onCreate() {
        super.onCreate();

        Log.i(TAG, "Service started");
        notificationManager = (NotificationManager)getSystemService(Context.NOTIFICATION_SERVICE);

        int status = SEP2P_AppSDK.SetCallbackContext(this, Build.VERSION.SDK_INT);
        Log.i(TAG, "SetCallbackContext: " + status);
    }

    @Override
    public void onDestroy() {
        Log.i(TAG, "Service destroyed");
        super.onDestroy();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return super.onStartCommand(intent, flags, startId);
    }

    void onRecvMsgCallback(String pDID, int nMsgType, byte[] pMsg, int nMsgSize, int pUserData) {
        synchronized (msgList) {
            IMsg curMsg = null;

            for (int i = 0; i < msgList.size(); i++) {
                curMsg = msgList.get(i);
                curMsg.onMsg(pDID, nMsgType, pMsg, nMsgSize, pUserData);
            }
        }
    }

    void onStreamCallback(String pDID, byte[] pData, int nDataSize, int pUserData) {
        synchronized (streamList) {
            IStream curStream = null;

            for (int i = 0; i < streamList.size(); i++) {
                curStream = streamList.get(i);
                curStream.onStream(pDID, pData, nDataSize, pUserData);
            }
        }
    }

    void onLANSearchCallback(byte[] pData, int nDataSize) {
        if (lanSearch != null) {
            lanSearch.onLANSearch(pData, nDataSize);
        }
    }

    void onEventCallback(String pDID, int nEventType, byte[] pEventData, int nEventDataSize, int pUserData) {
        if (event != null) {
            event.onEvent(pDID, nEventType, pUserData);
        }
    }
}
