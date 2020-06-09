//
//  CQHConfig.h
//  CQHTCSDK
//
//  Created by Love Charlie on 2019/6/3.
//  Copyright © 2019年 Love Charlie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQHConfig : NSObject
//init SDK
//+ (void)initWithSDKWithGameId:(NSString *)gameId andPackageId:(NSString *)packageId andChannelId:(NSString *)channelId andKey:(NSString *)key;

@property(nonatomic , copy) NSString *gameId;
@property(nonatomic , copy) NSString *packageId;
@property(nonatomic , copy) NSString *channelId;
@property(nonatomic , copy) NSString *key;
@property(nonatomic , copy) NSString *configId;
@property(nonatomic , copy) NSString *appleID;


+ (instancetype)sharedConfig;
@end
