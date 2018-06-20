package com.euroart93.cordova.camera;

import android.util.Log;
import java.util.Arrays;
import java.util.LinkedList;

import com.p2p.AV_PARAMETER;
import com.p2p.Convert;
import com.p2p.MSG_CONNECT_STATUS;
import com.p2p.MSG_GET_CURRENT_WIFI_RESP;
import com.p2p.MSG_GET_DEVICE_VERSION_RESP;
import com.p2p.MSG_GET_USER_INFO_RESP;
import com.p2p.MSG_PTZ_CONTROL_REQ;
import com.p2p.MSG_START_PLAY_REC_FILE_RESP;
import com.p2p.SEP2P_AppSDK;
import com.p2p.SEP2P_Define;
import com.p2p.STREAM_HEAD;
import android.media.AudioRecord;
import android.media.AudioFormat;
import android.media.MediaRecorder;
import com.utility.SE_AudioCodec;



import java.util.concurrent.ConcurrentLinkedQueue;

public class Camera implements IMsg, IStream {
    private static final String TAG = "Camera";
    public static final int CAMERA_ALREADY_CONNECTED    = -1000;
    public static final int CAMERA_NOT_CONNECTED        = -1001;
    public static final int VIDEO_ALREADY_PLAYING       = -1100;
    public static final int VIDEO_NOT_PLAYING           = -1101;
    public static final int AUDIO_ALREADY_PLAYING       = -1200;
    public static final int AUDIO_NOT_PLAYING           = -1201;
    
    public String did = null;
    public String username = null;
    public String password = null;
    public String onlineCameras = "";

    public Boolean connected = false;
    private Boolean videoPlaying = false;
    private Boolean audioPlaying = false;
    private ThreadSpeak m_threadSpeak = null;
    private int m_nCurAudioCodecID = 0;
    private int m_nProductSeries = 0; 
    private int nCamStatus = -1;
    private String m_strDevAdminName = ""; 
    private String m_strProductSeries = ""; 


    public String devAdminName = null;
    public int audioCodecId = 0;
    public int audioParameter = 0;
    public int productSeries = 0;
    public String productSeriesStr = null;
    public int camStatus = 0;
    public AudioRecord recorder = null;
    public int checkStatus;


    private String sP2pAPIVer = "";
    private String sFWP2pAppBuildTime = "";
    private String sFWP2pAppVer = "";
    private String sFWDdnsAppVer = "";

    public ConcurrentLinkedQueue<byte[]> videoQueue = new ConcurrentLinkedQueue<byte[]>();
    public ConcurrentLinkedQueue<byte[]> audioQueue = new ConcurrentLinkedQueue<byte[]>();
    private LinkedList<IAVListener> m_listener = new LinkedList<IAVListener>();


    public Camera(String did) {
        this.did = did;
    }

    public int connect(String username, String password) {
        if (connected) {
            return CAMERA_ALREADY_CONNECTED;
        }

        this.username = username;
        this.password = password;

        CameraService.regMessage(this);
        CameraService.regStream(this);

        int status = SEP2P_AppSDK.SEP2P_Connect(did, username, password);

        connected = true;

        return status;
    }

    public int check_camera_status(){
        // MSG_CONNECT_STATUS stConnectStatus = new MSG_CONNECT_STATUS(msg);
        // checkStatus = checkStatus.getConnectStatus();
        return 1;
    }

    public int disconnect() {
        if (!connected) {
            return CAMERA_NOT_CONNECTED;
        }

        CameraService.unregMessage(this);
        CameraService.unregStream(this);

        int status = SEP2P_AppSDK.SEP2P_Disconnect(did);

        connected = false;

        return status;
    }

    private int move(int ptzCtrl) {
        byte[] data = MSG_PTZ_CONTROL_REQ.toBytes(
            (byte) ptzCtrl,
            (byte) 0,
            (byte) 0
        );

        return SEP2P_AppSDK.SEP2P_SendMsg(
            did,
            SEP2P_Define.SEP2P_MSG_PTZ_CONTROL_REQ,
            data,
            data.length
        );
    }

    public static void startSearchInLAN() {
        Log.i(TAG, "startSearchInLAN------------------------");
        SEP2P_AppSDK.SEP2P_StartSearch();
    }
    public static void stopSearchInLAN() {
         Log.w(TAG, "stopSearchInLAN------------------------");
        SEP2P_AppSDK.SEP2P_StopSearch();
    }

    public int moveStop() {
        return move(SEP2P_Define.PTZ_CTRL_STOP);
    }

    public int moveUp() {
        return move(SEP2P_Define.PTZ_CTRL_UP);
    }

    public int moveDown() {
        return move(SEP2P_Define.PTZ_CTRL_DOWN);
    }

    public int moveLeft() {
        return move(SEP2P_Define.PTZ_CTRL_LEFT);
    }

    public int moveRight() {
        return move(SEP2P_Define.PTZ_CTRL_RIGHT);
    }

    public boolean isVideoPlaying() {
        return videoPlaying;
    }

    public int getCameraUserInfo(String did) {
        int nRet = SEP2P_AppSDK.SEP2P_SendMsg(did, SEP2P_Define.SEP2P_MSG_CONNECT_STATUS, null, 0);
        return nRet;
    }

    public int startVideo() {
        if (videoPlaying) {
            return VIDEO_ALREADY_PLAYING;
        }

        Log.i(TAG, "Starting video stream");

        flushVideoQueue();

        int status = SEP2P_AppSDK.SEP2P_SendMsg(did, SEP2P_Define.SEP2P_MSG_START_VIDEO, null, 0);

        if (status == SEP2P_AppSDK.ERR_SEP2P_SUCCESSFUL) {
            videoPlaying = true;
        }

        return status;
    }

    public int stopVideo() {
        if (!videoPlaying) {
            return VIDEO_NOT_PLAYING;
        }

        Log.i(TAG, "Stopping video stream");

        int status = SEP2P_AppSDK.SEP2P_SendMsg(did, SEP2P_Define.SEP2P_MSG_STOP_VIDEO, null, 0);

        videoPlaying = false;

        flushVideoQueue();

        return status;
    }

    private void flushVideoQueue() {
        Log.d(TAG, "video queue size " + videoQueue.size());
        while (!videoQueue.isEmpty()) {
            videoQueue.poll();
        }
    }

    public int startAudio() {
        if (audioPlaying) {
            return AUDIO_ALREADY_PLAYING;
        }

        Log.i(TAG, "Starting audio stream");

        flushAudioQueue();

        int status = SEP2P_AppSDK.SEP2P_SendMsg(did, SEP2P_Define.SEP2P_MSG_START_AUDIO, null, 0);

        if (status == SEP2P_AppSDK.ERR_SEP2P_SUCCESSFUL) {
            audioPlaying = true;
        }

        return status;
    }

    public int stopAudio() {
        if (!audioPlaying) {
            return AUDIO_NOT_PLAYING;
        }

        Log.i(TAG, "Stopping audio stream");

        int status = SEP2P_AppSDK.SEP2P_SendMsg(did, SEP2P_Define.SEP2P_MSG_STOP_AUDIO, null, 0);

        audioPlaying = false;

        flushAudioQueue();

        return status;
    }

    public int startTalk() {
        return SEP2P_AppSDK.SEP2P_SendMsg(did, SEP2P_Define.SEP2P_MSG_START_TALK, null, 0);
    }

    public void stopTalk() {
        SEP2P_AppSDK.SEP2P_SendMsg(did, SEP2P_Define.SEP2P_MSG_STOP_TALK, null, 0);
        if(m_threadSpeak != null) {
            m_threadSpeak.stopThread();
            m_threadSpeak = null;
        }
    }

    private void flushAudioQueue() {
        Log.d(TAG, "audio queue size " + audioQueue.size());
        while (!audioQueue.isEmpty()) {
            audioQueue.poll();
        }
    }

    private String bytesToHex(byte[] bytes, int start, int count) {
        String s = "";

        for (int i = start; i < start + count; i++) {
            s += String.format("%02x ", bytes[i]);
        }

        return s;
    }

    private String bytesToHex(byte[] bytes, int count) {
        return this.bytesToHex(bytes, 0, count);
    }

    private boolean isNullField(String str) {
        if(str == null || str.length() == 0) return true;
        else return false;
    }

    private void updateAVListenerMsg(int nMsgType, byte[] pMsg, int nMsgSize, int pUserData) {
        synchronized (m_listener) {
            IAVListener curListener = null;
            for (int i = 0; i < m_listener.size(); i++) {
                curListener = m_listener.get(i);
                curListener.updateMsg(this, nMsgType, pMsg, nMsgSize, pUserData);
            }
        }
    }

    @Override
    public void onMsg(String did, int msgType, byte[] msg, int msgSize, int userData) {
        if (!this.did.equals(did)) {
            return;
        }
        Log.i(TAG, "onMsg------------: "+did+"   message "+msg + " msgSize  "+msgSize+"  msgType  "+msgType);

        if(isNullField(did)) return;
        if(!did.equals(did)) return;
        if(msgType == SEP2P_Define.SEP2P_MSG_CONNECT_STATUS) {
            MSG_CONNECT_STATUS stConnectStatus = new MSG_CONNECT_STATUS(msg);
            //refer to SEP2P_Define.CONNECT_STATUS
            System.out.println("CamObj::onMsg] connected, getConnectStatus="+stConnectStatus.getConnectStatus());
            if(stConnectStatus.getConnectStatus() == MSG_CONNECT_STATUS.CONNECT_STATUS_CONNECTED) {
                AV_PARAMETER stAVParameter = new AV_PARAMETER();
                SEP2P_AppSDK.SEP2P_GetAVParameterSupported(did, stAVParameter);
                m_nCurAudioCodecID = stAVParameter.getAudioCodecID();
                System.out.println("CamObj::onMsg] connected, getAudioCodecID()="+ m_nCurAudioCodecID);
                SEP2P_AppSDK.SEP2P_SendMsg(did, SEP2P_Define.SEP2P_MSG_GET_USER_INFO_REQ, null, 0);
                if(m_nProductSeries == 0) SEP2P_AppSDK.SEP2P_SendMsg(did,SEP2P_Define.SEP2P_MSG_GET_DEVICE_VERSION_REQ, null, 0);
            }

            nCamStatus = stConnectStatus.getConnectStatus();
            checkStatus = stConnectStatus.getConnectStatus();
        } else if(msgType == SEP2P_Define.SEP2P_MSG_GET_USER_INFO_RESP) {
            MSG_GET_USER_INFO_RESP user_info_resp = new MSG_GET_USER_INFO_RESP(msg);
            m_strDevAdminName = user_info_resp.getchAdmin();
            
        } else if(msgType == SEP2P_Define.SEP2P_MSG_GET_DEVICE_VERSION_RESP) {
            MSG_GET_DEVICE_VERSION_RESP get_device_resp = new MSG_GET_DEVICE_VERSION_RESP(msg);
            m_nProductSeries = get_device_resp.getProductSeriesInt2();
            m_strProductSeries = get_device_resp.getProductSeriesStr();
            sP2pAPIVer      = get_device_resp.getAPIVer();
            sFWP2pAppBuildTime = get_device_resp.getP2PBuildTime();
            sFWP2pAppVer    = get_device_resp.getFwddnsVer();
            sFWDdnsAppVer   = get_device_resp.getFwddnsVer();
            System.out.println("imn_server_port="+get_device_resp.getImnServerPort());
            
        } else if(msgType == SEP2P_Define.SEP2P_MSG_START_TALK_RESP) {
            if(msg != null) { // can talk
                if(msg[0] == 0) {
                    System.out.println("CamObj::onMsg] talk success...");
                    if(m_threadSpeak == null) {
                        m_threadSpeak = new ThreadSpeak();
                        m_threadSpeak.start();
                    }
                } else if(msg[0] == 1) {
                    System.out.println("CamObj::onMsg] Other is talking...");
                }
            } else System.out.println("CamObj::onMsg] Talk failed");
        }
        else if(msgType == SEP2P_Define.SEP2P_MSG_START_PLAY_REC_FILE_RESP){
            System.out.println("play_rec_file_resp");
        }else if(msgType == SEP2P_Define.SEP2P_MSG_STOP_PLAY_REC_FILE_RESP){
            System.out.println("stop_rec_file_resp");
            
        }else if(msgType == SEP2P_Define.SEP2P_MSG_SET_CAMERA_PARAM_RESP){
            System.out.println("SEP2P_MSG_SET_CAMERA_PARAM_RESP");
        }
        updateAVListenerMsg(msgType, msg, msgSize, userData);


        switch (msgType) {
            case SEP2P_Define.SEP2P_MSG_CONNECT_STATUS:
                MSG_CONNECT_STATUS connectStatus = new MSG_CONNECT_STATUS(msg);

                switch (connectStatus.getConnectStatus()) {
                    case SEP2P_Define.CONNECT_STATUS_CONNECTING:
                        Log.i(TAG, "onMsg: connect: connecting");
                        if(this.onlineCameras.indexOf(did) != -1 && this.did.equals(did)){
                            this.onlineCameras = "";
                        }
                        break;

                    case SEP2P_Define.CONNECT_STATUS_ONLINE:
                        Log.i(TAG, "onMsg: connect: online");
                        break;

                    case SEP2P_Define.CONNECT_STATUS_CONNECTED:
                        if(this.onlineCameras.indexOf(did) == -1 && this.did.equals(did)){
                            this.onlineCameras = this.onlineCameras.concat(did);
                        }
                        Log.i(TAG, "onMsg: connect: connected "+this.onlineCameras+"  did "+did + "onlineCameras.indexOf(did) "+onlineCameras.indexOf(did));
                        
                        break;

                    default:
                        Log.i(TAG, String.format("onMsg: connect: status = 0x%x", connectStatus.getConnectStatus()));
                        break;
                }

                if (connectStatus.getConnectStatus() == MSG_CONNECT_STATUS.CONNECT_STATUS_CONNECTED) {
                    AV_PARAMETER avParam = new AV_PARAMETER();

                    SEP2P_AppSDK.SEP2P_GetAVParameterSupported(did, avParam);

                    audioCodecId = avParam.getAudioCodecID();
                    audioParameter = avParam.getAudioParameter();
                    Log.i(TAG, String.format("onMsg: connected, audioCodecId = 0x%x, audioparam = 0x%x", audioCodecId, audioParameter));

                    SEP2P_AppSDK.SEP2P_SendMsg(did, SEP2P_Define.SEP2P_MSG_GET_USER_INFO_REQ, null, 0);

                    if (productSeries == 0) {
                        SEP2P_AppSDK.SEP2P_SendMsg(did, SEP2P_Define.SEP2P_MSG_GET_DEVICE_VERSION_REQ, null, 0);
                    }
                }

                camStatus = connectStatus.getConnectStatus();
                break;

            case SEP2P_Define.SEP2P_MSG_CONNECT_MODE:
                int mode = Convert.byteArrayToInt_Little(msg);
                String connectModeStr = "onMsg: mode: ";

                switch (mode) {
                    case SEP2P_Define.CONNECT_MODE_P2P:
                        connectModeStr += "P2P";
                        break;

                    case SEP2P_Define.CONNECT_MODE_RLY:
                        connectModeStr += "RLY";
                        break;

                    case SEP2P_Define.CONNECT_MODE_UNKNOWN:
                        connectModeStr += "unknown";
                        break;

                    default:
                        connectModeStr += "unsupported";
                        break;
                }
                Log.i(TAG, connectModeStr);
                break;

            case SEP2P_Define.SEP2P_MSG_GET_USER_INFO_RESP:
                Log.i(TAG, "SEP2P_MSG_GET_USER_INFO_RESP");
                MSG_GET_USER_INFO_RESP infoResp = new MSG_GET_USER_INFO_RESP(msg);
                devAdminName = infoResp.getchAdmin();
                break;

            case SEP2P_Define.SEP2P_MSG_GET_DEVICE_VERSION_RESP:
                Log.i(TAG, "SEP2P_MSG_GET_DEVICE_VERSION_RESP");
                MSG_GET_DEVICE_VERSION_RESP verResp = new MSG_GET_DEVICE_VERSION_RESP(msg);

                productSeries = verResp.getProductSeriesInt2();
                productSeriesStr = verResp.getProductSeriesStr();

                sP2pAPIVer = verResp.getAPIVer();
                sFWP2pAppBuildTime = verResp.getP2PBuildTime();
                sFWP2pAppVer = verResp.getFwddnsVer();
                sFWDdnsAppVer = verResp.getFwddnsVer();

                Log.i(TAG, "onMsg: imn_server-port=" + verResp.getImnServerPort());
                break;

            case SEP2P_Define.SEP2P_MSG_START_TALK_RESP:
                Log.i(TAG, "SEP2P_MSG_START_TALK_RESP");
                if (msg == null) {
                    Log.i(TAG, "onMsg: talk failed");
                    break;
                }

                if (msg[0] == 0) {
                    Log.i(TAG, "onMsg: talk, not implemented");
                }
                else if (msg[0] == 1) {
                    Log.i(TAG, "onMsg: other side is talking");
                }

                break;

            case SEP2P_Define.SEP2P_MSG_START_PLAY_REC_FILE_RESP:
                MSG_START_PLAY_REC_FILE_RESP playRecFileResp = new MSG_START_PLAY_REC_FILE_RESP(msg);
                Log.i(TAG, "onMsg: SEP2P_MSG_START_PLAY_REC_FILE_RESP " + playRecFileResp.getnAudioParam());
                break;

            case SEP2P_Define.SEP2P_MSG_STOP_PLAY_REC_FILE_RESP:
                Log.i(TAG, "onMsg: SEP2P_MSG_STOP_PLAY_REC_FILE_RESP");
                break;

            case SEP2P_Define.SEP2P_MSG_SET_CAMERA_PARAM_RESP:
                Log.i(TAG, "onMsg: SEP2P_MSG_SET_CAMERA_PARAM_RESP");
                break;

            case SEP2P_Define.SEP2P_MSG_PTZ_CONTROL_RESP:
                Log.i(TAG, "onMsg: SEP2P_MSG_PTZ_CONTROL_RESP " + bytesToHex(msg, msgSize));
                break;

            case SEP2P_Define.SEP2P_MSG_GET_CURRENT_WIFI_RESP:
                MSG_GET_CURRENT_WIFI_RESP wifiInfo = new MSG_GET_CURRENT_WIFI_RESP(msg);
                Log.i(TAG, "onMsg: SEP2P_MSG_GET_CURRENT_WIFI_RESP " + wifiInfo.getChSSID());
                break;

            default:
                Log.i(TAG, String.format("onMsg: unhandled type 0x%x", msgType));
                break;
        }
    }

    

    @Override
    public void onStream(String did, byte[] data, int dataSize, int userData) {
        if (!this.did.equals(did) || !videoPlaying) {
            return;
        }

        // handle playback
        int codec_id = Convert.byteArrayToInt_Little(data, 0);
        STREAM_HEAD streamHead = new STREAM_HEAD(data);

        // videoThread
        if (codec_id < STREAM_HEAD.AV_CODECID_AUDIO_ADPCM) {
            // live or playback
            if (streamHead.getFlagPlayback() == 0) {
                videoQueue.add(data);
            }
        }
        // audio
        else {
            // live or playback
            if (streamHead.getFlagPlayback() == 0) {
                audioQueue.add(data);
            }
        }

        // Log.d(TAG, String.format(
        //     "onStream codec=%x live=%d time=%d video_queue_size=%d audio_queue_size=%d",
        //     codec_id,
        //     streamHead.getFlagPlayback() == 0 ? 1 : 0,
        //     streamHead.getTimestamp(),
        //     videoQueue.size(),
        //     audioQueue.size()
        // ));
    }

    class ThreadSpeak extends Thread {
        private int[] ppHandleToSpeak = new int[1];
        byte[] outBufToSpeak = new byte[1024];
        int[] outBufLenToSpeak = new int[1];
        private int SAMPLE_RATE_IN_HZ = 8000;
        private int nMinBufSize = 0, nReadBytes = 0, nSizeAssembled = 0;
        byte[] inBuf = null, inBuf2 = new byte[1024]; // new byte[320];
        int nReadByteNum = 0, nRet = 0;
        byte flag = (byte) (STREAM_HEAD.AUDIO_SAMPLE_8K << 2 | STREAM_HEAD.AUDIO_DATABITS_16 << 1 | STREAM_HEAD.AUDIO_CHANNEL_MONO);
        volatile boolean bSpeaking = false;
        // ----{{juju8-----
        int nBufDataSize = 0;
        byte[] bytsTmp = null; // new byte[1024 * 3];

        int assembleData(byte[] bytBuf, byte[] bytSrcData, int nSrcDataSize, byte[] bytDstBuf,int nDstNeedSize) {
            try {
                int nRealSize = 0;
                if(nSrcDataSize > 0) {
                    System.arraycopy(bytSrcData, 0, bytBuf, nBufDataSize, nSrcDataSize);
                    nBufDataSize += nSrcDataSize;
                    //System.out.println("adpcm nSizeAssembled] 1 nBufDataSize=" + nBufDataSize+ ",nDstNeedSize=" + nDstNeedSize);
                }
                if(nBufDataSize >= nDstNeedSize) {
                    nRealSize = nDstNeedSize;
                    System.arraycopy(bytBuf, 0, bytDstBuf, 0, nDstNeedSize);
                    nBufDataSize = nBufDataSize - nDstNeedSize;
                    //System.out.println("adpcm nSizeAssembled] 2 nBufDataSize=" + nBufDataSize);
                    System.arraycopy(bytBuf, nDstNeedSize, bytBuf, 0, nBufDataSize);
                }
                //System.out.println("adpcm nSizeAssembled] 3 nSrcDataSize=" + nSrcDataSize+ ",nBufDataSize=" + nBufDataSize + ",nRealSize=" + nRealSize);
                return nRealSize;
            } catch (Exception e) {
                System.out.println("adpcm nSizeAssembled] excep " + e.getMessage());
                return -1;
            }
        }

        // ----}}juju8-----
        @Override
        public void run() {
            if(m_nCurAudioCodecID == STREAM_HEAD.AV_CODECID_AUDIO_AAC) SAMPLE_RATE_IN_HZ = 16000;
            nMinBufSize = AudioRecord.getMinBufferSize(SAMPLE_RATE_IN_HZ,
                    AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT);
            recorder = new AudioRecord(MediaRecorder.AudioSource.MIC, SAMPLE_RATE_IN_HZ,
                    AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT, nMinBufSize);
            recorder.startRecording();
            bSpeaking = true;

            bytsTmp = new byte[nMinBufSize * 8];
            inBuf = new byte[nMinBufSize];
            ppHandleToSpeak[0] = -1;

            switch (m_nCurAudioCodecID) {
                case STREAM_HEAD.AV_CODECID_AUDIO_G726:
                    SE_AudioCodec.SEAudio_Create(SE_AudioCodec.AUDIO_CODE_TYPE_G726,
                            ppHandleToSpeak);
                    break;
                case STREAM_HEAD.AV_CODECID_AUDIO_G711A:
                    SE_AudioCodec.SEAudio_Create(SE_AudioCodec.AUDIO_CODE_TYPE_G711A,
                            ppHandleToSpeak);
                    break;
                case STREAM_HEAD.AV_CODECID_AUDIO_ADPCM:
                    SE_AudioCodec.SEAudio_Create(SE_AudioCodec.AUDIO_CODE_TYPE_ADPCM, ppHandleToSpeak);
                    break;
                case STREAM_HEAD.AV_CODECID_AUDIO_AAC:
                    SE_AudioCodec.SEAudio_Create(SE_AudioCodec.AUDIO_CODE_TYPE_AAC, ppHandleToSpeak);
                    break;
            }

            while (bSpeaking) {
                // audio encode
                if(m_nCurAudioCodecID == STREAM_HEAD.AV_CODECID_AUDIO_G726) {
                    Arrays.fill(inBuf, (byte) 0); // yanyan6
                    nReadBytes = recorder.read(inBuf, 0, nMinBufSize);
                    //System.out.println("wai g726 nReadBytes=" + nReadBytes + ",nMinBufSize="+ nMinBufSize);
                    if(nReadBytes > 0) {// juju
                        do {
                            outBufLenToSpeak[0] = outBufToSpeak.length;
                            nSizeAssembled = assembleData(bytsTmp, inBuf, nReadBytes, inBuf2, 320);
                            //System.out.println("g726 nSizeAssembled=" + nSizeAssembled + ",nBufDataSize=" + nBufDataSize);
                            nReadBytes = 0;
                            if(nSizeAssembled > 0) { // juju8
                                int nread_encode = SE_AudioCodec.SEAudio_Encode(ppHandleToSpeak[0],
                                        inBuf2, nSizeAssembled, outBufToSpeak, outBufLenToSpeak);
                                // send audio data encoded
                                if(nread_encode > 0) {
                                    // 写编码后的
                                    nRet = SEP2P_AppSDK.SEP2P_SendTalkData(did,
                                            outBufToSpeak, outBufLenToSpeak[0],
                                            System.currentTimeMillis());
                                }
                            } else break;
                        } while (true);
                    }
                }

                else if(m_nCurAudioCodecID == STREAM_HEAD.AV_CODECID_AUDIO_G711A) {
                    Arrays.fill(inBuf, (byte) 0); // yanyan6
                    nReadBytes = recorder.read(inBuf, 0, nMinBufSize);
                    System.out.println();
                    if(nReadBytes > 0) {// juju
                        do {
                            outBufLenToSpeak[0] = outBufToSpeak.length;
                            nSizeAssembled = assembleData(bytsTmp, inBuf, nReadBytes, inBuf2, 320);
                            //System.out.println("g711 nSizeAssembled=" + nSizeAssembled+ ",nBufDataSize=" + nBufDataSize);
                            nReadBytes = 0;
                            if(nSizeAssembled > 0) { // juju8
                                int nread_encode = SE_AudioCodec.SEAudio_Encode(ppHandleToSpeak[0],
                                        inBuf2, nSizeAssembled, outBufToSpeak, outBufLenToSpeak);
                                // send audio data encoded
                                if(nread_encode > 0) nRet = SEP2P_AppSDK.SEP2P_SendTalkData(
                                        did, outBufToSpeak, outBufLenToSpeak[0],
                                        System.currentTimeMillis());
                                // 1-20 add new code
                                // try {
                                // g711outputStream.write(outBufToSpeak,0,outBufLenToSpeak[0]);
                                // } catch (IOException e) {
                                // e.printStackTrace();
                                // }
                            } else break;
                        } while (true);
                    }
                }

                else if(m_nCurAudioCodecID == STREAM_HEAD.AV_CODECID_AUDIO_ADPCM) {
                    Arrays.fill(inBuf, (byte) 0); // yanyan6
                    //System.out.println("adpcm nMinBufSize" + nMinBufSize);
                    nReadBytes = recorder.read(inBuf, 0, nMinBufSize);
                    if(nReadBytes > 0) {// juju
                        do {
                            outBufLenToSpeak[0] = outBufToSpeak.length;
                            nSizeAssembled = assembleData(bytsTmp, inBuf, nReadBytes, inBuf2, 1024);
                            nReadBytes = 0;
                            if(nSizeAssembled > 0) { // juju8
                                int nread_encode = SE_AudioCodec.SEAudio_Encode(ppHandleToSpeak[0],
                                        inBuf2, nSizeAssembled, outBufToSpeak, outBufLenToSpeak);
                                // send audio data encoded
                                if(nread_encode > 0) {
                                    nRet = SEP2P_AppSDK.SEP2P_SendTalkData(did,
                                            outBufToSpeak, outBufLenToSpeak[0],
                                            System.currentTimeMillis());
                                }
                            } else break;
                        } while (true);
                    }
                }else if(m_nCurAudioCodecID == STREAM_HEAD.AV_CODECID_AUDIO_AAC) {
                    Arrays.fill(inBuf, (byte) 0); // yanyan6
                    nReadBytes = recorder.read(inBuf, 0, nMinBufSize);
                    if(nReadBytes > 0) {// juju
                        do {
                            outBufLenToSpeak[0] = outBufToSpeak.length;
                            nSizeAssembled = assembleData(bytsTmp, inBuf, nReadBytes, inBuf2, 1024);
                            nReadBytes = 0;
                            if(nSizeAssembled > 0) { // juju8
                                int nread_encode = SE_AudioCodec.SEAudio_Encode(ppHandleToSpeak[0],inBuf2, nSizeAssembled, outBufToSpeak, outBufLenToSpeak);
                                // send audio data encoded
                                if(nread_encode > 0 && outBufLenToSpeak[0] > 0) 
                                    nRet = SEP2P_AppSDK.SEP2P_SendTalkData(did, outBufToSpeak, outBufLenToSpeak[0], System.currentTimeMillis());
                            } else break;
                        } while (true);
                    }
                }
                if(!bSpeaking) break;
                try {
                    Thread.sleep(20);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            if(recorder != null) {
                recorder.stop();
                recorder.release();
                recorder = null;
            }
            if(ppHandleToSpeak[0] > -1) {
                SE_AudioCodec.SEAudio_Destroy(ppHandleToSpeak);
                ppHandleToSpeak[0] = -1;
            }
        }

        public void stopThread() {
            try {
                Thread.sleep(800);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            bSpeaking = false;
            try {
                if(this.isAlive()) {
                    try {
                        this.join();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            } catch (NullPointerException npe) {
                npe.printStackTrace();
            }
        }
    }

}
