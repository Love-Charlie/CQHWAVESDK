//
//  CQHPhontLoginView.m
//  WaveSDK
//
//  Created by Love Charlie on 2020/3/30.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "CQHPhontLoginView.h"
#import "UIView+Frame.h"
#import "CQHTools.h"
#import "CQHKeyboardProcess.h"
#import "CQHMainLoginView.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CQHTools.h"
#import "WSDK.h"
#import "CQHHUDView.h"
#import <objc/runtime.h>

@interface CQHPhontLoginView()
@property (nonatomic , weak) UILabel *registerLabel ;
@property (nonatomic , weak) UIButton *backBtn ;
@property (nonatomic , weak) UIView *line;
@property (nonatomic , weak) UITextField *phoneTF;
@property (nonatomic , weak) UILabel *desLabel;
@property (nonatomic , weak) UIImageView *imageView;
@property (nonatomic , weak) UITextField *verificationCodeTF;
@property (nonatomic , weak) UIButton *verificationCodeBtn;
@property (nonatomic , weak) UITextField *passwordTF;
@property (nonatomic , weak) UIButton *regAndLoginBtn;
@property (nonatomic , strong) CQHKeyboardProcess *process;
@property (nonatomic, strong)dispatch_source_t time;//定时器
@end

@implementation CQHPhontLoginView

//解决AFN内存泄露的问题，使用单例模式解决
static AFHTTPSessionManager *manager ;
- (AFHTTPSessionManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 20;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"text/json",@"text/javascript", nil];
    });
    return manager;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CQHKeyboardProcess *process = [[CQHKeyboardProcess alloc] init];
        _process = process;
        [process changeFrameWithView:[CQHMainLoginView sharedMainLoginView]];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        
        UILabel *registerLabel = [[UILabel alloc] init];
        _registerLabel = registerLabel;
        [registerLabel setText:@"手机注册"];
        [registerLabel setFont:[UIFont systemFontOfSize:17.0]];
        [registerLabel setTextColor:[UIColor darkGrayColor]];
        [registerLabel sizeToFit];
        
        [self addSubview:registerLabel];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = backBtn;
        [backBtn setImage:[CQHTools bundleForImage:@"箭头" packageName:@""] forState:UIControlStateNormal];
        [self addSubview:backBtn];
        
        
        UIView *line = [[UIView alloc] init];
        _line = line;
        [line setBackgroundColor:[UIColor lightGrayColor]];
        line.alpha = 0.5;
        [self addSubview:line];
        
        
        /***************************************************************************************************/
        UITextField *phoneTF = [[UITextField alloc] init];
        phoneTF.textColor = [UIColor blackColor];
        phoneTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        UIImageView *leftView1 = [[UIImageView alloc] init];
        [leftView1 setImage:[CQHTools bundleForImage:@"手机icon深色" packageName:@""]];
        leftView1.frame =CGRectMake(0, 0, 15, 15);
        phoneTF.leftView = leftView1;
        phoneTF.leftViewMode = UITextFieldViewModeAlways;
        
        [phoneTF setBackgroundColor:[UIColor whiteColor]];
        phoneTF.layer.cornerRadius = 6.0;
        phoneTF.layer.borderColor= [UIColor lightGrayColor].CGColor;
        phoneTF.layer.borderWidth= 1.0f;
        phoneTF.layer.masksToBounds = YES;
        phoneTF.tintColor = [UIColor colorWithRed:214.0/255.0 green:6.0/255.0 blue:0/255.0 alpha:1];
        _phoneTF = phoneTF;
        phoneTF.placeholder=@" 请输入手机号";
//        [phoneTF setValue:[UIFont boldSystemFontOfSize:12.0] forKeyPath:@"_placeholderLabel.font"];
        
        Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel = object_getIvar(phoneTF, ivar);
        placeholderLabel.textColor = [UIColor lightGrayColor];
        placeholderLabel.text = @" 请输入手机号";
        [placeholderLabel setFont:[UIFont systemFontOfSize:12.0]];
        
        UIView *contentLeftView1 = [[UIView alloc] init];
        [contentLeftView1 setBackgroundColor:[UIColor whiteColor]];
        contentLeftView1.frame = CGRectMake(0, 0, 30*W_Adapter, 30*W_Adapter);
        
        
        UIButton *usernameTFLeftView1 = [[UIButton alloc] init];
        usernameTFLeftView1.frame = CGRectMake(5*W_Adapter, 5*W_Adapter, 20*W_Adapter, 20*W_Adapter);
        [usernameTFLeftView1 setImage:[CQHTools bundleForImage:@"手机icon深色" packageName:@""] forState:UIControlStateNormal];
        
        [contentLeftView1 addSubview:usernameTFLeftView1];
        phoneTF.leftView = contentLeftView1;
        phoneTF.leftViewMode = UITextFieldViewModeAlways;
        
        
        UIButton *usernameTFRightView1 = [[UIButton alloc] init];
        usernameTFRightView1.frame = CGRectMake(0, 0, 15*W_Adapter, 15*H_Adapter);
        [usernameTFRightView1 setImage:[CQHTools bundleForImage:@"6" packageName:@"1"] forState:UIControlStateNormal];
        [self addSubview:phoneTF];
         /***************************************************************************************************/
       
        
        UILabel *desLabel = [[UILabel alloc] init];
        desLabel.numberOfLines = 0;
        _desLabel = desLabel;
        desLabel.text = @"您的隐私将受到保护,手机号码仅会用于账号登录及密码找回";
        [desLabel setFont:[UIFont systemFontOfSize:8.0]];
//        [desLabel setLineBreakMode:NSLineBreakByWordWrapping];
        desLabel.textColor = [UIColor colorWithRed:226/255.0 green:88/255.0 blue:65/255.0 alpha:1];
        CGSize constraint = CGSizeMake(300, 20000.0f);
        [desLabel sizeToFit];
        [self addSubview:desLabel];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
        [imageView setImage:[CQHTools bundleForImage:@"icon" packageName:@""]];
        [self addSubview:imageView];
        
         /***************************************************************************************************/
        
        UITextField *verificationCodeTF = [[UITextField alloc] init];
        verificationCodeTF.textColor = [UIColor blackColor];
        _verificationCodeTF = verificationCodeTF;
        [verificationCodeTF setBackgroundColor:[UIColor whiteColor]];
        verificationCodeTF.layer.cornerRadius = 6.0;
        verificationCodeTF.layer.borderColor= [UIColor lightGrayColor].CGColor;
        verificationCodeTF.layer.borderWidth= 1.0f;
        verificationCodeTF.layer.masksToBounds = YES;
        verificationCodeTF.tintColor = [UIColor colorWithRed:214.0/255.0 green:6.0/255.0 blue:0/255.0 alpha:1];
        verificationCodeTF.placeholder=@" 请输入验证码";
//        [verificationCodeTF setValue:[UIFont boldSystemFontOfSize:12.0] forKeyPath:@"_placeholderLabel.font"];
        
        Ivar ivar1 =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel1 = object_getIvar(verificationCodeTF, ivar1);
        placeholderLabel1.textColor = [UIColor lightGrayColor];
        placeholderLabel1.text = @" 请输入验证码";
        [placeholderLabel1 setFont:[UIFont systemFontOfSize:12.0]];
        
        UIView *contentLeftView2 = [[UIView alloc] init];
        [contentLeftView2 setBackgroundColor:[UIColor whiteColor]];
        contentLeftView2.frame = CGRectMake(0, 0, 30*W_Adapter, 30*W_Adapter);
        
        
        UIButton *usernameTFLeftView2 = [[UIButton alloc] init];
        usernameTFLeftView2.frame = CGRectMake(5*W_Adapter, 5*W_Adapter, 20*W_Adapter, 20*W_Adapter);
        [usernameTFLeftView2 setImage:[CQHTools bundleForImage:@"验证码icon" packageName:@""] forState:UIControlStateNormal];
        
        [contentLeftView2 addSubview:usernameTFLeftView2];
        verificationCodeTF.leftView = contentLeftView2;
        verificationCodeTF.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:verificationCodeTF];
        /***************************************************************************************************/
        UIButton *verificationCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [verificationCodeBtn addTarget:self action:@selector(verificationCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        verificationCodeBtn.layer.cornerRadius = 5.0;
        verificationCodeBtn.layer.masksToBounds = YES;
        [verificationCodeBtn  setBackgroundColor:[UIColor colorWithRed:226/255.0 green:88/255.0 blue:65/255.0 alpha:1]];
        [verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [verificationCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        _verificationCodeBtn = verificationCodeBtn;
        [verificationCodeTF addSubview:verificationCodeBtn];
        /***************************************************************************************************/
        UITextField *passwordTF = [[UITextField alloc] init];
        passwordTF.textColor = [UIColor blackColor];
        passwordTF.secureTextEntry = YES;
        _passwordTF = passwordTF;
        [passwordTF setBackgroundColor:[UIColor whiteColor]];
        passwordTF.layer.cornerRadius = 6.0;
        passwordTF.layer.borderColor= [UIColor lightGrayColor].CGColor;
        passwordTF.layer.borderWidth= 1.0f;
        passwordTF.layer.masksToBounds = YES;
        passwordTF.tintColor = [UIColor colorWithRed:214.0/255.0 green:6.0/255.0 blue:0/255.0 alpha:1];
        passwordTF.placeholder=@" 请输入密码";
//        [passwordTF setValue:[UIFont boldSystemFontOfSize:12.0] forKeyPath:@"_placeholderLabel.font"];
        
        Ivar ivar2 =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel2 = object_getIvar(passwordTF, ivar2);
        placeholderLabel2.textColor = [UIColor lightGrayColor];
        placeholderLabel2.text = @" 请输入密码";
        [placeholderLabel2 setFont:[UIFont systemFontOfSize:12.0]];
        
        UIView *contentLeftView3 = [[UIView alloc] init];
        [contentLeftView3 setBackgroundColor:[UIColor whiteColor]];
        contentLeftView3.frame = CGRectMake(0, 0, 30*W_Adapter, 30*W_Adapter);
        
        
        UIButton *usernameTFLeftView3 = [[UIButton alloc] init];
        usernameTFLeftView3.frame = CGRectMake(5*W_Adapter, 5*W_Adapter, 20*W_Adapter, 20*W_Adapter);
        [usernameTFLeftView3 setImage:[CQHTools bundleForImage:@"密码icon深色" packageName:@""] forState:UIControlStateNormal];
        
        [contentLeftView3 addSubview:usernameTFLeftView3];
        passwordTF.leftView = contentLeftView3;
        passwordTF.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:passwordTF];
        /***************************************************************************************************/
        UIButton *regAndLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [regAndLoginBtn addTarget:self action:@selector(regAndLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        regAndLoginBtn.layer.cornerRadius = 6.0;
        regAndLoginBtn.layer.masksToBounds = YES;
        [regAndLoginBtn setTitle:@"注册并登录" forState:UIControlStateNormal];
        [regAndLoginBtn setBackgroundColor:[UIColor colorWithRed:216/255.0 green:58/255.0 blue:41/255.0 alpha:1]];
        [regAndLoginBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        _regAndLoginBtn = regAndLoginBtn;
        [self addSubview:regAndLoginBtn];
    }
    return self;
}

- (void)regAndLoginBtnClick:(UIButton *)btn
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //随机数
    NSString *nonceStr = [CQHTools randomNumber];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"sdkVersion"]=sdkVersion;
    dict[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
    dict[@"deviceType"]= @"1";
    dict[@"gameId"]=[userDefaults objectForKey:GAMEID];
    dict[@"platformCode"]=PLATFORMCODE;
    dict[@"nonceStr"]=nonceStr;
    dict[@"mobile"] = self.phoneTF.text;
    dict[@"password"] =  [CQHTools jiami:self.passwordTF.text];
    dict[@"captcha"] = self.verificationCodeTF.text;
    dict[@"channelId"] = [userDefaults objectForKey:CHANNELID];
    
    NSString *stringA = [CQHTools sortArrWithDictionary:dict];
    //sign
    NSString *sign = [NSString stringWithFormat:@"%@&key=%@",stringA,[userDefaults objectForKey:SIGNKEY]];
    //sign md5签名
    NSString *md5String = [CQHTools md5:sign];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[@"sdkVersion"]=sdkVersion;
    dict1[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
    dict1[@"deviceType"]= @"1";
    dict1[@"gameId"]=[userDefaults objectForKey:GAMEID];
    dict1[@"platformCode"]=PLATFORMCODE;
    dict1[@"nonceStr"]=nonceStr;
    dict1[@"mobile"] = self.phoneTF.text;
    dict1[@"password"] =  [CQHTools jiami:self.passwordTF.text];
    dict1[@"captcha"] = self.verificationCodeTF.text;
    dict1[@"channelId"] = [userDefaults objectForKey:CHANNELID];
    dict1[@"sign"] = md5String;
    
    NSString *dictString = [CQHTools convertToJsonData:dict1];
    NSString *base64String = [CQHTools base64EncodeString:dictString];
    
    //字符串前两位
    NSString *qianStr = [base64String substringToIndex:2];
    //字符串第六位开始后面的字符
    NSString *houStr = [base64String substringFromIndex:6];
    NSMutableString *newStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@%@",qianStr,houStr]];
    NSString *jiequStr = [CQHTools stringJieQu:base64String];
    [newStr insertString:jiequStr atIndex:newStr.length - 2];
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    dict3[@"data"] = newStr;
    
    //    CQHNetworkingTools *tools =  [self sharedSingleton];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    hud.label.text = NSLocalizedString(@"验证中...", @"HUD loading title");
    WSDK *wsdk = [WSDK sharedCQHSDK];
    [[self sharedManager] POST:[NSString stringWithFormat:@"%@sdk/mobile/register?data=%@",BASE_URL,newStr] parameters:dict3 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [userDefaults setObject:responseObject[@"data"][@"userId"] forKey:@"userId"];
            [userDefaults synchronize];
            
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
            hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(responseObject[@"message"], @"HUD message title");
            [hud hideAnimated:YES afterDelay:1.f];
            //            [WSDK showHUDView];
            
            [self removeFromSuperview];
//            [[CQHMainLoginView sharedMainLoginView] removeFromSuperview];
            [[CQHHUDView shareHUDView] removeFromSuperview];
            
            if ([wsdk.delegate respondsToSelector:@selector(loginSuccessWithResponse:)]) {
                [wsdk.delegate loginSuccessWithResponse:responseObject[@"data"]];
                
                if ([responseObject[@"data"][@"authStatus"] integerValue] == 1) {
                    
                    if ([responseObject[@"data"][@"authInfo"][@"idno"] isEqualToString:@""]) {
                        NSLog(@"没有认证");
                        //
//                        [CQHHUDView sharedCQHVerView];
                        [CQHHUDView showVerView];
                    }
                }
            }
            
            
//            if ([responseObject[@"mobileStatus"] integerValue] == 0) {
//                //手机号没有注册
//            }else if ([responseObject[@"mobileStatus"] integerValue] == 1){
//                //手机号已经注册
//            }else{
//                [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
//                hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
//                hud.mode = MBProgressHUDModeText;
//                hud.label.text = NSLocalizedString(@"验证手机号失败", @"HUD message title");
//                [hud hideAnimated:YES afterDelay:1.f];
//            }
        }else{
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
            hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(responseObject[@"message"], @"HUD message title");
            [hud hideAnimated:YES afterDelay:1.f];
            if ([wsdk.delegate respondsToSelector:@selector(loginFailed)]) {
                [wsdk.delegate loginFailed];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
        hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请查看网络连接!", @"HUD message title");
        [hud hideAnimated:YES afterDelay:1.f];
        if ([wsdk.delegate respondsToSelector:@selector(loginFailed)]) {
            [wsdk.delegate loginFailed];
        }
    }];
}

- (void)verificationCodeBtnClick:(UIButton *)btn
{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//
//    //随机数
//    NSString *nonceStr = [CQHTools randomNumber];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"sdkVersion"]=sdkVersion;
//    dict[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
//    dict[@"gameId"]=[userDefaults objectForKey:GAMEID];
//    dict[@"platformCode"]=PLATFORMCODE;
//    dict[@"nonceStr"]=nonceStr;
//    dict[@"mobile"] = self.phoneTF.text;
//    dict[@"activeCode"] = ACTIVECODE;
//    NSString *stringA = [CQHTools sortArrWithDictionary:dict];
//    //sign
//    NSString *sign = [NSString stringWithFormat:@"%@&key=%@",stringA,[userDefaults objectForKey:SIGNKEY]];
//    //sign md5签名
//    NSString *md5String = [CQHTools md5:sign];
//
//    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
//    dict1[@"sdkVersion"]=sdkVersion;
//    dict1[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
//    dict1[@"gameId"]=[userDefaults objectForKey:GAMEID];
//    dict1[@"platformCode"]=PLATFORMCODE;
//    dict1[@"nonceStr"]=nonceStr;
//    dict1[@"mobile"] = self.phoneTF.text;
//    dict1[@"activeCode"] = ACTIVECODE;
//    dict1[@"sign"] = md5String;
//
//    NSString *dictString = [CQHTools convertToJsonData:dict1];
//    NSString *base64String = [CQHTools base64EncodeString:dictString];
//
//    //字符串前两位
//    NSString *qianStr = [base64String substringToIndex:2];
//    //字符串第六位开始后面的字符
//    NSString *houStr = [base64String substringFromIndex:6];
//    NSMutableString *newStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@%@",qianStr,houStr]];
//    NSString *jiequStr = [CQHTools stringJieQu:base64String];
//    [newStr insertString:jiequStr atIndex:newStr.length - 2];
//    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
//    dict3[@"data"] = newStr;
//
//    //    CQHNetworkingTools *tools =  [self sharedSingleton];
//
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
//    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
//    hud.label.text = NSLocalizedString(@"验证中...", @"HUD loading title");
//
//    [[self sharedManager] POST:[NSString stringWithFormat:@"%@sdk/mobile/verify?data=%@",BASE_URL,newStr] parameters:dict3 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        [hud hideAnimated:YES];
//        if ([responseObject[@"code"] integerValue] == 200) {
//
//            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
//            hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
//            hud.mode = MBProgressHUDModeText;
//            hud.label.text = NSLocalizedString(responseObject[@"message"], @"HUD message title");
//            [hud hideAnimated:YES afterDelay:1.f];
////            [WSDK showHUDView];
//
//            if ([responseObject[@"mobileStatus"] integerValue] == 0) {
//                //手机号没有注册
//            }else if ([responseObject[@"mobileStatus"] integerValue] == 1){
//                //手机号已经注册
//            }else{
//                [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
//                hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
//                hud.mode = MBProgressHUDModeText;
//                hud.label.text = NSLocalizedString(@"验证手机号失败", @"HUD message title");
//                [hud hideAnimated:YES afterDelay:1.f];
//            }
//        }else{
//            //            [view removeFromSuperview];
//            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
//            hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
//            hud.mode = MBProgressHUDModeText;
//            hud.label.text = NSLocalizedString(responseObject[@"message"], @"HUD message title");
//            [hud hideAnimated:YES afterDelay:1.f];
//
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
//        [hud hideAnimated:YES];
//        //        [view removeFromSuperview];
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
//        hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
//        hud.mode = MBProgressHUDModeText;
//        hud.label.text = NSLocalizedString(@"请查看网络连接!", @"HUD message title");
//        [hud hideAnimated:YES afterDelay:1.f];
//
//    }];
    
    NSString *newCodeStr= [self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!(newCodeStr.length == 11) ) {
        [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
        hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请输入11位正确手机号", @"HUD message title");
        [hud hideAnimated:YES afterDelay:1.f];
        return;
    }
    __block NSInteger count = VerTime;
    //获得队列
    //    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个定时器
    self.time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(1.0* NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(self.time, start, interval, 0);
    //设置回调
    dispatch_source_set_event_handler(self.time, ^{
        //设置当执行五次是取消定时器
        count--;
        [btn setTitle:[NSString stringWithFormat:@"剩余%ld秒",(long)count] forState:UIControlStateNormal];
        btn.enabled = NO;
        if(count == 0){
            [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
            dispatch_cancel(self.time);
            btn.enabled = YES;
        }
    });
    //由于定时器默认是暂停的所以我们启动一下
    //启动定时器
    dispatch_resume(self.time);
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //随机数
    NSString *nonceStr = [CQHTools randomNumber];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"sdkVersion"]=sdkVersion;
    dict[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
    dict[@"gameId"]=[userDefaults objectForKey:GAMEID];
    dict[@"platformCode"]=PLATFORMCODE;
    dict[@"nonceStr"]=nonceStr;
    dict[@"mobile"] = self.phoneTF.text;
    dict[@"activeCode"] = ACTIVECODE;
    NSString *stringA = [CQHTools sortArrWithDictionary:dict];
    //sign
    NSString *sign = [NSString stringWithFormat:@"%@&key=%@",stringA,[userDefaults objectForKey:SIGNKEY]];
    //sign md5签名
    NSString *md5String = [CQHTools md5:sign];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[@"sdkVersion"]=sdkVersion;
    dict1[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
    dict1[@"gameId"]=[userDefaults objectForKey:GAMEID];
    dict1[@"platformCode"]=PLATFORMCODE;
    dict1[@"nonceStr"]=nonceStr;
    dict1[@"mobile"] = self.phoneTF.text;
    dict1[@"activeCode"] = ACTIVECODE;
    dict1[@"sign"] = md5String;
    
    NSString *dictString = [CQHTools convertToJsonData:dict1];
    NSString *base64String = [CQHTools base64EncodeString:dictString];
    
    //字符串前两位
    NSString *qianStr = [base64String substringToIndex:2];
    //字符串第六位开始后面的字符
    NSString *houStr = [base64String substringFromIndex:6];
    NSMutableString *newStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@%@",qianStr,houStr]];
    NSString *jiequStr = [CQHTools stringJieQu:base64String];
    [newStr insertString:jiequStr atIndex:newStr.length - 2];
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    dict3[@"data"] = newStr;
    
    //    CQHNetworkingTools *tools =  [self sharedSingleton];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    hud.label.text = NSLocalizedString(@"验证中...", @"HUD loading title");
    
    [[self sharedManager] POST:[NSString stringWithFormat:@"%@sdk/sms/code?data=%@",BASE_URL,newStr] parameters:dict3 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
            hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(responseObject[@"message"], @"HUD message title");
            [hud hideAnimated:YES afterDelay:1.f];
            //            [WSDK showHUDView];
            
            if ([responseObject[@"mobileStatus"] integerValue] == 0) {
                //手机号没有注册
            }else if ([responseObject[@"mobileStatus"] integerValue] == 1){
                //手机号已经注册
            }else{
                [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
                hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"验证手机号失败", @"HUD message title");
                [hud hideAnimated:YES afterDelay:1.f];
            }
        }else{
            //            [view removeFromSuperview];
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
            hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(responseObject[@"message"], @"HUD message title");
            [hud hideAnimated:YES afterDelay:1.f];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
        [hud hideAnimated:YES];
        //        [view removeFromSuperview];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
        hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请查看网络连接!", @"HUD message title");
        [hud hideAnimated:YES afterDelay:1.f];
        
    }];
}

- (void)backBtnClick:(UIButton *)btn
{
    [self removeFromSuperview];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _registerLabel.frame = CGRectMake((self.width -_registerLabel.width)*0.5 , 20, _registerLabel.width, _registerLabel.height);
    _backBtn.frame = CGRectMake(25*W_Adapter, 20, _registerLabel.height , _registerLabel.height);
    _line.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_registerLabel.frame)+20, self.width - 50*W_Adapter, 1);
    _phoneTF.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_line.frame)+15, self.width - 50*W_Adapter, 40*H_Adapter);
    _desLabel.frame = CGRectMake(40*W_Adapter, CGRectGetMaxY(_phoneTF.frame)+10, self.width - 50*W_Adapter-_desLabel.height, _desLabel.height);
    _imageView.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_phoneTF.frame)+10,  _desLabel.height,  _desLabel.height);
    _verificationCodeTF.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_desLabel.frame)+10, self.width - 50*W_Adapter, 40*H_Adapter);
    _verificationCodeBtn.frame = CGRectMake(_verificationCodeTF.width*0.7-3 , 5*H_Adapter, _verificationCodeTF.width*0.3-3, 30*H_Adapter);
    _passwordTF.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_verificationCodeTF.frame)+20, self.width - 50*W_Adapter, 40*H_Adapter);
//    _regAndLoginBtn.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_passwordTF.frame)+20*H_Adapter, self.width - 50*W_Adapter, 40*H_Adapter);
    _regAndLoginBtn.frame = CGRectMake(25*W_Adapter, (self.width - CGRectGetMaxY(_passwordTF.frame)- self.height/7.0)*0.5+CGRectGetMaxY(_passwordTF.frame), self.width - 50*W_Adapter, self.height/7.0);
}

@end
