
var exec = require('cordova/exec');

var CameraPlugin = function() {
    this.plugin_class = "CameraPlugin";

    this.WIFI_SECURITY_MODE_OPEN            = 0;
    this.WIFI_SECURITY_MODE_WEP             = 1;
    this.WIFI_SECURITY_MODE_WEP_64_ASCII    = 2;
    this.WIFI_SECURITY_MODE_WEP_64_HEX      = 3;
    this.WIFI_SECURITY_MODE_WEP_128_ASCII   = 4;
    this.WIFI_SECURITY_MODE_WEP_128_HEX     = 5;
    this.WIFI_SECURITY_MODE_WPAPSK_TKIP     = 6;
    this.WIFI_SECURITY_MODE_WPAPSK_AES      = 7;
    this.WIFI_SECURITY_MODE_WPA2PSK_TKIP    = 8;
    this.WIFI_SECURITY_MODE_WPA2PSK_AES     = 9;
    this.WIFI_SECURITY_MODE_UNKNOWN         = 0xf;
};

CameraPlugin.prototype.call_action = function(success, error, action, args) {
    exec(
        success || function(msg) {
            if (msg) {
                console.log(action + ": " + msg);
            }
            else {
                console.log(action + ": success");
            }
        },
        error || function(err) {
            console.log(action + ": " + err);
        },
        this.plugin_class,
        action,
        args || []
    )
};

CameraPlugin.prototype.get_version = function(success, error) {
    this.call_action(success, error, "get_version")
};

CameraPlugin.prototype.connect = function(did, username, password, camName, success, error) {
    console.log('cammname ------------> ',camName);
    this.call_action(success, error, "connect", [did, username, password, camName]);
};

CameraPlugin.prototype.disconnect = function(did, success, error) {
    this.call_action(success, error, "disconnect", [did]);
};

CameraPlugin.prototype.move_stop = function(did, success, error) {
    this.call_action(success, error, "move_stop", [did]);
};

CameraPlugin.prototype.move_up = function(did, success, error) {
    this.call_action(success, error, "move_up", [did]);
};

CameraPlugin.prototype.move_down = function(did, success, error) {
    this.call_action(success, error, "move_down", [did]);
};

CameraPlugin.prototype.move_left = function(did, success, error) {
    this.call_action(success, error, "move_left", [did]);
};

CameraPlugin.prototype.move_right = function(did, success, error) {
    this.call_action(success, error, "move_right", [did]);
};

CameraPlugin.prototype.video_stream_start = function(did, success, error) {
    this.call_action(success, error, "video_stream_start", [did]);
};

CameraPlugin.prototype.video_stream_stop = function(did, success, error) {
    this.call_action(success, error, "video_stream_stop", [did]);
};

CameraPlugin.prototype.send_wifi_setup = function(ssid, password, mode, success, error) {
    this.call_action(success, error, "send_wifi_setup", [ssid, password, mode]);
}

CameraPlugin.prototype.scan_qr = function(success, error) {
    this.call_action(success, error, "scan_qr");
}

CameraPlugin.prototype.start_lan_search = function(success, error) {
    this.call_action(success, error, "start_lan_search");
}

CameraPlugin.prototype.check_camera_status = function(did, success, error) {
    this.call_action(success, error, "check_camera_status",[did]);
}

CameraPlugin.prototype.take_screenshot = function(success, error) {
    this.call_action(success, error, "take_screenshot");
}

CameraPlugin.prototype.recording_start = function(success, error) {
    this.call_action(success, error, "recording_start");
}

CameraPlugin.prototype.recording_stop = function(success, error) {
    this.call_action(success, error, "recording_stop");
}

CameraPlugin.prototype.register_video_click_callback = function(success) {
    this.call_action(success, null, "register_video_click_callback");
}

CameraPlugin.prototype.unregister_video_click_callback = function() {
    this.call_action(null, null, "unregister_video_click_callback");
}

// module.exports = new CameraPlugin();

window.CameraPlugin = CameraPlugin;
window.CameraPlugin = new CameraPlugin();
module.exports = new CameraPlugin();
