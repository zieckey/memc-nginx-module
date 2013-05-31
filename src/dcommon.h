#ifndef _MAP_REDUCE_COMMON_H_
#define _MAP_REDUCE_COMMON_H_

#include <sys/time.h>
#include <time.h>
#include <errno.h>

#include <stdio.h>
#include <stdarg.h>


void logAll(const char* filename, const char* funcname, int lineno, const char* fmt, ... );

    //#define LogTrace(fmt, args...) { if (FLAGS_runlog <= 0) logAll(__FILE__, "TRACE", __LINE__, fmt, ##args ); }
    //#define LogDebug(fmt, args...) { if (FLAGS_runlog <= 1) logAll(__FILE__, "DEBUG", __LINE__, fmt, ##args ); }
    //#define LogInfo(fmt, args...)  { if (FLAGS_runlog <= 2) logAll(__FILE__, "INFO ", __LINE__, fmt, ##args ); }
    //#define LogWarn(fmt, args...)  { if (FLAGS_runlog <= 3) logAll(__FILE__, "WARN ", __LINE__, fmt, ##args ); }
    //#define LogError(fmt, args...) { if (FLAGS_runlog <= 4) logAll(__FILE__, "ERROR", __LINE__, fmt, ##args ); }

#ifndef htrace
    #define htrace(fmt, args...) logAll(__FILE__, __func__, __LINE__, fmt, ##args )
#endif

#endif

