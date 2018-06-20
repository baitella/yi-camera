#ifndef __INCLUDED_SEP2P_Error____H
#define __INCLUDED_SEP2P_Error____H


/*!
 @header SEP2P_Error
 @abstract This file define all the error types
 @version 
 */

/*!
 @const      ERR_SEP2P_SUCCESSFUL
 @abstract   The status information that the interface return . It's means that the api performed successfully.
 @discussion The status information that the interface return . It's means that the api performed successfully.
 */
#define ERR_SEP2P_SUCCESSFUL							0


/*!
 @const      ERR_SEP2P_NOT_INITIALIZED
 @abstract   The status information that the interface return . It's means that the sdk is not be initialized. The SEP2P_Initialize API is called first.
 @discussion The status information that the interface return . It's means that the sdk is not be initialized. The SEP2P_Initialize API is called first.
 */
#define ERR_SEP2P_NOT_INITIALIZED						-1


/*!
 @const      ERR_SEP2P_ALREADY_INITIALIZED
 @abstract   The status information that the interface return . It's means that the sdk have been initialized suceessfully.
 @discussion The status information that the interface return . It's means that the sdk have been initialized suceessfully.
 */
#define ERR_SEP2P_ALREADY_INITIALIZED					-2


/*!
 @const      ERR_SEP2P_TIME_OUT
 @abstract   The status information that the interface return . It's means that it's timeout.
 @discussion The status information that the interface return . It's means that it's timeout.
 */
#define ERR_SEP2P_TIME_OUT								-3


/*!
 @const      ERR_SEP2P_INVALID_ID
 @abstract   The status information that the interface return . It's means that it's a invalid DID.
 @discussion The status information that the interface return . It's means that it's a invalid DID.
 */
#define ERR_SEP2P_INVALID_ID							-4


/*!
 @const      ERR_SEP2P_INVALID_PARAMETER
 @abstract   The status information that the interface return . It's means that it's a invalid parameter.
 @discussion The status information that the interface return . It's means that it's a invalid parameter.
 */
#define ERR_SEP2P_INVALID_PARAMETER						-5


/*!
 @const      ERR_SEP2P_DEVICE_NOT_ONLINE
 @abstract   The status information that the interface return . It's means that the device is offline.
 @discussion The status information that the interface return . It's means that the device is offline.
 */
#define ERR_SEP2P_DEVICE_NOT_ONLINE						-6


/*!
 @const      ERR_SEP2P_FAIL_TO_RESOLVE_NAME
 @abstract   The status information that the interface return . It's means that it' s failed to resolve name.
 @discussion The status information that the interface return . It's means that it' s failed to resolve name.
 */
#define ERR_SEP2P_FAIL_TO_RESOLVE_NAME					-7


/*!
 @const      ERR_SEP2P_INVALID_PREFIX
 @abstract   The status information that the interface return . It's means that it's a invalid prefix, that is wrong DID.
 @discussion The status information that the interface return . It's means that it's a invalid prefix, that is wrong DID.
 */
#define ERR_SEP2P_INVALID_PREFIX						-8


/*!
 @const      ERR_SEP2P_ID_OUT_OF_DATE
 @abstract   The status information that the interface return . It's means that the id is out of date.
 @discussion The status information that the interface return . It's means that the id is out of date.
 */
#define ERR_SEP2P_ID_OUT_OF_DATE						-9


/*!
 @const      ERR_SEP2P_NO_RELAY_SERVER_AVAILABLE
 @abstract   The status information that the interface return . It's means that the device no relay connect to server available.
 @discussion The status information that the interface return . It's means that the device no relay connect to server available.
 */
#define ERR_SEP2P_NO_RELAY_SERVER_AVAILABLE				-10


/*!
 @const      ERR_SEP2P_INVALID_SESSION_HANDLE
 @abstract   The status information that the interface return . It's means that the handle is invalid p2p session handle.
 @discussion The status information that the interface return . It's means that the handle is invalid p2p session handle.
 */
#define ERR_SEP2P_INVALID_SESSION_HANDLE				-11


/*!
 @const      ERR_SEP2P_SESSION_CLOSED_REMOTE
 @abstract   The status information that the interface return . It's means that p2p session closed by remote.
 @discussion The status information that the interface return . It's means that p2p session closed by remote.
 */
#define ERR_SEP2P_SESSION_CLOSED_REMOTE					-12


/*!
 @const      ERR_SEP2P_SESSION_CLOSED_TIMEOUT
 @abstract   The status information that the interface return . It's means that p2p session closed because of keepalive timeout.
 @discussion The status information that the interface return . It's means that p2p session closed because of keepalive timeout.
 */
#define ERR_SEP2P_SESSION_CLOSED_TIMEOUT				-13


/*!
 @const      ERR_SEP2P_SESSION_CLOSED_CALLED
 @abstract   The status information that the interface return . It's means that p2p session closed because of calling SEP2P_Disconnect.
 @discussion The status information that the interface return . It's means that p2p session closed because of calling SEP2P_Disconnect.
 */
#define ERR_SEP2P_SESSION_CLOSED_CALLED					-14


/*!
 @const      ERR_SEP2P_REMOTE_SITE_BUFFER_FULL
 @abstract   The status information that the interface return . It's means that the other side of buffer is full.
 @discussion The status information that the interface return . It's means that the other side of buffer is full.
 */
#define ERR_SEP2P_REMOTE_SITE_BUFFER_FULL				-15


/*!
 @const      ERR_SEP2P_USER_LISTEN_BREAK
 @abstract   The status information that the interface return . It's means that the listening site break.
 @discussion The status information that the interface return . It's means that the listening site break.
 */
#define ERR_SEP2P_USER_LISTEN_BREAK						-16


/*!
 @const      ERR_SEP2P_MAX_SESSION
 @abstract   The status information that the interface return . It's means that the device 's p2p session over the max number.
 @discussion The status information that the interface return . It's means that the device 's p2p session over the max number.
 */
#define ERR_SEP2P_MAX_SESSION							-17


/*!
 @const      ERR_SEP2P_UDP_PORT_BIND_FAILED
 @abstract   The status information that the interface return  . It's means that the device 's udp port bind failed.
 @discussion The status information that the interface return  . It's means that the device 's udp port bind failed.
 */
#define ERR_SEP2P_UDP_PORT_BIND_FAILED					-18


/*!
 @const      ERR_SEP2P_USER_CONNECT_BREAK
 @abstract   The status information that the interface return  . It's means that the device is disconnected.
 @discussion The status information that the interface return  . It's means that the device is disconnected.
 */
#define ERR_SEP2P_USER_CONNECT_BREAK					-19


/*!
 @const      ERR_SEP2P_SESSION_CLOSED_INSUFFICIENT_MEMORY
 @abstract   The status information that the interface return . It's means that session close in sufficient memory.
 @discussion The status information that the interface return . It's means that session close in sufficient memory.
 */
#define ERR_SEP2P_SESSION_CLOSED_INSUFFICIENT_MEMORY	-20


/*!
 @const      ERR_SEP2P_INVALID_APILICENSE
 @abstract   The status information that the interface return . It's means that the api license is invalid.
 @discussion The status information that the interface return . It's means that the api license is invalid.
 */
#define ERR_SEP2P_INVALID_APILICENSE					-21


/*!
 @const      ERR_SEP2P_FAIL_TO_CREATE_THREAD
 @abstract   The status information that the interface return . It's means that it's failed to create a new thread.
 @discussion The status information that the interface return . It's means that it's failed to create a new thread.
 */
#define ERR_SEP2P_FAIL_TO_CREATE_THREAD					-22






/*!
 @const      ERR_SEP2P_EXCEED_MAX_CONNECT_NUM
 @abstract   The status information that the interface return. It's means that it is more than the SDK allows the number of concurrent connections. Concurrent connect maximum number is 64 now.
 @discussion The status information that the interface return. it is more than the SDK allows the number of concurrent connections. Concurrent connect maximum number is 64 now.
 */
#define ERR_SEP2P_EXCEED_MAX_CONNECT_NUM				-200


/*!
 @const      ERR_SEP2P_ALREADY_CONNECTED
 @abstract   The status information that the interface return . It's means that the current device is connected .
 @parseOnly.
 @discussion The status information that the interface return . It's means that the current device is connected .
 @parseOnly.
 */
#define ERR_SEP2P_ALREADY_CONNECTED						-201


/*!
 @const      ERR_SEP2P_INVALID_MSG_TYPE
 @abstract   The status information that the interface return . It's means that the send message type is not defined.
 @discussion The status information that the interface return . It's means that the send message type is not defined.
 */
#define ERR_SEP2P_INVALID_MSG_TYPE						-202


/*!
 @const      ERR_SEP2P_NO_CONNECT_THIS_DID
 @abstract   The status information that the interface return. It's means that the app can not interact with the device before connecting the device.
 @discussion The status information that the interface return. It's means that the app can not interact with the device before connecting the device.
 */
#define ERR_SEP2P_NO_CONNECT_THIS_DID					-203


/*!
 @const      ERR_SEP2P_NO_SUPPORT_THIS_CODECID
 @abstract   The status information that the interface return. It's means that current sdk don't support the audio or video CODECID defined in the SEP2P_ENUM_AV_CODECID.
 @discussion The status information that the interface return. It's means that current sdk don't support the audio or video CODECID defined in the SEP2P_ENUM_AV_CODECID.
 */
#define ERR_SEP2P_NO_SUPPORT_THIS_CODECID				-204


/*!
 @const      ERR_SEP2P_NO_SUPPORT_THIS_RESO
 @abstract   The status information that the interface return. It's means that current sdk don't support the request.
 @discussion The status information that the interface return. It's means that current sdk don't support the request.
 */
#define ERR_SEP2P_NO_SUPPORT_THIS_RESO					-205


/*!
 @const      ERR_SEP2P_FIRST_START_VIDEO
 @abstract   The status information that the interface return. It's means that current is first start video before starting audio or talk.
 @discussion The status information that the interface return. It's means that current is first start video before starting audio or talk.
 */
#define ERR_SEP2P_FIRST_START_VIDEO						-206


/*!
 @const      ERR_SEP2P_WRITTEN_SIZE_TOO_BIG
 @abstract   The status information that the interface return. It's means that every time the size of the audio data of more than 1024 bytes.
 @discussion The status information that the interface return. It's means that every time the size of the audio data of more than 1024 bytes.
 */
#define ERR_SEP2P_WRITTEN_SIZE_TOO_BIG					-207

/*!
 @const      ERR_SEP2P_STOPPED_TALK
 @abstract   The status information that the interface return. It's means that the talk has already stopped. The SEP2P_SendTalkData will return one.
 @discussion The status information that the interface return. It's means that the talk has already stopped. The SEP2P_SendTalkData will return one.
 */
#define ERR_SEP2P_STOPPED_TALK							-208



#endif //// #ifndef __INCLUDED_SEP2P_Error____H