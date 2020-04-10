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
#import <objc/runtime.h>

@interface CQHRegisterView()
@property (nonatomic , weak)  UIImageView *imageView;
@property (nonatomic , weak)  UIView *line;
@property (nonatomic , weak) UIButton *backBtn ;
@property (nonatomic , weak) UITextField *usernameTF ;
@property (nonatomic , weak) UITextField *passwordTF ;
@property (nonatomic , weak) UIButton *loginBtn ;
@property (nonatomic , weak) UIButton *forgetBtn;
@property (nonatomic , weak) UIButton *registerBtn;
@end

@implementation CQHRegisterView

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
        
        
        /*******************************************************************************************************/
        UITextField *passwordTF = [[UITextField alloc] init];
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
        [self addSubview:passwordTF];
        
        /*******************************************************************************************************/
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn = loginBtn;
        [loginBtn setBackgroundColor:[UIColor colorWithRed:216/255.0 green:58/255.0 blue:41/255.0 alpha:1]];
        [loginBtn setTitle:@"注册并登录" forState:UIControlStateNormal];
        [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
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
    _usernameTF.frame = CGRectMake(30*W_Adapter, CGRectGetMaxY(_line.frame)+25*H_Adapter, self.width - 60*W_Adapter, 40);
    _passwordTF.frame = CGRectMake(30*W_Adapter, CGRectGetMaxY(_usernameTF.frame)+25*H_Adapter, self.width - 60*W_Adapter, 40);
    _loginBtn.frame = CGRectMake(30*W_Adapter, CGRectGetMaxY(_passwordTF.frame)+30*H_Adapter, self.width - 60*W_Adapter, 40);
//    _forgetBtn.frame = CGRectMake(CGRectGetMinX(_loginBtn.frame), CGRectGetMaxY(_loginBtn.frame) +(self.height - CGRectGetMaxY(_loginBtn.frame)-_forgetBtn.height)*0.5, _forgetBtn.width, _forgetBtn.height);
//    _registerBtn.frame = CGRectMake(self.width -30*W_Adapter - _registerBtn.width , CGRectGetMinY(_forgetBtn.frame), _registerBtn.width, _registerBtn.height);
}

@end
