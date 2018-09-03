//
//  KMTLogFormatter.h
//  KMDeparture
//
//  Created by mac on 6/8/2018.
//  Copyright © 2018 KMT. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelError;
#endif

@interface KMTLogFormatter : NSObject<DDLogFormatter>

@end
