//
//  CQHEditPasswordView.m
//  WaveSDK
//
//  Created by  Charlie on 2020/5/20.
//  Copyright © 2020 Love Charlie. All rights reserved.
//

#import "CQHEditPasswordView.h"
#import "CQHKeyboardProcess.h"
#import "CQHHUDView.h"
#import "CQHTools.h"
#import "UIView+Frame.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "CQHUserModel.h"
#import "CQHHUDView.h"
#import "WSDK.h"

@interface CQHEditPasswordView()<UITextFieldDelegate>

@property(nonatomic , strong) CQHKeyboardProcess *process;
@property (nonatomic , weak) UILabel *registerLabel;
@property (nonatomic , weak) UIButton *backBtn;
@property (nonatomic , weak) UIView *line;
@property (nonatomic , weak) UILabel *contentLabel;
@property (nonatomic , weak) UITextField *passwordTF;
@property (nonatomic , weak) UITextField *passwordTF1;
@property (nonatomic , weak) UITextField *passwordTF2;
@property (nonatomic , weak) UIButton *editAndLoginBtn;

@end


@implementation CQHEditPasswordView

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
        [registerLabel setText:@"修改密码"];
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
        
        UITextField *passwordTF = [[UITextField alloc] init];
        passwordTF.returnKeyType = UIReturnKeyNext;
        passwordTF.delegate = self;
        passwordTF.secureTextEntry = YES;
        passwordTF.textColor = [UIColor blackColor];
        passwordTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        UIImageView *leftView = [[UIImageView alloc] init];
        [leftView setImage:[CQHTools bundleForImage:@"账号icon深色" packageName:@""]];
        leftView.frame =CGRectMake(0, 0, 15, 15);
        passwordTF.leftView = leftView;
        passwordTF.leftViewMode = UITextFieldViewModeAlways;
                        
        [passwordTF setBackgroundColor:[UIColor whiteColor]];
        passwordTF.layer.cornerRadius = 6.0;
        passwordTF.layer.borderColor= [UIColor lightGrayColor].CGColor;
        passwordTF.layer.borderWidth= 1.0f;
        passwordTF.layer.masksToBounds = YES;
        passwordTF.tintColor = [UIColor colorWithRed:214.0/255.0 green:6.0/255.0 blue:0/255.0 alpha:1];
        _passwordTF = passwordTF;
        passwordTF.placeholder=@" 请输入旧密码";
        
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@" 请输入旧密码" attributes:
        @{NSForegroundColorAttributeName:[UIColor grayColor],
                     NSFontAttributeName:passwordTF.font
             }];
        passwordTF.attributedPlaceholder = attrString;
                        
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
        
        /////////////////////////////////////////////////////////////////////////
        UITextField *passwordTF1 = [[UITextField alloc] init];
        passwordTF1.returnKeyType = UIReturnKeyNext;
        passwordTF1.delegate = self;
        passwordTF1.secureTextEntry = YES;
        passwordTF1.textColor = [UIColor blackColor];
        passwordTF1.clearButtonMode=UITextFieldViewModeWhileEditing;
        UIImageView *leftView1 = [[UIImageView alloc] init];
        [leftView1 setImage:[CQHTools bundleForImage:@"账号icon深色" packageName:@""]];
        leftView1.frame =CGRectMake(0, 0, 15, 15);
        passwordTF1.leftView = leftView1;
        passwordTF1.leftViewMode = UITextFieldViewModeAlways;
                               
        [passwordTF1 setBackgroundColor:[UIColor whiteColor]];
        passwordTF1.layer.cornerRadius = 6.0;
        passwordTF1.layer.borderColor= [UIColor lightGrayColor].CGColor;
        passwordTF1.layer.borderWidth= 1.0f;
        passwordTF1.layer.masksToBounds = YES;
        passwordTF1.tintColor = [UIColor colorWithRed:214.0/255.0 green:6.0/255.0 blue:0/255.0 alpha:1];
        _passwordTF1 = passwordTF1;
        passwordTF1.placeholder=@" 请输入新密码";
        
        UIView *rightViewContent1 = [[UIView alloc] init];
        rightViewContent1.frame = CGRectMake(0, 0, 30, 30);
        
        UIButton *passwordTFRightView = [[UIButton alloc] init];
        passwordTFRightView.frame = CGRectMake(7.5, 7.5, 15, 15);
        
        
        [passwordTFRightView setImage:[CQHTools bundleForImage:@"7" packageName:@""] forState:UIControlStateNormal];
        [passwordTFRightView setImage:[CQHTools bundleForImage:@"9" packageName:@""] forState:UIControlStateSelected];
        passwordTF1.rightView = rightViewContent1;
        passwordTF1.rightViewMode = UITextFieldViewModeAlways;
        [passwordTFRightView addTarget:self action:@selector(eyeClick1:) forControlEvents:UIControlEventTouchUpInside];
                
        [rightViewContent1 addSubview:passwordTFRightView];
               
        NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:@" 请输入新密码" attributes:
               @{NSForegroundColorAttributeName:[UIColor grayColor],
                            NSFontAttributeName:passwordTF1.font
                    }];
        passwordTF1.attributedPlaceholder = attrString1;
                               
        UIView *contentLeftView1 = [[UIView alloc] init];
        [contentLeftView1 setBackgroundColor:[UIColor whiteColor]];
        contentLeftView1.frame = CGRectMake(0, 0, 30*W_Adapter, 30*W_Adapter);
                               
                               
        UIButton *usernameTFLeftView1 = [[UIButton alloc] init];
        usernameTFLeftView1.frame = CGRectMake(5*W_Adapter, 5*W_Adapter, 20*W_Adapter, 20*W_Adapter);
        [usernameTFLeftView1 setImage:[CQHTools bundleForImage:@"密码icon深色" packageName:@""] forState:UIControlStateNormal];
                               
        [contentLeftView1 addSubview:usernameTFLeftView1];
        passwordTF1.leftView = contentLeftView1;
        passwordTF1.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:passwordTF1];
        
        
        /////////////////////////////////////////////////////////////////////////
        UITextField *passwordTF2 = [[UITextField alloc] init];
        passwordTF2.returnKeyType = UIReturnKeyDone;
        passwordTF2.delegate = self;
        passwordTF2.secureTextEntry = YES;
        passwordTF2.textColor = [UIColor blackColor];
        passwordTF2.clearButtonMode=UITextFieldViewModeWhileEditing;
        UIImageView *leftView2 = [[UIImageView alloc] init];
        [leftView2 setImage:[CQHTools bundleForImage:@"账号icon深色" packageName:@""]];
        leftView2.frame =CGRectMake(0, 0, 15, 15);
        passwordTF2.leftView = leftView2;
        passwordTF2.leftViewMode = UITextFieldViewModeAlways;
                               
        [passwordTF2 setBackgroundColor:[UIColor whiteColor]];
        passwordTF2.layer.cornerRadius = 6.0;
        passwordTF2.layer.borderColor= [UIColor lightGrayColor].CGColor;
        passwordTF2.layer.borderWidth= 1.0f;
        passwordTF2.layer.masksToBounds = YES;
        passwordTF2.tintColor = [UIColor colorWithRed:214.0/255.0 green:6.0/255.0 blue:0/255.0 alpha:1];
        _passwordTF2 = passwordTF2;
        passwordTF2.placeholder=@" 请再次输入新密码";
        
        
        UIView *rightViewContent2 = [[UIView alloc] init];
        rightViewContent2.frame = CGRectMake(0, 0, 30, 30);
        
        UIButton *passwordTFRightView2 = [[UIButton alloc] init];
        passwordTFRightView2.frame = CGRectMake(7.5, 7.5, 15, 15);
        
        
        [passwordTFRightView2 setImage:[CQHTools bundleForImage:@"7" packageName:@""] forState:UIControlStateNormal];
        [passwordTFRightView2 setImage:[CQHTools bundleForImage:@"9" packageName:@""] forState:UIControlStateSelected];
        passwordTF2.rightView = rightViewContent2;
        passwordTF2.rightViewMode = UITextFieldViewModeAlways;
        [passwordTFRightView2 addTarget:self action:@selector(eyeClick2:) forControlEvents:UIControlEventTouchUpInside];
                
        [rightViewContent2 addSubview:passwordTFRightView2];
               
        NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@" 请再次输入新密码" attributes:
               @{NSForegroundColorAttributeName:[UIColor grayColor],
                            NSFontAttributeName:passwordTF2.font
                    }];
        passwordTF2.attributedPlaceholder = attrString2;
                               
        UIView *contentLeftView2 = [[UIView alloc] init];
        [contentLeftView2 setBackgroundColor:[UIColor whiteColor]];
        contentLeftView2.frame = CGRectMake(0, 0, 30*W_Adapter, 30*W_Adapter);
                               
                               
        UIButton *usernameTFLeftView2 = [[UIButton alloc] init];
        usernameTFLeftView2.frame = CGRectMake(5*W_Adapter, 5*W_Adapter, 20*W_Adapter, 20*W_Adapter);
        [usernameTFLeftView2 setImage:[CQHTools bundleForImage:@"密码icon深色" packageName:@""] forState:UIControlStateNormal];
                               
        [contentLeftView2 addSubview:usernameTFLeftView2];
        passwordTF2.leftView = contentLeftView2;
        passwordTF2.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:passwordTF2];
        
        
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

#pragma mark点击眼睛图标
- (void)eyeClick1:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.passwordTF1.secureTextEntry = !btn.selected;
    NSString *psd = self.passwordTF1.text;
    self.passwordTF1.text = @"";
    self.passwordTF1.text = psd;

}

#pragma mark点击眼睛图标
- (void)eyeClick2:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.passwordTF2.secureTextEntry = !btn.selected;
    NSString *psd = self.passwordTF2.text;
    self.passwordTF2.text = @"";
    self.passwordTF2.text = psd;

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:_passwordTF] && [string isEqualToString:@"\n"]) {
        [_passwordTF1 becomeFirstResponder];
    }

    if ([textField isEqual:_passwordTF1] && [string isEqualToString:@"\n"]) {
        [_passwordTF2 becomeFirstResponder];
    }
    
    if ([textField isEqual:_passwordTF2] && [string isEqualToString:@"\n"]) {
        [_passwordTF2 resignFirstResponder];
    }
    return YES;
}

- (void)setUsername:(NSString *)username
{
    _username = username;
    _username = username;
       if (username.length > 16) {
            username = [username stringByReplacingCharactersInRange:NSMakeRange(5, username.length - 10) withString:@"...."];
       }
       [_contentLabel setTextColor:[UIColor blackColor]];
       
       _contentLabel.font = [UIFont systemFontOfSize:13.0];
       _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
       _contentLabel.numberOfLines = 0;
       
       
       NSMutableAttributedString *Att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"正在给账号 : %@, 修改密码",username]];
       
       [Att addAttribute:NSForegroundColorAttributeName value:[UIColor  redColor] range:NSMakeRange(8,username.length)];
       _contentLabel.attributedText = Att;
       [_contentLabel sizeToFit];
}

- (void)backBtnClick:(UIButton *)btn
{
    [self removeFromSuperview];
}


- (void)editAndLoginBtnClick:(UIButton *)btn
{
    
    
    if (![_passwordTF1.text isEqualToString:_passwordTF2.text]) {
        [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
        hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"两次密码不一致！", @"HUD message title");
        [hud hideAnimated:YES afterDelay:1.f];
        return;
    }
    
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
    dict[@"username"] = _username;
    dict[@"oldPassword"] = [CQHTools jiami:_passwordTF.text];
    dict[@"password"] = [CQHTools jiami:_passwordTF1.text];
    dict[@"enterPassword"] = [CQHTools jiami:_passwordTF1.text];
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
        dict1[@"username"] = _username;
        dict1[@"oldPassword"] = [CQHTools jiami:_passwordTF.text];
        dict1[@"password"] = [CQHTools jiami:_passwordTF1.text];
        dict1[@"enterPassword"] = [CQHTools jiami:_passwordTF1.text];
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
    [[self sharedManager] POST:[NSString stringWithFormat:@"%@sdk/password/edit?data=%@",BASE_URL,newStr] parameters:dict3 headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject[@"code"] integerValue] == 200) {
            
            
            CQHUserModel *userModel = [[CQHUserModel alloc] init];
            userModel.accountName = responseObject[@"data"][@"accountName"];
            userModel.password = self.passwordTF1.text;
            //            userModel.username = responseObject[@"data"][@"username"];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userModel];
            
            [userDefaults setObject:data forKey:CQHUSERMODEL];
            
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


-(void)layoutSubviews
{
    [super layoutSubviews];
    _registerLabel.frame = CGRectMake((self.width -_registerLabel.width)*0.5 , self.height/25.0, _registerLabel.width, _registerLabel.height);
     _backBtn.frame = CGRectMake(25*W_Adapter, self.height/25.0, _registerLabel.height , _registerLabel.height);
     
      _line.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_registerLabel.frame)+self.height/30.0, self.width - 50*W_Adapter, 1);
    
    
    
     _contentLabel.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_line.frame)+self.height/60.0, self.width - 50*W_Adapter, _contentLabel.height);
    
    _passwordTF.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_contentLabel.frame)+self.height/60.0,  self.width - 50*W_Adapter, self.height/7.0);
    
    _passwordTF1.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_passwordTF.frame)+self.height/30.0,  self.width - 50*W_Adapter, self.height/7.0);
    
    _passwordTF2.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_passwordTF1.frame)+self.height/30.0,  self.width - 50*W_Adapter, self.height/7.0);
     _editAndLoginBtn.frame = CGRectMake(25*W_Adapter,CGRectGetMaxY(_passwordTF2.frame)+ (self.height - CGRectGetMaxY(_passwordTF2.frame)-self.height/7.0)*0.5, self.width - 50*W_Adapter, self.height/7.0);
}
@end
