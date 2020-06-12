//
//  ViewController.m
//  WaveSDKDemo
//
//  Created by Love Charlie on 2020/3/11.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "ViewController.h"

#import <WaveSDK/WSDK.h>
//#import <AuthenticationServices/AuthenticationServices.h>

@interface ViewController ()<WAVESDKDelegate>

@end

@implementation ViewController

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor redColor]];
//    [WSDK showHUDView];
    [WSDK sharedCQHSDK].delegate = self;
    
//    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
//    NSLog(@"%@",NSStringFromCGRect(statusBarFrame));
//    UIView *view =[UIView new];
//    [view setBackgroundColor:[UIColor greenColor]];
//    view.frame = CGRectMake(0, statusBarFrame.size.height, statusBarFrame.size.width, 44);
//    [self.view addSubview:view];
    
    CQHConfig *config = [CQHConfig sharedConfig];
    //    config.gameId = @"1132";
    //    config.packageId = @"100";
    //    config.channelId = @"100002";
    //    config.key = @"cvFbf3rdmTqcpQWSTu5eIG8Av5L17Flv";
    //    config.configId = @"0";
    //    config.appleID = @"wx343790ea3256d6dc";
        
        config.gameId = @"1166";
        config.packageId = @"100";
        config.channelId = @"ios1";
        config.key = @"zvqt9jcAhbRHRQFBKRV1j0BaB0aoNQY6";
        config.configId = @"0";
        config.appleID = @"wx343790ea3256d6dc";
        [WSDK initWithSDKWithConfig:config];
    
}

//初始化成功
- (void)initSDKWithSuccess
{
    //登陆
    [WSDK cqhLogin];

}

//初始化失败
- (void)initSDKWithFailed
{
    
}
- (void)loginSuccessWithResponse:(id)response
{
    NSLog(@"%s,%@,登录成功",__func__,response);
}

- (void)loginFailed
{
    NSLog(@"%s,登录失败",__func__);
}

- (void)pSuccess
{
    NSLog(@"%s,支付成功",__func__);
}

- (void)pFailed
{
     NSLog(@"%s,支付失败",__func__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [WSDK appleLogin];
//    [WSDK wechatLogin];
    
//    [WSDK payAppleWithServerId:@"1" andServerName:@"1" andProductName:@"60元宝" andProductPrice:@"1" andProductCode:@"1" andCpOrderId:@"1" andRoleId:@"1" andRoleName:@"1" andRoleLevel:@"1" andRoleCreateTime:@"1" andNotifyUrl:@"" andExtendParams:@"1" andProduceCode:@"com.klw.game"];
    [WSDK payAppleWithServerId:@"1" andServerName:@"测试1服" andProductName:@"60元宝" andProductPrice:@"1" andProductCode:@"fengshen_yuanbao6" andCpOrderId:@"00000043000010150602200006072629" andRoleId:@"101506" andRoleName:@"ha" andRoleLevel:@"1" andRoleCreateTime:@"1591944014" andNotifyUrl:@"" andExtendParams:@"00000043000010150602200006072629" andProduceCode:@"fengshen_yuanbao6"];
    
    NSInteger a = 1;
    
    NSNumber *longNumber = [NSNumber numberWithLong:a];
    NSString *longStr = [longNumber stringValue];
//    NSString *b = [NSString stringWithFormat:@"%d",a];
    NSLog(@"%@",longStr);
}

@end
