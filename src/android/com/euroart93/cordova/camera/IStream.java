package com.euroart93.cordova.camera;

public interface IStream {
    void onStream(String did, byte[] data, int dataSize, int userData);
}
