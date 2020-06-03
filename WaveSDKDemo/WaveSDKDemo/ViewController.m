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
//    [WSDK wechatLogin];
    [WSDK payAppleWithServerId:@"1" andServerName:@"1" andProductName:@"com.klw.game" andProductPrice:@"1" andProductCode:@"1" andCpOrderId:@"1" andRoleId:@"1" andRoleName:@"1" andRoleLevel:@"1" andRoleCreateTime:@"1" andNotifyUrl:@"" andExtendParams:@"1" andProduceCode:@"com.klw.game"];
}


@end
