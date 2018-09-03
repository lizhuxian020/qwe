//
//  KMTCrashCatcher.h
//  KMTGlobe
//
//  Created by mac on 6/8/2018.
//

#import <Foundation/Foundation.h>

@interface KMTCrashCatcher : NSObject

void uncaughtExceptionHandler(NSException *exception);

@end
