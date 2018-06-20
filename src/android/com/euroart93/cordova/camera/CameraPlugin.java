package com.euroart93.cordova.camera;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.net.Uri;
import android.os.Environment;
import android.os.Handler;
import android.provider.MediaStore;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.LinearLayout;
import com.p2p.MSG_PTZ_CONTROL_REQ;

import com.p2p.INIT_STR;
import com.p2p.SEARCH_RESP;
import com.p2p.SEP2P_AppSDK;
import com.p2p.SEP2P_Define;
import com.smarteye.SEAT_API;
import hr.euroart93.yismarthome.R;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import android.view.View.OnTouchListener;
import android.view.MotionEvent;

import android.content.pm.ActivityInfo;
import android.util.Log;

public class CameraPlugin extends CordovaPlugin implements ILANSearch, IEvent {
    private static final String TAG = "CameraPlugin";

    public static final int MAX_NUM_CAM_OBJ =2;
    public static final int ACTION_GET_VERSION                      = 0;
    public static final int ACTION_CONNECT                          = 1;
    public static final int ACTION_DISCONNECT                       = 2;
    public static final int ACTION_MOVE_STOP                        = 3;
    public static final int ACTION_MOVE_UP                          = 4;
    public static final int ACTION_MOVE_DOWN                        = 5;
    public static final int ACTION_MOVE_LEFT                        = 6;
    public static final int ACTION_MOVE_RIGHT                       = 7;
    public static final int ACTION_VIDEO_STREAM_START               = 8;
    public static final int ACTION_VIDEO_STREAM_STOP                = 9;
    public static final int ACTION_SEND_WIFI_SETUP                  = 10;
    public static final int ACTION_SCAN_QR                          = 11;
    public static final int ACTION_TAKE_SCREENSHOT                  = 12;
    public static final int ACTION_RECORDING_START                  = 13;
    public static final int ACTION_RECORDING_STOP                   = 14;
    public static final int ACTION_REGISTER_VIDEO_CLICK_CALLBACK    = 15;
    public static final int ACTION_UNREGISTER_VIDEO_CLICK_CALLBACK  = 16;
    public static final int ACTION_CHECK_CAMERA_STATUS              = 17;
    public static final int ACTION_START_LAN_SEARCH                 = 18;
    public CallbackContext publicContext = null;
    public String publicArgs = null;
    public String publicDid = null;

    JSONArray cameraArr = new JSONArray();
    // public JSONObject cameraDid = new JSONObject();

    private List<String> actions = Arrays.asList(
        "get_version",
        "connect",
        "disconnect",
        "move_stop",
        "move_up",
        "move_down",
        "move_left",
        "move_right",
        "video_stream_start",
        "video_stream_stop",
        "send_wifi_setup",
        "scan_qr",
        "take_screenshot",
        "recording_start",
        "recording_stop",
        "register_video_click_callback",
        "unregister_video_click_callback",
        "check_camera_status",
        "start_lan_search"
    );

    private Map<String, Camera> cameras = new HashMap<String, Camera>();
    private CameraWifi cameraWifi = new CameraWifi();

    private ImageView imageView = null;
    private LinearLayout greyLayout = null;
    private LinearLayout greyLayoutTop = null;
    private ImageView moveUpView = null;
    private ImageView moveDownView = null;
    private ImageView moveLeftView = null;
    private ImageView moveRightView = null;
    private ImageView exitVideoView = null;
    private ImageView startTalking = null;
    private ImageView startAudio = null;
    private ViewGroup viewGroup = null;
    private View webViewView = null;
    private boolean istalk = false;
    private boolean isAudio = false;

    private CallbackContext qrContext = null;

    private VideoThread videoThread = null;
    private AudioThread audioThread = null;
    private MediaRecorderThread recorderThread = null;

    private String recordFilename = null;

    private CallbackContext videoClickCallbackContext = null;

    @Override
    public void initialize(final CordovaInterface cordova, final CordovaWebView webView) {
        super.initialize(cordova, webView);

        webViewView = webView.getView();
        viewGroup = (ViewGroup)webViewView.getParent();

        String arch = System.getProperty("os.arch");
        Log.i(TAG, "device architecture ---------------->> " + arch);

        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                LayoutInflater.from(cordova.getActivity())
                    .inflate(R.layout.new_layout, viewGroup);

                imageView = (ImageView)viewGroup.findViewById(R.id.imageview);
                imageView.setVisibility(View.GONE);
                webViewView.bringToFront();  
                // drawCommands();
                imageView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Log.i(TAG, "onClick");
                        // videoClickCallbackSendResult();
                    }
                });
            }
        });
    }

    public void drawCommands(){
       
        final Camera camera = cameras.get(publicDid);

        greyLayout = (LinearLayout) viewGroup.findViewById(R.id.greyLayout);
        greyLayout.setVisibility(View.VISIBLE);
        greyLayout.bringToFront();
        
        greyLayoutTop = (LinearLayout) viewGroup.findViewById(R.id.greyLayoutTop);
        greyLayoutTop.setVisibility(View.VISIBLE);
        greyLayoutTop.bringToFront();

        TextView cammName = (TextView) viewGroup.findViewById(R.id.cammName);
        cammName.setVisibility(View.VISIBLE);
        cammName.bringToFront();
        
        exitVideoView = (ImageView)viewGroup.findViewById(R.id.exitVideoView);
        exitVideoView.setVisibility(View.VISIBLE);
        exitVideoView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Log.i(TAG, "onClick");
                        exitVideoTap();
                    }
                });
        exitVideoView.bringToFront();

        moveUpView = (ImageView)viewGroup.findViewById(R.id.moveUpView);
        moveUpView.setVisibility(View.VISIBLE);
        
        moveUpView.setOnTouchListener(new OnTouchListener () {
            public boolean onTouch(View view, MotionEvent event) {
                if (event.getAction() == android.view.MotionEvent.ACTION_DOWN) {
                    Log.d("TouchTest", "Touch down");
                    cameras.get(publicDid).moveUp();
                } else if (event.getAction() == android.view.MotionEvent.ACTION_UP) {
                    
                    cameras.get(publicDid).moveStop();
                    Log.d("TouchTest", "Touch up");
                }
                return true;
            }
        });

        moveUpView.bringToFront();

        moveDownView = (ImageView)viewGroup.findViewById(R.id.moveDownView);
        moveDownView.setVisibility(View.VISIBLE);
        
        moveDownView.setOnTouchListener(new OnTouchListener () {
            public boolean onTouch(View view, MotionEvent event) {
                if (event.getAction() == android.view.MotionEvent.ACTION_DOWN) {
                    Log.d("TouchTest", "Touch down");
                    cameras.get(publicDid).moveDown();

                } else if (event.getAction() == android.view.MotionEvent.ACTION_UP) {
                    Log.d("TouchTest", "Touch up");
                    cameras.get(publicDid).moveStop();

                }
                return true;
            }
        });


        moveDownView.bringToFront();


        moveLeftView = (ImageView)viewGroup.findViewById(R.id.moveLeftView);
        moveLeftView.setVisibility(View.VISIBLE);
        
        moveLeftView.setOnTouchListener(new OnTouchListener () {
            public boolean onTouch(View view, MotionEvent event) {
                if (event.getAction() == android.view.MotionEvent.ACTION_DOWN) {
                    Log.d("TouchTest", "Touch down");
                    cameras.get(publicDid).moveLeft();

                } else if (event.getAction() == android.view.MotionEvent.ACTION_UP) {
                    Log.d("TouchTest", "Touch up");
                    cameras.get(publicDid).moveStop();

                }
                return true;
            }
        });


        moveLeftView.bringToFront();


        moveRightView = (ImageView)viewGroup.findViewById(R.id.moveRightView);
        moveRightView.setVisibility(View.VISIBLE);
        
        moveRightView.setOnTouchListener(new OnTouchListener () {
            public boolean onTouch(View view, MotionEvent event) {
                if (event.getAction() == android.view.MotionEvent.ACTION_DOWN) {
                    Log.d("TouchTest", "Touch down");
                    cameras.get(publicDid).moveRight();

                } else if (event.getAction() == android.view.MotionEvent.ACTION_UP) {
                    Log.d("TouchTest", "Touch up");
                    cameras.get(publicDid).moveStop();

                }
                return true;
            }
        });

        moveRightView.bringToFront();

        startTalking = (ImageView)viewGroup.findViewById(R.id.startTalking);
        startTalking.setVisibility(View.VISIBLE);
        startTalking.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Log.i(TAG, "onClick");
                        if(istalk) {
                            camera.stopTalk();
                            startTalking.setImageResource(R.drawable.micoff);
                            istalk = false;
                        } else {
                            istalk = true;
                            camera.startTalk();
                            startTalking.setImageResource(R.drawable.micon);
                        }
                    }
                });
        startTalking.bringToFront();

        startAudio = (ImageView)viewGroup.findViewById(R.id.startAudio);
        startAudio.setVisibility(View.VISIBLE);
        startAudio.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Log.i(TAG, "onClick");
                        if(isAudio) {
                            isAudio = false;
                            camera.stopAudio();
                            startAudio.setImageResource(R.drawable.soundoff);
                        } else {
                            isAudio = true;
                            camera.startAudio();
                            startAudio.setImageResource(R.drawable.sound);
                        }
                    }
                });
        startAudio.bringToFront();
       
        

    }

    @Override
    protected void pluginInitialize() {
        super.pluginInitialize();

        Log.i(TAG, "CameraPlugin init");

        ArrayList<INIT_STR> init_str_arr = new ArrayList<INIT_STR>();
        INIT_STR init_str = new INIT_STR("VIEW", "EBGDEKBKKHJLGHJIEJGEFGEBHHNNHKNGHGFMBACGAAJELKLBDNAICGOKGMLJJDLPALMLLMDIODMFBPCIJLMP");

        init_str_arr.add(init_str);

        int status = SEP2P_AppSDK.SEP2P_Initialize(init_str_arr);
        Log.i(TAG, "SEP2P_Initialize: " + status);

        Intent intent = new Intent();
        Context appContext = this.cordova.getActivity().getApplicationContext();

        intent.setClass(appContext, CameraService.class);
        appContext.startService(intent);

        CameraService.setLanSearch(this);
        CameraService.setEvent(this);

        cameraWifi.initialize();
        //SEP2P_AppSDK.SEP2P_StartSearch();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);

        if (requestCode == Activity.RESULT_OK) {
            Log.i(TAG, String.format(
                "qr result ok %s %s",
                intent.getStringExtra("SCAN_RESULT_FORMAT"),
                intent.getStringExtra("SCAN_RESULT")
            ));
        }
        else if (requestCode == Activity.RESULT_CANCELED) {
            Log.i(TAG, String.format(
                "qr result canceled %s %s",
                intent.getStringExtra("SCAN_RESULT_FORMAT"),
                intent.getStringExtra("SCAN_RESULT")
            ));
        }

        if (qrContext != null) {
            if (intent.getStringExtra("SCAN_RESULT_FORMAT").equals("QR_CODE")) {
                qrContext.success(intent.getStringExtra("SCAN_RESULT"));
            }

            qrContext = null;
        }
    }

    @Override
    public void onDestroy() {
        int status = SEP2P_AppSDK.SEP2P_DeInitialize();
        Log.i(TAG, "SEP2P_DeInitialize: " + status);

        Intent intent = new Intent();
        Context appContext = this.cordova.getActivity().getApplicationContext();

        intent.setClass(appContext, CameraService.class);
        appContext.stopService(intent);

        // under comment because of app crashing
        // cameraWifi.deinitialize();

        super.onDestroy();
    }

    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext context) throws JSONException {
        Log.d(TAG, "execute: " + action);
        final Camera camera = cameras.get(publicDid);
        try {
            int actionId = actions.indexOf(action);
            Log.d(TAG, "action id: " + actionId);
            switch (actionId) {
                case ACTION_GET_VERSION:
                    getVersion(context);
                    break;

                case ACTION_CONNECT:
                    connectCamera(
                        context,
                        args.getString(0),
                        args.getString(1),
                        args.getString(2),
                        args.getString(3)
                    );
                    break;

                case ACTION_DISCONNECT:
                    disconnectCamera(context, args.getString(0));
                    break;

                case ACTION_MOVE_STOP:
                    processStatus(context, cameras.get(args.getString(0)).moveStop());
                    break;

                case ACTION_MOVE_UP:
                    processStatus(context, cameras.get(args.getString(0)).moveUp());
                    break;

                case ACTION_MOVE_DOWN:
                    processStatus(context, cameras.get(args.getString(0)).moveDown());
                    break;

                case ACTION_MOVE_LEFT:
                    processStatus(context, cameras.get(args.getString(0)).moveLeft());
                    break;

                case ACTION_MOVE_RIGHT:
                    processStatus(context, cameras.get(args.getString(0)).moveRight());
                    break;

                case ACTION_START_LAN_SEARCH:

                    camera.startSearchInLAN();
                    new java.util.Timer().schedule( 
                            new java.util.TimerTask() {
                                @Override
                                public void run() {
                                    camera.stopSearchInLAN();
                                    context.success(cameraArr.toString());
                                }
                            }, 
                            5000 
                    );
                    new java.util.Timer().schedule( 
                            new java.util.TimerTask() {
                                @Override
                                public void run() {
                                    cameraArr = new JSONArray();
                                }
                            }, 
                            7000 
                    );

                    break;

                case ACTION_VIDEO_STREAM_START:
                    final String did = args.getString(0);

                    cordova.getActivity().runOnUiThread(
                        new Runnable() {
                            @Override
                            public void run() {
                                startVideoStream(context, did);
                                showVideoScreen();
                            }
                        }
                    );
                    break;

                case ACTION_VIDEO_STREAM_STOP:
                    stopVideoStream(args.getString(0));
                    hideVideoScreen();
                    publicContext = context;
                    publicArgs = args.getString(0);
                    break;

                case ACTION_SEND_WIFI_SETUP:
                    
                    camera.startSearchInLAN();
                    cameraWifi.serializeToAir(
                        args.getString(0),
                        args.getString(1),
                        args.getInt(2)
                    );
                    try{
                        Thread.sleep(10000);
                        camera.stopSearchInLAN();
                        context.success(cameraArr.toString());

                    }catch(InterruptedException e){
                        e.printStackTrace();
                    }

                    try{
                        Thread.sleep(1000);
                        cameraArr = new JSONArray();

                    }catch(InterruptedException e){
                        e.printStackTrace();
                    }
                    
                    Log.w(TAG, "ACTION_SEND_WIFI_SETUP");
                    break;

                case ACTION_SCAN_QR:
                    scanQr();
                    qrContext = context;
                    break;

                case ACTION_CHECK_CAMERA_STATUS:

                    Camera cam = cameras.get(args.getString(0));
                    cam.getCameraUserInfo(args.getString(0));
                    context.success(cam.onlineCameras.toString());

                    break;

                case ACTION_TAKE_SCREENSHOT:
                    takeScreenshot(context);
                    break;

                case ACTION_RECORDING_START:
                    recordingStart(context);
                    break;

                case ACTION_RECORDING_STOP:
                    recordingStop(context);
                    break;

                case ACTION_REGISTER_VIDEO_CLICK_CALLBACK:
                    videoClickCallbackContext = context;
                    videoClickCallbackSendResult();
                    break;

                case ACTION_UNREGISTER_VIDEO_CLICK_CALLBACK:
                    videoClickCallbackContext = null;
                    context.success();
                    break;

                default:
                    return false;
            }
        } catch (NullPointerException ex) {
            errorNoCamera(context, args.getString(0));
        }

        return true;
    }

    private void videoClickCallbackSendResult() {
        PluginResult result = new PluginResult(PluginResult.Status.OK);
        result.setKeepCallback(true);
        videoClickCallbackContext.sendPluginResult(result);
    }


    private void exitVideoTap() {
        final Camera camera = cameras.get(publicDid);
        stopVideoStream(publicDid);
        hideVideoScreen();
        camera.stopTalk();
        camera.stopAudio();

    }

    private void scanQr() {
        this.cordova.setActivityResultCallback(this);

        try {
            Intent zxingIntent = new Intent("com.google.zxing.client.android.SCAN");
            zxingIntent.putExtra("SCAN_MODE", "QR_CODE_MODE");

            this.cordova.getActivity().startActivityForResult(zxingIntent, 0);
        } catch (ActivityNotFoundException ex) {
            Uri uri = Uri.parse("market://details?id=com.google.zxing.client.android");

            Intent marketIntent = new Intent(Intent.ACTION_VIEW, uri);
            this.cordova.getActivity().startActivity(marketIntent);
        }
    }

    private void takeScreenshot(CallbackContext context) {
        String filename = new SimpleDateFormat("yyyyMMddHHmmss", Locale.US).format(new Date());

        String url = MediaStore.Images.Media.insertImage(
            cordova.getActivity().getContentResolver(),
            ((BitmapDrawable)imageView.getDrawable()).getBitmap(),
            "camera_" + filename + ".jpg",
            ""
        );

        if (url == null) {
            context.error("Failed to save image");
        }
        else {
            context.success(url);
        }
    }

    private String genRecordFilename() {
        return String.format("%s/camera_%s.mp4",
            Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES),
            new SimpleDateFormat("yyyyMMddHHmmss", Locale.US).format(new Date())
        );
    }

    private void recordingStart(CallbackContext context) {
        if (videoThread == null) {
            context.error("No video playback on which to attach recorder");
            return;
        }

        if (recorderThread != null) {
            context.error("Media is already recording");
            return;
        }

        mediaThreadStartRecorder();

        context.success();
    }

    private void recordingStop(CallbackContext context) {
        if (videoThread == null) {
            context.error("No video playback on which to stop recorder");
            return;
        }

        if (recorderThread != null) {
            context.error("No video is presently being recorded");
            return;
        }

        mediaThreadStopRecorder();
        context.success();
    }

    private void mediaThreadStartRecorder() {
        if (recorderThread != null) {
            Log.w(TAG, "Already recording");
            return;
        }

        recordFilename = genRecordFilename();
        recorderThread = new MediaRecorderThread(recordFilename);
        recorderThread.start();

        videoThread.startRecording(recorderThread.getFrameQueue());
        audioThread.startRecording(recorderThread.getFrameQueue());
    }

    private void mediaThreadStopRecorder() {
        if (recorderThread != null) {
            videoThread.stopRecording();
            audioThread.stopRecording();

            recorderThread.stopAll();
            recorderThread = null;

            Log.d(TAG, recordFilename);

            cordova.getActivity().sendBroadcast(
                new Intent(
                    Intent.ACTION_MEDIA_SCANNER_SCAN_FILE,
                    Uri.fromFile(new File(recordFilename))
                )
            );

            recordFilename = null;
        }
    }

    private void errorNoCamera(CallbackContext context, String tid) {
        context.error("Camera with did '" + tid + "' not intialized");
    }

    private void processStatus(CallbackContext context, int status) {
        if (status < 0) {
            context.error(status);
        }

        context.success(status);
    }

    private int getSEATVersion() {
        byte[] desc = new byte[255];

        Arrays.fill(desc, (byte) 0);

        return SEAT_API.SEAT_GetSdkVer(desc, desc.length);
    }

    private void getVersion(CallbackContext context) {
        byte[] desc = new byte[255];

        Arrays.fill(desc, (byte) 0);

        context.success(SEP2P_AppSDK.SEP2P_GetSDKVersion(desc, desc.length));
    }

    private void connectCamera(CallbackContext context, String did, String username, String password, final String cameraName) {
        if (did == null || username == null || password == null || cameraName == null) {
            context.error("missing arguments");
        }
        else {
            if (!cameras.containsKey(did)) {
                cameras.put(did, new Camera(did));
                publicDid = did;
            }
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    TextView cammName = (TextView) viewGroup.findViewById(R.id.cammName);
                    cammName.setText(cameraName);
                }
            });
            Log.i(TAG, "connect camera did     "+did);

            processStatus(context, cameras.get(did).connect(username, password));
        }



    }

    private void disconnectCamera(CallbackContext context, String did) {
        if (did == null) {
            context.error("missing did");
        }
        else {
            processStatus(context, cameras.get(did).disconnect());
        }
    }

    private boolean startMediaThread(Camera camera) {
        if (videoThread == null) {
            /* Setting images on imageview needs to be done on ui thread.
               For that purpose video thread accepts callback with runnable
               working on ui thread. */
            videoThread = new VideoThread(
                new VideoThread.ImageShowRunnable() {
                    @Override
                    public void run(final Bitmap bitmap) {
                        cordova.getActivity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                imageView.setImageBitmap(bitmap);
                            }
                        });
                    }
                },
                camera.videoQueue
            );
            videoThread.start();

            audioThread = new AudioThread(camera.audioQueue);
            audioThread.start();
            return true;
        }

        Log.i(TAG, "media threads already created, aborting creation");
        return false;
    }

    private void stopMediaThread() {
        if (videoThread != null) {
            mediaThreadStopRecorder();

            videoThread.stopAll();
            videoThread = null;

            audioThread.stopAll();
            audioThread = null;
        }
        else {
            Log.d(TAG, "videoThread is null");
        }
    }

    private void showVideoScreen() {
        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                webViewView.setVisibility(View.GONE);
                imageView.setVisibility(View.VISIBLE);
                imageView.bringToFront();
                drawCommands();
            }
        });
    }

    private void hideVideoScreen() {
        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                TextView cammName = (TextView) viewGroup.findViewById(R.id.cammName);

                imageView.setVisibility(View.GONE);
                moveDownView.setVisibility(View.GONE);
                moveRightView.setVisibility(View.GONE);
                moveLeftView.setVisibility(View.GONE);
                moveUpView.setVisibility(View.GONE);
                greyLayout.setVisibility(View.GONE);
                greyLayoutTop.setVisibility(View.GONE);
                cammName.setVisibility(View.GONE);
                exitVideoView.setVisibility(View.GONE);
                webViewView.setVisibility(View.VISIBLE);
                webViewView.bringToFront();
            }
        });
    }

    private void startVideoStream(final CallbackContext context, String did) {

        Activity activity = cordova.getActivity();

        activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
        final Camera camera = cameras.get(did);

        publicDid = did;
        if (camera == null) {
            throw new NullPointerException();
        }

        if (!startMediaThread(camera)) {
            context.error("media thread occupied");
            return;
        }

        int status = camera.startVideo();
       
        processStatus(context, status);
    }

    private void stopVideoStream(String did) {

        Activity activity = cordova.getActivity();

        activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

        Camera camera = cameras.get(did);
        if (camera == null) {
            throw new NullPointerException();
        }

        stopMediaThread();

        int status = camera.stopVideo();

        if (status == SEP2P_AppSDK.ERR_SEP2P_SUCCESSFUL) {
            status = camera.stopAudio();
        }
        else {
            camera.stopAudio();
        }

        // if (context != null) {
        //     processStatus(context, status);
        // }
    }

    private String getVideoPlayingCameraDID() {
        for (Map.Entry<String, Camera> camera: cameras.entrySet()) {
            if (camera.getValue().isVideoPlaying()) {
                return camera.getKey();
            }
        }

        return null;
    }

    // public PluginResult(Status status, ArrayList message) {
    //     this.status = status.ordinal();
    //     this.message = (message != null) ? message.toString(): "null";
    // }

    @Override
    public void onLANSearch(byte[] data, int dataSize) {
        SEARCH_RESP response = new SEARCH_RESP(data);

        Log.i(TAG, "Found==========================>>>>>: DID=" + response.getDID() + ", ip=" + response.getIpAddr());

        String hasDid = "no";
        if (camDIDExists(cameraArr, response.getDID())) {
            hasDid = "yes";
            return;
        }

        if (hasDid == "no") {
            cameraArr.put(response.getDID());
        }

    }

    private boolean camDIDExists(JSONArray jsonArray, String camdDidToFind){
        return jsonArray.toString().contains(camdDidToFind);
    }

    @Override
    public void onEvent(String did, int eventType, int userData) {
        switch (eventType) {
            case SEP2P_Define.EVENT_TYPE_MOTION_ALARM:
                Log.i(TAG, "EVENT_TYPE_MOTION_ALARM");
                break;

            case SEP2P_Define.EVENT_TYPE_INPUT_ALARM:
                Log.i(TAG, "EVENT_TYPE_INPUT_ALARM");
                break;

            case SEP2P_Define.EVENT_TYPE_AUDIO_ALARM:
                Log.i(TAG, "EVENT_TYPE_AUDIO_ALARM");
                break;

            default:
                Log.i(TAG, String.format("Event type: 0x%x", eventType));
                break;
        }
    }
}
