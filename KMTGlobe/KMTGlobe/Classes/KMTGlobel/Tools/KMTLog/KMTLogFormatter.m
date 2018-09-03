//
//  KMTLogFormatter.m
//  KMDeparture
//
//  Created by mac on 6/8/2018.
//  Copyright © 2018 KMT. All rights reserved.
//

#import "KMTLogFormatter.h"

@implementation KMTLogFormatter

+(void)load {
    KMTLogFormatter *formatter = [KMTLogFormatter new];
    
    // 添加DDASLLogger，你的日志语句将被发送到Xcode控制台
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // 添加DDTTYLogger，你的日志语句将被发送到Console.app
//    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    [[DDASLLogger sharedInstance] setLogFormatter:formatter];
//    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    
    // 添加DDFileLogger，你的日志语句将写入到一个文件中，默认路径在沙盒的Library/Caches/Logs/目录下，文件名为bundleid+空格+日期.log。
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [fileLogger setLogFormatter:formatter];
    [DDLog addLogger:fileLogger];
    
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    return [NSString stringWithFormat:@"[%@] %@ | %@ @ %@ | %@", logMessage.threadName,
            [logMessage fileName], logMessage->_function, @(logMessage->_line), logMessage->_message];
}

@end
