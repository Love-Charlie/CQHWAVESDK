//
//  CQHChangeAccountView.m
//  WaveSDK
//
//  Created by  Charlie on 2020/4/19.
//  Copyright © 2020 Love Charlie. All rights reserved.
//

#import "CQHChangeAccountView.h"
#import "CQHTools.h"
#import "UIView+Frame.h"
#import "CQHButton.h"
#import <objc/runtime.h>

@interface CQHChangeAccountView()

@property (nonatomic , weak) UILabel *registerLabel ;
@property (nonatomic , weak) UIButton *backBtn ;
@property (nonatomic , weak) UIView *line;
@property (nonatomic , weak) UITextField *phoneTF;
@property (nonatomic , weak) UITextField *passwordTF;
@property (nonatomic , weak) UIButton *loginBtn;
@property (nonatomic , weak) UIButton *xinRegisterBtn;
@property (nonatomic , weak) UIButton *forgetBtn;
@property (nonatomic , weak) UIView *line1;
@property (nonatomic , weak) UIView *btnContentView ;
@property (nonatomic , weak) CQHButton *WXBtn;
@property (nonatomic , weak) CQHButton *resetBtn;
@property (nonatomic , weak) CQHButton *bangdingBtn;
@end

@implementation CQHChangeAccountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        [self setBackgroundColor:[UIColor whiteColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange1) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        
        UILabel *registerLabel = [[UILabel alloc] init];
        _registerLabel = registerLabel;
        [registerLabel setText:@"切换账号"];
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
        
        
        UIView *rightViewContent = [[UIView alloc] init];
        rightViewContent.frame = CGRectMake(0, 0, 30, 30);
                UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightView addTarget:self action:@selector(rightViewClick:) forControlEvents:UIControlEventTouchUpInside];
                [rightView setImage:[CQHTools bundleForImage:@"下拉按钮" packageName:@""] forState:UIControlStateNormal];
        rightView.frame = CGRectMake(0, 5, 20, 20);
        
        [rightViewContent addSubview:rightView];
        phoneTF.rightView = rightViewContent;
        phoneTF.rightViewMode = UITextFieldViewModeAlways;
                
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
        
        /*******************************************************************************************************/
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
        //        [passwordTF setValue:[UIFont boldSystemFontOfSize:12.0] forKeyPath:@"_placeholderLabel.font"];
                Ivar ivar1 =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
                UILabel *placeholderLabel1 = object_getIvar(passwordTF, ivar1);
                placeholderLabel1.text = @" 请输入密码";
                placeholderLabel1.textColor = [UIColor lightGrayColor];
                [placeholderLabel1 setFont:[UIFont systemFontOfSize:12.0]];
                
                UIView *contentLeftView2 = [[UIView alloc] init];
                [contentLeftView2 setBackgroundColor:[UIColor whiteColor]];
                contentLeftView2.frame = CGRectMake(0, 0, 30*W_Adapter, 30*W_Adapter);
                
                
                UIButton *usernameTFLeftView2 = [[UIButton alloc] init];
                usernameTFLeftView2.frame = CGRectMake(5*W_Adapter, 5*W_Adapter, 20*W_Adapter, 20*W_Adapter);
                [usernameTFLeftView2 setImage:[CQHTools bundleForImage:@"密码icon深色" packageName:@""] forState:UIControlStateNormal];
                
                [contentLeftView2 addSubview:usernameTFLeftView2];
                passwordTF.leftView = contentLeftView2;
                passwordTF.leftViewMode = UITextFieldViewModeAlways;
                
//
//                UIButton *usernameTFRightView2 = [[UIButton alloc] init];
//                usernameTFRightView2.frame = CGRectMake(0, 0, 15*W_Adapter, 15*H_Adapter);
//                [usernameTFRightView2 setImage:[CQHTools bundleForImage:@"6" packageName:@"1"] forState:UIControlStateNormal];
                [self addSubview:passwordTF];
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
               [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
               _loginBtn = loginBtn;
               [loginBtn setBackgroundColor:[UIColor colorWithRed:216/255.0 green:58/255.0 blue:41/255.0 alpha:1]];
               [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
               [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
               loginBtn.layer.cornerRadius = 5.0;
               loginBtn.layer.masksToBounds = YES;
               [self addSubview:loginBtn];
        
        UIButton *xinRegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _xinRegisterBtn = xinRegisterBtn;
        [xinRegisterBtn setTitle:@"新账号注册" forState:UIControlStateNormal];
        [xinRegisterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [xinRegisterBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [xinRegisterBtn sizeToFit];
        
        [self addSubview:xinRegisterBtn];
        
        
        UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetBtn = forgetBtn;
        [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [forgetBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [forgetBtn sizeToFit];
        
        [self addSubview:forgetBtn];
        
        UIView *line1 = [[UIView alloc] init];
        _line1 = line1;
        [line1 setBackgroundColor:[UIColor lightGrayColor]];
        line1.alpha = 0.5;
        [self addSubview:line1];
        
        //***********************************************************//
        
        UIView *btnContentView = [[UIView alloc] init];
        _btnContentView = btnContentView;
//        [btnContentView setBackgroundColor:[UIColor greenColor]];
        [self addSubview:btnContentView];
        
        CQHButton *WXBtn = [CQHButton buttonWithType:UIButtonTypeCustom];
        _WXBtn = WXBtn;
        [WXBtn setImage:[CQHTools bundleForImage:@"wx登录" packageName:@""] forState:UIControlStateNormal];
        [WXBtn addTarget:self action:@selector(WXBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [WXBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [WXBtn setTitle:@"微信登录" forState:UIControlStateNormal];
        [WXBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [WXBtn sizeToFit];
        
        [btnContentView addSubview:WXBtn];
        
//        [self addSubview:WXBtn];
        
        CQHButton *resetBtn = [CQHButton buttonWithType:UIButtonTypeCustom];
        _resetBtn = resetBtn;
        [resetBtn setImage:[CQHTools bundleForImage:@"绑定手机" packageName:@""] forState:UIControlStateNormal];
        [resetBtn addTarget:self action:@selector(resetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [resetBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [resetBtn setTitle:@"重置密码" forState:UIControlStateNormal];
        [resetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [resetBtn sizeToFit];
        
        [btnContentView addSubview:resetBtn];
        
        
        CQHButton *bangdingBtn = [CQHButton buttonWithType:UIButtonTypeCustom];
        _bangdingBtn = bangdingBtn;
        [bangdingBtn setImage:[CQHTools bundleForImage:@"绑定手机" packageName:@""] forState:UIControlStateNormal];
        [bangdingBtn addTarget:self action:@selector(bangdingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [bangdingBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [bangdingBtn setTitle:@"绑定手机" forState:UIControlStateNormal];
        [bangdingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bangdingBtn sizeToFit];
        
        [btnContentView addSubview:bangdingBtn];

    }
    return self;
}

- (void)bangdingBtnClick:(UIButton *)btn
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)resetBtnClick:(UIButton *)btn
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)WXBtnClick:(UIButton *)btn
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)rightViewClick:(UIButton *)btn
{
    NSLog(@"%s",__FUNCTION__);

}

- (void)loginBtnClick:(UIButton *)btn
{
    NSLog(@"%s",__FUNCTION__);

}

- (void)backBtnClick:(UIButton *)btn
{
    NSLog(@"%s",__FUNCTION__);

}

- (void)statusBarOrientationChange1
{
    self.superview.frame = KEYWINDOW.bounds;
    double a = [UIScreen mainScreen].bounds.size.height >  [UIScreen mainScreen].bounds.size.width?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height;
    self.bounds = CGRectMake(0, 0, a - 30, a - 30);
    self.center = CGPointMake(self.superview.frame.size.width *0.5, self.superview.frame.size.height *0.5);
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _registerLabel.frame = CGRectMake((self.width -_registerLabel.width)*0.5 , 20, _registerLabel.width, _registerLabel.height);
    _backBtn.frame = CGRectMake(25*W_Adapter, 20, _registerLabel.height , _registerLabel.height);
    _line.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_registerLabel.frame)+20, self.width - 50*W_Adapter, 1);
    
    _phoneTF.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_line.frame)+15, self.width - 50*W_Adapter, 40*H_Adapter);
    _passwordTF.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_phoneTF.frame)+15,  self.width - 50*W_Adapter, 40*H_Adapter);
    _loginBtn.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_passwordTF.frame)+15, self.width - 50*W_Adapter, 40*H_Adapter);
    _xinRegisterBtn.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_loginBtn.frame)+10, _xinRegisterBtn.width, _xinRegisterBtn.height);
    _forgetBtn.frame = CGRectMake(self.width - _forgetBtn.width - 25*W_Adapter, CGRectGetMaxY(_loginBtn.frame)+10, _forgetBtn.width, _forgetBtn.height);
    _line1.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_forgetBtn.frame)+10, self.width - 50*W_Adapter, 1);
    _btnContentView.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_line1.frame), self.width - 50*W_Adapter, self.width - CGRectGetMaxY(_line1.frame));
    _WXBtn.frame = CGRectMake(0, 5, _btnContentView.height-5, _btnContentView.height-5);
    
    CGFloat marge = (_btnContentView.width- 3*_WXBtn.width)*0.5;
    _resetBtn.frame = CGRectMake(CGRectGetMaxX(_WXBtn.frame)+marge, 5, _btnContentView.height-5, _btnContentView.height-5);
    _bangdingBtn.frame = CGRectMake(CGRectGetMaxX(_resetBtn.frame)+marge, 5, _btnContentView.height-5, _btnContentView.height-5);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
