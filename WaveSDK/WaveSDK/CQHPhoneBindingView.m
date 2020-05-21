//
//  CQHPhoneBindingView.m
//  WaveSDK
//
//  Created by Love Charlie on 2020/4/20.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "CQHPhoneBindingView.h"
#import "CQHTools.h"
#import "UIView+Frame.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CQHKeyboardProcess.h"
#import "CQHHUDView.h"
#import "CQHMainLoginView.h"
#import "CQHHUDView.h"
#import "WSDK.h"

@interface CQHPhoneBindingView()

@property (nonatomic , weak) UILabel *registerLabel ;
@property (nonatomic , weak) UIButton *backBtn ;
@property (nonatomic , weak) UIView *line;
@property (nonatomic , weak) UILabel *contentLabel;
@property (nonatomic , weak) UITextField *usernameTF;
@property (nonatomic , weak) UIView *tipsView;
@property (nonatomic , weak) UIImageView *imageview;
@property (nonatomic , weak) UILabel *label;
@property (nonatomic , weak) UITextField *verificationCodeTF;
@property (nonatomic , weak) UIButton *verificationCodeBtn;
@property (nonatomic , weak) UIButton *bindAndLogin;
@property (nonatomic , weak) UILabel *label1;
@property (nonatomic , strong) CQHKeyboardProcess *process;
@property (nonatomic, strong)dispatch_source_t time;//定时器

@end

@implementation CQHPhoneBindingView

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
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        [self setBackgroundColor:[UIColor whiteColor]];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange1) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        
        CQHKeyboardProcess *process = [[CQHKeyboardProcess alloc] init];
        _process = process;
        [process changeFrameWithView:[CQHHUDView shareHUDView]];
        
        UILabel *registerLabel = [[UILabel alloc] init];
        _registerLabel = registerLabel;
        [registerLabel setText:@"手机绑定"];
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
        
        
        UILabel *contentLabel = [[UILabel alloc] init];
        _contentLabel = contentLabel;
        [self addSubview:contentLabel];
        
        UITextField *usernameTF = [[UITextField alloc] init];
        usernameTF.textColor = [UIColor blackColor];
        usernameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _usernameTF = usernameTF;
        UIView *leftContentView = [[UIView alloc] init];
        leftContentView.frame = CGRectMake(0, 0, 30, 30);
        
        UIImageView *leftView = [[UIImageView alloc] init];
        [leftContentView addSubview:leftView];
        [leftView setImage:[CQHTools bundleForImage:@"账号icon深色" packageName:@""]];
        leftView.frame =CGRectMake(7.5, 7.5, 15, 15);
        usernameTF.leftView = leftContentView;
        usernameTF.leftViewMode = UITextFieldViewModeAlways;
        
        [usernameTF setBackgroundColor:[UIColor whiteColor]];
        usernameTF.layer.cornerRadius = 6.0;
        usernameTF.layer.borderColor= [UIColor lightGrayColor].CGColor;
        usernameTF.layer.borderWidth= 1.0f;
        usernameTF.layer.masksToBounds = YES;
        usernameTF.tintColor = [UIColor colorWithRed:214/255.0 green:6/255.0 blue:0/255.0 alpha:1];
        usernameTF.placeholder=@" 请输入手机号";
        [self addSubview:usernameTF];
        
        UIView *tipsView = [[UIView alloc] init];
        _tipsView = tipsView;
        [self addSubview:tipsView];
        
        UIImageView *imageview = [[UIImageView alloc] init];
        _imageview = imageview;
        [imageview setImage:[CQHTools bundleForImage:@"icon" packageName:@""]];
        [tipsView addSubview:imageview];
        
        UILabel *label = [[UILabel alloc] init];
        _label = label;
        label.text = @"您的隐私将受到保护,手机号码仅会用于账号登录及密码找回";
        [label setFont:[UIFont systemFontOfSize:8]];
        [label setTextColor:[UIColor redColor]];
        [tipsView addSubview:label];
        
        
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
        
        
        UIButton *bindAndLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        [bindAndLogin addTarget:self action:@selector(bindAndLoginClick:) forControlEvents:UIControlEventTouchUpInside];
        bindAndLogin.layer.cornerRadius = 5.0;
        bindAndLogin.layer.masksToBounds = YES;
        _bindAndLogin = bindAndLogin;
        [bindAndLogin setTitle:@"绑定手机并登录游戏" forState:UIControlStateNormal];
        [bindAndLogin setBackgroundColor:[UIColor colorWithRed:216/255.0 green:58/255.0 blue:41/255.0 alpha:1]];
        [bindAndLogin.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self addSubview:bindAndLogin];
        
        UILabel *label1 = [[UILabel alloc] init];
        _label1 = label1;
        [label1 setText:@"*绑定手机号码成功后，可直接用手机号座位账号登录游戏"];
        [label1 setFont:[UIFont systemFontOfSize:8.0]];
        [label1 setTextColor:[UIColor blackColor]];
        [self addSubview:label1];
        
    }
    return self;
}

- (void)bindAndLoginClick:(UIButton *)btn
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //随机数
    NSString *nonceStr = [CQHTools randomNumber];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"channelId"] = [userDefaults objectForKey:CHANNELID];
    dict[@"sdkVersion"]=sdkVersion;
    dict[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
    dict[@"gameId"]=[userDefaults objectForKey:GAMEID];
    dict[@"platformCode"]=PLATFORMCODE;
    dict[@"nonceStr"]=nonceStr;
    dict[@"username"] = self.username;
    dict[@"mobile"] = self.usernameTF.text;
    dict[@"captcha"] = self.verificationCodeTF.text;
    NSString *stringA = [CQHTools sortArrWithDictionary:dict];
    //sign
    NSString *sign = [NSString stringWithFormat:@"%@&key=%@",stringA,[userDefaults objectForKey:SIGNKEY]];
    //sign md5签名
    NSString *md5String = [CQHTools md5:sign];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[@"channelId"] = [userDefaults objectForKey:CHANNELID];
    dict1[@"sdkVersion"]=sdkVersion;
    dict1[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
    dict1[@"gameId"]=[userDefaults objectForKey:GAMEID];
    dict1[@"platformCode"]=PLATFORMCODE;
    dict1[@"nonceStr"]=nonceStr;
    dict1[@"username"] = self.username;
    dict1[@"mobile"] = self.usernameTF.text;
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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    hud.label.text = NSLocalizedString(@"绑定并登录中...", @"HUD loading title");
    WSDK *wsdk = [WSDK sharedCQHSDK];
    [[self sharedManager] POST:[NSString stringWithFormat:@"%@sdk/user/bind/mobile?data=%@",BASE_URL,newStr] parameters:dict3 headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 200) {
        [userDefaults setObject:responseObject[@"data"][@"userId"] forKey:@"userId"];
        [userDefaults synchronize];
        
        [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
        hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(responseObject[@"message"], @"HUD message title");
        [hud hideAnimated:YES afterDelay:1.f];
        
        [self removeFromSuperview];
        [[CQHMainLoginView sharedMainLoginView] removeFromSuperview];
        [[CQHHUDView shareHUDView] removeFromSuperview];
        
        if ([wsdk.delegate respondsToSelector:@selector(loginSuccessWithResponse:)]) {
            [wsdk.delegate loginSuccessWithResponse:responseObject[@"data"]];
            
            if ([responseObject[@"data"][@"authStatus"] integerValue] == 1) {
                
                if ([responseObject[@"data"][@"authInfo"][@"idno"] isEqualToString:@""]) {
                    NSLog(@"没有认证");
                    //
                    [CQHHUDView sharedCQHVerView];
                }
            }
        }
   
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
        [hud hideAnimated:YES];
    }];
}

- (void)verificationCodeBtnClick:(UIButton *)btn
{
    NSString *newCodeStr= [self.usernameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
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

- (void)setUsername:(NSString *)username
{
    _username = username;
    if (username.length > 16) {
         username = [username stringByReplacingCharactersInRange:NSMakeRange(5, username.length - 10) withString:@"...."];
    }
    
    NSMutableAttributedString *Att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"正在给账号 : %@, 进行手机绑定",username]];
    [Att addAttribute:NSForegroundColorAttributeName value:[UIColor  redColor] range:NSMakeRange(8,username.length)];
    _contentLabel.attributedText = Att;
    _contentLabel.font = [UIFont systemFontOfSize:13.0];
    [_contentLabel sizeToFit];
}

- (void)backBtnClick:(UIButton *)btn
{
    [self removeFromSuperview];
}

- (void)statusBarOrientationChange1
{
    self.frame = self.superview.bounds;
    self.center = CGPointMake(self.superview.frame.size.width *0.5, self.superview.frame.size.height *0.5);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _registerLabel.frame = CGRectMake((self.width -_registerLabel.width)*0.5 , self.height/25.0, _registerLabel.width, _registerLabel.height);
    _backBtn.frame = CGRectMake(25*W_Adapter, 20, _registerLabel.height , _registerLabel.height);
    _line.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_registerLabel.frame)+self.height/25.0, self.width - 50*W_Adapter, 1);
    _contentLabel.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_line.frame)+self.height/25.0, self.width - 50*W_Adapter, _contentLabel.height);
    _usernameTF.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_contentLabel.frame)+self.height/25.0, self.width - 50*W_Adapter, self.height/7.0);
    _tipsView.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_usernameTF.frame)+self.height/75.0, self.width - 50*W_Adapter, 15);
    _imageview.frame = CGRectMake(0, 2.5, 10, 10);
    _label.frame = CGRectMake(15, 0, self.width - 50*W_Adapter-15, 15);
    
    _verificationCodeTF.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_tipsView.frame)+self.height/50.0, self.width - 50*W_Adapter, self.height/7.0);
    _verificationCodeBtn.frame = CGRectMake(_verificationCodeTF.width*0.7-3 , (self.height/7.0-self.height/9.0)*0.5, _verificationCodeTF.width*0.3-3, self.height/9.0);
    _bindAndLogin.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_verificationCodeTF.frame)+self.height/10.0, self.width - 50*W_Adapter, self.height/6.0);
    _label1.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_bindAndLogin.frame)+self.height/75.0, self.width - 50*W_Adapter, 15);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
