//
//  CQHAutoLoginView.m
//  WaveSDK
//
//  Created by Love Charlie on 2020/4/15.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "CQHAutoLoginView.h"
#import "UIView+Frame.h"
#import "WSDK.h"
#import "CQHChangeAccountView.h"
#import "AFNetworking.h"
#import "CQHTools.h"
#import "MBProgressHUD.h"
#import "CQHHUDView.h"
#import "CQHMainLoginView.h"

@interface CQHAutoLoginView()

@property (nonatomic , weak) UILabel *accountNameLabel;
@property (nonatomic , weak) UIButton *changeLoginBtn ;
@end

@implementation CQHAutoLoginView

//点击切换按钮标识
static NSInteger isSwitch;

//解决AFN内存泄露的问题，使用单例模式解决
static AFHTTPSessionManager *manager ;
- (AFHTTPSessionManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 20;
        //        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"text/json",@"text/javascript", nil];
    });
    return manager;
}


static CQHAutoLoginView *autoLoginView;
static dispatch_once_t onceToken;
+ (CQHAutoLoginView *)sharedAutoLoginView {
    
    dispatch_once(&onceToken, ^{
        autoLoginView = [[self alloc] init];
    });
    return autoLoginView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        UILabel *accountNameLabel = [[UILabel alloc] init];
        [accountNameLabel setTextColor:[UIColor blackColor]];
        _accountNameLabel = accountNameLabel;
        [accountNameLabel setFont:[UIFont systemFontOfSize:11.0]];
        
        
        UIButton *changeLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [changeLoginBtn addTarget:self action:@selector(changeLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _changeLoginBtn = changeLoginBtn;
        [changeLoginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [changeLoginBtn setTitle:@"切换账号" forState:UIControlStateNormal];
        [changeLoginBtn.titleLabel  setFont:[UIFont systemFontOfSize:11.0]];
        [changeLoginBtn sizeToFit];
        
        [self addSubview:accountNameLabel];
        [self addSubview:changeLoginBtn];
        
        isSwitch = 0;
    }
    return self;
}

- (void)setUserModel:(CQHUserModel *)userModel
{
    _userModel = userModel;
    
    NSLog(@"%@,%@",userModel.accountName,userModel.password);
    
    NSMutableAttributedString *Att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ , 正在登录...",userModel.accountName]];
    NSUInteger length = [userModel.accountName length];
    [Att addAttribute:NSForegroundColorAttributeName value:[UIColor  redColor] range:NSMakeRange(0,length)];
    _accountNameLabel.attributedText = Att;
    _accountNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    //自动登录请求
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
    dict[@"username"] = userModel.accountName;
//    dict[@"password"] =  [CQHTools md5:userModel.password];
    dict[@"password"] =  [CQHTools jiami:userModel.password];
    
    
    
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
    dict1[@"username"] = userModel.accountName;
//    dict1[@"password"] =  [CQHTools md5:userModel.password];
    dict1[@"password"] =  [CQHTools jiami:userModel.password];
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
    
    WSDK *wsdk = [WSDK sharedCQHSDK];
    
    [[self sharedManager] POST:[NSString stringWithFormat:@"%@sdk/login?data=%@",BASE_URL,newStr] parameters:dict3 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [userDefaults setObject:responseObject[@"data"][@"userId"] forKey:@"userId"];
            [userDefaults synchronize];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //是否点击了切换按钮
                [self.superview removeFromSuperview];
                [self removeFromSuperview];
                if (isSwitch == 0) {
                    if ([wsdk.delegate respondsToSelector:@selector(loginSuccessWithResponse:)]) {
                        [wsdk.delegate loginSuccessWithResponse:responseObject[@"data"]];
                        
                        if ([responseObject[@"data"][@"authStatus"] integerValue] == 1) {
                            
                            if ([responseObject[@"data"][@"authInfo"][@"idno"] isEqualToString:@""]) {
                                NSLog(@"没有认证");
                                //
                                [CQHHUDView showVerView];
                            }
                        }
                    }
                }
            });
            
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
        [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
//        [hud hideAnimated:YES];
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


- (void)changeLoginBtnClick:(UIButton *)btn
{
    isSwitch = 1 ;
    CQHChangeAccountView *changeAccountView = [[CQHChangeAccountView alloc] init];
    changeAccountView.userModel = _userModel;
    [self.superview addSubview:changeAccountView];
    changeAccountView.frame = CGRectMake(100, 100, 100, 100 );
    double a = [UIScreen mainScreen].bounds.size.height >  [UIScreen mainScreen].bounds.size.width?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height;
    changeAccountView.bounds = CGRectMake(0, 0, a - 30, a - 30);
    changeAccountView.center = CGPointMake(self.superview.frame.size.width *0.5, self.superview.frame.size.height *0.5);
    [self removeFromSuperview];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _accountNameLabel.frame = CGRectMake(20, 0, self.width*0.5, self.height);
    _changeLoginBtn.frame = CGRectMake(self.width - _changeLoginBtn.width - 20, 0, _changeLoginBtn.width, self.height);
}

@end
