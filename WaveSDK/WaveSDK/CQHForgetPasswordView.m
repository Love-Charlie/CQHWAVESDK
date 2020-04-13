//
//  CQHForgetPasswordView.m
//  WaveSDK
//
//  Created by Love Charlie on 2020/4/3.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "CQHForgetPasswordView.h"
#import "CQHTools.h"
#import "UIView+Frame.h"
#import "CQHKeyboardProcess.h"
#import "CQHMainLoginView.h"
#import "CQHHUDView.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

#import <objc/runtime.h>

@interface CQHForgetPasswordView()

@property (nonatomic , weak) UILabel *registerLabel ;
@property (nonatomic , weak) UIButton *backBtn ;
@property (nonatomic , weak) UIView *line;
@property (nonatomic , weak) UITextField *usernameTF;
@property (nonatomic , weak) UITextField *verificationCodeTF;
@property (nonatomic , weak) UIButton *verificationCodeBtn;
@property (nonatomic , weak) UITextField *passwordTF;
@property (nonatomic , weak) UITextField *passwordTF1;
@property (nonatomic , weak) UIButton *loginBtn;
@property (nonatomic , strong) CQHKeyboardProcess *process;
@property (nonatomic, strong)dispatch_source_t time;//定时器
@end

@implementation CQHForgetPasswordView

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
        [registerLabel setText:@"重置密码"];
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
        [line setBackgroundColor:[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:0.8]];
        
        [self addSubview:line];
        
        UITextField *usernameTF = [[UITextField alloc] init];
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
        usernameTF.placeholder=@" 请输入手机号";
//        [usernameTF setValue:[UIFont boldSystemFontOfSize:12.0] forKeyPath:@"_placeholderLabel.font"];
        
        Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel = object_getIvar(usernameTF, ivar);
        placeholderLabel.text = @" 请输入手机号";
        [placeholderLabel setFont:[UIFont systemFontOfSize:12.0]];
        placeholderLabel.textColor = [UIColor lightGrayColor];
        
        UIView *contentLeftView = [[UIView alloc] init];
        [contentLeftView setBackgroundColor:[UIColor whiteColor]];
        contentLeftView.frame = CGRectMake(0, 0, 30*W_Adapter, 30*W_Adapter);
        
        
        UIButton *usernameTFLeftView = [[UIButton alloc] init];
        usernameTFLeftView.frame = CGRectMake(5*W_Adapter, 5*W_Adapter, 20*W_Adapter, 20*W_Adapter);
        [usernameTFLeftView setImage:[CQHTools bundleForImage:@"账号icon深色" packageName:@""] forState:UIControlStateNormal];
        
        [contentLeftView addSubview:usernameTFLeftView];
        usernameTF.leftView = contentLeftView;
        usernameTF.leftViewMode = UITextFieldViewModeAlways;
        
        
        UIButton *usernameTFRightView = [[UIButton alloc] init];
        usernameTFRightView.frame = CGRectMake(0, 0, 15*W_Adapter, 15*H_Adapter);
        [usernameTFRightView setImage:[CQHTools bundleForImage:@"6" packageName:@"1"] forState:UIControlStateNormal];
        
        [self addSubview:usernameTF];
        
        
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
        placeholderLabel1.text = @" 请输入验证码";
        [placeholderLabel1 setFont:[UIFont systemFontOfSize:12.0]];
        placeholderLabel1.textColor = [UIColor lightGrayColor];
        
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
        placeholderLabel2.text = @" 请输入密码";
        [placeholderLabel2 setFont:[UIFont systemFontOfSize:12.0]];
        placeholderLabel2.textColor = [UIColor lightGrayColor];
        
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
        UITextField *passwordTF1 = [[UITextField alloc] init];
        passwordTF1.textColor = [UIColor blackColor];
        _passwordTF1 = passwordTF1;
        [passwordTF1 setBackgroundColor:[UIColor whiteColor]];
        passwordTF1.layer.cornerRadius = 6.0;
        passwordTF1.layer.borderColor= [UIColor lightGrayColor].CGColor;
        passwordTF1.layer.borderWidth= 1.0f;
        passwordTF1.layer.masksToBounds = YES;
        passwordTF1.tintColor = [UIColor colorWithRed:214.0/255.0 green:6.0/255.0 blue:0/255.0 alpha:1];
        passwordTF1.placeholder=@" 请再次输入密码";
//        [passwordTF1 setValue:[UIFont boldSystemFontOfSize:12.0] forKeyPath:@"_placeholderLabel.font"];
        
        Ivar ivar3 =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel3 = object_getIvar(passwordTF1, ivar3);
        placeholderLabel3.text = @" 请再次输入密码";
        [placeholderLabel3 setFont:[UIFont systemFontOfSize:12.0]];
        placeholderLabel3.textColor = [UIColor lightGrayColor];
        
        UIView *contentLeftView4 = [[UIView alloc] init];
        [contentLeftView4 setBackgroundColor:[UIColor whiteColor]];
        contentLeftView4.frame = CGRectMake(0, 0, 30*W_Adapter, 30*W_Adapter);
        
        
        UIButton *usernameTFLeftView4 = [[UIButton alloc] init];
        usernameTFLeftView4.frame = CGRectMake(5*W_Adapter, 5*W_Adapter, 20*W_Adapter, 20*W_Adapter);
        [usernameTFLeftView4 setImage:[CQHTools bundleForImage:@"密码icon深色" packageName:@""] forState:UIControlStateNormal];
        
        [contentLeftView4 addSubview:usernameTFLeftView4];
        passwordTF1.leftView = contentLeftView4;
        passwordTF1.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:passwordTF1];
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        loginBtn.layer.cornerRadius = 6.0;
        loginBtn.layer.masksToBounds = YES;
        [loginBtn setTitle:@"修改密码并登录" forState:UIControlStateNormal];
        [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [loginBtn setBackgroundColor:[UIColor colorWithRed:216/255.0 green:58/255.0 blue:41/255.0 alpha:1]];
        _loginBtn = loginBtn;
        [self addSubview:loginBtn];
    }
    return self;
}

- (void)loginBtnClick:(UIButton *)btn
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //随机数
    NSString *nonceStr = [CQHTools randomNumber];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"sdkVersion"]=sdkVersion;
    dict[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
    dict[@"channelId"]= [userDefaults objectForKey:CHANNELID];
    dict[@"gameId"]=[userDefaults objectForKey:GAMEID];
    dict[@"platformCode"]=PLATFORMCODE;
    dict[@"nonceStr"]=nonceStr;
    dict[@"mobile"] = self.usernameTF.text;
    dict[@"password"] = [CQHTools md5:self.passwordTF.text];
    dict[@"captcha"] = self.verificationCodeTF.text;
    NSString *stringA = [CQHTools sortArrWithDictionary:dict];
    //sign
    NSString *sign = [NSString stringWithFormat:@"%@&key=%@",stringA,[userDefaults objectForKey:SIGNKEY]];
    //sign md5签名
    NSString *md5String = [CQHTools md5:sign];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[@"sdkVersion"]=sdkVersion;
    dict1[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
    dict1[@"channelId"]= [userDefaults objectForKey:CHANNELID];
    dict1[@"gameId"]=[userDefaults objectForKey:GAMEID];
    dict1[@"platformCode"]=PLATFORMCODE;
    dict1[@"nonceStr"]=nonceStr;
    dict1[@"mobile"] = self.usernameTF.text;
    dict1[@"password"] = [CQHTools md5:self.passwordTF.text];
    dict1[@"captcha"] = self.verificationCodeTF.text;
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
    
    [[self sharedManager] POST:[NSString stringWithFormat:@"%@sdk/password/forgot?data=%@",BASE_URL,newStr] parameters:dict3 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
            hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(responseObject[@"message"], @"HUD message title");
            [hud hideAnimated:YES afterDelay:1.f];
            //            [WSDK showHUDView];
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

- (void)verificationCodeBtnClick:(UIButton *)btn
{
    
    NSString *newCodeStr= [self.usernameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!(newCodeStr.length == 11) ) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入11位手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
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
        [btn setTitle:[NSString stringWithFormat:@"剩余%ld秒",count] forState:UIControlStateNormal];
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
    dict[@"mobile"] = self.usernameTF.text;
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
    dict1[@"mobile"] = self.usernameTF.text;
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
    hud.label.text = NSLocalizedString(@"获取验证码中...", @"HUD loading title");
    
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
    _line.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_registerLabel.frame)+20*H_Adapter, self.width - 50*W_Adapter, 1);
    _usernameTF.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_line.frame)+10*H_Adapter, self.width - 50*W_Adapter, 35*H_Adapter);
    _verificationCodeTF.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_usernameTF.frame)+10*H_Adapter, self.width - 50*W_Adapter, 35*H_Adapter);
    _verificationCodeBtn.frame = CGRectMake(_verificationCodeTF.width*0.7-3 , 5*H_Adapter, _verificationCodeTF.width*0.3-3, 25*H_Adapter);
    _passwordTF.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_verificationCodeTF.frame)+10*H_Adapter, self.width - 50*W_Adapter, 35*H_Adapter);
    _passwordTF1.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_passwordTF.frame)+10*H_Adapter, self.width - 50*W_Adapter, 35*H_Adapter);
    _loginBtn.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_passwordTF1.frame)+(self.height - CGRectGetMaxY(_passwordTF1.frame) - 40*H_Adapter)*0.5, self.width - 50*W_Adapter, 40);
}
@end
