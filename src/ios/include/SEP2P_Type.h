#if !defined(__INCLUDED_SEP2P_Type____H)
#define __INCLUDED_SEP2P_Type____H


#ifdef LINUX
	#include <stdlib.h>
	#include <unistd.h> 
	#include <fcntl.h>
	#include <pthread.h>
	#include <stdio.h> 
	#include <sys/types.h>
	#include <sys/time.h> 
	#include <signal.h> 
	#include <netinet/in.h>
	#include <netdb.h> 
	#include <net/if.h>
	#include <string.h>
	#include <sched.h>
	#include <stdarg.h>
	#include <math.h>
	#include <dirent.h>
	#include <sys/socket.h>
	#include <unistd.h>
	#include <arpa/inet.h>
    #include <semaphore.h>
	#include <errno.h>

	#define WINAPI
#endif  //// #ifdef LINUX

#ifdef WIN32DLL
	#include <Winsock2.h>
	#include <ws2tcpip.h>
	#include <windows.h>
	#include <stdio.h>
	#include <stdarg.h>
	#include <time.h>
	#include <assert.h>

	#pragma comment(lib, "ws2_32.lib")
	#define WSA_VERSION MAKEWORD(2, 2) // using winsock 2.2
#endif //// #ifdef WIN32DLL


#ifdef _MANAGED
#pragma managed(push, off)
#endif


#if defined WIN32DLL || defined LINUX
typedef int				INT32;
typedef unsigned int	UINT32;
#endif

typedef short			INT16;
typedef unsigned short	UINT16;

typedef char			CHAR;
typedef signed char		SCHAR;
typedef unsigned char	UCHAR;

typedef long			LONG;

#ifndef LINUX_OSX
    typedef unsigned long	ULONG;
#endif

#if defined(WIN32DLL)
    typedef unsigned __int64   UINT64;
#elif defined(LINUX)
	#ifdef RT5350
		typedef unsigned long UINT64;
	#else
		typedef unsigned long long int UINT64;
	#endif
#else
    typedef unsigned long long UINT64;
#endif

#if defined(WIN32DLL)
	typedef __int64   INT64;
#elif defined(LINUX)
	#ifdef RT5350
		typedef long INT64;
	#else
		typedef long long int INT64;
	#endif
#else
	typedef long long INT64;
#endif

#ifndef status_t
	typedef int		status_t;
#endif

#ifndef LINUX
	typedef long	ssize_t;
#endif

#ifndef VOID
	typedef void        VOID;
#endif

#ifndef HANDLE
	typedef void*		HANDLE;
#endif

#ifndef bool
	#define bool		CHAR
#endif

#ifndef true
	#define true		1
#endif

#ifndef false
	#define false		0
#endif

#ifndef NULL
	#define NULL ((void *)0)
#endif

#ifndef IN
	#define	IN
#endif

#ifndef OUT
	#define	OUT
#endif


#endif  //__INCLUDED_SEP2P_Type____H