//
//  LogMacro.h
//  Unity-iPhone
//
//  Created by abc on 13-6-24.
//
//

#if DEBUG

#define __SHOW__LOG__

#endif

#ifdef __SHOW__LOG__

typedef enum {
    
    LEVEL_ALL,
    LEVEL_1,
    LEVEL_2,
    LEVEL_3,
    LEVEL_4,
    LEVEL_5,
    
}LOG_LEVEL;

#define MyLevelLog      LEVEL_1

#define LogFileName     @"LEVEL_1.txt"

#define DocumentPath    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

extern void myLevelLog(int line,char *functname,char *file,LOG_LEVEL level,int writeTofile, id formatstring,...);

#define DLog(format,...) myLevelLog(__LINE__,(char *)__FUNCTION__,(char *)__FILE__,LEVEL_ALL,format, ##__VA_ARGS__)
#define DLLog(LEVEL_,format,...) myLevelLog(__LINE__,(char *)__FUNCTION__,(char *)__FILE__,LEVEL_,format, ##__VA_ARGS__)

#define DLV1Log(format,...) myLevelLog(__LINE__,(char *)__FUNCTION__,(char *)__FILE__,LEVEL_1,0,format, ##__VA_ARGS__)
#define DLV2Log(format,...) myLevelLog(__LINE__,(char *)__FUNCTION__,(char *)__FILE__,LEVEL_2,0,format, ##__VA_ARGS__)
#define DLV3Log(format,...) myLevelLog(__LINE__,(char *)__FUNCTION__,(char *)__FILE__,LEVEL_3,0,format, ##__VA_ARGS__)
#define DLV4Log(format,...) myLevelLog(__LINE__,(char *)__FUNCTION__,(char *)__FILE__,LEVEL_4,0,format, ##__VA_ARGS__)
#define DLV5Log(format,...) myLevelLog(__LINE__,(char *)__FUNCTION__,(char *)__FILE__,LEVEL_5,0,format, ##__VA_ARGS__)

#define WFLV1Log(format,...) myLevelLog(__LINE__,(char *)__FUNCTION__,(char *)__FILE__,LEVEL_1,1,format, ##__VA_ARGS__)
#define WFLV2Log(format,...) myLevelLog(__LINE__,(char *)__FUNCTION__,(char *)__FILE__,LEVEL_2,1,format, ##__VA_ARGS__)
#define WFLV3Log(format,...) myLevelLog(__LINE__,(char *)__FUNCTION__,(char *)__FILE__,LEVEL_3,1,format, ##__VA_ARGS__)
#define WFLV4Log(format,...) myLevelLog(__LINE__,(char *)__FUNCTION__,(char *)__FILE__,LEVEL_4,1,format, ##__VA_ARGS__)
#define WFLV5Log(format,...) myLevelLog(__LINE__,(char *)__FUNCTION__,(char *)__FILE__,LEVEL_5,1,format, ##__VA_ARGS__)

#else

#define DLog(...)
#define DLLog(...)
#define DLV1Log(...)
#define DLV2Log(...)
#define DLV3Log(...)
#define DLV4Log(...)
#define DLV5Log(...)

#define WFLV1Log(...)
#define WFLV2Log(...)
#define WFLV3Log(...)
#define WFLV4Log(...)
#define WFLV5Log(...)

#endif