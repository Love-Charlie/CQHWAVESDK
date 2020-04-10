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

@interface CQHPhontLoginView()
@property (nonatomic , weak) UILabel *registerLabel ;
@property (nonatomic , weak) UIButton *backBtn ;
@property (nonatomic , weak) UIView *line;
@property (nonatomic , weak) UIView *phoneTF;
@property (nonatomic , weak) UILabel *desLabel;
@property (nonatomic , weak) UIImageView *imageView;
@property (nonatomic , weak) UITextField *verificationCodeTF;
@property (nonatomic , weak) UIButton *verificationCodeBtn;
@property (nonatomic , weak) UITextField *passwordTF;
@property (nonatomic , weak) UIButton *regAndLoginBtn;
@property (nonatomic , strong) CQHKeyboardProcess *process;
@end

@implementation CQHPhontLoginView

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
        [phoneTF setValue:[UIFont boldSystemFontOfSize:12.0] forKeyPath:@"_placeholderLabel.font"];
        
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
        /***************************************************************************************************/
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
        UIButton *regAndLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        regAndLoginBtn.layer.cornerRadius = 6.0;
        regAndLoginBtn.layer.masksToBounds = YES;
        [regAndLoginBtn setTitle:@"注册并登录" forState:UIControlStateNormal];
        [regAndLoginBtn setBackgroundColor:[UIColor colorWithRed:226/255.0 green:88/255.0 blue:65/255.0 alpha:1]];
        _regAndLoginBtn = regAndLoginBtn;
        [self addSubview:regAndLoginBtn];
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
    _line.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_registerLabel.frame)+20, self.width - 50*W_Adapter, 1);
    _phoneTF.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_line.frame)+15*H_Adapter, self.width - 50*W_Adapter, 35);
    _desLabel.frame = CGRectMake(40*W_Adapter, CGRectGetMaxY(_phoneTF.frame)+10*H_Adapter, self.width - 50*W_Adapter-_desLabel.height, _desLabel.height);
    _imageView.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_phoneTF.frame)+10*H_Adapter,  _desLabel.height,  _desLabel.height);
    _verificationCodeTF.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_desLabel.frame)+10*H_Adapter, self.width - 50*W_Adapter, 35);
    _verificationCodeBtn.frame = CGRectMake(_verificationCodeTF.width*0.7-3 , 5, _verificationCodeTF.width*0.3-3, 25);
    _passwordTF.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_verificationCodeTF.frame)+20*H_Adapter, self.width - 50*W_Adapter, 35);
    _regAndLoginBtn.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_passwordTF.frame)+20*H_Adapter, self.width - 50*W_Adapter, 35);
}

@end
