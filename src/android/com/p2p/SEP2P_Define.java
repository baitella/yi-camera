package com.p2p;

public class SEP2P_Define {
	//CONNECT_MODE
	public static final int CONNECT_MODE_P2P	=0x00;
	public static final int CONNECT_MODE_RLY	=0x01;
	public static final int CONNECT_MODE_UNKNOWN=0x02;
	
	//ENUM_BIT_MASK_CAMERA_PARAM
	public static final int BIT_MASK_CAM_PARAM_RESOLUTION =0x01;
	public static final int BIT_MASK_CAM_PARAM_BRIGHT	  =0x02;
	public static final int BIT_MASK_CAM_PARAM_CONTRAST	  =0x04;
	public static final int BIT_MASK_CAM_PARAM_HUE		  =0x08;
	public static final int BIT_MASK_CAM_PARAM_SATURATION =0x10;
	public static final int BIT_MASK_CAM_PARAM_OSD		  =0x20;
	public static final int BIT_MASK_CAM_PARAM_MODE		  =0x40;
	public static final int BIT_MASK_CAM_PARAM_FLIP		  =0x80;
	public static final int BIT_MASK_CAM_PARAM_IRLED	  =0x0100;
	
	//ENUM_PTZ_CONTROL_CMD
	public static final int PTZ_CTRL_STOP				=0x00;
	public static final int PTZ_CTRL_UP					=0x01;
	public static final int PTZ_CTRL_DOWN				=0x02;
	public static final int PTZ_CTRL_LEFT				=0x03;
	public static final int PTZ_CTRL_RIGHT				=0x04;

	public static final int PTZ_CTRL_CRUISE_H			=0x30;
	public static final int PTZ_CTRL_CRUISE_V			=0x31;

	public static final int PTZ_CTRL_PRESET_BIT_SET		=0x40;
	public static final int PTZ_CTRL_PRESET_BIT_GOTO	=0x41;
	
	//SEP2P_ENUM_EVENT_TYPE
	public static final int EVENT_TYPE_UNKNOWN		= 0x00;
	public static final int EVENT_TYPE_MOTION_ALARM	= 0x01;
	public static final int EVENT_TYPE_INPUT_ALARM	= 0x02;
	public static final int EVENT_TYPE_AUDIO_ALARM	= 0x03;
	public static final int EVENT_TYPE_MANUAL_ALARM = 0x04;
	public static final int EVENT_TYPE_DOORBELL_ALARM	 = 0x08;
	public static final int EVENT_TYPE_TEMPERATURE_ALARM = 0x10;
	public static final int EVENT_TYPE_HUMIDITY_ALARM	 = 0x20;
			
	//RECORD_TYPE
	public static final int RECORD_TYPE_PLAN	=0x01;
	public static final int RECORD_TYPE_ALARM	=0x02;
	public static final int RECORD_TYPE_ALL		=0x03;
	
	//CONNECT_STATUS
	public static final int CONNECT_STATUS_CONNECTING	=0x00;
	public static final int CONNECT_STATUS_INITIALING	=0x01;
	public static final int CONNECT_STATUS_ONLINE		=0x02;
	public static final int CONNECT_STATUS_CONNECT_FAILED=0x03;
	public static final int CONNECT_STATUS_DISCONNECT	 =0x04;
	public static final int CONNECT_STATUS_INVALID_ID	 =0x05;
	public static final int CONNECT_STATUS_DEVICE_NOT_ONLINE=0x06;
	public static final int CONNECT_STATUS_CONNECT_TIMEOUT	=0x07;
	public static final int CONNECT_STATUS_WRONG_USER_PWD	=0x08;

	public static final int CONNECT_STATUS_INVALID_REQ		=0x09;
	public static final int CONNECT_STATUS_EXCEED_MAX_USER	=0x0A; // exceed the max user
	public static final int CONNECT_STATUS_CONNECTED		=0x0B;

	public static final int CONNECT_STATUS_UNKNOWN	=0xFFFFFF;
	
	//SEP2P_ENUM_MSGTYPE----------------------------------------------------------------------------
	public static final int SEP2P_MSG_CONNECT_STATUS						   = 0x0100;
	public static final int SEP2P_MSG_CONNECT_MODE							   = 0x0101;

	public static final int SEP2P_MSG_START_VIDEO 				               = 0x0110; // start videoThread
	public static final int SEP2P_MSG_STOP_VIDEO 				               = 0x0111; // destroy videoThread
	public static final int SEP2P_MSG_START_AUDIO 				               = 0x0112; // start audio
	public static final int SEP2P_MSG_STOP_AUDIO 				               = 0x0113; // destroy audio
	public static final int SEP2P_MSG_START_TALK 				               = 0x0114; // start talk
	public static final int SEP2P_MSG_START_TALK_RESP			               = 0x0115; // start talk response
	public static final int SEP2P_MSG_STOP_TALK 				               = 0x0117; // destroy talk

	public static final int SEP2P_MSG_GET_CAMERA_PARAM_REQ					   = 0x0120;
	public static final int SEP2P_MSG_GET_CAMERA_PARAM_RESP					   = 0x0121;
	public static final int SEP2P_MSG_SET_CAMERA_PARAM_REQ					   = 0x0122;
	public static final int SEP2P_MSG_SET_CAMERA_PARAM_RESP					   = 0x0123;
	public static final int SEP2P_MSG_SET_CAMERA_PARAM_DEFAULT_REQ			   = 0x0124;
	public static final int SEP2P_MSG_SET_CAMERA_PARAM_DEFAULT_RESP			   = 0x0125;
	public static final int SEP2P_MSG_PTZ_CONTROL_REQ			               = 0x0126;  // yuntai control request
	public static final int SEP2P_MSG_PTZ_CONTROL_RESP			               = 0x0127;  // yuntai control response
	public static final int SEP2P_MSG_SNAP_PICTURE_REQ			               = 0x0128;  //
	public static final int SEP2P_MSG_SNAP_PICTURE_RESP			               = 0x0129;  //return jpg

	public static final int SEP2P_MSG_GET_CURRENT_WIFI_REQ		               = 0x0130;  //
	public static final int SEP2P_MSG_GET_CURRENT_WIFI_RESP		               = 0x0131;  //
	public static final int SEP2P_MSG_SET_CURRENT_WIFI_REQ		               = 0x0132;  //
	public static final int SEP2P_MSG_SET_CURRENT_WIFI_RESP		               = 0x0133;  //
	public static final int SEP2P_MSG_GET_WIFI_LIST_REQ		                   = 0x0134;  //
	public static final int SEP2P_MSG_GET_WIFI_LIST_RESP		               = 0x0135;  //

	public static final int SEP2P_MSG_GET_USER_INFO_REQ		        = 0x0140;  //
	public static final int SEP2P_MSG_GET_USER_INFO_RESP		    = 0x0141;  //
	public static final int SEP2P_MSG_SET_USER_INFO_REQ		        = 0x0142;  //
	public static final int SEP2P_MSG_SET_USER_INFO_RESP		    = 0x0143;  //

	public static final int SEP2P_MSG_GET_DATETIME_REQ		        = 0x0150;  //
	public static final int SEP2P_MSG_GET_DATETIME_RESP		        = 0x0151;  //
	public static final int SEP2P_MSG_SET_DATETIME_REQ		        = 0x0152;  //
	public static final int SEP2P_MSG_SET_DATETIME_RESP		        = 0x0153;  //

	public static final int SEP2P_MSG_GET_FTP_INFO_REQ		        = 0x0160;  //
	public static final int SEP2P_MSG_GET_FTP_INFO_RESP		        = 0x0161;  //
	public static final int SEP2P_MSG_SET_FTP_INFO_REQ		        = 0x0162;  //
	public static final int SEP2P_MSG_SET_FTP_INFO_RESP		        = 0x0163;  //

	public static final int SEP2P_MSG_GET_EMAIL_INFO_REQ		    = 0x0170;  //
	public static final int SEP2P_MSG_GET_EMAIL_INFO_RESP		    = 0x0171;  //
	public static final int SEP2P_MSG_SET_EMAIL_INFO_REQ		    = 0x0172;  //
	public static final int SEP2P_MSG_SET_EMAIL_INFO_RESP		    = 0x0173;  //

	public static final int SEP2P_MSG_GET_ALARM_INFO_REQ		    = 0x0180;  //
	public static final int SEP2P_MSG_GET_ALARM_INFO_RESP		    = 0x0181;  //
	public static final int SEP2P_MSG_SET_ALARM_INFO_REQ		    = 0x0182;  //
	public static final int SEP2P_MSG_SET_ALARM_INFO_RESP		    = 0x0183;  //

	public static final int SEP2P_MSG_GET_SDCARD_REC_PARAM_REQ		= 0x0190;  //
	public static final int SEP2P_MSG_GET_SDCARD_REC_PARAM_RESP		= 0x0191;  //
	public static final int SEP2P_MSG_SET_SDCARD_REC_PARAM_REQ		= 0x0192;  //
	public static final int SEP2P_MSG_SET_SDCARD_REC_PARAM_RESP		= 0x0193;  //

	public static final int SEP2P_MSG_FORMAT_SDCARD_REQ		        = 0x0194;  //
	//SEP2P_MSG_FORMAT_SDCARD_RESP		               = 0x0195,        //
	
	public static final int SEP2P_MSG_REBOOT_DEVICE 				= 0x0196;
	//
	
	public static final int SEP2P_MSG_GET_CUSTOM_PARAM_REQ  		= 0x0198;
	public static final int SEP2P_MSG_GET_CUSTOM_PARAM_RESP 		= 0x0199;
	public static final int SEP2P_MSG_SET_CUSTOM_PARAM_REQ  		= 0x019A;
	public static final int SEP2P_MSG_SET_CUSTOM_PARAM_RESP 		= 0x019B;
	
	public static final int SEP2P_MSG_GET_DEVICE_VERSION_REQ		= 0x01A0;  //
	public static final int SEP2P_MSG_GET_DEVICE_VERSION_RESP		= 0x01A1;  //	
	
	//----{{playback
	public static final int SEP2P_MSG_GET_REMOTE_REC_DAY_BY_MONTH_REQ	= 0x01A6;  //
	public static final int SEP2P_MSG_GET_REMOTE_REC_DAY_BY_MONTH_RESP	= 0x01A7;  //
	public static final int SEP2P_MSG_GET_REMOTE_REC_FILE_BY_DAY_REQ	= 0x01A8;  //
	public static final int SEP2P_MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP	= 0x01A9;  //
	public static final int SEP2P_MSG_START_PLAY_REC_FILE_REQ			= 0x01AA;  //
	public static final int SEP2P_MSG_START_PLAY_REC_FILE_RESP			= 0x01AB;  //
	public static final int SEP2P_MSG_STOP_PLAY_REC_FILE_REQ			= 0x01AC;  //
	public static final int SEP2P_MSG_STOP_PLAY_REC_FILE_RESP			= 0x01AD;  //
	
	public static final int SEP2P_MSG_GET_IPUSH_INFO_REQ				= 0x01BA;
	public static final int SEP2P_MSG_GET_IPUSH_INFO_RESP				= 0x01BB;
	public static final int SEP2P_MSG_SET_IPUSH_INFO_REQ				= 0x01BC;
	public static final int SEP2P_MSG_SET_IPUSH_INFO_RESP				= 0x01BD;
	
	//----}}playback
	
}
