//
//  ViewController.m
//  WaveSDKDemo
//
//  Created by Love Charlie on 2020/3/11.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "ViewController.h"

#import <WaveSDK/WSDK.h>

@interface ViewController ()<WAVESDKDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor redColor]];
//    [WSDK showHUDView];
    [WSDK sharedCQHSDK].delegate = self;
    
}

- (void)loginSuccessWithResponse:(id)response
{
    NSLog(@"%@,登录成功",response);
}

- (void)loginFailed
{
    NSLog(@"登录失败");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [WSDK wechatLogin];
    [WSDK payAppleWithServerId:@"1" andServerName:@"1" andProductName:@"1" andProductPrice:@"1" andProductCode:@"1" andCpOrderId:@"1" andRoleId:@"1" andRoleName:@"1" andRoleLevel:@"1" andRoleCreateTime:@"1" andNotifyUrl:@"" andExtendParams:@"1" andProduceCode:@"com.klw.game"];
}


@end
