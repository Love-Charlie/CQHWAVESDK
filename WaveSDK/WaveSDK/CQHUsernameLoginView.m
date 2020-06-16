//
//  CQHUsernameLoginView.m
//  WaveSDK
//
//  Created by Love Charlie on 2020/3/30.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "CQHUsernameLoginView.h"
#import "CQHTools.h"
#import "UIView+Frame.h"
#import "CQHRegisterView.h"
#import "CQHForgetPasswordView.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "WSDK.h"
#import "CQHMainLoginView.h"
#import "CQHHUDView.h"
#import "CQHUserModel.h"
#import "JQFMDB.h"
#import <objc/runtime.h>


@interface CQHUsernameLoginView()<UITextFieldDelegate>
@property (nonatomic , weak)  UIImageView *imageView;
@property (nonatomic , weak)  UIView *line;
@property (nonatomic , weak) UIButton *backBtn ;
@property (nonatomic , weak) UITextField *usernameTF ;
@property (nonatomic , weak) UITextField *passwordTF ;
@property (nonatomic , weak) UIButton *loginBtn ;
@property (nonatomic , weak) UIButton *forgetBtn;
@property (nonatomic , weak) UIButton *registerBtn;
@end

@implementation CQHUsernameLoginView

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
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
        [imageView setImage:[CQHTools bundleForImage:@"logo-en" packageName:@""]];
        UIImage *image = [CQHTools bundleForImage:@"logo-en" packageName:@""];
        [imageView sizeToFit];
        imageView.frame = CGRectMake(self.width*0.5/3.0 , 10, self.width*2.0/3.0, self.width*2.0/3.0 *image.size.height/image.size.width);
        [self addSubview:imageView];
        
        UIView *line = [[UIView alloc] init];
        _line = line;
        [line setBackgroundColor:[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:0.8]];
        line.frame = CGRectMake(20, CGRectGetMaxY(imageView.frame), self.width - 40, 1);
        [self addSubview:line];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[CQHTools bundleForImage:@"箭头" packageName:@""] forState:UIControlStateNormal];
        [backBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [backBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = backBtn;
        [self addSubview:backBtn];
        
        UITextField *usernameTF = [[UITextField alloc] init];
        usernameTF.returnKeyType = UIReturnKeyNext;
        usernameTF.delegate = self;
        usernameTF.textColor = [UIColor blackColor];
        usernameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _usernameTF = usernameTF;
        UIImageView *leftView = [[UIImageView alloc] init];
        [leftView setImage:[CQHTools bundleForImage:@"账号icon深色" packageName:@""]];
        leftView.frame =CGRectMake(0, 0, 15, 15);
        usernameTF.leftView = leftView;
        usernameTF.leftViewMode = UITextFieldViewModeAlways;
        
        [usernameTF setBackgroundColor:[UIColor whiteColor]];
        usernameTF.layer.cornerRadius = 6.0;
        usernameTF.layer.borderColor= [UIColor lightGrayColor].CGColor;
        usernameTF.layer.borderWidth= 1.0f;
        usernameTF.layer.masksToBounds = YES;
        usernameTF.tintColor = [UIColor colorWithRed:214/255.0 green:6/255.0 blue:0/255.0 alpha:1];
        _usernameTF = usernameTF;
        usernameTF.placeholder=@" 请输入账号";
//        [usernameTF setValue:[UIFont boldSystemFontOfSize:12.0] forKeyPath:@"_placeholderLabel.font"];
        
        Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel = object_getIvar(usernameTF, ivar);
        placeholderLabel.textColor = [UIColor lightGrayColor];
        placeholderLabel.text = @" 请输入账号";
        [placeholderLabel setFont:[UIFont systemFontOfSize:12.0]];
        
        UIView *contentLeftView = [[UIView alloc] init];
        [contentLeftView setBackgroundColor:[UIColor whiteColor]];
        contentLeftView.frame = CGRectMake(0, 0, 30*W_Adapter, 30*W_Adapter);
        
        
        UIButton *usernameTFLeftView = [[UIButton alloc] init];
        usernameTFLeftView.frame = CGRectMake(5*W_Adapter, 5*W_Adapter, 20*W_Adapter, 20*W_Adapter);
        [usernameTFLeftView setImage:[CQHTools bundleForImage:@"账号icon深色" packageName:@""] forState:UIControlStateNormal];
        
        [contentLeftView addSubview:usernameTFLeftView];
//        usernameTF.leftView = usernameTFLeftView;
        usernameTF.leftView = contentLeftView;
        usernameTF.leftViewMode = UITextFieldViewModeAlways;
        
        
        UIButton *usernameTFRightView = [[UIButton alloc] init];
//        _usernameTFRightView = usernameTFRightView;
        usernameTFRightView.frame = CGRectMake(0, 0, 15*W_Adapter, 15*H_Adapter);
        [usernameTFRightView setImage:[CQHTools bundleForImage:@"6" packageName:@"1"] forState:UIControlStateNormal];
//        usernameTF.rightView = usernameTFRightView;
//        usernameTF.rightViewMode = UITextFieldViewModeAlways;
//        [usernameTFRightView addTarget:self action:@selector(xialaBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:usernameTF];
        
        
        /*******************************************************************************************************/
        UITextField *passwordTF = [[UITextField alloc] init];
        passwordTF.returnKeyType = UIReturnKeyDone;
        passwordTF.delegate = self;
        passwordTF.secureTextEntry = YES;
    
        passwordTF.textColor = [UIColor blackColor];
        passwordTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        UIImageView *leftView1 = [[UIImageView alloc] init];
        [leftView1 setImage:[CQHTools bundleForImage:@"账号icon深色" packageName:@""]];
        leftView1.frame =CGRectMake(0, 0, 15, 15);
        passwordTF.leftView = leftView1;
        passwordTF.leftViewMode = UITextFieldViewModeAlways;
        
        [passwordTF setBackgroundColor:[UIColor whiteColor]];
        passwordTF.layer.cornerRadius = 6.0;
        passwordTF.layer.borderColor= [UIColor lightGrayColor].CGColor;
        passwordTF.layer.borderWidth= 1.0f;
        passwordTF.layer.masksToBounds = YES;
        passwordTF.tintColor = [UIColor colorWithRed:214.0/255.0 green:6.0/255.0 blue:0/255.0 alpha:1];
        _passwordTF = passwordTF;
        passwordTF.placeholder=@" 请输入密码";
//        [passwordTF setValue:[UIFont boldSystemFontOfSize:12.0] forKeyPath:@"_placeholderLabel.font"];
        Ivar ivar1 =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel1 = object_getIvar(passwordTF, ivar1);
        placeholderLabel1.text = @" 请输入密码";
        placeholderLabel1.textColor = [UIColor lightGrayColor];
        [placeholderLabel1 setFont:[UIFont systemFontOfSize:12.0]];
        
        UIView *contentLeftView1 = [[UIView alloc] init];
        [contentLeftView1 setBackgroundColor:[UIColor whiteColor]];
        contentLeftView1.frame = CGRectMake(0, 0, 30*W_Adapter, 30*W_Adapter);
        
        
        UIButton *usernameTFLeftView1 = [[UIButton alloc] init];
        usernameTFLeftView1.frame = CGRectMake(5*W_Adapter, 5*W_Adapter, 20*W_Adapter, 20*W_Adapter);
        [usernameTFLeftView1 setImage:[CQHTools bundleForImage:@"密码icon深色" packageName:@""] forState:UIControlStateNormal];
        
        [contentLeftView1 addSubview:usernameTFLeftView1];
        passwordTF.leftView = contentLeftView1;
        passwordTF.leftViewMode = UITextFieldViewModeAlways;
        
        
        UIButton *usernameTFRightView1 = [[UIButton alloc] init];
        usernameTFRightView1.frame = CGRectMake(0, 0, 15*W_Adapter, 15*H_Adapter);
        [usernameTFRightView1 setImage:[CQHTools bundleForImage:@"6" packageName:@"1"] forState:UIControlStateNormal];
        [self addSubview:passwordTF];
        
        /*******************************************************************************************************/
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn = loginBtn;
        [loginBtn setBackgroundColor:[UIColor colorWithRed:216/255.0 green:58/255.0 blue:41/255.0 alpha:1]];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        loginBtn.layer.cornerRadius = 5.0;
        loginBtn.layer.masksToBounds = YES;
        [self addSubview:loginBtn];
        /*******************************************************************************************************/
        UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [forgetBtn addTarget:self action:@selector(forgetBtn:) forControlEvents:UIControlEventTouchUpInside];
        _forgetBtn = forgetBtn;
        [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [forgetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [forgetBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [forgetBtn sizeToFit];
        [self addSubview:forgetBtn];
        /*******************************************************************************************************/
        UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _registerBtn = registerBtn;
        [registerBtn setTitle:@"注册账号>" forState:UIControlStateNormal];
        [registerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [registerBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [registerBtn sizeToFit];
        [self addSubview:registerBtn];
        
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:_usernameTF] && [string isEqualToString:@"\n"]) {
        [_passwordTF becomeFirstResponder];
    }
    
    if ([textField isEqual:_passwordTF] && [string isEqualToString:@"\n"]) {
        [_passwordTF resignFirstResponder];
    }
    
    return YES;
}

- (void)loginBtnClick:(UIButton *)btn
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //随机数
    NSString *nonceStr = [CQHTools randomNumber];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"sdkVersion"]=sdkVersion;
    dict[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
    dict[@"deviceType"]= @"1";
    dict[@"gameId"]=[userDefaults objectForKey:GAMEID];
    dict[@"channelId"] = [userDefaults objectForKey:CHANNELID];
    dict[@"platformCode"]=PLATFORMCODE;
    dict[@"nonceStr"]=nonceStr;
    dict[@"username"] = self.usernameTF.text;
    dict[@"password"] =  [CQHTools jiami:self.passwordTF.text];
    
    
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
    dict1[@"channelId"] = [userDefaults objectForKey:CHANNELID];
    dict1[@"platformCode"]=PLATFORMCODE;
    dict1[@"nonceStr"]=nonceStr;
    dict1[@"username"] = self.usernameTF.text;
    dict1[@"password"] =  [CQHTools jiami:self.passwordTF.text];
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
    hud.label.text = NSLocalizedString(@"登录中...", @"HUD loading title");
    WSDK *wsdk = [WSDK sharedCQHSDK];
    [[self sharedManager] POST:[NSString stringWithFormat:@"%@sdk/login?data=%@",BASE_URL,newStr] parameters:dict3 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        [hud hideAnimated:YES];
        if ([responseObject[@"code"] integerValue] == 200) {
            
            CQHUserModel *userModel = [[CQHUserModel alloc] init];
            
            userModel.accountName = self.usernameTF.text;
            userModel.password = self.passwordTF.text;
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userModel];
            [userDefaults setObject:data forKey:CQHUSERMODEL];
            
            [userDefaults setObject:responseObject[@"data"][@"userId"] forKey:@"userId"];
            [userDefaults setObject:@"1" forKey:ISAUTO];
            [userDefaults synchronize];
            
            
            JQFMDB *db = [JQFMDB shareDatabase:CQHUSERMODELDB];
//            CQHUserModel *userModel = [[CQHUserModel alloc] init];
            if (![db jq_isExistTable:CQHUSERMODELTABLE]) {
                [db jq_createTable:CQHUSERMODELTABLE dicOrModel:userModel];
            }

//            userModel.accountName = responseObject[@"data"][@"accountName"];
//            userModel.password = self.passwordTF.text;
            [db jq_insertTable:CQHUSERMODELTABLE dicOrModel:userModel];
            
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
            hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(responseObject[@"message"], @"HUD message title");
            [hud hideAnimated:YES afterDelay:1.f];
            //            [WSDK showHUDView];
            
            [self removeFromSuperview];
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
            //            [view removeFromSuperview];
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
        //        [view removeFromSuperview];
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

- (void)forgetBtn:(UIButton *)btn
{
    CQHForgetPasswordView *forgetPasswordView = [[CQHForgetPasswordView alloc] init];
    forgetPasswordView.frame = self.bounds;
    [self addSubview:forgetPasswordView];
}

- (void)registerBtnClick:(UIButton *)btn
{
    CQHRegisterView *registerView = [[CQHRegisterView alloc] init];
    registerView.frame = self.bounds;
    [self addSubview:registerView];
}

- (void)backBtnClick:(UIButton *)btn
{
    [self removeFromSuperview];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
     UIImage *image = [CQHTools bundleForImage:@"logo-en" packageName:@""];
    _imageView.frame = CGRectMake(self.width*0.5/3.0 , 10*H_Adapter, self.width*2.0/3.0, self.width*2.0/3.0 *image.size.height/image.size.width);
    _line.frame = CGRectMake(20, CGRectGetMaxY(_imageView.frame) +10*H_Adapter, self.width - 40, 1);
    _backBtn.frame = CGRectMake(15*W_Adapter, (CGRectGetMaxY(_line.frame) - 15)*0.5, 20, 15);
    _usernameTF.frame = CGRectMake(30*W_Adapter, CGRectGetMaxY(_line.frame)+25*H_Adapter, self.width - 60*W_Adapter, self.height/7.0);
    _passwordTF.frame = CGRectMake(30*W_Adapter, CGRectGetMaxY(_usernameTF.frame)+25*H_Adapter, self.width - 60*W_Adapter, self.height/7.0);
    _loginBtn.frame = CGRectMake(30*W_Adapter, CGRectGetMaxY(_passwordTF.frame)+25*H_Adapter, self.width - 60*W_Adapter, self.height/7.0);
    _forgetBtn.frame = CGRectMake(CGRectGetMinX(_loginBtn.frame), CGRectGetMaxY(_loginBtn.frame) +(self.height - CGRectGetMaxY(_loginBtn.frame)-_forgetBtn.height)*0.5, _forgetBtn.width, _forgetBtn.height);
    _registerBtn.frame = CGRectMake(self.width -30*W_Adapter - _registerBtn.width , CGRectGetMinY(_forgetBtn.frame), _registerBtn.width, _registerBtn.height);
}

@end
