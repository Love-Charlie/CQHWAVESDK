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
@end

@implementation CQHForgetPasswordView

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
        [usernameTF setValue:[UIFont boldSystemFontOfSize:12.0] forKeyPath:@"_placeholderLabel.font"];
        
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
        _verificationCodeTF = verificationCodeTF;
        [verificationCodeTF setBackgroundColor:[UIColor whiteColor]];
        verificationCodeTF.layer.cornerRadius = 6.0;
        verificationCodeTF.layer.borderColor= [UIColor lightGrayColor].CGColor;
        verificationCodeTF.layer.borderWidth= 1.0f;
        verificationCodeTF.layer.masksToBounds = YES;
        verificationCodeTF.tintColor = [UIColor colorWithRed:214.0/255.0 green:6.0/255.0 blue:0/255.0 alpha:1];
        verificationCodeTF.placeholder=@" 请输入验证码";
        [verificationCodeTF setValue:[UIFont boldSystemFontOfSize:12.0] forKeyPath:@"_placeholderLabel.font"];
        
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
        verificationCodeBtn.layer.cornerRadius = 5.0;
        verificationCodeBtn.layer.masksToBounds = YES;
        [verificationCodeBtn  setBackgroundColor:[UIColor colorWithRed:226/255.0 green:88/255.0 blue:65/255.0 alpha:1]];
        [verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [verificationCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        _verificationCodeBtn = verificationCodeBtn;
        [verificationCodeTF addSubview:verificationCodeBtn];
         /***************************************************************************************************/
        UITextField *passwordTF = [[UITextField alloc] init];
        _passwordTF = passwordTF;
        [passwordTF setBackgroundColor:[UIColor whiteColor]];
        passwordTF.layer.cornerRadius = 6.0;
        passwordTF.layer.borderColor= [UIColor lightGrayColor].CGColor;
        passwordTF.layer.borderWidth= 1.0f;
        passwordTF.layer.masksToBounds = YES;
        passwordTF.tintColor = [UIColor colorWithRed:214.0/255.0 green:6.0/255.0 blue:0/255.0 alpha:1];
        passwordTF.placeholder=@" 请输入密码";
        [passwordTF setValue:[UIFont boldSystemFontOfSize:12.0] forKeyPath:@"_placeholderLabel.font"];
        
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
        _passwordTF1 = passwordTF1;
        [passwordTF1 setBackgroundColor:[UIColor whiteColor]];
        passwordTF1.layer.cornerRadius = 6.0;
        passwordTF1.layer.borderColor= [UIColor lightGrayColor].CGColor;
        passwordTF1.layer.borderWidth= 1.0f;
        passwordTF1.layer.masksToBounds = YES;
        passwordTF1.tintColor = [UIColor colorWithRed:214.0/255.0 green:6.0/255.0 blue:0/255.0 alpha:1];
        passwordTF1.placeholder=@" 请再次输入密码";
        [passwordTF1 setValue:[UIFont boldSystemFontOfSize:12.0] forKeyPath:@"_placeholderLabel.font"];
        
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
        loginBtn.layer.cornerRadius = 6.0;
        loginBtn.layer.masksToBounds = YES;
        [loginBtn setTitle:@"修改密码并登录" forState:UIControlStateNormal];
        [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [loginBtn setBackgroundColor:[UIColor colorWithRed:226/255.0 green:88/255.0 blue:65/255.0 alpha:1]];
        _loginBtn = loginBtn;
        [self addSubview:loginBtn];
    }
    return self;
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
    _loginBtn.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_passwordTF1.frame)+(self.height - CGRectGetMaxY(_passwordTF1.frame) - 40*H_Adapter)*0.5, self.width - 50*W_Adapter, 40*H_Adapter);
}
@end
