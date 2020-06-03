//
//  CQHUserModel.m
//  WaveSDK
//
//  Created by Love Charlie on 2020/4/13.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "CQHUserModel.h"

@implementation CQHUserModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.accountName forKey:@"accountName"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.md5Password forKey:@"md5Password"];
    [aCoder encodeObject:self.isWX forKey:@"isWX"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.accountName = [aDecoder decodeObjectForKey:@"accountName"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.md5Password = [aDecoder decodeObjectForKey:@"md5Password"];
        self.isWX = [aDecoder decodeObjectForKey:@"isWX"];
    }
    return self;
}

@end
