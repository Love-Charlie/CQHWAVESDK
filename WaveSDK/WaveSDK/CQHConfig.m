//
//  CQHConfig.m
//  CQHTCSDK
//
//  Created by Love Charlie on 2019/6/3.
//  Copyright © 2019年 Love Charlie. All rights reserved.
//

#import "CQHConfig.h"

@implementation CQHConfig


+ (instancetype)sharedConfig {
    static CQHConfig *sharedConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConfig = [[self alloc] init];
    });
    return sharedConfig;
}

@end
