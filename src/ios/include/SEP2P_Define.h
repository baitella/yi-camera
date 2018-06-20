//
//  SEP2P_Define.h
//


#ifndef __INCLUDED_SEP2P_Define____H
#define __INCLUDED_SEP2P_Define____H
/*!
 @header SEP2P_Define
 @abstract This file define all the message types and structs that may be use 
 @version 
 */

#include "SEP2P_Type.h"


/*!
 @enum SEP2P_ENUM_AV_CODECID
 @abstract the enum used to distinguish stream type .
 @discussion the enum user for difference between video stream,audio stream .
 @constant AV_CODECID_UNKNOWN  means that the stream type is unknown .
 @constant AV_CODECID_VIDEO_MJPEG  means that stream type is mjpeg video stream .
 @constant AV_CODECID_VIDEO_H264  means that stream type is H264 video stream .
 @constant AV_CODECID_AUDIO_ADPCM  means that stream type is adpcm audio stream .
 @constant AV_CODECID_AUDIO_G726   means that stream type is G726 audio stream .
 @constant AV_CODECID_AUDIO_G711A   means that stream type is G711A audio stream .
 */
typedef enum
{
	AV_CODECID_UNKNOWN		= 0x00,
	AV_CODECID_VIDEO_MJPEG,
	AV_CODECID_VIDEO_H264,

	AV_CODECID_AUDIO_ADPCM	=0x100,
	AV_CODECID_AUDIO_G726,
	AV_CODECID_AUDIO_G711A,
	AV_CODECID_AUDIO_AAC

}SEP2P_ENUM_AV_CODECID;

/*!
 @enum SEP2P_ENUM_VIDEO_FRAME
 @abstract the enum used to distinguish the first frame in video stream.
 @discussion the enum used to distinguish the first frame in video stream. VIDEO_FRAME_FLAG_I means that the first frame is I frame. VIDEO_FRAME_FLAG_P means that the first frame is P frame. VIDEO_FRAME_FLAG_B means that the first frame is B frame.
 @constant VIDEO_FRAME_FLAG_I  means that this frame is I frame.
 @constant VIDEO_FRAME_FLAG_P  means that this frame is P frame..
 @constant VIDEO_FRAME_FLAG_B  means that this frame is B frame..
 */
typedef enum
{
	VIDEO_FRAME_FLAG_I	= 0x00,	// Video I Frame
	VIDEO_FRAME_FLAG_P	= 0x01,	// Video P Frame
	VIDEO_FRAME_FLAG_B	= 0x02	// Video B Frame
}SEP2P_ENUM_VIDEO_FRAME;


/*!
 @enum SEP2P_ENUM_AV_CODECID
 @abstract the enum used to distinguish video quality.
 @discussion .
 @constant VIDEO_RESO_QQVGA  means that the video quality is QQVGA(160*120).
 @constant VIDEO_RESO_QVGA  means that the video quality is QVGA(320*240).
 @constant VIDEO_RESO_VGA1  means that video quality is VGA1(640*480).
 @constant VIDEO_RESO_VGA2  means that video quality is VGA2(640*360).
 @constant VIDEO_RESO_720P  means video quality is 720P(1280*720).
 @constant VIDEO_RESO_960P  means video quality is 960P(280*960).
 @constant VIDEO_RESO_UNKNOWN  means that video quality is unknown..
 */
typedef enum
{
	VIDEO_RESO_QQVGA	= 0x00, //160*120
	VIDEO_RESO_QVGA		= 0x01,	//320*240
	VIDEO_RESO_VGA1		= 0x02,	//640*480
	VIDEO_RESO_VGA2		= 0x03,	//640*360
	VIDEO_RESO_720P		= 0x04,	//1280*720
	VIDEO_RESO_960P		= 0x05,	//1280*960
	VIDEO_RESO_1080P	= 0x06,	//1920*1080 //added on 2014-10-30, for x series
	VIDEO_RESO_1296P	= 0x07,	//2304*1296 //added on 2015-06-08, for x series

	VIDEO_RESO_UNKNOWN  = 0xFF
}SEP2P_ENUM_VIDEO_RESO;

/*!
 @enum SEP2P_ENUM_AUDIO_SAMPLERATE
 @abstract the enum used to distinguish the audio sample.
 @discussion .
 @constant AUDIO_SAMPLE_8K   means that the the audio sample is 8000 Hz.
 @constant AUDIO_SAMPLE_11K  means that the audio sample is 1100 Hz.
 @constant AUDIO_SAMPLE_12K  means  that the audio sample is 1200 Hz.
 @constant AUDIO_SAMPLE_16K  means that the audio sample is 1600 Hz.
 @constant AUDIO_SAMPLE_22K  means that  the audio sample is 2200 Hz.
 @constant AUDIO_SAMPLE_24K  means that  the audio sample is 2400 Hz.
 @constant AUDIO_SAMPLE_32K  means that  the audio sample is 3200 Hz.
 @constant AUDIO_SAMPLE_44K  means that  the audio sample is 4400 Hz.
 @constant AUDIO_SAMPLE_48K  means that the audio sample is 4800  Hz.
 */
typedef enum
{
	AUDIO_SAMPLE_8K		= 0x00,
	AUDIO_SAMPLE_11K	= 0x01,
	AUDIO_SAMPLE_12K	= 0x02,
	AUDIO_SAMPLE_16K	= 0x03,
	AUDIO_SAMPLE_22K	= 0x04,
	AUDIO_SAMPLE_24K	= 0x05,
	AUDIO_SAMPLE_32K	= 0x06,
	AUDIO_SAMPLE_44K	= 0x07,
	AUDIO_SAMPLE_48K	= 0x08
}SEP2P_ENUM_AUDIO_SAMPLERATE;

/*!
 @enum SEP2P_ENUM_AUDIO_DATABITS
 @abstract the enum used to distinguish audio data bits.
 @discussion .
 @constant AUDIO_DATABITS_8    means that the audio data bits is 8 bits.
 @constant AUDIO_DATABITS_16   means that the audio data bits is 16 bits.
 */
typedef enum
{
	AUDIO_DATABITS_8	= 0,
	AUDIO_DATABITS_16	= 1
}SEP2P_ENUM_AUDIO_DATABITS;

/*!
 @enum SEP2P_ENUM_AUDIO_CHANNEL
 @abstract the enum used to distinguish audio channel.
 @discussion .
 @constant AUDIO_CHANNEL_MONO    means that the audio channel is mono.
 @constant AUDIO_CHANNEL_STERO   means that the audio channel is stero.
 */
typedef enum
{
	AUDIO_CHANNEL_MONO	= 0,
	AUDIO_CHANNEL_STERO	= 1
}SEP2P_ENUM_AUDIO_CHANNEL;

/*!
 @enum SEP2P_ENUM_MSGTYPE
 @abstract the enum used to distinguish all the message type, you should use these message type to get the response data you want or send the data to control the device , such as start video stream ,start audio strream , get device's params and so on.
 @discussion .
 @constant SEP2P_MSG_CONNECT_STATUS means that the message type is device connect status.
 @constant SEP2P_MSG_CONNECT_MODE   means that the message type is device connect mode .
 @constant SEP2P_MSG_START_VIDEO  means that the message type is start video stream, after you start video stream you can get video stream in  stream call back funtion.
 @constant SEP2P_MSG_STOP_VIDEO  means that the message type is  stop video stream.
 @constant SEP2P_MSG_START_AUDIO  means that the message type is start audio stream .
 @constant SEP2P_MSG_STOP_AUDIO  means that the message type is  stop audio stream.
 @constant SEP2P_MSG_START_TALK  means that the message type is  open talk channel.
 @constant SEP2P_MSG_START_TALK_RESP  means that the message type is  the response with open talk channel request.
 @constant SEP2P_MSG_STOP_TALK, means that the message type is  close talk channel.
 @constant SEP2P_MSG_GET_CAMERA_PARAM_REQ  means that the message type is  get device param request.
 @constant SEP2P_MSG_GET_CAMERA_PARAM_RESP  means that the message type is  the response on get device param request.
 @constant SEP2P_MSG_SET_CAMERA_PARAM_REQ  means that the message type is set device params request .
 @constant SEP2P_MSG_SET_CAMERA_PARAM_RESP  means that the message type is the response on set device params request .
 @constant SEP2P_MSG_SET_CAMERA_PARAM_DEFAULT_REQ  means that the message type is the set device default params request .
 @constant SEP2P_MSG_SET_CAMERA_PARAM_DEFAULT_RESP  means that the message type is the response on set device default params request .
 @constant SEP2P_MSG_PTZ_CONTROL_REQ  means that the message type is the control device's ptz command request .
 @constant SEP2P_MSG_PTZ_CONTROL_RESP  means that the message type is the response on control device's ptz command request .
 @constant SEP2P_MSG_SNAP_PICTURE_REQ  means that the message type is the snap picture command request.
 @constant SEP2P_MSG_SNAP_PICTURE_RESP  means that the message type is the response on snap picture(jpg format) request .
 @constant SEP2P_MSG_GET_CURRENT_WIFI_REQ  means that the message type is the get device's Wi-Fi request .
 @constant SEP2P_MSG_GET_CURRENT_WIFI_RESP  means that the message type is the response on get device's Wi-Fi request .
 @constant SEP2P_MSG_SET_CURRENT_WIFI_REQ  means that the message type is the set device's Wi-Fi request .
 @constant SEP2P_MSG_SET_CURRENT_WIFI_RESP  means that the message type is the response on set device's Wi-Fi request .
 @constant SEP2P_MSG_GET_WIFI_LIST_REQ  means that the message type is the get Wi-Fi list request .
 @constant SEP2P_MSG_GET_WIFI_LIST_RESP  means that the message type is the response on get Wi-Fi list request .
 @constant SEP2P_MSG_GET_USER_INFO_REQ  means that the message type is the get user information request .
 @constant SEP2P_MSG_GET_USER_INFO_RESP  means that the message type is the response on get user information request .
 @constant SEP2P_MSG_SET_USER_INFO_REQ  means that the message type is the set user information request .
 @constant SEP2P_MSG_SET_USER_INFO_RESP  means that the message type is the response on set user information request .
 @constant SEP2P_MSG_GET_DATETIME_REQ  means that the message type is the get datetime request .
 @constant SEP2P_MSG_GET_DATETIME_RESP  means that the message type is the response on get datetime request .
 @constant SEP2P_MSG_SET_DATETIME_REQ  means that the message type is the set datetime request .
 @constant SEP2P_MSG_SET_DATETIME_RESP  means that the message type is the response on set datetime request .
 @constant SEP2P_MSG_GET_FTP_INFO_REQ  means that the message type is the get ftp information request .
 @constant SEP2P_MSG_GET_FTP_INFO_RESP  means that the message type is the response on get ftp information request .
 @constant SEP2P_MSG_SET_FTP_INFO_REQ  means that the message type is the set ftp information request .
 @constant SEP2P_MSG_SET_FTP_INFO_RESP  means that the message type is the response on set ftp information request .
 @constant SEP2P_MSG_GET_EMAIL_INFO_REQ  means that the message type is the get email information request .
 @constant SEP2P_MSG_GET_EMAIL_INFO_RESP  means that the message type is the response on get email information request .
 @constant SEP2P_MSG_SET_EMAIL_INFO_REQ  means that the message type is the set email information request .
 @constant SEP2P_MSG_SET_EMAIL_INFO_RESP  means that the message type is the response on set email information request .
 @constant SEP2P_MSG_GET_ALARM_INFO_REQ  means that the message type is the get alarm information request .
 @constant SEP2P_MSG_GET_ALARM_INFO_RESP  means that the message type is the response on get alarm information request .
 @constant SEP2P_MSG_SET_ALARM_INFO_REQ means that the message type is the set alarm information request .
 @constant SEP2P_MSG_SET_ALARM_INFO_RESP  means that the message type is the response on set alarm information request .
 @constant SEP2P_MSG_GET_SDCARD_REC_PARAM_REQ  means that the message type is the get sdcard record params request .
 @constant SEP2P_MSG_GET_SDCARD_REC_PARAM_RESP  means that the message type is the response on get sdcard record parmas request .
 @constant SEP2P_MSG_SET_SDCARD_REC_PARAM_REQ  means that the message type is the set sdcard record params request .
 @constant SEP2P_MSG_SET_SDCARD_REC_PARAM_RESP  means that the message type is the response on the set sdcard record param request .
 @constant SEP2P_MSG_FORMAT_SDCARD_REQ  means that the message type is the format sdcard request .
 @constant SEP2P_MSG_GET_DEVICE_VERSION_REQ  means that the message type is the request get device hard soft version information request .
 @constant SEP2P_MSG_GET_DEVICE_VERSION_RESP  means that the message type is the response on get device hard soft version information request .

 */
typedef enum
{
	SEP2P_MSG_QUERY_CHANNEL_INFO_OF_NVR_REQ			   = 0x0096,    
	SEP2P_MSG_QUERY_CHANNEL_INFO_OF_NVR_RESP		   = 0x0097,

	SEP2P_MSG_CONNECT_STATUS						   = 0x0100,
	SEP2P_MSG_CONNECT_MODE							   = 0x0101,

	SEP2P_MSG_START_VIDEO 				               = 0x0110,     // start video
	SEP2P_MSG_STOP_VIDEO 				               = 0x0111,     // stop video
	SEP2P_MSG_START_AUDIO 				               = 0x0112,     // start audio
	SEP2P_MSG_STOP_AUDIO 				               = 0x0113,     // stop audio
	SEP2P_MSG_START_TALK 				               = 0x0114,     // start talk
	SEP2P_MSG_START_TALK_RESP			               = 0x0115,     // start talk response
	SEP2P_MSG_STOP_TALK 				               = 0x0117,     // stop talk

	SEP2P_MSG_GET_CAMERA_PARAM_REQ					   = 0x0120,
	SEP2P_MSG_GET_CAMERA_PARAM_RESP					   = 0x0121,
	SEP2P_MSG_SET_CAMERA_PARAM_REQ					   = 0x0122,
	SEP2P_MSG_SET_CAMERA_PARAM_RESP					   = 0x0123,
	SEP2P_MSG_SET_CAMERA_PARAM_DEFAULT_REQ			   = 0x0124,
	SEP2P_MSG_SET_CAMERA_PARAM_DEFAULT_RESP			   = 0x0125,
	SEP2P_MSG_PTZ_CONTROL_REQ			               = 0x0126,    // PTZ control request
	SEP2P_MSG_PTZ_CONTROL_RESP			               = 0x0127,    // PTZ control response
	SEP2P_MSG_SNAP_PICTURE_REQ			               = 0x0128,    //
	SEP2P_MSG_SNAP_PICTURE_RESP			               = 0x0129,    // return jpg snapshoted

	SEP2P_MSG_GET_CURRENT_WIFI_REQ		               = 0x0130,
	SEP2P_MSG_GET_CURRENT_WIFI_RESP		               = 0x0131,
	SEP2P_MSG_SET_CURRENT_WIFI_REQ		               = 0x0132,
	SEP2P_MSG_SET_CURRENT_WIFI_RESP		               = 0x0133,
	SEP2P_MSG_GET_WIFI_LIST_REQ		                   = 0x0134,
	SEP2P_MSG_GET_WIFI_LIST_RESP		               = 0x0135,

	SEP2P_MSG_GET_USER_INFO_REQ		                   = 0x0140,
	SEP2P_MSG_GET_USER_INFO_RESP		               = 0x0141,
	SEP2P_MSG_SET_USER_INFO_REQ		                   = 0x0142,
	SEP2P_MSG_SET_USER_INFO_RESP		               = 0x0143,

	SEP2P_MSG_GET_DATETIME_REQ		                   = 0x0150,
	SEP2P_MSG_GET_DATETIME_RESP		                   = 0x0151,
	SEP2P_MSG_SET_DATETIME_REQ		                   = 0x0152,
	SEP2P_MSG_SET_DATETIME_RESP		                   = 0x0153,

	SEP2P_MSG_GET_FTP_INFO_REQ		                   = 0x0160,
	SEP2P_MSG_GET_FTP_INFO_RESP		                   = 0x0161,
	SEP2P_MSG_SET_FTP_INFO_REQ		                   = 0x0162,
	SEP2P_MSG_SET_FTP_INFO_RESP		                   = 0x0163,

	SEP2P_MSG_GET_EMAIL_INFO_REQ		               = 0x0170,
	SEP2P_MSG_GET_EMAIL_INFO_RESP		               = 0x0171,
	SEP2P_MSG_SET_EMAIL_INFO_REQ		               = 0x0172,
	SEP2P_MSG_SET_EMAIL_INFO_RESP		               = 0x0173,

	SEP2P_MSG_GET_ALARM_INFO_REQ		               = 0x0180,
	SEP2P_MSG_GET_ALARM_INFO_RESP		               = 0x0181,
	SEP2P_MSG_SET_ALARM_INFO_REQ		               = 0x0182,
	SEP2P_MSG_SET_ALARM_INFO_RESP		               = 0x0183,

	SEP2P_MSG_ALARM_IO_CTRL_REQ						   = 0x0184,
	SEP2P_MSG_ALARM_IO_CTRL_RESP					   = 0x0185,

	SEP2P_MSG_GET_UART_CTRL_REQ						   = 0x0186,
	SEP2P_MSG_GET_UART_CTRL_RESP					   = 0x0187,
	SEP2P_MSG_SET_UART_CTRL_REQ						   = 0x0188,
	SEP2P_MSG_SET_UART_CTRL_RESP					   = 0x0189,

	SEP2P_MSG_GET_SDCARD_REC_PARAM_REQ			       = 0x0190,
	SEP2P_MSG_GET_SDCARD_REC_PARAM_RESP				   = 0x0191,
	SEP2P_MSG_SET_SDCARD_REC_PARAM_REQ		           = 0x0192,
	SEP2P_MSG_SET_SDCARD_REC_PARAM_RESP		           = 0x0193,

	SEP2P_MSG_FORMAT_SDCARD_REQ		                   = 0x0194,
	//SEP2P_MSG_FORMAT_SDCARD_RESP		               = 0x0195,

	SEP2P_MSG_REBOOT_DEVICE							   = 0x0196,	//valid when firmwareVersion>=0.1.0.21 of M
	//

	SEP2P_MSG_GET_CUSTOM_PARAM_REQ					   = 0x0198,	//valid when firmwareVersion>=0.1.0.21 of M
	SEP2P_MSG_GET_CUSTOM_PARAM_RESP					   = 0x0199,	//valid when firmwareVersion>=0.1.0.21 of M
	SEP2P_MSG_SET_CUSTOM_PARAM_REQ					   = 0x019A,	//valid when firmwareVersion>=0.1.0.21 of M
	SEP2P_MSG_SET_CUSTOM_PARAM_RESP					   = 0x019B,	//valid when firmwareVersion>=0.1.0.21 of M

	SEP2P_MSG_GET_DEVICE_VERSION_REQ		           = 0x01A0,
	SEP2P_MSG_GET_DEVICE_VERSION_RESP		           = 0x01A1,

	SEP2P_MSG_GET_REMOTE_REC_DAY_BY_MONTH_REQ		   = 0x01A6,	//added on 2014-12-01
	SEP2P_MSG_GET_REMOTE_REC_DAY_BY_MONTH_RESP		   = 0x01A7,	//added on 2014-12-01
	SEP2P_MSG_GET_REMOTE_REC_FILE_BY_DAY_REQ           = 0x01A8,	//added on 2014-12-01
	SEP2P_MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP          = 0x01A9,	//added on 2014-12-01

	SEP2P_MSG_START_PLAY_REC_FILE_REQ				   = 0x01AA,	//added on 2014-12-01
	SEP2P_MSG_START_PLAY_REC_FILE_RESP                 = 0x01AB,	//added on 2014-12-01
	SEP2P_MSG_STOP_PLAY_REC_FILE_REQ                   = 0x01AC,	//added on 2014-12-01
	SEP2P_MSG_STOP_PLAY_REC_FILE_RESP                  = 0x01AD,	//added on 2014-12-01

	SEP2P_MSG_GET_REC_DATE_RANGE_REQ				   = 0x01AE,	//
	SEP2P_MSG_GET_REC_DATE_RANGE_RESP		           = 0x01AF,	//
	SEP2P_MSG_START_PLAY_REC_FILE2_REQ                 = 0x01B0,	//
	SEP2P_MSG_START_PLAY_REC_FILE2_RESP                = 0x01B1,	//
	SEP2P_MSG_STOP_PLAY_REC_FILE2_REQ                  = 0x01B2,	//
	SEP2P_MSG_STOP_PLAY_REC_FILE2_RESP                 = 0x01B3,	//

	SEP2P_MSG_GET_IPUSH_INFO_REQ					   = 0x01BA,	//X series, supported on the firmware v1.0.0.14
	SEP2P_MSG_GET_IPUSH_INFO_RESP					   = 0x01BB,	//X series, supported on the firmware v1.0.0.14
	SEP2P_MSG_SET_IPUSH_INFO_REQ					   = 0x01BC,	//X series, supported on the firmware v1.0.0.14
	SEP2P_MSG_SET_IPUSH_INFO_RESP					   = 0x01BD		//X series, supported on the firmware v1.0.0.14

	//user can extend message type from 0x1000 to 0xFFFF
	
}SEP2P_ENUM_MSGTYPE;


/*!
 @enum CONNECT_STATUS
 @abstract the enum used to distinguish device's status, it mark all the device's status. only the device;s status is CONNECT_STATUS_CONNECTED all the sdk api interface are valid.
 @discussion .
 @constant CONNECT_STATUS_CONNECTING   means that the device's status is connecting.
 @constant CONNECT_STATUS_INITIALING   means that the device's status is initialing.
 @constant CONNECT_STATUS_ONLINE       means that the device's status is online.
 @constant CONNECT_STATUS_CONNECT_FAILED   means that the device's status is connected failed.
 @constant CONNECT_STATUS_DISCONNECT       means that the device's status is disconnected.
 @constant CONNECT_STATUS_INVALID_ID       means that the device's status is connect failed for invaild id error.
 @constant CONNECT_STATUS_DEVICE_NOT_ONLINE means that the device's status is connect failed for device is offline.
 @constant CONNECT_STATUS_CONNECT_TIMEOUT   means that the device's status is connect timeout .
 @constant CONNECT_STATUS_WRONG_USER_PWD    means that the device's status is connect failed for username or password error.
 @constant CONNECT_STATUS_INVALID_REQ       means that the device's status is connect failed for invaild request errro.
 @constant CONNECT_STATUS_EXCEED_MAX_USER   means that the device's status is connect failed for too many client connect to the same device.
 @constant CONNECT_STATUS_CONNECTED       means that the device's status is connected ok.
 @constant CONNECT_STATUS_UNKNOWN       means that the device's status is unknown.
 */
typedef enum{
	CONNECT_STATUS_CONNECTING,
	CONNECT_STATUS_INITIALING,
	CONNECT_STATUS_ONLINE,
	CONNECT_STATUS_CONNECT_FAILED,
	CONNECT_STATUS_DISCONNECT,
	CONNECT_STATUS_INVALID_ID,
	CONNECT_STATUS_DEVICE_NOT_ONLINE,
	CONNECT_STATUS_CONNECT_TIMEOUT,
	CONNECT_STATUS_WRONG_USER_PWD,

	CONNECT_STATUS_INVALID_REQ,
	CONNECT_STATUS_EXCEED_MAX_USER,		// exceed the max user
	CONNECT_STATUS_CONNECTED,

	CONNECT_STATUS_UNKNOWN	=0xFFFFFF
}CONNECT_STATUS;


/*!
 @enum CONNECT_MODE
 @abstract the enum used to distinguish the mode of device connect.
 @discussion .
 @constant CONNECT_MODE_P2P       means that the device connect mode is p2p mode.
 @constant CONNECT_MODE_RLY   means that that the device connect mode is relay mode .
 @constant CONNECT_MODE_UNKNOWN  means that the device connect mode is unknown.
 */
typedef enum{
	CONNECT_MODE_P2P,
	CONNECT_MODE_RLY,
	
	CONNECT_MODE_UNKNOWN=0x7F	//modified by juju on 20151217
}CONNECT_MODE;

/*!
 @enum ENUM_PTZ_CONTROL_CMD
 @abstract the enum used to distinguish device's ptz go directions.
 @discussion .
 @constant PTZ_CTRL_STOP  means that the device's yuntai will stop running  .
 @constant PTZ_CTRL_UP    means that the direction which device will go is up .
 @constant PTZ_CTRL_DOWN  means that the direction which device will go is down.
 @constant PTZ_CTRL_LEFT  means that the direction which device will go is left.
 @constant PTZ_CTRL_RIGHT    means that the direction which device will go is right.
 @constant PTZ_CTRL_CRUISE_H   means that the direction which device will go is horizontal patrol.
 @constant PTZ_CTRL_CRUISE_V   means that the direction which device will go is vertical patrol.
 @constant PTZ_CTRL_PRESET_BIT_SET  means that the device's some position will be set. the position value is specified by MSG_PTZ_CONTROL_REQ.nCtrlParam. the range is from 0 to 15.
 @constant PTZ_CTRL_PRESET_BIT_GOTO means that the device's some position will be go to. the position value is specified by MSG_PTZ_CONTROL_REQ.nCtrlParam. the range is from 0 to 15.
 */
typedef enum 
{
	PTZ_CTRL_STOP				=0x00,
	PTZ_CTRL_UP					=0x01,
	PTZ_CTRL_DOWN,
	PTZ_CTRL_LEFT,
	PTZ_CTRL_RIGHT,

	PTZ_CTRL_CRUISE_H			=0x30,
	PTZ_CTRL_CRUISE_V			=0x31,

	PTZ_CTRL_PRESET_BIT_SET		=0x40,
	PTZ_CTRL_PRESET_BIT_GOTO	=0x41
	//PTZ_CTRL_PRESET_BIT_CLEAR	=0x42,

}ENUM_PTZ_CONTROL_CMD;


/*!
 @enum ENUM_BIT_MASK_CAMERA_PARAM
 @abstract the enum used to distinguish the device's params information .
 @discussion .
 @constant BIT_MASK_CAM_PARAM_RESOLUTION means that MSG_SET_CAMERA_PARAM_REQ.nResolution is valid.
 @constant BIT_MASK_CAM_PARAM_BRIGHT     means that MSG_SET_CAMERA_PARAM_REQ.nBright is valid.
 @constant BIT_MASK_CAM_PARAM_CONTRAST   means that MSG_SET_CAMERA_PARAM_REQ.nContrast is valid.
 @constant BIT_MASK_CAM_PARAM_HUE       means that MSG_SET_CAMERA_PARAM_REQ.nHue is valid.
 @constant BIT_MASK_CAM_PARAM_SATURATION  means that MSG_SET_CAMERA_PARAM_REQ.nSaturation is valid.
 @constant BIT_MASK_CAM_PARAM_OSD   means that MSG_SET_CAMERA_PARAM_REQ.bOSD is valid.
 @constant BIT_MASK_CAM_PARAM_MODE  means that MSG_SET_CAMERA_PARAM_REQ.nMode is valid.
 @constant BIT_MASK_CAM_PARAM_FLIP  means that MSG_SET_CAMERA_PARAM_REQ.nFlip is valid.
 @constant BIT_MASK_CAM_PARAM_IRLED means that MSG_SET_CAMERA_PARAM_REQ.nIRLed is valid.
 */
typedef enum
{
	BIT_MASK_CAM_PARAM_RESOLUTION =0x01,
	BIT_MASK_CAM_PARAM_BRIGHT	  =0x02,
	BIT_MASK_CAM_PARAM_CONTRAST	  =0x04,
	BIT_MASK_CAM_PARAM_HUE		  =0x08,
    
	BIT_MASK_CAM_PARAM_SATURATION =0x10,
	BIT_MASK_CAM_PARAM_OSD		  =0x20,
	BIT_MASK_CAM_PARAM_MODE		  =0x40,
	BIT_MASK_CAM_PARAM_FLIP		  =0x80,
	BIT_MASK_CAM_PARAM_IRLED	  =0x0100
}ENUM_BIT_MASK_CAMERA_PARAM;


///////////////////////////////////////////////////////////////////////////////////////
//         Struct define
//
///////////////////////////////////////////////////////////////////////////////////////

// SEP2P_MSG_QUERY_CHANNEL_INFO_OF_NVR_REQ
typedef  struct tag_MSG_QUERY_CHANNEL_INFO_OF_NVR_REQ
{
	UCHAR nChannel;     //[0, MAX_CHANNEL);  0xFF:query all channel information
	CHAR  reserve[15];
}MSG_QUERY_CHANNEL_INFO_OF_NVR_REQ;

typedef struct tag_CHANNEL_INFO_OF_NVR
{
	CHAR  bExistDevice;	  //1:exist; 0:not
	UCHAR chResoIndex[7]; //it's value refer to SEP_ENUM_VIDEO_RESO; resolution index save at chResoIndex[0],chResoIndex[1]... from small to large order. the value 0xFF is over.
	CHAR  reserve[8];
}CHANNEL_INFO_OF_NVR;
//  SEP2P_MSG_QUERY_CHANNEL_INFO_OF_NVR_RESP
typedef  struct tag_MSG_QUERY_CHANNEL_INFO_OF_NVR_RESP
{
	CHAR  result;	//=0 OK; 1:invalid channel no
	CHAR  reserve[2];
	UCHAR nChannel; //=MSG_QUERY_CHANNEL_INFO_OF_NVR_REQ.nChannel
	INT32 nChannelNum; //the value of nChannelNum consistent with the number of array CHANNEL_INFO_OF_NVR[x] below. 
	//CHANNEL_INFO_OF_NVR[0]
	//CHANNEL_INFO_OF_NVR[1]
	//......

}MSG_QUERY_CHANNEL_INFO_OF_NVR_RESP;


/*!
 @struct MSG_CONNECT_STATUS
 @abstract MSG_CONNECT_STATUS define the device's connect status information .
 @discussion .
 @field eConnectStatus type: CONNECT_STATUS ; means: the enum CONNECT_STATUS contain all status of device, refer to  the define of CONNECT_STATUS .
 @field reserve type: CHAR* ; means: no used, prepared for future use .
 */
 //SEP2P_MSG_CONNECT_STATUS
typedef  struct tag_MSG_CONNECT_STATUS
{
	CONNECT_STATUS eConnectStatus;
	INT32  eConnectMode;			 // refer to CONNECT_MODE
	struct sockaddr_in stRemoteAddr; // Remote site IP:Port
	struct sockaddr_in stMyLocalAddr;// My Local site IP:Port
	struct sockaddr_in stMyWanAddr;	 // My WAN site IP:Port
	CHAR  reserve[8];
}MSG_CONNECT_STATUS;


/*!
 @struct MSG_START_VIDEO
 @abstract MSG_START_VIDEO define the start video stream request data information. when you want to start video stream ,you should pass the struct as a param. the request message type: SEP2P_MSG_START_VIDEO .
 @discussion .
 @field nVideoCodecID type: INT32 ; means:the stream type, refer to SEP2P_ENUM_AV_CODECID .
 @field eVideoReso type: SEP2P_ENUM_VIDEO_RESO ; means: the video quality, refer to the define of enum SEP2P_ENUM_VIDEO_RESO.But its value is specified by AV_PARAMETER.nVideoParameter of SEP2P_GetAVParameterSupported(...).
 */
 //SEP2P_MSG_START_VIDEO
typedef  struct tag_MSG_START_VIDEO
{
	INT32 nVideoCodecID; //refer to SEP2P_ENUM_AV_CODECID
	SEP2P_ENUM_VIDEO_RESO eVideoReso;
	UCHAR nChannel;
	CHAR  reserve[7];
}MSG_START_VIDEO;

/*!
 @struct MSG_STOP_VIDEO
 @abstract MSG_STOP_VIDEO define the stop video command send data information,the request message type: SEP2P_MSG_STOP_VIDEO .
 @discussion .
 @field reserve type: CHAR* ; means:  no used , prepared for future use .
 */
 //SEP2P_MSG_STOP_VIDEO
typedef  struct tag_MSG_STOP_VIDEO
{
	UCHAR nChannel;
	CHAR  reserve[15];
}MSG_STOP_VIDEO;


/*!
 @struct MSG_START_AUDIO
 @abstract MSG_START_AUDIO define the start audio stream request data information. when you want to start audio stream ,you should pass the struct as a param. the request message type: SEP2P_MSG_START_AUDIO .
 @discussion .
 @field nAudioCodecID type:INT32  ; means:define the audio stream type, you can refer to SEP2P_ENUM_AV_CODECID .
 @field reserve type: CHAR* ; means: no used , prepared for future use .
 */
 //SEP2P_MSG_START_AUDIO
typedef  struct tag_MSG_START_AUDIO
{
	INT32 nAudioCodecID; //refer to SEP2P_ENUM_AV_CODECID
	UCHAR nChannel;
	CHAR  reserve[11];
}MSG_START_AUDIO;


/*!
 @struct MSG_STOP_AUDIO
 @abstract MSG_STOP_AUDIO define the stop audio command send data information,the request message type: SEP2P_MSG_STOP_AUDIO .
 @discussion .
 @field reserve type: CHAR* ; means: no used , prepared for future use .
 */
 //SEP2P_MSG_STOP_AUDIO
typedef  struct tag_MSG_STOP_AUDIO
{
	UCHAR nChannel;
	CHAR  reserve[15];
}MSG_STOP_AUDIO;


/*!
 @struct MSG_START_TALK
 @abstract MSG_START_TALK define the start talk command send data information,the request message type: SEP2P_MSG_START_TALK.
 @discussion .
 @field reserve type: CHAR* ; means: no used , prepared for future use .
 */
 //SEP2P_MSG_START_TALK
typedef  struct tag_MSG_START_TALK
{
	UCHAR nChannel;
	CHAR  reserve[15];
}MSG_START_TALK;

/*!
 @struct MSG_START_TALK_RESP
 @abstract MSG_START_TALK_RESP the struct define the start talk returned result. you can determine the  operator success or failure by field result. if the result = 0, it's means that set  successfully, else if result = 1 it's means that someone is using the talk channel, you should wait for it's free. if result = 2 mean open talk channel failed, some error happened..
 @discussion .
 @field result type: CHAR ; means: the start talk request response result.if the result = 0, it's means that set  successfully, else if result = 1 it's means that someone is using the talk channel, you should wait for it's free. if result = 2 mean open talk channel failed, some error happened .
 @field reserve type: CHAR* ; means: no used , prepared for future use .
 */
 //SEP2P_MSG_START_TALK_RESP
typedef  struct tag_MSG_START_TALK_RESP
{
	CHAR  result;	//=0 OK; 1:talking; 2:unknown error
	UCHAR nChannel;
	CHAR  reserve[14];
}MSG_START_TALK_RESP;

/*!
 @struct MSG_STOP_TALK
 @abstract MSG_STOP_TALK define the stop talk command send data information,the request message type: SEP2P_MSG_STOP_TALK.
 @discussion .
 @field reserve type: CHAR* ; means: no used , prepared for future use .
 */
 //SEP2P_MSG_STOP_TALK
typedef  struct tag_MSG_STOP_TALK
{
	UCHAR nChannel;
	CHAR  reserve[15];
}MSG_STOP_TALK;


/*!
 @struct MSG_GET_CAMERA_PARAM_REQ
 @abstract  MSG_GET_CAMERA_PARAM_REQ define the get camera param request packet data information.the request message type: SEP2P_MSG_GET_CAMERA_PARAM_REQ, you can get the response result in message call back function by message type :SEP2P_MSG_GET_CAMERA_PARAM_RESP .
 @discussion .
 @field reserve type: CHAR* ; means: no used , prepared for future use.
 */
 //SEP2P_MSG_GET_CAMERA_PARAM_REQ
typedef struct tag_MSG_GET_CAMERA_PARAM_REQ
{
	CHAR  reserve[16];
}MSG_GET_CAMERA_PARAM_REQ;

/*!
 @struct MSG_GET_CAMERA_PARAM_RESP
 @abstract  MSG_GET_CAMERA_PARAM_RESP define the response result after you send SEP2P_MSG_GET_CAMERA_PARAM_REQ command..
 @discussion .
 @field nResolution type: INT32 ; means: The resolution of the device, refer to SEP2P_ENUM_VIDEO_RESO.Get resolution index supported by SEP2P_GetAVParameterSupported(...)
 @field nBright type: INT32 ; means: the device's bright value, numerical range [0,255] .
 @field nContrast type: INT32 ; means: the device's contrast value, numerical range [0,7] .
 @field reserve1 type: INT32 ; means: no use .
 @field nSaturation type: INT32 ; means: the device's saturation value, numerical range [0,255] .
 @field bOSD type: INT32 ; means:whether the osd is enable,0->disable, 1->enable.
 @field nMode type: INT32 ; means: the device's video mode,0->50Hz, 1->60Hz.
 @field nFlip type: INT32 ; means: the device's mirror flip,0->normal, 1->flip, 2->mirror, 3->flip & mirror.
 @field reserve2 type: CHAR* ; means: no used , prepared for future use. .
 @field nIRLed type: CHAR ; means:0->close, 1->open, 2->auto . support getting its value when FirmwareVer>=0.1.0.18 for M Series
 @field reserve3 type: CHAR* ; means: no used , prepared for future use.
 */
 //SEP2P_MSG_GET_CAMERA_PARAM_RESP
typedef struct tag_MSG_GET_CAMERA_PARAM_RESP
{
	INT32 nResolution;	//refer to SEP2P_ENUM_VIDEO_RESO. 0->160*120, 1->320*240, 2->640*480, 3->640*360, 4->1280*720, 5->1280*960, 6->1920*1080
	INT32 nBright;		//[0,255]
	INT32 nContrast;	//[0,255]
	INT32 reserve1;
	INT32 nSaturation;	//[0,255]
	INT32 bOSD;			//CHAR* pBytOSD=(CHAR *)&bOSD;   pBytOSD[0],time OSD: 0->disable,1->enable;  pBytOSD[1],name OSD: 0->disable,1->enable;  //No this item to L series;
	INT32 nMode;		//0->50Hz, 1->60Hz
	INT32 nFlip;		//0->normal, 1->flip, 2->mirror, 3->flip & mirror
	CHAR  reserve2[8];
	CHAR  nIRLed;		//0->close, 1->open, 2->auto //support getting its value when FirmwareVer>=0.1.0.18 for only M Series
	CHAR  reserve3[15];
}MSG_GET_CAMERA_PARAM_RESP, *PMSG_GET_CAMERA_PARAM_RESP;


/*!
 @struct MSG_SET_CAMERA_PARAM_REQ
 @abstract  MSG_SET_CAMERA_PARAM_REQ define set camera param request data information. the send message type :SEP2P_MSG_SET_CAMERA_PARAM_REQ, the response message type: SEP2P_MSG_SET_CAMERA_PARAM_RESP..
 @discussion .
 @field nResolution type: INT32 ; means: the device's resolution, refer to SEP2P_ENUM_VIDEO_RESO.Get resolution index supported by SEP2P_GetAVParameterSupported(...).There is VGA(nResolution=2) and QVGA(nResolution=1) for L series. There is 720P(nResolution=4),VGA(nResolution=2),QVGA(nResolution=1) for M series;
 @field nBright type: INT32 ; means: the device's bright value, numerical range [0,255] .
 @field nContrast type: INT32 ; means: the device's contrast value, numerical range [0,255] .
 @field reserve1 type: INT32 ; means: no used.
 @field nSaturation type: INT32 ; means: the device's saturation value, numerical range [0,255] .
 @field bOSD type: INT32 ; means:whether the osd is enable,0->disable, 1->enable .
 @field nMode type: INT32 ; means: the device's video mode,0->50Hz, 1->60Hz. NOTES:the device will reboot when setting for M series
 @field nFlip type: INT32 ; means: the device's mirror flip,0->normal, 1->mirror, 2->flip, 3->mirror & flip .
 @field reserve1 type: CHAR* ; means: no used , prepared for future use. .
 @field nIRLed type: CHAR ; means:0->close, 1->open, 2->auto .
 @field reserve2 type: CHAR* ; means: no used , prepared for future use. .
 @field nBitMaskToSet type: INT32 ; means: refer to ENUM_BIT_MASK_CAMERA_PARAM,(Bit0:=1->set resolution; Bit1:=1->set bright; Bit2:=1->set contrast; Bit3:=1->set hue; Bit4:=1->set saturation; Bit5:=1->set OSD;	 Bit6:=1->set mode;		Bit7:=1->set flip; Bit8:=1->set infrared led) .

 */
 //SEP2P_MSG_SET_CAMERA_PARAM_REQ
typedef struct tag_MSG_SET_CAMERA_PARAM_REQ
{
	INT32 nResolution;	//0->160*120, 1->320*240, 2->640*480, 3->640*360, 4->1280*720, 5->1280*960, 6->1920*1080
	INT32 nBright;		//[0,255]
	INT32 nContrast;	//[0,255]
	INT32 reserve1;
	INT32 nSaturation;	//[0,255]
	INT32 bOSD;			//CHAR* pBytOSD=(CHAR *)&bOSD;   pBytOSD[0],time OSD: 0->disable,1->enable;  pBytOSD[1],name OSD: 0->disable,1->enable;  //No this item to L series;
	INT32 nMode;		//0->50Hz,1->60Hz; NOTES:the device will reboot when setting for M series
	INT32 nFlip;		//0->normal, 1->flip, 2->mirror, 3->flip & mirror
	CHAR  reserve2[8];
	CHAR  nIRLed;		//0->close, 1->open, 2->auto
	CHAR  reserve3[11];
	INT32 nBitMaskToSet; //refer to ENUM_BIT_MASK_CAMERA_PARAM
						 //Bit0:=1->set resolution; Bit1:=1->set bright; Bit2:=1->set contrast; Bit3:=1->set hue;
						 //Bit4:=1->set saturation; Bit5:=1->set OSD;	 Bit6:=1->set mode;		Bit7:=1->set flip; Bit8:=1->set infrared led
}MSG_SET_CAMERA_PARAM_REQ;

/*!
 @struct MSG_SET_CAMERA_PARAM_RESP
 @abstract MSG_SET_CAMERA_PARAM_RESP the struct define the Set device's camera params information returned result. you can determine the  operator success or failure by field result. if the result = 0, it's means that set  successfully, otherwise failure..
 @discussion .
 @field result type: CHAR ; means: if the result = 0, it's means that set  successfully, otherwise failure .
 @field reserve type: CHAR* ; means: no used , prepared for future use .
 @field nBitMaskToSet type:  ; means: refer to ENUM_BIT_MASK_CAMERA_PARAM,(Bit0:=1->set resolution; Bit1:=1->set bright; Bit2:=1->set contrast; Bit3:=1->set hue; Bit4:=1->set saturation; Bit5:=1->set OSD;	 Bit6:=1->set mode;		Bit7:=1->set flip; Bit8:=1->set infrared led) .
 */
 //SEP2P_MSG_SET_CAMERA_PARAM_RESP
typedef struct tag_MSG_SET_CAMERA_PARAM_RESP
{
	CHAR  result;	//0: OK; or not fail
	CHAR  reserve[11];
	INT32 nBitMaskToSet;
}MSG_SET_CAMERA_PARAM_RESP;

/*!
 @struct MSG_SET_CAMERA_PARAM_DEFAULT_REQ
 @abstract MSG_SET_CAMERA_PARAM_DEFAULT_REQ define the set camera default param command request data. (the send message type: SEP2P_MSG_SET_CAMERA_PARAM_DEFAULT_REQ, the response message type: SEP2P_MSG_SET_CAMERA_PARAM_DEFAULT_RESP).
 @discussion .
 @field reserve type: CHAR* ; means: no used , prepared for future use .
 */
 //SEP2P_MSG_SET_CAMERA_PARAM_DEFAULT_REQ
typedef struct tag_MSG_SET_CAMERA_PARAM_DEFAULT_REQ //Change brightness and contrast to default value, no flip and no mirror
{
	CHAR  reserve[16];
}MSG_SET_CAMERA_PARAM_DEFAULT_REQ;

/*!
 @struct MSG_SET_CAMERA_PARAM_DEFAULT_RESP
 @abstract  MSG_SET_CAMERA_PARAM_DEFAULT_RESP the struct define the Set device's default params information returned result. you can determine the  operator success or failure by field result. if the result = 0, it's means that set  successfully, otherwise failure..
 @discussion .
 @field result type: CHAR ; means:if the result = 0, it's means that set successfully, otherwise failure .
 @field reserve type: CHAR* ; means: no used , prepared for future use .
 */
 //SEP2P_MSG_SET_CAMERA_PARAM_DEFAULT_RESP
typedef struct tag_MSG_SET_CAMERA_PARAM_DEFAULT_RESP
{
	CHAR  result;	//0: OK; or not fail
	CHAR  reserve[15];
}MSG_SET_CAMERA_PARAM_DEFAULT_RESP;

/*!
 @struct MSG_PTZ_CONTROL_REQ
 @abstract  MSG_PTZ_CONTROL_REQ define the set ptz control command requesst data information. you use it control the device's ptz. (the send message type: SEP2P_MSG_PTZ_CONTROL_REQ, the response message type: SEP2P_MSG_PTZ_CONTROL_RESP) .
 @discussion .
 @field nCtrlCmd type: UCHAR ; means:ptz command type, TZ control command, refer to ENUM_PTZ_CONTROL_CMD .
 @field nCtrlParam type: UCHAR ; means:for PTZ_CTRL_PRESET_BIT_...: nCtrlParam is SET/GOTO/CLEAR preset bit no. range is [0,15] .
 @field reserve type: CHAR* ; means: no used , prepared for future use .
 */
 //SEP2P_MSG_PTZ_CONTROL_REQ
typedef struct tag_MSG_PTZ_CONTROL_REQ
{
	UCHAR nCtrlCmd;		// PTZ control command, refer to ENUM_PTZ_CONTROL_CMD
	UCHAR nCtrlParam;	// for PTZ_CTRL_PRESET_BIT_...: nCtrlParam is SET/GOTO/CLEAR preset bit no. range is [0,15]
						// for PTZ_CTRL_UP, PTZ_CTRL_DOWN, PTZ_CTRL_LEFT, PTZ_CTRL_RIGHT: 1=continue after one step; 0=one step
	UCHAR nChannel;
	CHAR  reserve[13];
}MSG_PTZ_CONTROL_REQ;

/*!
 @struct MSG_PTZ_CONTROL_RESP
 @abstract MSG_PTZ_CONTROL_RESP the struct define the Set device's PTZ information returned result. you can determine the  operator success or failure by field result. if the result = 0, it's means that set  successfully, otherwise failure..
 @discussion .
 @field result type: CHAR ; means:if the result = 0, it's means that set  successfully, otherwise failure .
 @field reserve type: CHAR* ; means: no used , prepared for future use .
 */
 //SEP2P_MSG_PTZ_CONTROL_RESP
typedef struct tag_MSG_PTZ_CONTROL_RESP
{
	CHAR  result;	//0: OK; or not fail
	UCHAR nChannel;
	CHAR  reserve[14];
}MSG_PTZ_CONTROL_RESP;


/*!
 @struct MSG_SNAP_PICTURE_REQ
 @abstract MSG_SNAP_PICTURE_REQ define the snap picture command request data information. (the send message type :SEP2P_MSG_SNAP_PICTURE_REQ , the response message type: SEP2P_MSG_SNAP_PICTURE_RESP) You can use the snap one picture from device..
 @discussion .
 @field reserve type: CHAR* ; means: no used , prepared for future use .
 */
 //SEP2P_MSG_SNAP_PICTURE_REQ
typedef struct tag_MSG_SNAP_PICTURE_REQ
{
	CHAR  reserve[16];
}MSG_SNAP_PICTURE_REQ;

//SEP2P_MSG_SNAP_PICTURE_RESP
//typedef INT32 (* POnRecvMsgCallback)(CHAR*   pDID, UINT32  nMsgType, CHAR* pMsg, UINT32  nMsgSize, VOID* pUserData);
//nMsgType=SEP2P_MSG_SNAP_PICTURE_RESP
//pMsg	  =jpg data snapshoted
//nMsgSize=the size of jpg data snapshoted

/*!
 @struct MSG_GET_CURRENT_WIFI_REQ
 @abstract MSG_GET_CURRENT_WIFI_REQ define the get device's Wi-Fi command to request data information.(send message type: SEP2P_MSG_GET_CURRENT_WIFI_REQ, response message type: SEP2P_MSG_GET_CURRENT_WIFI_RESP).
 @discussion .
 @field reserve type:CHAR*  ; means: no used , prepared for future use.
 */
 //SEP2P_MSG_GET_CURRENT_WIFI_REQ
typedef struct tag_MSG_GET_CURRENT_WIFI_REQ
{
	CHAR  reserve[16];
}MSG_GET_CURRENT_WIFI_REQ;

/*!
 @struct MSG_GET_CURRENT_WIFI_RESP
 @abstract MSG_GET_CURRENT_WIFI_RESP define the Wi-Fi information that get Wi-Fi command returned result..
 @discussion .
 @field bEnable type: INT32 ; means: disable the Wi-Fi if its value is 0. Otherwise, enable the Wi-Fi.
 @field chSSID type: CHAR* ; means: the SSID name of the Wi-Fi using by the device.
 @field reserve type:  INT32; means: no use.
 @field nMode type: INT32 ; means: infrastructure mode if its value is 0. ad-hoc mode if 1 
 @field nAuthtype type:  INT32; means: Wi-Fi security authentication type.these items below:0 is WEP-NONE; 1 is WEP; 2 is WPA-PSK-AES; 3 is WPA-PSK-TKIP; 4 is WPA2-PSK-AES; 5 is WPA2-PSK-TKIP
 @field nWEPEncrypt type:  INT32; means: valid if authentication type is WEP.It is authentication type for WEP.The zero value is open system,one is share key.
 @field nWEPKeyFormat type: INT32 ; means: valid if authentication type is WEP.It is the key value format. The zero value is hexadecimal number,one is ASCII character.
 @field nWEPDefaultKey type: INT32 ; means: valid if authentication type is WEP.It is the index of default key value from the first to the fourth key value. the first key value is default if 0, and so on.
 @field chWEPKey1 type: CHAR* ; means: valid if authentication type is WEP.It is the first key value for WEP type.
 @field chWEPKey2 type: CHAR* ; means: valid if authentication type is WEP.It is the second key value for WEP type.
 @field chWEPKey3 type: CHAR*  ; means: valid if authentication type is WEP.It is the third key value for WEP type.
 @field chWEPKey4 type: CHAR* ; means: valid if authentication type is WEP.It is the fourth key value for WEP type.
 @field nWEPKey1_bits type:  INT32; means: valid if authentication type is WEP.The zero value is 64 bits,one is 128 bits for WEP key1.
 @field nWEPKey2_bits type:  INT32; means: valid if authentication type is WEP.The zero value is 64 bits,one is 128 bits for WEP key2.
 @field nWEPKey3_bits type:  INT32; means: valid if authentication type is WEP.The zero value is 64 bits,one is 128 bits for WEP key3.
 @field nWEPKey4_bits type:  INT32; means: valid if authentication type is WEP.The zero value is 64 bits,one is 128 bits for WEP key4.
 @field chWPAPsk type: CHAR* ; means: valid if authentication type is WPA. Pre-Shared Key for WPA authentication type
 */
 //SEP2P_MSG_GET_CURRENT_WIFI_RESP
typedef struct tag_MSG_GET_CURRENT_WIFI_RESP
{
	INT32  bEnable;     //0->disable Wi-Fi, 1->enable Wi-Fi
	CHAR   chSSID[128]; //WiFi SSID name
	UCHAR  nChannel;	//no use
	CHAR   bReqTestWifiResult; //0->don't request testing wifi result; 1->request
	CHAR   reserve[2];
	INT32  nMode;	    //0->infra; 1->adhoc; 2->SoftAP
	INT32  nAuthtype;   //0->WEP-NONE; 1->WEP; 2->WPA-PSK AES; 3->WPA-PSK TKIP; 4->WPA2-PSK AES; 5->WPA2-PSK TKIP
	INT32  nWEPEncrypt;	   //WEP: 0->open; 1->share key 
	INT32  nWEPKeyFormat;  //WEP: 0->hexadecimal number; 1->ASCII Character
	INT32  nWEPDefaultKey; //WEP: [0,3]
	CHAR   chWEPKey1[128]; //WEP: WEP key1
	CHAR   chWEPKey2[128]; //WEP: WEP key2 
	CHAR   chWEPKey3[128]; //WEP: WEP key3
	CHAR   chWEPKey4[128]; //WEP: WEP key4
	INT32  nWEPKey1_bits;  //WEP: 0->64bits, 1->128bits for WEP key1
	INT32  nWEPKey2_bits;  //WEP: 0->64bits, 1->128bits for WEP key2
	INT32  nWEPKey3_bits;  //WEP: 0->64bits, 1->128bits for WEP key3
	INT32  nWEPKey4_bits;  //WEP: 0->64bits, 1->128bits for WEP key4
	CHAR   chWPAPsk[128];  //WPA: share key
}MSG_GET_CURRENT_WIFI_RESP, *PMSG_GET_CURRENT_WIFI_RESP;

//SEP2P_MSG_SET_CURRENT_WIFI_REQ
typedef MSG_GET_CURRENT_WIFI_RESP MSG_SET_CURRENT_WIFI_REQ; //L: the device will reboot after completing settings

/*!
 @struct MSG_SET_CURRENT_WIFI_RESP
 @abstract MSG_SET_CURRENT_WIFI_RESP the struct define the Set device's current Wi-Fi information returned result. you can determine the operator success or failure by field result. if the result = 0, it's means that set  successfully, otherwise failure..
 @discussion .
 @field result type:CHAR  ; means: if the result = 0, it's means that set  successfully, otherwise failure .
 @field reserve type:CHAR*  ; means: no used , prepared for future use .
 */
 //SEP2P_MSG_SET_CURRENT_WIFI_RESP
typedef struct tag_MSG_SET_CURRENT_WIFI_RESP
{
	CHAR  result;	//0: OK; or not fail
	CHAR  reserve[15];
}MSG_SET_CURRENT_WIFI_RESP;


/*!
 @struct MSG_GET_WIFI_LIST_REQ
 @abstract MSG_GET_WIFI_LIST_REQ define the get Wi-Fi list command request data information.(Request message type: SEP2P_MSG_GET_WIFI_LIST_REQ ; Response messaget type: SEP2P_MSG_GET_WIFI_LIST_RESP).
 @discussion .
 @field reserve type:CHAR*  ; means: no used , prepared for future use .
 */
 //SEP2P_MSG_GET_WIFI_LIST_REQ
typedef struct tag_MSG_GET_WIFI_LIST_REQ
{
	CHAR  reserve[16];
}MSG_GET_WIFI_LIST_REQ;

/*!
 @struct SEP2P_RESULT_WIFI_INFO
 @abstract SEP2P_RESULT_WIFI_INFO Wi-Fi information .The struct define the one Wi-Fi information.
 @discussion .
 @field chSSID char;Wi-Fi's name .
 @field chMAC char; Wi-Fi's mac address .
 @field nAuthtype int; Wi-Fi security authentication type.these items below:0 is WEP-NONE; 1 is WEP; 2 is WPA-PSK-AES; 3 is WPA-PSK-TKIP; 4 is WPA2-PSK-AES; 5 is WPA2-PSK-TKIP
 @field dbm0 char;	Wi-Fi sign level. It is a numerator of percent.
 @field dbm1 char;	It is a percent, always 100.
 @field nMode int;	infrastructure mode if its value is 0. ad-hoc mode if 1.
 @field reserve int; prepared for future use.
 */
typedef struct tag_SEP2P_RESULT_WIFI_INFO
{
    CHAR   chSSID[64]; //Wi-Fi SSID name
    CHAR   chMAC[64];
    INT32  nAuthtype;//0->WEP-NONE, 1->WEP, 2->WPA-PSK AES, 3->WPA-PSK TKIP, 4->WPA2-PSK AES, 5->WPA2-PSK TKIP
    
    CHAR   dbm0[32];//'80' sign level.
    CHAR   dbm1[32];//'100'percent. it is always 100.
    INT32  nMode;	//0->infra 1->adhoc
    INT32  reserve;
}SEP2P_RESULT_WIFI_INFO,*PSEP2P_RESULT_WIFI_INFO;

/*!
 @struct MSG_GET_WIFI_LIST_RESP
 @abstract MSG_GET_WIFI_LIST_RESP Wi-Fi list information .The struct define the response data information that send a get Wi-Fi list command request returned .
 @discussion .
 @field nResultCount int nResultCount the list contain Wi-Fi informations number .
 @field wifi SEP2P_RESULT_WIFI_INFO wifi[50] RESULT_WIFI_INFO Wi-Fi information you can find the define in SEP2P_RESULT_WIFI_INFO .
 */
 //SEP2P_MSG_GET_WIFI_LIST_RESP
typedef struct tag_MSG_GET_WIFI_LIST_RESP
{
    INT32 nResultCount;
    SEP2P_RESULT_WIFI_INFO wifi[50];
}MSG_GET_WIFI_LIST_RESP, *PMSG_GET_WIFI_LIST_RESP;


/*!
 @struct MSG_GET_USER_INFO_REQ
 @abstract MSG_GET_USER_INFO_REQ define the get user information rquest data struct. (Request message type: SEP2P_MSG_GET_USER_INFO_REQ; Response message tyep:SEP2P_MSG_GET_USER_INFO_RESP).
 @discussion .
  @field reserve type:CHAR*  ; means: no used, prepared for future use.
 */
 //SEP2P_MSG_GET_USER_INFO_REQ
typedef struct tag_MSG_GET_USER_INFO_REQ
{
	CHAR  reserve[16];
}MSG_GET_USER_INFO_REQ;

/*!
 @struct MSG_GET_USER_INFO_RESP
 @abstract MSG_GET_USER_INFO_REQ define the get user information rquest data struct. (Request message type: SEP2P_MSG_GET_USER_INFO_REQ; Response message tyep:SEP2P_MSG_GET_USER_INFO_RESP) .
 @discussion The chVisitor or chAdmin can NOT be empty when setting.Otherwise SEP2P_SendMsg return ERR_SEP2P_INVALID_PARAMETER.
 @field chVisitor type:CHAR*  ; means: the visitor's name .
 @field chVisitorPwd type:CHAR*  ; means: the visitor's password .
 @field reserve type:CHAR*  ; means: no used, prepared for future use.
 @field chAdmin type:CHAR*  ; means: the admin's name .
 @field chAdminPwd type:CHAR*  ; means: the admin's password .
 */
 //SEP2P_MSG_GET_USER_INFO_RESP
typedef struct tag_MSG_GET_USER_INFO_RESP
{
	CHAR chVisitor[64]; //visitor
	CHAR chVisitorPwd[64];
	CHAR chCurUser[64]; //for X series, 2015-04-16
	CHAR chCurUserPwd[64];
	CHAR chAdmin[64];	//admin
	CHAR chAdminPwd[64];
	CHAR nCurUserRoleID;//only get it for X series, 2015-04-16
	CHAR reserve[7];
}MSG_GET_USER_INFO_RESP, *PMSG_GET_USER_INFO_RESP;

//SEP2P_MSG_SET_USER_INFO_REQ
typedef MSG_GET_USER_INFO_RESP MSG_SET_USER_INFO_REQ;

/*!
 @struct MSG_SET_USER_INFO_RESP
 @abstract MSG_SET_USER_INFO_RESP the struct define the Set device's user information returned result. you can determine the  operator success or failure by field result. if the result = 0, it's means that set  successfully, otherwise failure..
 @discussion .
 @field result type:CHAR  ; means: the set user information result (0: OK; or not fail).
 @field reserve type:CHAR*  ; means: no used , prepared for future use.
 */
 //SEP2P_MSG_SET_USER_INFO_RESP
typedef struct tag_MSG_SET_USER_INFO_RESP
{
	CHAR  result;	//0: OK; or not fail
	CHAR  reserve[15];
}MSG_SET_USER_INFO_RESP;

/*!
 @struct MSG_GET_DATETIME_REQ
 @abstract MSG_GET_DATETIME_REQ define the struct that send a get datetime command need..(Request message type: MSG_GET_DATETIME_REQ; Response messge type:MSG_GET_DATETIME_RESP ).
 @discussion .
 @field reserve type:CHAR*  ; means: no used , prepared for future use .
 */
 //SEP2P_MSG_GET_DATETIME_REQ
typedef struct tag_MSG_GET_DATETIME_REQ
{
	CHAR  reserve[16];
}MSG_GET_DATETIME_REQ;

/*!
 @struct MSG_GET_DATETIME_RESP
 @abstract MSG_GET_DATETIME_RESP define the struct that the response of send a get datetime command..
 @discussion The current device timezone supported is:
 {"Pacific/Apia",		GMT-11.00},
 {"Pacific/Honolulu",	GMT-10.00},
 {"America/Anchorage",	GMT-09.00},
 {"America/Los_Angeles",GMT-08.00},
 {"America/Denver",	    GMT-07.00},
 {"America/Chicago",	GMT-06.00},
 {"America/New_York",	GMT-05.00},
 {"America/Montreal",	GMT-04.00},
 {"America/St_Johns",	GMT-03.30},
 {"America/Thule",	    GMT-03.00},
 {"Atlantic/South_Georgia",	GMT-02.00},
 {"Atlantic/Cape_Verde",	GMT-01.00},
 {"Europe/Dublin",			GMT00.00},
 {"Europe/Brussels",	    GMT01.00},
 {"Europe/Athens",			GMT02.00},
 {"Asia/Kuwait",		    GMT03.00},
 {"Asia/Tehran",		    GMT03.30},
 {"Asia/Baku",		    GMT+04.00},
 {"Asia/Kabul",		    GMT+04.30},
 {"Asia/Karachi",		GMT+05.00},
 {"Asia/Calcutta",	    GMT+05.30},
 {"Asia/Almaty",		GMT+6.00},
 {"Asia/Bangkok",		GMT+7.00},
 {"Asia/Hong_Kong",	    GMT+8.00},
 {"Asia/Tokyo",		    GMT+9.00},
 {"Australia/Adelaide",	GMT+9.30},
 {"Pacific/Guam",		GMT+10.00},
 {"Asia/Magadan",		GMT+11.00},
 {"Pacific/Auckland",   GMT+12.00}.

 NTP server suggested is:
 time.windows.com
 time.nist.gov
 time.kriss.re.kr
 time.nuri.net
 @field nSecToNow type: INT32 ; means: the second number elapsed from 1970-01-01 0:0:0 to now at the zero timezone when getting. To MSG_SET_DATETIME_REQ: it used to calibrate the device if its value is NOT zero.
 @field nSecTimeZone type: INT32 ; means: time interval from GMT in second.e.g.:28800 seconds is GMT+08; -28800 seconds is GMT-08.
 @field bEnableNTP type:  INT32; means: whether the NTP(Network Time Protocol) is enable 1: enable , 0: disable .
 @field chNTPServer type:CHAR*  ; means: the NTP server domain.
 */
 //SEP2P_MSG_GET_DATETIME_RESP
typedef struct tag_MSG_GET_DATETIME_RESP
{
	INT32 nSecToNow;		//[date timeIntervalSince1970], To MSG_SET_DATETIME_REQ: it used to calibrate the device time if its value is NOT zero.
	INT32 nSecTimeZone;		//time interval from GMT in second, e.g.:28800 seconds is GMT+08; -28800 seconds is GMT-08
	INT32 bEnableNTP;		//0->disable; 1->enable
	CHAR  chNTPServer[64];	
	INT32 nIndexTimeZoneTable;//-1: invalid; >=0: ok//added on 2014-11-17, for x series
}MSG_GET_DATETIME_RESP,*PMSG_GET_DATETIME_RESP;


//SEP2P_MSG_SET_DATETIME_REQ
typedef MSG_GET_DATETIME_RESP MSG_SET_DATETIME_REQ;

/*!
 @struct MSG_SET_DATETIME_RESP
 @abstract MSG_SET_DATETIME_RESP the struct define the Set device's datetime information returned result. you can determine the  operator success or failure by field result. if the result = 0, it's means that set  successfully, otherwise failure.
 @discussion .
 @field result type:CHAR  ; means: the set result. if the result is 0, it's means that set successfully, otherwise failure.
 @field reserve type:CHAR*  ; means: no used , prepared for future use.
 */
 //SEP2P_MSG_SET_DATETIME_RESP
typedef struct tag_MSG_SET_DATETIME_RESP
{
	CHAR  result;	//0: OK; or not fail
	CHAR  reserve[15];
}MSG_SET_DATETIME_RESP;

/*!
 @struct MSG_GET_FTP_INFO_REQ
 @abstract MSG_GET_FTP_INFO_REQ define the struct that send a get ftp information command request need (send message type: MSG_GET_FTP_INFO_REQ; response message type:  MSG_GET_FTP_INFO_RESP)..
 @discussion .
 @field reserve type:CHAR*  ; means: no used , prepared for future use .
 */
 //SEP2P_MSG_GET_FTP_INFO_REQ
typedef struct tag_MSG_GET_FTP_INFO_REQ
{
	CHAR  reserve[16];
}MSG_GET_FTP_INFO_REQ;

/*!
 @struct MSG_GET_FTP_INFO_RESP
 @abstract MSG_GET_FTP_INFO_RESP the struct define the get FTP information returned result (send message type: MSG_GET_FTP_INFO_REQ; response message type:  MSG_GET_EMAIL_INFO_RESP).
 @discussion .
 @field chFTPSvr type:CHAR*  ; means: The ftp server.
 @field chUser type:CHAR*  ; means: The username in ftp server.
 @field chPwd type:CHAR*  ; means: The password in ftp server.
 @field chDir type:CHAR*  ; means: The ftp path that you want to save your files.
 @field nPort type:INT32  ; means: The ftp server port.
 @field nMode type:INT32  ; means: The ftp connect mode (0:port mode 1:passive mode).
 @field reserve type:INT32 ; means: no used , prepared for future use .
 */
 //SEP2P_MSG_GET_FTP_INFO_RESP
typedef struct tag_MSG_GET_FTP_INFO_RESP
{
	CHAR   chFTPSvr[64];
	CHAR   chUser[64];
	CHAR   chPwd[64];
	CHAR   chDir[128];
	INT32  nPort;
	INT32  nMode; //0:port mode 1:passive mode
	INT32  reserve;
}MSG_GET_FTP_INFO_RESP, *PMSG_GET_FTP_INFO_RESP;

//SEP2P_MSG_SET_FTP_INFO_REQ
typedef MSG_GET_FTP_INFO_RESP	MSG_SET_FTP_INFO_REQ;

/*!
 @struct MSG_SET_FTP_INFO_RESP
 @abstract MSG_SET_FTP_INFO_RESP the struct define the Set FTP information returned result. you can determine the  operator success or failure by field result. if the result is 0, it's means that set  successfully, otherwise failure..
 @discussion .
 @field result type:CHAR  ; means: the set result. if the result is 0, it's means that set successfully, otherwise failure.
 @field reserve type:CHAR*  ; means: no used , prepared for future use .
 */
 //SEP2P_MSG_SET_FTP_INFO_RESP
typedef struct tag_MSG_SET_FTP_INFO_RESP
{
	CHAR  result;	//0: OK; or not fail
	CHAR  reserve[15];
}MSG_SET_FTP_INFO_RESP;


/*!
 @struct MSG_GET_EMAIL_INFO_REQ
 @abstract MSG_GET_EMAIL_INFO_REQ define the struct that send a get email information command request need (send message type: MSG_GET_EMAIL_INFO_REQ; response message type:  MSG_GET_EMAIL_INFO_RESP ).
 @discussion .
 @field reserve type:CHAR*  ; means: no used , prepared for future use.
 */
 //SEP2P_MSG_GET_EMAIL_INFO_REQ
typedef struct tag_MSG_GET_EMAIL_INFO_REQ
{
	CHAR  reserve[16];
}MSG_GET_EMAIL_INFO_REQ;

/*!
 @struct MSG_GET_EMAIL_INFO_RESP
 @abstract MSG_GET_EMAIL_INFO_RESP define the get email information returned result.you can get the result by send command.(send message type: SEP2P_MSG_GET_EMAIL_INFO_REQ; response message type:  SEP2P_MSG_GET_EMAIL_INFO_RESP ).
 @discussion .
 @field chSMTPSvr type:CHAR*  ; means: the SMTP server domain of E-Mail.
 @field chUser type:CHAR*  ; means: the username of E-Mail. need authentication when username is not empty, otherwize don't need authentication.
 @field chPwd type:CHAR*  ; means: the password of E-Mail.
 @field chSender type:CHAR*  ; means: the sender of E-Mail.
 @field chReceiver1 type:CHAR*  ; means: the first receiver of E-Mail.
 @field chReceiver2 type:CHAR*  ; means: the second receiver of E-Mail.
 @field chReceiver3 type:CHAR*  ; means: the third receiver of E-Mail.
 @field chReceiver4 type:CHAR*  ; means: the fourth receiver of E-Mail.
 @field chSubject type:CHAR*  ; means: the E-Mail's subject.
 @field nSMTPPort type:  ; means: the SMTP server's port .
 @field nSSLAuth type:  ; means: SSL authentication level. 0 is none. 1 is SSL authentication. 2 is TLS authentication.
 */
 //SEP2P_MSG_GET_EMAIL_INFO_RESP
typedef struct tag_MSG_GET_EMAIL_INFO_RESP
{
	CHAR chSMTPSvr[64];
	CHAR chUser[64];    
	CHAR chPwd[64];
	CHAR chSender[64];
	CHAR chReceiver1[64];
	CHAR chReceiver2[64];
	CHAR chReceiver3[64];
	CHAR chReceiver4[64];
	CHAR chSubject[64];
	INT32  nSMTPPort;
	INT32  nSSLAuth; //0=NONE, 1=SSL, 2=TLS;  XP2P series: 0=none, 1=ssl/tls, 2=starttls
	CHAR chText[64]; //add 2014-11-13, x series
}MSG_GET_EMAIL_INFO_RESP, *PMSG_GET_EMAIL_INFO_RESP;

//SEP2P_MSG_SET_EMAIL_INFO_REQ
typedef MSG_GET_EMAIL_INFO_RESP MSG_SET_EMAIL_INFO_REQ;

/*!
 @struct MSG_SET_EMAIL_INFO_RESP
 @abstract 
 @field 
 @discussion
 */
/*!
 @struct MSG_SET_EMAIL_INFO_RESP
 @abstract MSG_SET_EMAIL_INFO_RESP the struct define the Set E-Mail information returned result. you can determine the  operator success or failure by field result. if the result is 0, it's means that set  successfully, otherwise failure..
 @discussion .
 @field result type:CHAR  ; means: the set result. if the result is 0, it's means that set successfully, otherwise failure.
 @field reserve type:CHAR*  ; means: no used , prepared for future use .
 */
 //SEP2P_MSG_SET_EMAIL_INFO_RESP
typedef struct tag_MSG_SET_EMAIL_INFO_RESP
{
	CHAR  result;	//0: OK; or not fail
	CHAR  reserve[15];
}MSG_SET_EMAIL_INFO_RESP;

/*!
 @struct MSG_GET_ALARM_INFO_REQ
 @abstract MSG_GET_ALARM_INFO_REQ define the data struct that send a get alarm information command request need (Request message type: MSG_GET_ALARM_INFO_REQ, Response message tyep: MSG_GET_ALARM_INFO_RESP).
 @discussion .
 @field reserve type:CHAR*  ; means: no used , prepared for future use.
 */
 //SEP2P_MSG_GET_ALARM_INFO_REQ
typedef struct tag_MSG_GET_ALARM_INFO_REQ
{
	CHAR  reserve[16];
}MSG_GET_ALARM_INFO_REQ;

/*!
 @struct MSG_GET_ALARM_INFO_RESP
 @abstract MSG_GET_ALARM_INFO_RESP define the get alarm information result. you can get the result by send command.(send message type: SEP2P_MSG_GET_ALARM_INFO_REQ; return message type:  SEP2P_MSG_GET_ALARM_INFO_RESP ).
 @discussion .
 @field bMDEnable type: INT32 ; means: alarm type .
 @field nMDSensitivity type: INT32 ; means: motion detect alarm sensitivity. its level is from 0 to 9. the highest is 0, the lowest is 9.
 @field bInputAlarm type: INT32 ; means: whether to enable input alarm, 0 is disable, 1 is enable.
 @field nInputAlarmMode type: INT32 ; means:input alarm mode. 0 is low level mode, 1 is high level mode.
 @field bIOLinkageWhenAlarm type: INT32 ; means:whether to enable io linkage when alarm, 0 is disable, 1 is enable.
 @field reserve1 type: INT32 ; means:no used.
 @field nPresetbitWhenAlarm type: INT32 ; means: set preset position index whan alarm. Disable it if the value is 0. Enable it if the value is more than 0. The range of position index is from 1 to 8.
 @field bMailWhenAlarm type: INT32 ; means: whether to send E-Mail when alarm. 0 is disable, 1 is enable.The FTP setting refer to SEP2P_MSG_SET_EMAIL_INFO_REQ.
 @field bSnapshotToSDWhenAlarm type: INT32 ; means: whether to snapshot to SDCard when alarm. 0 is disable, 1 is enable.
 @field bRecordToSDWhenAlarm type: INT32 ; means: whether to record to SDCard when alarm. 0 is disable, 1 is enable.
 @field bSnapshotToFTPWhenAlarm type: INT32 ; means: whether to snapshot to FTP server when alarm. 0 is disable, 1 is enable.The FTP setting refer to SEP2P_MSG_SET_FTP_INFO_REQ.
 @field bRecordToFTPWhenAlarm type: INT32 ; means:  whether to record to FTP server when alarm. 0 is disable, 1 is enable.The FTP setting refer to SEP2P_MSG_SET_FTP_INFO_REQ.
 @field reserve2 type: CHAR ; means: no used.
 @field nAudioAlarmSensitivity type:UCHAR; means: audio alarm sensitivity. its level is from 0 to 100. the highest is 100, the lowest is 1, 0 is disable other value is enable.

 */

 //SEP2P_MSG_GET_ALARM_INFO_RESP
typedef struct tag_MSG_GET_ALARM_INFO_RESP
{
	CHAR  bMDEnable[4];		//bMDEnable[0]--> enable flag of MD0,...; their value are 0->disable, 1->enable;
	CHAR  nMDSensitivity[4];//nMDSensitivity[0]--> sensitivity value of MD0,...; their value are (0,9],0->the highest, 9->the lowest;
	INT32 bInputAlarm;		//0->disable; 1->enable
	INT32 nInputAlarmMode;	//0->low level(close); 1->high level(open)
	INT32 bIOLinkageWhenAlarm; //Trigger IO output, 0->disable linkage; 1->enable linkage
	INT32 reserve1;
	INT32 nPresetbitWhenAlarm; //[0,8]; 0->disable; >0 enable, position index from 1 to 8
	INT32 bMailWhenAlarm;	   //0->disable; 1->enable
	INT32 bSnapshotToSDWhenAlarm;  //0->disable; 1->enable	//None for L Series
	INT32 bRecordToSDWhenAlarm;	   //0->disable; 1->enable  //None for L Series
	INT32 bSnapshotToFTPWhenAlarm; //0->disable; 1->enable
	INT32 bRecordToFTPWhenAlarm;   //0->disable; 1->enable  //None for L Series
	CHAR  reserve2[8];
	INT32 nAlarmTime_sun_0;		//24 hours every day, 15 minutes every hour, one flag every 15 minutes, one flag is one bit. bit0---bit95, 0 is invalid in this period(15 minutes), 1 is valid in this period(15 minutes). 
	INT32 nAlarmTime_sun_1;		//nAlarmTime_sun_0.bit0=00:00:00--00:14:59; nAlarmTime_sun_0.bit1=00:15:00--00:29:59; nAlarmTime_sun_0.bit2=00:30:00--00:44:59; ......
	INT32 nAlarmTime_sun_2;		//nAlarmTime_sun_1.bit0=08:00:00--08:14:59; nAlarmTime_sun_1.bit1=08:15:00--08:29:59; nAlarmTime_sun_1.bit2=08:30:00--08:44:59; ......
	INT32 nAlarmTime_mon_0;		
	INT32 nAlarmTime_mon_1;		//nAlarmTime_sun_0, nAlarmTime_sun_1, nAlarmTime_sun_2: Sunday
	INT32 nAlarmTime_mon_2;		//nAlarmTime_mon_0, nAlarmTime_mon_1, nAlarmTime_mon_2: Monday
	INT32 nAlarmTime_tue_0;		//......
	INT32 nAlarmTime_tue_1;
	INT32 nAlarmTime_tue_2;
	INT32 nAlarmTime_wed_0;
	INT32 nAlarmTime_wed_1;
	INT32 nAlarmTime_wed_2;
	INT32 nAlarmTime_thu_0;
	INT32 nAlarmTime_thu_1;
	INT32 nAlarmTime_thu_2;
	INT32 nAlarmTime_fri_0;
	INT32 nAlarmTime_fri_1;
	INT32 nAlarmTime_fri_2;
	INT32 nAlarmTime_sat_0;
	INT32 nAlarmTime_sat_1;
	INT32 nAlarmTime_sat_2;
	UCHAR nAudioAlarmSensitivity;  //0->disable; >0 enable, [1,100] is sensitivity value. 1 is the lowest, 100 is the highest. level 1 is [1,10), level 2 is [10,20),... for X series
	UCHAR nTimeSecOfIOOut;		   //time of IO output, unit second, for X series
	UCHAR bSpeakerWhenAlarm;	   //0->disable; 1->enable, for x series
	UCHAR nTimeSecOfSpeaker;	   //unit: second, for x series
	CHAR  md_name[64];			   //name of the motion detect area 0 for x series

	INT32 md_x[4];	   //md_x[0] is the horizontal coordinates of MD0, md_x[1] is MD1,...;	valid firmware>=V0.1.0.30 for M, 1.0.0.22 for X
	INT32 md_y[4];	   //md_y[0] is the vertical coordinates of MD0, md_y[1] is MD1,...;	valid firmware>=V0.1.0.30 for M, 1.0.0.22 for X
	INT32 md_width[4]; //md_width[0] is the width of MD0, md_width[1] is MD1,...;			valid firmware>=V0.1.0.30 for M, 1.0.0.22 for X
	INT32 md_height[4];//md_height[0] is the height of MD0, md_height[1] is MD1,...;		valid firmware>=V0.1.0.30 for M, 1.0.0.22 for X
	
	UCHAR nTriggerAlarmType;	//0=Trigger independently: Trigger when detecting by any kind of trigger; 1=Trigger jointly
	UCHAR bTemperatureAlarm;	//0->disable; 1->enable, for x series
	UCHAR bHumidityAlarm;		//0->disable; 1->enable, for x series
	UCHAR reserve3[5];
	INT16 nTempMinValueWhenAlarm;  //trigger alarm when temperature < this value, [-100, 100],unit 0C
	INT16 nTempMaxValueWhenAlarm;  //trigger alarm when temperature > this value, [-100, 100],unit 0C
	INT16 nHumiMinValueWhenAlarm;  //trigger alarm when humidity < this value,	  [0, 100], unit %
	INT16 nHumiMaxValueWhenAlarm;  //trigger alarm when humidity > this value,    [0, 100], unit %
}MSG_GET_ALARM_INFO_RESP, *PMSG_GET_ALARM_INFO_RESP;


//SEP2P_MSG_SET_ALARM_INFO_REQ
typedef MSG_GET_ALARM_INFO_RESP MSG_SET_ALARM_INFO_REQ;

/*!
 @struct MSG_SET_ALARM_INFO_RESP
 @abstract MSG_SET_ALARM_INFO_RESP the struct define the Set alarm information returned result. you can determine the  operator success or failure by field result. if the result = 0, it's means that set  successfully, otherwise failure.
 @discussion .
 @field result type:CHAR  ; means: the set result ,0: OK; otherwise fail.
 @field reserve type:CHAR*  ; means: no used , prepared for future use.
 */
 //SEP2P_MSG_SET_ALARM_INFO_RESP
typedef struct tag_MSG_SET_ALARM_INFO_RESP
{
	CHAR  result;	//0: OK; or not fail
	CHAR  reserve[15];
}MSG_SET_ALARM_INFO_RESP;

/*!
 @struct MSG_GET_SDCARD_REC_PARAM_REQ
 @abstract MSG_GET_SDCARD_REC_PARAM_REQ define the  struct that send a get sdcard record param command need data.(Request message tyep: MSG_GET_SDCARD_REC_PARAM_REQ; Response message type: SEP2P_MSG_GET_SDCARD_REC_PARAM_RESP).
 @discussion .
 @field reserve type:CHAR*  ; means: no used , prepared for future use.
 */
 //SEP2P_MSG_GET_SDCARD_REC_PARAM_REQ
typedef struct tag_MSG_GET_SDCARD_REC_PARAM_REQ
{
	CHAR  reserve[16];
}MSG_GET_SDCARD_REC_PARAM_REQ;



/*!
 @struct MSG_GET_SDCARD_REC_PARAM_RESP
 @abstract MSG_GET_SDCARD_REC_PARAM_RESP the struct define the information of get sdcard record schedule.
 you can get the data by send command.(send message type: SEP2P_MSG_GET_SDCARD_REC_PARAM_REQ; return message type:SEP2P_MSG_GET_SDCARD_REC_PARAM_RESP ).
 @discussion .
 @field bRecordCoverInSDCard type: INT32 ; means: whether to record in the SDCard and automatic coverage when full record. 0 is disable it, 1 is enable it.
 @field nRecordTimeLen type:  INT32; means:the record time length in minutes. the range is from 2 to 30 minutes
 @field reserve1 type:  INT32; means:no use.
 @field bRecordTime type: INT32 ; means:wether to enable the record schedule time,1: enable, 0: disable.
 @field reserve2 type: CHAR ; means: no use.
 @field nSDCardStatus type: INT32 ; means:wether device have sdcard,0: no sdcard; 1:with sdcard
 @field nSDTotalSpace type: INT32 ; means: the total space of sdcard in MBytes
 @field nSDFreeSpace type: INT32 ; means:  the free space of sdcard in MBytes
 */
 //SEP2P_MSG_GET_SDCARD_REC_PARAM_RESP
typedef struct tag_MSG_GET_SDCARD_REC_PARAM_RESP
{
	INT32 bRecordCoverInSDCard; //0->disable record in sd-card; 1->enable record in sd-card
	INT32 nRecordTimeLen;		//record time length, in minutes
	INT32 reserve1;
	INT32 bRecordTime;		//0->disable 1->enable
	CHAR  reserve2[84];
	INT32 nSDCardStatus;	//0: no sdcard; 1: sdcard inserted
	INT32 nSDTotalSpace;	//in MBytes
	INT32 nSDFreeSpace;		//in MBytes
}MSG_GET_SDCARD_REC_PARAM_RESP, *PMSG_GET_SDCARD_REC_PARAM_RESP;

//SEP2P_MSG_SET_SDCARD_REC_PARAM_REQ
typedef MSG_GET_SDCARD_REC_PARAM_RESP MSG_SET_SDCARD_REC_PARAM_REQ;

/*!
 @struct MSG_SET_SDCARD_REC_PARAM_RESP
 @abstract MSG_SET_SDCARD_REC_PARAM_RESP the struct define the Set sdcard result. you can determine success or failure by field result. if the result = 0, it's means that set  successfully, otherwise failure.
 @discussion .
 @field result type:CHAR  ; means: the result of  setting sdcard, 0: success, other values means failure.
 @field reserve type:CHAR*  ; means: no used , prepared for future use.
 */
 //SEP2P_MSG_SET_SDCARD_REC_PARAM_RESP
typedef struct tag_MSG_SET_SDCARD_REC_PARAM_RESP
{
	CHAR  result;	//0: OK; or not fail
	CHAR  reserve[15];
}MSG_SET_SDCARD_REC_PARAM_RESP;

/*!
 @struct MSG_FORMAT_SDCARD_REQ
 @abstract MSG_FORMAT_SDCARD_REQ define the struct that send a fomat sdcard command request need data inforamtion.(Request message type: SEP2P_MSG_FORMAT_SDCARD_REQ; there is no response information about send the format sdcard command).
 @discussion .
 @field reserve type:CHAR*  ; means: no used , prepared for future use.
 */
 //SEP2P_MSG_FORMAT_SDCARD_REQ
typedef struct tag_MSG_FORMAT_SDCARD_REQ
{
	CHAR  reserve[16];
}MSG_FORMAT_SDCARD_REQ;

/*!
 @struct MSG_GET_DEVICE_VERSION_REQ
 @abstract MSG_GET_DEVICE_VERSION_REQ define the struct that send a get device's version command request need data information.(Request message type: SEP2P_MSG_GET_DEVICE_VERSION_REQ; Response message type: SEP2P_MSG_GET_DEVICE_VERSION_RESP).
 @discussion .
 @field reserve type:CHAR*  ; means: no used , prepared for future use.
 */
 //SEP2P_MSG_GET_DEVICE_VERSION_REQ
typedef struct tag_MSG_GET_DEVICE_VERSION_REQ
{
	CHAR  reserve[16];
}MSG_GET_DEVICE_VERSION_REQ;

/*!
 @struct MSG_GET_DEVICE_VERSION_RESP
 @abstract MSG_GET_DEVICE_VERSION_RESP, tag_MSG_GET_DEVICE_VERSION_RESP the struct define the information of device's version, you can send command to get the data,(send message type: SEP2P_MSG_GET_DEVICE_VERSION_REQ, return messsage type: SEP2P_MSG_GET_DEVICE_VERSION_RESP).
 @discussion .
 @field chP2papi_ver type:CHAR*  ; means: the version of API used by the device.
 @field chFwp2p_app_ver type:CHAR*  ; means: P2P firmware version
 @field chFwp2p_app_buildtime type:CHAR*  ; means: P2P firmware build time
 @field chFwddns_app_ver type:CHAR*  ; means: the device firmware version
 @field chFwhard_ver type:CHAR*  ; means: the device hard version.
 @field chVendor type:CHAR*  ; means: the factory name.
 @field chProduct type:CHAR*  ; means:product mode
 @field reserve type:CHAR*  ; means:no used, prepared for future.
 */
 //SEP2P_MSG_GET_DEVICE_VERSION_RESP
typedef struct tag_MSG_GET_DEVICE_VERSION_RESP
{
	CHAR chP2papi_ver[32];			//API version
	CHAR chFwp2p_app_ver[32];		//P2P firmware version
	CHAR chFwp2p_app_buildtime[32];	//P2P firmware build time
	CHAR chFwddns_app_ver[32];      //firmware version
	CHAR chFwhard_ver[32];          //the device hard version
	CHAR chVendor[32];    			//factory name
	CHAR chProduct[32];          	//product mode
	CHAR product_series[4];			//product main category, L series: product_series[0]='L'; M series:product_series[0]='M',product_series[1]='1';
	INT32 imn_ver_of_device;//little-endian	 //2015-08-21
	CHAR  is_push_function;	//0: no, 1: yes; //2015-08-21
	CHAR  reserve1[3];
	CHAR  imn_server_port[96];//e.g.: domain_or_ip1:port1|domain_or_ip2:port2|...
	CHAR  reserve[20];
}MSG_GET_DEVICE_VERSION_RESP, *PMSG_GET_DEVICE_VERSION_RESP;



//SEP2P_MSG_ALARM_IO_CTRL_REQ
typedef struct tag_MSG_ALARM_IO_CTRL_REQ
{
	CHAR   bAlarmOutIO1;	//0-->off, 1-->on
	CHAR   reserve[23];
}MSG_ALARM_IO_CTRL_REQ, *PMSG_ALARM_IO_CTRL_REQ;

//SEP2P_MSG_ALARM_IO_CTRL_RESP
typedef struct tag_MSG_ALARM_IO_CTRL_RESP
{
	CHAR  result;	//0: OK; or not fail
	CHAR  reserve[15];
}MSG_ALARM_IO_CTRL_RESP;



//SEP2P_MSG_GET_UART_CTRL_REQ
typedef struct tag_MSG_GET_UART_CTRL_REQ
{
	CHAR  reserve[16];
}MSG_GET_UART_CTRL_REQ;

//SEP2P_MSG_GET_UART_CTRL_RESP
typedef struct tag_MSG_GET_UART_CTRL_RESP
{
	CHAR   bUartAlarmEnable[24]; //24 pcs uart alarm port enable/disable. bUartAlarmEnable[0]=0,first uart alarm port disable,bUartAlarmEnable[0]=1,first uart alarm port enable,......
	CHAR   chUartAlarmServer[64];
	UINT16 nUartAlarmServerPort;
	CHAR   reserve[62];

}MSG_GET_UART_CTRL_RESP, *PMSG_GET_UART_CTRL_RESP;


typedef enum
{
	BIT_MASK_UART_ALARM_ENABLE		=0x01,
	BIT_MASK_UART_ALARM_SERVER		=0x02,
	BIT_MASK_UART_ALARM_SERVER_PORT	=0x04

}ENUM_BIT_MASK_UART_CTRL;
//SEP2P_MSG_SET_UART_CTRL_REQ
typedef struct tag_MSG_SET_UART_CTRL_REQ
{
	CHAR   bUartAlarmEnable[24]; //24 pcs uart alarm port enable/disable. bUartAlarmEnable[0]=0,first uart alarm port disable,bUartAlarmEnable[0]=1,first uart alarm port enable,bUartAlarmEnable[0]=other value,invalid;......
	CHAR   chUartAlarmServer[64];
	UINT16 nUartAlarmServerPort;
	CHAR   reserve[58];

	INT32  nBitMaskToSet;//refer to ENUM_BIT_MASK_UART_CTRL
						//Bit0:=1->set uart alarm port enable/disable(field bUartAlarmEnable); Bit1:=1->set uart alarm server ip or domain(field chUartAlarmServer);
						//Bit2:=1->set uart alarm server port(field nUartAlarmServerPort);
}MSG_SET_UART_CTRL_REQ, *PMSG_SET_UART_CTRL_REQ;

//SEP2P_MSG_SET_UART_CTRL_RESP
typedef struct tag_MSG_SET_UART_CTRL_RESP
{
	CHAR   result;	//0: OK; or not fail
	CHAR   reserve[11];
	INT32  nBitMaskToSet;//refer to ENUM_BIT_MASK_UART_CTRL
}MSG_SET_UART_CTRL_RESP;


//SEP2P_MSG_REBOOT_DEVICE = 0x0196,
typedef struct tag_MSG_REBOOT_DEVICE
{
	CHAR  reserve[16];
}MSG_REBOOT_DEVICE;

//SEP2P_MSG_GET_CUSTOM_PARAM_REQ  = 0x0198,
typedef struct tag_MSG_GET_CUSTOM_PARAM_REQ
{
	CHAR  reserve[8];
	CHAR  chParamName[32];
}MSG_GET_CUSTOM_PARAM_REQ;

//SEP2P_MSG_GET_CUSTOM_PARAM_RESP = 0x0199,
typedef struct tag_MSG_GET_CUSTOM_PARAM_RESP
{
	CHAR  result;	//0: OK; 1:config_custom.ini does not exist; 2:chParamName does not exist
	CHAR  reserve[7];
	CHAR  chParamName[32];
	CHAR  chParamValue[64];
}MSG_GET_CUSTOM_PARAM_RESP;


//SEP2P_MSG_SET_CUSTOM_PARAM_REQ  = 0x019A,
typedef struct tag_MSG_SET_CUSTOM_PARAM_REQ
{
	CHAR  reserve[8];
	CHAR  chParamName[32];
	CHAR  chParamValue[64];
}MSG_SET_CUSTOM_PARAM_REQ;

//SEP2P_MSG_SET_CUSTOM_PARAM_RESP = 0x019B
//discussion:
//	after setting is ok. return MSG_SET_CUSTOM_PARAM_RESP.chParamName=MSG_SET_CUSTOM_PARAM_REQ.chParamName
//	MSG_SET_CUSTOM_PARAM_RESP.chParamValue=MSG_SET_CUSTOM_PARAM_REQ.chParamValue
//
typedef struct tag_MSG_SET_CUSTOM_PARAM_RESP
{
	CHAR  result;	//0: OK; 1:config_custom.ini does not exist; 2:chParamName does not exist
	CHAR  reserve[7];
	CHAR  chParamName[32];
	CHAR  chParamValue[64];
}MSG_SET_CUSTOM_PARAM_RESP;



//SEP2P_MSG_GET_REMOTE_REC_DAY_BY_MONTH_REQ		= 0x01A6
typedef struct tag_MSG_GET_REMOTE_REC_DAY_BY_MONTH_REQ
{
	INT32	nYearMon;	//e.g:201412
	INT32	nRecType;	//1:plan record; 2:alarm record; 3:all
	CHAR	reserve[136];
}MSG_GET_REMOTE_REC_DAY_BY_MONTH_REQ;

//SEP2P_MSG_GET_REMOTE_REC_DAY_BY_MONTH_RESP	= 0x01A7
typedef struct tag_MSG_GET_REMOTE_REC_DAY_BY_MONTH_RESP
{
	INT32	nYearMon;	//e.g:201412
	INT32	nRecType;	//1:plan record; 2:alarm record; 3:all
	CHAR	chDay[128];	//e.g: "01,02" means that there is record file on the 20141201 and the 20141202
	CHAR    reserve[8]; 
}MSG_GET_REMOTE_REC_DAY_BY_MONTH_RESP;

//SEP2P_MSG_GET_REMOTE_REC_FILE_BY_DAY_REQ      = 0x01A8
typedef struct tag_MSG_GET_REMOTE_REC_FILE_BY_DAY_REQ
{
	INT32	nYearMonDay;//e.g:20141201
	INT32	nRecType;	//1:plan record; 2:alarm record; 3:all
	INT32   nBeginNoOfThisTime;	//>=0; want to return the first file index in this time
	INT32   nEndNoOfThisTime;	//>=0 and >=nBeginNoOfThisTime; want to return the last file index in this time. when nEndNoOfThisTime=nBeginNoOfThisTime and is zero, get all record of given condition
	CHAR	reserve[8];	
}MSG_GET_REMOTE_REC_FILE_BY_DAY_REQ;

typedef struct tag_REC_FILE_INFO
{
	CHAR  chStartTime[32];
	CHAR  chEndTime[32];
	CHAR  nRecType;
	CHAR  reserve[7];
	INT32 nTimeLen_sec;		//unit: second, record file playback time
	INT32 nFileSize_KB;		//unit: KBytes, record file size in byte
	CHAR  chFilePath[120];
}REC_FILE_INFO;

//SEP2P_MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP     = 0x01A9
typedef struct tag_MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP
{
	INT32 nResult;	//0:OK, 1:NO SDCard; 2:fail
	INT32 nFileTotalNum;		//total file num >=0
	INT32 nBeginNoOfThisTime;	//to return the first file index in this time
	INT32 nEndNoOfThisTime;		//to return the last file index in this time
	CHAR  reserve[8];
	
	//REC_FILE_INFO[x], x=nEndNoOfThisTime-nBeginNoOfThisTime+1
}MSG_GET_REMOTE_REC_FILE_BY_DAY_RESP;


//SEP2P_MSG_START_PLAY_REC_FILE_REQ				   = 0x01AA
typedef struct tag_MSG_START_PLAY_REC_FILE_REQ
{
	CHAR  bOnlyPlayIFrame;
	CHAR  reserve1[3];
	INT32 nBeginPos_sec;	//unit: second
	CHAR  chFilePath[120];
	CHAR  reserve2[8];
}MSG_START_PLAY_REC_FILE_REQ;
//SEP2P_MSG_START_PLAY_REC_FILE_RESP               = 0x01AB
typedef struct tag_MSG_START_PLAY_REC_FILE_RESP
{
	CHAR  nResult;	//0:OK; 1:playback end;    Error:[11:already playback; 12:failed to open file; 13:playback fail;]
	CHAR  nAudioParam; //-1 no audio; >=0 with audio:[samplerate << 2) | (databits << 1) | (channel)], samplerate refer to SEP2P_ENUM_AUDIO_SAMPLERATE; databits refer to SEP2P_ENUM_AUDIO_DATABITS; channel refer to SEP2P_ENUM_AUDIO_CHANNEL
	CHAR  reserve1[2];
	INT32 nBeginPos_sec;	//unit: second
	CHAR  chFilePath[120];
	INT32 nTimeLen_sec;		//unit: second, record file playback total time;  it is invalid,always is 0 for X series
	INT32 nFileSize_KB;		//unit: KBytes, record file size in byte
	UINT32 nPlaybackID;		//this id will assign to STREAM_HEAD.reserve2[2] ~ STREAM_HEAD.reserve2[5]
	CHAR   reserve2[4];
}MSG_START_PLAY_REC_FILE_RESP;


//SEP2P_MSG_STOP_PLAY_REC_FILE_REQ                   = 0x01AC
typedef struct tag_MSG_STOP_PLAY_REC_FILE_REQ
{
	CHAR  reserve[16];
	CHAR  chFilePath[120];
}MSG_STOP_PLAY_REC_FILE_REQ;
//SEP2P_MSG_STOP_PLAY_REC_FILE_RESP                  = 0x01AD
typedef struct tag_MSG_STOP_PLAY_REC_FILE_RESP
{
	CHAR  nResult;		//0:OK; 
	CHAR  reserve[15];
	CHAR  chFilePath[120];
}MSG_STOP_PLAY_REC_FILE_RESP;




//SEP2P_MSG_GET_REC_DATE_RANGE_REQ				   = 0x01AE,
typedef struct tag_MSG_GET_REC_DATE_RANGE_REQ
{
	CHAR	reserve[64];
}MSG_GET_REC_DATE_RANGE_REQ;

//SEP2P_MSG_GET_REC_DATE_RANGE_RESP		           = 0x01AF,
typedef struct tag_MSG_GET_REC_DATE_RANGE_RESP
{
	CHAR    result;
	CHAR    reserve[7]; 
	INT32	nYearMonDay1;	//e.g:20141201, is 2014-12-01
	INT32	nHourMinSec1;	//e.g:160110, is 16:01:10
	INT32	nYearMonDay2;	//e.g:20141206, is 2014-12-01
	INT32	nHourMinSec2;	//e.g:160110, is 16:01:10
}MSG_GET_REC_DATE_RANGE_RESP;

//SEP2P_MSG_START_PLAY_REC_FILE2_REQ               = 0x01B0,
typedef struct tag_MSG_START_PLAY_REC_FILE2_REQ
{

}MSG_START_PLAY_REC_FILE2_REQ;

//SEP2P_MSG_START_PLAY_REC_FILE2_RESP              = 0x01B1,
typedef struct tag_MSG_START_PLAY_REC_FILE2_RESP 
{

}MSG_START_PLAY_REC_FILE2_RESP;

//SEP2P_MSG_STOP_PLAY_REC_FILE2_REQ                = 0x01B2,
typedef struct tag_MSG_STOP_PLAY_REC_FILE2_REQ
{

}MSG_STOP_PLAY_REC_FILE2_REQ;

//SEP2P_MSG_STOP_PLAY_REC_FILE2_RESP               = 0x01B3,
typedef struct tag_MSG_STOP_PLAY_REC_FILE2_RESP
{
	
}MSG_STOP_PLAY_REC_FILE2_RESP;




//SEP2P_MSG_GET_IPUSH_INFO_REQ					   = 0x01BA,	//X series, supported on the v1.0.0.14 of firmware 
//- (no data)

//SEP2P_MSG_GET_IPUSH_INFO_RESP					   = 0x01BB,	//X series, supported on the v1.0.0.14 of firmware 
typedef struct tag_MSG_GET_IPUSH_INFO_RESP
{
	CHAR bEnable; //0: disable; 1:enable
	CHAR nResult; //0: OK; other fail
	CHAR reserve[102];
}MSG_GET_IPUSH_INFO_RESP;

//SEP2P_MSG_SET_IPUSH_INFO_REQ					   = 0x01BC,	//X series, supported on the v1.0.0.14 of firmware 
typedef MSG_GET_IPUSH_INFO_RESP  MSG_SET_IPUSH_INFO_REQ;

//SEP2P_MSG_SET_IPUSH_INFO_RESP					   = 0x01BD,	//X series, supported on the v1.0.0.14 of firmware 
typedef MSG_GET_IPUSH_INFO_RESP  MSG_SET_IPUSH_INFO_RESP;



#endif  //#ifndef __INCLUDED_SEP2P_Define____H
