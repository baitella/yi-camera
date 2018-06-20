package com.euroart93.cordova.camera;

public interface IMsg {
    void onMsg(String did, int msgType, byte[] msg, int msgSize, int userData);
}
