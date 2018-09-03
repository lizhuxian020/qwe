//
//  KMTRequestManager.h
//  AFNetworking
//
//  Created by mac on 22/8/2018.
//

#import <Foundation/Foundation.h>

typedef void(^KMTCallback)();

@interface KMTRequestManager : NSObject

+ (instancetype)shareManager;

- (void)addRequest:(KMTRequest *)reqeust;

- (void)cancelAllTask;

@end
