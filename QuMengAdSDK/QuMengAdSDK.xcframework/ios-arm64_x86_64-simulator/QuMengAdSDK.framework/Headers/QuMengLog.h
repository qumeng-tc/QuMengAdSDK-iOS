//
//  QuMengLog.h
//  QuMengAdSDK
//
//  Created by qusy on 2023/12/28.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(int, QuMengLoggingLevel) {
    kQuMengLoggingLevel_Info,
    kQuMengLoggingLevel_Warning,
    kQuMengLoggingLevel_Error,
};

extern void _QuMengLogMessage(QuMengLoggingLevel level, NSString *format, ...) NS_FORMAT_FUNCTION(2, 3);

#define QuMengLog(fmt, ...)         _QuMengLogMessage(kQuMengLoggingLevel_Info, @"%s: " fmt, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#define QuMengLogWarning(fmt, ...)  _QuMengLogMessage(kQuMengLoggingLevel_Warning, @"%s: " fmt, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#define QuMengLogError(fmt, ...)    _QuMengLogMessage(kQuMengLoggingLevel_Error, @"%s: " fmt, __PRETTY_FUNCTION__, ##__VA_ARGS__)

