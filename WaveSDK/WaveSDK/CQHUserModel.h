//
//  CQHUserModel.h
//  WaveSDK
//
//  Created by Love Charlie on 2020/4/13.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQHUserModel : NSObject

@property (nonatomic , copy) NSString *username;
@property (nonatomic , copy) NSString *password;
@property (nonatomic , copy) NSString *userId;

@property (nonatomic , copy) NSString *accountName;
@property (nonatomic , copy) NSString *md5Password;

@property (nonatomic , copy) NSString *isWX;
@property (nonatomic , copy) NSString *isAppleLogin;

@end
