
#include <sys/time.h>
#include <time.h>
#include <errno.h>

#include <stdio.h>
#include <stdarg.h>


void logAll(const char* filename, const char* funcname, int lineno, const char* fmt, ... )
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    struct tm *pTime;
    time_t ctTime;
    //time( &ctTime );
    ctTime = tv.tv_sec;
    pTime = localtime( &ctTime );
    const size_t BUF_SIZE = 1024 * 128;
    char s[BUF_SIZE];
    int writen = snprintf( s, sizeof(s), "%4d/%.2d/%.2d %.2d:%.2d:%.2d %.3ld %s:%d [%s] - ", 
                pTime->tm_year + 1900, pTime->tm_mon + 1, pTime->tm_mday,
                pTime->tm_hour, pTime->tm_min, pTime->tm_sec, tv.tv_usec / 1000, filename, lineno, funcname );

    if ( writen <= 0 )
    {
        fprintf( stderr, "snprintf return error, errno=%d\n", errno );
        return;
    }
    va_list ap;
    va_start(ap,fmt);
    int len = vsnprintf(s + writen, sizeof(s) - writen, fmt, ap);
    (void)len;
    va_end(ap);

#ifdef _DEBUG
    fprintf(stdout, "%s\n", s);
#else
    fprintf(stdout, "%s\n", s);
#endif
}



char* hstring(ngx_pool_t* pool, void* p, size_t len)
{
    char * r = ngx_pcalloc(pool, len+1);
    memcpy(r, p, len);
    r[len] = 0;
    return r;
}
