//
//  CQHRegisterView.m
//  WaveSDK
//
//  Created by Love Charlie on 2020/4/3.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "CQHRegisterView.h"
#import "CQHTools.h"
#import "UIView+Frame.h"
#import "MBProgressHUD.h"
#import "CQHMainLoginView.h"
#import "WSDK.h"
#import "AFNetworking.h"
#import "CQHHUDView.h"
#import "CQHUserModel.h"
#import "JQFMDB.h"
#import <objc/runtime.h>

@interface CQHRegisterView()<UITextFieldDelegate>
@property (nonatomic , weak)  UIImageView *imageView;
@property (nonatomic , weak)  UIView *line;
@property (nonatomic , weak) UIButton *backBtn ;
@property (nonatomic , weak) UITextField *usernameTF ;
@property (nonatomic , weak) UILabel *explainLabel;
@property (nonatomic , weak) UITextField *passwordTF ;
@property (nonatomic , weak) UIButton *loginBtn ;
@property (nonatomic , weak) UIButton *forgetBtn;
@property (nonatomic , weak) UIButton *registerBtn;
@end

@implementation CQHRegisterView

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
        placeholderLabel.text = @" 请输入账号";
        [placeholderLabel setFont:[UIFont systemFontOfSize:12.0]];
        placeholderLabel.textColor = [UIColor lightGrayColor];
        
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
        
        
        UILabel *explainLabel = [[UILabel alloc] init];
        _explainLabel = explainLabel;
        [explainLabel setText:@"请输入6-12位字符，可使用数字、字母、下划线"];
        [explainLabel setTextColor:[UIColor redColor]];
        [explainLabel setFont:[UIFont systemFontOfSize:11.0]];
        [explainLabel sizeToFit];
        [self addSubview:explainLabel];
        
        
        /*******************************************************************************************************/
        UITextField *passwordTF = [[UITextField alloc] init];
        passwordTF.delegate = self;
        passwordTF.returnKeyType = UIReturnKeyDone;
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
        passwordTF.placeholder=@"请输入密码(6-16位)";
//        [passwordTF setValue:[UIFont boldSystemFontOfSize:12.0] forKeyPath:@"_placeholderLabel.font"];
        
        UIView *rightViewContent1 = [[UIView alloc] init];
               rightViewContent1.frame = CGRectMake(0, 0, 30, 30);
               
               UIButton *passwordTFRightView = [[UIButton alloc] init];
               passwordTFRightView.frame = CGRectMake(7.5, 7.5, 15, 15);
               
               
               [passwordTFRightView setImage:[CQHTools bundleForImage:@"7" packageName:@""] forState:UIControlStateNormal];
               [passwordTFRightView setImage:[CQHTools bundleForImage:@"9" packageName:@""] forState:UIControlStateSelected];
               passwordTF.rightView = rightViewContent1;
               passwordTF.rightViewMode = UITextFieldViewModeAlways;
               [passwordTFRightView addTarget:self action:@selector(eyeClick:) forControlEvents:UIControlEventTouchUpInside];
                       
               [rightViewContent1 addSubview:passwordTFRightView];
        
        Ivar ivar1 =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel1 = object_getIvar(passwordTF, ivar1);
        placeholderLabel1.text = @"请输入密码(6-16位)";
        [placeholderLabel1 setFont:[UIFont systemFontOfSize:12.0]];
        placeholderLabel1.textColor = [UIColor lightGrayColor];
        
        
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
        
//        UIButton *passwordTFRightView = [[UIButton alloc] init];
//        passwordTFRightView.frame = CGRectMake(0, 0, 44*W_Adapter, 44*H_Adapter);
//        [passwordTFRightView setImage:[CQHTools bundleForImage:@"7" packageName:@""] forState:UIControlStateNormal];
//        [passwordTFRightView setImage:[CQHTools bundleForImage:@"9" packageName:@""] forState:UIControlStateSelected];
//        passwordTF.rightView = passwordTFRightView;
//        passwordTF.rightViewMode = UITextFieldViewModeAlways;
//        [passwordTFRightView addTarget:self action:@selector(eyeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:passwordTF];
        
        /*******************************************************************************************************/
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn = loginBtn;
        [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [loginBtn setBackgroundColor:[UIColor colorWithRed:216/255.0 green:58/255.0 blue:41/255.0 alpha:1]];
        [loginBtn setTitle:@"注册并登录" forState:UIControlStateNormal];
        [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        loginBtn.layer.cornerRadius = 5.0;
        loginBtn.layer.masksToBounds = YES;
        [self addSubview:loginBtn];
        /*******************************************************************************************************/
        UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetBtn = forgetBtn;
        [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [forgetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [forgetBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [forgetBtn sizeToFit];
//        [self addSubview:forgetBtn];
        /*******************************************************************************************************/
        UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _registerBtn = registerBtn;
        [registerBtn setTitle:@"注册账号>" forState:UIControlStateNormal];
        [registerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [registerBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [registerBtn sizeToFit];
//        [self addSubview:registerBtn];
    }
    return self;
}

//#pragma mark点击眼睛图标
//- (void)eyeClick1:(UIButton *)btn
//{
//    btn.selected = !btn.selected;
//    self.passwordTF1.secureTextEntry = !btn.selected;
//    NSString *psd = self.passwordTF1.text;
//    self.passwordTF1.text = @"";
//    self.passwordTF1.text = psd;
//    
//}
//
//#pragma mark点击眼睛图标
//- (void)eyeClick2:(UIButton *)btn
//{
//    btn.selected = !btn.selected;
//    self.passwordTF2.secureTextEntry = !btn.selected;
//    NSString *psd = self.passwordTF2.text;
//    self.passwordTF2.text = @"";
//    self.passwordTF2.text = psd;
//    
//}

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
    
    NSString *text =self.usernameTF.text;
    NSString *temp = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//清空空格
    if([text isEqualToString:@""] || temp.length==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
        hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请输入账号", @"HUD message title");
        [hud hideAnimated:YES afterDelay:1.f];
        return;
    }
    
    
    NSString *text1 =self.passwordTF.text;
    NSString *temp1 = [text1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//清空空格
    if([text1 isEqualToString:@""] || temp1.length==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
        hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请输入密码", @"HUD message title");
        [hud hideAnimated:YES afterDelay:1.f];
        return;
    }
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //随机数
    NSString *nonceStr = [CQHTools randomNumber];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"username"] = self.usernameTF.text;
    dict[@"password"] = [CQHTools jiami:self.passwordTF.text];
    dict[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
    dict[@"deviceType"]= @"1";
    dict[@"gameId"]=[userDefaults objectForKey:GAMEID];
    dict[@"channelId"]=[userDefaults objectForKey:CHANNELID];
    dict[@"platformCode"]=PLATFORMCODE;
    dict[@"nonceStr"]=nonceStr;

    NSString *stringA = [CQHTools sortArrWithDictionary:dict];
    //sign
    NSString *sign = [NSString stringWithFormat:@"%@&key=%@",stringA,[userDefaults objectForKey:SIGNKEY]];
    //sign md5签名
    NSString *md5String = [CQHTools md5:sign];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[@"username"] = self.usernameTF.text;
    dict1[@"password"] = [CQHTools jiami:self.passwordTF.text];
    dict1[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
    dict1[@"deviceType"]= @"1";
    dict1[@"gameId"]=[userDefaults objectForKey:GAMEID];
    dict1[@"channelId"]=[userDefaults objectForKey:CHANNELID];
    dict1[@"platformCode"]=PLATFORMCODE;
    dict1[@"nonceStr"]=nonceStr;
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
    hud.label.text = NSLocalizedString(@"验证中...", @"HUD loading title");
     WSDK *wsdk = [WSDK sharedCQHSDK];
    [[self sharedManager] POST:[NSString stringWithFormat:@"%@sdk/user/register?data=%@",BASE_URL,newStr] parameters:dict3 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        [hud hideAnimated:YES];
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [userDefaults setObject:responseObject[@"data"][@"userId"] forKey:@"userId"];
            
            [userDefaults setObject:@"1" forKey:ISAUTO];
            
            
            JQFMDB *db = [JQFMDB shareDatabase:CQHUSERMODELDB];
            CQHUserModel *userModel = [[CQHUserModel alloc] init];
            if (![db jq_isExistTable:CQHUSERMODELTABLE]) {
                [db jq_createTable:CQHUSERMODELTABLE dicOrModel:userModel];
            }

            userModel.accountName = responseObject[@"data"][@"accountName"];
            userModel.password = self.passwordTF.text;
            [db jq_insertTable:CQHUSERMODELTABLE dicOrModel:userModel];
            
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userModel];
            
            [userDefaults setObject:data forKey:CQHUSERMODEL];
            
            
            [userDefaults synchronize];
            
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
            hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(responseObject[@"message"], @"HUD message title");
            [hud hideAnimated:YES afterDelay:1.f];
           
            [self.superview removeFromSuperview];
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
        }else{
            //            [view removeFromSuperview];
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
            hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
            hud.mode = MBProgressHUDModeText;
            [hud.label setFont:[UIFont systemFontOfSize:12.0]];
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

#pragma mark点击眼睛图标
- (void)eyeClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.passwordTF.secureTextEntry = !btn.selected;
    NSString *psd = self.passwordTF.text;
    self.passwordTF.text = @"";
    self.passwordTF.text = psd;
    
}

- (void)registerBtnClick:(UIButton *)btn
{
    
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
    _explainLabel.frame = CGRectMake(30*W_Adapter, CGRectGetMaxY(_usernameTF.frame)+self.height/60.0, _explainLabel.width, _explainLabel.height);
    _passwordTF.frame = CGRectMake(30*W_Adapter, CGRectGetMaxY(_explainLabel.frame)+15*H_Adapter, self.width - 60*W_Adapter, self.height/7.0);
    _loginBtn.frame = CGRectMake(30*W_Adapter, CGRectGetMaxY(_passwordTF.frame)+30*H_Adapter, self.width - 60*W_Adapter, self.height/7.0);
//    _forgetBtn.frame = CGRectMake(CGRectGetMinX(_loginBtn.frame), CGRectGetMaxY(_loginBtn.frame) +(self.height - CGRectGetMaxY(_loginBtn.frame)-_forgetBtn.height)*0.5, _forgetBtn.width, _forgetBtn.height);
//    _registerBtn.frame = CGRectMake(self.width -30*W_Adapter - _registerBtn.width , CGRectGetMinY(_forgetBtn.frame), _registerBtn.width, _registerBtn.height);
}

@end
