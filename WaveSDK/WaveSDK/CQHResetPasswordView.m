//
//  CQHResetPasswordView.m
//  WaveSDK
//
//  Created by Love Charlie on 2020/5/12.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "CQHResetPasswordView.h"
#import "CQHKeyboardProcess.h"
#import "CQHHUDView.h"
#import "CQHTools.h"
#import "UIView+Frame.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "CQHUserModel.h"
#import "WSDK.h"

@interface CQHResetPasswordView()

@property (nonatomic , strong) CQHKeyboardProcess *process;
@property (nonatomic , weak) UILabel *registerLabel;
@property (nonatomic , weak) UIButton *backBtn;
@property (nonatomic , weak) UIView *line;
@property (nonatomic , weak) UILabel *contentLabel;
@property (nonatomic , weak) UITextField *verificationCodeTF;
@property (nonatomic , weak) UIButton *verificationCodeBtn;
@property (nonatomic , weak) UITextField *passwordTF;
@property (nonatomic , weak) UITextField *passwordTF1;
@property (nonatomic , weak) UIButton *editAndLoginBtn;
@property (nonatomic, strong)dispatch_source_t time;//定时器

@end

@implementation CQHResetPasswordView


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
        
        CQHKeyboardProcess *process = [[CQHKeyboardProcess alloc] init];
        _process = process;
        [process changeFrameWithView:[CQHHUDView shareHUDView]];
        
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
        [line setBackgroundColor:[UIColor lightGrayColor]];
        line.alpha = 0.5;
        [self addSubview:line];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        _contentLabel = contentLabel;
        [self addSubview:contentLabel];
        
        
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
        NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:@" 请输入验证码" attributes:
        @{NSForegroundColorAttributeName:[UIColor grayColor],
                     NSFontAttributeName:verificationCodeTF.font
             }];
        verificationCodeTF.attributedPlaceholder = attrString1;
        

        
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
        
        
        UITextField *passwordTF = [[UITextField alloc] init];
        passwordTF.secureTextEntry = YES;
        passwordTF.textColor = [UIColor blackColor];
        passwordTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        UIImageView *leftView2 = [[UIImageView alloc] init];
        [leftView2 setImage:[CQHTools bundleForImage:@"账号icon深色" packageName:@""]];
        leftView2.frame =CGRectMake(0, 0, 15, 15);
        passwordTF.leftView = leftView2;
        passwordTF.leftViewMode = UITextFieldViewModeAlways;
                        
        [passwordTF setBackgroundColor:[UIColor whiteColor]];
        passwordTF.layer.cornerRadius = 6.0;
        passwordTF.layer.borderColor= [UIColor lightGrayColor].CGColor;
        passwordTF.layer.borderWidth= 1.0f;
        passwordTF.layer.masksToBounds = YES;
        passwordTF.tintColor = [UIColor colorWithRed:214.0/255.0 green:6.0/255.0 blue:0/255.0 alpha:1];
        _passwordTF = passwordTF;
        passwordTF.placeholder=@" 请输入密码";
        
        NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@" 请输入密码" attributes:
        @{NSForegroundColorAttributeName:[UIColor grayColor],
                     NSFontAttributeName:passwordTF.font
             }];
        passwordTF.attributedPlaceholder = attrString2;
                        
        UIView *contentLeftView = [[UIView alloc] init];
        [contentLeftView setBackgroundColor:[UIColor whiteColor]];
        contentLeftView.frame = CGRectMake(0, 0, 30*W_Adapter, 30*W_Adapter);
                        
                        
        UIButton *usernameTFLeftView = [[UIButton alloc] init];
        usernameTFLeftView.frame = CGRectMake(5*W_Adapter, 5*W_Adapter, 20*W_Adapter, 20*W_Adapter);
        [usernameTFLeftView setImage:[CQHTools bundleForImage:@"密码icon深色" packageName:@""] forState:UIControlStateNormal];
                        
        [contentLeftView addSubview:usernameTFLeftView];
        passwordTF.leftView = contentLeftView;
        passwordTF.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:passwordTF];
        
        
        //////////////////////////////////////////////////////////
        UITextField *passwordTF1 = [[UITextField alloc] init];
        passwordTF1.secureTextEntry = YES;
        passwordTF1.textColor = [UIColor blackColor];
        passwordTF1.clearButtonMode=UITextFieldViewModeWhileEditing;
        UIImageView *leftView3 = [[UIImageView alloc] init];
        [leftView3 setImage:[CQHTools bundleForImage:@"账号icon深色" packageName:@""]];
        leftView3.frame =CGRectMake(0, 0, 15, 15);
        passwordTF1.leftView = leftView3;
        passwordTF1.leftViewMode = UITextFieldViewModeAlways;
                               
        [passwordTF1 setBackgroundColor:[UIColor whiteColor]];
        passwordTF1.layer.cornerRadius = 6.0;
        passwordTF1.layer.borderColor= [UIColor lightGrayColor].CGColor;
        passwordTF1.layer.borderWidth= 1.0f;
        passwordTF1.layer.masksToBounds = YES;
        passwordTF1.tintColor = [UIColor colorWithRed:214.0/255.0 green:6.0/255.0 blue:0/255.0 alpha:1];
        _passwordTF1 = passwordTF1;
        passwordTF1.placeholder=@" 请再次输入密码";
               
        NSAttributedString *attrString3 = [[NSAttributedString alloc] initWithString:@" 请再次输入密码" attributes:
               @{NSForegroundColorAttributeName:[UIColor grayColor],
                            NSFontAttributeName:passwordTF1.font
                    }];
        passwordTF1.attributedPlaceholder = attrString3;
                               
        UIView *contentLeftView3 = [[UIView alloc] init];
        [contentLeftView3 setBackgroundColor:[UIColor whiteColor]];
        contentLeftView3.frame = CGRectMake(0, 0, 30*W_Adapter, 30*W_Adapter);
                               
                               
        UIButton *usernameTFLeftView3 = [[UIButton alloc] init];
        usernameTFLeftView3.frame = CGRectMake(5*W_Adapter, 5*W_Adapter, 20*W_Adapter, 20*W_Adapter);
        [usernameTFLeftView3 setImage:[CQHTools bundleForImage:@"密码icon深色" packageName:@""] forState:UIControlStateNormal];
                               
        [contentLeftView3 addSubview:usernameTFLeftView3];
        passwordTF1.leftView = contentLeftView3;
        passwordTF1.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:passwordTF1];
        
        
        UIButton *editAndLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editAndLoginBtn = editAndLoginBtn;
        [editAndLoginBtn setTitle:@"修改密码并登录" forState:UIControlStateNormal];
        [editAndLoginBtn addTarget:self action:@selector(editAndLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        editAndLoginBtn.layer.cornerRadius = 5.0;
        editAndLoginBtn.layer.masksToBounds = YES;
//        [editAndLoginBtn setTitle:@"绑定手机并登录游戏" forState:UIControlStateNormal];
        [editAndLoginBtn setBackgroundColor:[UIColor colorWithRed:216/255.0 green:58/255.0 blue:41/255.0 alpha:1]];
        [editAndLoginBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self addSubview:editAndLoginBtn];
        
    }
    return self;
}

- (void)editAndLoginBtnClick:(UIButton *)btn
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
       //随机数
    NSString *nonceStr = [CQHTools randomNumber];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"sdkVersion"]=sdkVersion;
    dict[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
    dict[@"channelId"] = [userDefaults objectForKey:CHANNELID];
    dict[@"gameId"]=[userDefaults objectForKey:GAMEID];
    dict[@"platformCode"]=PLATFORMCODE;
    dict[@"nonceStr"]=nonceStr;
//    dict[@"username"] = _username;
    dict[@"mobile"] = _mobile;
    dict[@"password"] = [CQHTools jiami:_passwordTF.text];
    dict[@"captcha"] = _verificationCodeTF.text;
//    dict[@"activeCode"] = ACTIVECODE;
    NSString *stringA = [CQHTools sortArrWithDictionary:dict];
       //sign
    NSString *sign = [NSString stringWithFormat:@"%@&key=%@",stringA,[userDefaults objectForKey:SIGNKEY]];
       //sign md5签名
    NSString *md5String = [CQHTools md5:sign];
       
       NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        dict1[@"sdkVersion"]=sdkVersion;
         dict1[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
         dict1[@"channelId"] = [userDefaults objectForKey:CHANNELID];
         dict1[@"gameId"]=[userDefaults objectForKey:GAMEID];
         dict1[@"platformCode"]=PLATFORMCODE;
         dict1[@"nonceStr"]=nonceStr;
//        dict1[@"username"] = _username;
         dict1[@"mobile"] = _mobile;
         dict1[@"password"] = [CQHTools jiami:_passwordTF.text];
         dict1[@"captcha"] = _verificationCodeTF.text;
//         dict1[@"activeCode"] = ACTIVECODE;
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
//       hud.label.text = NSLocalizedString(@"获取验证码...", @"HUD loading title");
    WSDK *wsdk = [WSDK sharedCQHSDK];
    [[self sharedManager] POST:[NSString stringWithFormat:@"%@sdk/password/forgot?data=%@",BASE_URL,newStr] parameters:dict3 headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject[@"code"] integerValue] == 200) {
            
            
            CQHUserModel *userModel = [[CQHUserModel alloc] init];
            userModel.accountName = responseObject[@"data"][@"accountName"];
            userModel.password = responseObject[@"data"][@"password"];
            userModel.username = responseObject[@"data"][@"username"];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userModel];
            [userDefaults setObject:data forKey:CQHUSERMODEL];
//            [userDefaults synchronize];
            [userDefaults setObject:@"1" forKey:ISAUTO];
            
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
            [[CQHHUDView shareHUDView] removeFromSuperview];
            
            if ([wsdk.delegate respondsToSelector:@selector(loginSuccessWithResponse:)]) {
                [wsdk.delegate loginSuccessWithResponse:responseObject[@"data"]];
                
                if ([responseObject[@"data"][@"authStatus"] integerValue] == 1) {
                    
                    if ([responseObject[@"data"][@"authInfo"][@"idno"] isEqualToString:@""]) {
                        NSLog(@"没有认证");
                        [CQHHUDView showVerView];
                    }
                }
            }
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

- (void)backBtnClick:(UIButton *)btn
{
    [self removeFromSuperview];
}

- (void)setMobile:(NSString *)mobile
{
    _mobile = mobile;
}

- (void)setUsername:(NSString *)username
{
    _username = username;
    if (username.length > 16) {
         username = [username stringByReplacingCharactersInRange:NSMakeRange(5, username.length - 10) withString:@"...."];
    }
    [_contentLabel setTextColor:[UIColor blackColor]];
    
    _contentLabel.font = [UIFont systemFontOfSize:13.0];
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.numberOfLines = 0;
    
    NSString *mobileString=[_mobile stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"];
    
    NSMutableAttributedString *Att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"正在给账号 : %@, 进行密码重置，验证码短信将发送至手机: %@",username,mobileString]];
    
    
    [Att addAttribute:NSForegroundColorAttributeName value:[UIColor  redColor] range:NSMakeRange(8,username.length)];
    _contentLabel.attributedText = Att;
    [_contentLabel sizeToFit];
    
}

- (void)verificationCodeBtnClick:(UIButton *)btn
{
//    NSString *newCodeStr= [self.usernameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if (!(newCodeStr.length == 11) ) {
//        [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
//        hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
//        hud.mode = MBProgressHUDModeText;
//        hud.label.text = NSLocalizedString(@"请输入11位正确手机号", @"HUD message title");
//        [hud hideAnimated:YES afterDelay:1.f];
//        return;
//    }
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
    dict[@"mobile"] = _mobile;
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
    dict1[@"mobile"] = _mobile;
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
    hud.label.text = NSLocalizedString(@"获取验证码...", @"HUD loading title");
    
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



- (void)layoutSubviews
{
    [super layoutSubviews];
    _registerLabel.frame = CGRectMake((self.width -_registerLabel.width)*0.5 , self.height/25.0, _registerLabel.width, _registerLabel.height);
    _backBtn.frame = CGRectMake(25*W_Adapter, self.height/25.0, _registerLabel.height , _registerLabel.height);
    
     _line.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_registerLabel.frame)+self.height/30.0, self.width - 50*W_Adapter, 1);
    _contentLabel.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_line.frame)+self.height/60.0, self.width - 50*W_Adapter, _contentLabel.height*3);
    
    _verificationCodeTF.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_contentLabel.frame)+self.height/60.0, self.width - 50*W_Adapter, self.height/7.0);
    _verificationCodeBtn.frame = CGRectMake(_verificationCodeTF.width*0.7-3 , (self.height/7.0-self.height/9.0)*0.5, _verificationCodeTF.width*0.3-3, self.height/9.0);
    _passwordTF.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_verificationCodeTF.frame)+self.height/60.0,  self.width - 50*W_Adapter, self.height/7.0);
    _passwordTF1.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_passwordTF.frame)+self.height/60.0,  self.width - 50*W_Adapter, self.height/7.0);
    
    _editAndLoginBtn.frame = CGRectMake(25*W_Adapter,CGRectGetMaxY(_passwordTF1.frame)+ (self.height - CGRectGetMaxY(_passwordTF1.frame)-self.height/7.0)*0.5, self.width - 50*W_Adapter, self.height/7.0);
}
@end
