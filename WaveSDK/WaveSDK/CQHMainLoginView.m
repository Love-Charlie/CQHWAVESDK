//
//  CQHMainLoginView.m
//  WaveSDK
//
//  Created by Love Charlie on 2020/3/24.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "CQHMainLoginView.h"
#import "CQHTools.h"
#import "UIView+Frame.h"
#import "MBProgressHUD.h"
#import "CQHAgreementView.h"
#import "CQHRegisterAndLoginView.h"
#import "CQHPhontLoginView.h"
#import "CQHUsernameLoginView.h"
#import "CQHRealNameVerificationView.h"
#import "CQHTipsView.h"
#import "AFNetworking.h"
#import "CQHConfig.h"
#import "WaveSDK.h"
#import "CQHHUDView.h"
#import "CQHAutoLoginView.h"
#import "JQFMDB.h"
#import "CQHUserModel.h"

@interface CQHMainLoginView()

@property (nonatomic , weak)  UIImageView *imageView;
@property (nonatomic , weak)  UIView *line;
@property (nonatomic , weak)  UIButton *wxBtn;
@property (nonatomic , weak)  UIButton *phontBtn;
@property (nonatomic , weak)  UIButton *kuaisuBtn;
@property (nonatomic , weak)  UIButton *xieyiBtn;
@property (nonatomic , weak)  UIButton *tongyiBtn;
@property (nonatomic , weak)  UIView *redLine;
@property (nonatomic , weak)  UIButton *youkeBtn;

@end

@implementation CQHMainLoginView

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


static CQHMainLoginView *mainLoginView;
static dispatch_once_t onceToken;
+ (CQHMainLoginView *)sharedMainLoginView {
    
    dispatch_once(&onceToken, ^{
        mainLoginView = [[self alloc] init];
        [CQHAgreementView sharedAgreementView];
    });
    return mainLoginView;
}

+(void)deallocMainLoginView{
    onceToken = 0;
    mainLoginView = nil;

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
        
        UIButton *wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [wxBtn setBackgroundImage:[CQHTools bundleForImage:@"微信登录" packageName:@""] forState:UIControlStateNormal];
        [wxBtn addTarget:self action:@selector(wxBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        wxBtn.layer.cornerRadius = 5.0;
        wxBtn.layer.masksToBounds = YES;
        _wxBtn = wxBtn;
        [wxBtn setBackgroundColor:[UIColor colorWithRed:24/255.0 green:150/255.0 blue:104/255.0 alpha:1]];
        wxBtn.frame = CGRectMake(20, CGRectGetMaxY(line.frame)+20, self.width - 40, 40);
        [wxBtn setImageEdgeInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
        [wxBtn.imageView setContentMode:UIViewContentModeScaleToFill];
        [self addSubview:wxBtn];
        
        UIButton *phontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [phontBtn addTarget:self action:@selector(phontBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _phontBtn = phontBtn;
        [phontBtn setBackgroundImage:[CQHTools bundleForImage:@"手机登录" packageName:@""] forState:UIControlStateNormal];
        phontBtn.layer.cornerRadius = 5.0;
        phontBtn.layer.masksToBounds = YES;
        [self addSubview:phontBtn];
        
        
        UIButton *kuaisuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [kuaisuBtn addTarget:self action:@selector(kuaisuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _kuaisuBtn = kuaisuBtn;
        [kuaisuBtn setBackgroundColor:[UIColor colorWithRed:216/255.0 green:58/255.0 blue:41/255.0 alpha:1]];
        [kuaisuBtn setTitle:@"快速游戏" forState:UIControlStateNormal];
        [kuaisuBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        kuaisuBtn.layer.cornerRadius = 5.0;
        kuaisuBtn.layer.masksToBounds = YES;
        [self addSubview:kuaisuBtn];
        
        
        UIButton *xieyiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        xieyiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        xieyiBtn.contentMode = UIViewContentModeLeft;
    
        _xieyiBtn = xieyiBtn;
        [xieyiBtn addTarget:self action:@selector(xieyiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [xieyiBtn setTitle:@"注册即同意" forState:UIControlStateNormal];
        [xieyiBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
//        [xieyiBtn.titleLabel setTextColor:[UIColor blackColor]];
        [xieyiBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [xieyiBtn setImage:[CQHTools bundleForImage:@"勾选on" packageName:@""] forState:UIControlStateNormal];
        [xieyiBtn setImage:[CQHTools bundleForImage:@"勾选none" packageName:@""] forState:UIControlStateSelected];
        [xieyiBtn setImageEdgeInsets:UIEdgeInsetsMake(15, -15, 15, -30)];
        xieyiBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
//        xieyiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //距离左边10个像素
        xieyiBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, -30);
        [xieyiBtn sizeToFit];
        [self addSubview:xieyiBtn];
        
        UIButton *tongyiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tongyiBtn addTarget:self action:@selector(tongyiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _tongyiBtn = tongyiBtn;
        [tongyiBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [tongyiBtn setTitle:@"用户协议" forState:UIControlStateNormal];
        [tongyiBtn setTitleColor:[UIColor colorWithRed:207/255.0 green:0.0 blue:0.0 alpha:1] forState:UIControlStateNormal];
        [tongyiBtn sizeToFit];
        [self addSubview:tongyiBtn];
        
        UIView *redLine = [[UIView alloc] init];
        _redLine = redLine;
        [redLine setBackgroundColor:[UIColor colorWithRed:207/255.0 green:0 blue:0 alpha:1]];
        [self addSubview:redLine];
        
        UIButton *youkeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [youkeBtn addTarget:self action:@selector(youkeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _youkeBtn = youkeBtn;
        [youkeBtn setTitle:@"已有账号登录" forState:UIControlStateNormal];
        [youkeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [youkeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [youkeBtn sizeToFit];
        [self addSubview:youkeBtn];
        
    }
    return self;
}

- (void)xieyiBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

- (void)wxBtnClick:(UIButton *)btn
{
    if (_xieyiBtn.selected) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请阅读并同意协议！！！";
        [hud hideAnimated:YES afterDelay:1.f];
        return ;
    }
    [WSDK wechatLogin];
}

- (void)phontBtnClick:(UIButton *)btn
{
    if (_xieyiBtn.selected) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请阅读并同意协议！！！";
        [hud hideAnimated:YES afterDelay:1.f];
        return ;
    }
    CQHPhontLoginView *phoneLoginView = [[CQHPhontLoginView alloc] init];
    phoneLoginView.frame = self.bounds;
    [self addSubview:phoneLoginView];
}

- (void)kuaisuBtnClick:(UIButton *)btn
{
    if (_xieyiBtn.selected) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请阅读并同意协议！！！";
        [hud hideAnimated:YES afterDelay:1.f];
        return ;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nonceStr = [CQHTools randomNumber];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
    dict[@"deviceType"]=@"1";
    dict[@"imei"]= [CQHTools getUDID];
    dict[@"gameId"]= [userDefaults objectForKey:GAMEID];
    dict[@"packageId"] = [userDefaults objectForKey:PACKAGEID];
    dict[@"channelId"]= [userDefaults objectForKey:CHANNELID];
    dict[@"configId"] = [userDefaults objectForKey:CONFIGID];
    dict[@"platformCode"]=PLATFORMCODE;
    dict[@"regType"] = @"2";
    dict[@"nonceStr"]=nonceStr;
    
    NSString *stringA = [CQHTools sortArrWithDictionary:dict];
    //sign
    NSString *sign = [NSString stringWithFormat:@"%@&key=%@",stringA,[userDefaults objectForKey:SIGNKEY]];
    //sign md5签名
    NSString *md5String = [CQHTools md5:sign];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
    dict1[@"deviceType"]=@"1";
    dict1[@"imei"]= [CQHTools getUDID];
    dict1[@"gameId"]= [userDefaults objectForKey:GAMEID];
    dict1[@"packageId"] = [userDefaults objectForKey:PACKAGEID];
    dict1[@"channelId"]= [userDefaults objectForKey:CHANNELID];
    dict1[@"configId"] = [userDefaults objectForKey:CONFIGID];
    dict1[@"platformCode"]=PLATFORMCODE;
    dict1[@"regType"] = @"2";
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
//    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    hud.label.text = NSLocalizedString(@"快速登录中...", @"HUD loading title");
    WSDK *wsdk = [WSDK sharedCQHSDK];
    [[self sharedManager] POST:[NSString stringWithFormat:@"%@sdk/guest/register?data=%@",BASE_URL,newStr] parameters:dict3 success:^(NSURLSessionDataTask * _Nonnull task, NSMutableDictionary *responseObject) {
//        NSLog(@"%@",responseObject);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
//        if ([responseObject[@"code"] integerValue] == 505)) {
//            [userDefaults setInteger:0 forKey:ISAUTO];
//            [userDefaults synchronize];
//            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
//
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
//            //            hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
//            hud.mode = MBProgressHUDModeText;
//            hud.label.text = NSLocalizedString(@"密码错误!", @"HUD message title");
//            [hud hideAnimated:YES afterDelay:2.f];
//        }
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
            
            [userDefaults setObject:responseObject[@"data"][@"userId"] forKey:@"userId"];
            [userDefaults setObject:@"1" forKey:ISAUTO];
           
            
            
            JQFMDB *db = [JQFMDB shareDatabase:CQHUSERMODELDB];
            CQHUserModel *userModel = [[CQHUserModel alloc] init];
            if (![db jq_isExistTable:CQHUSERMODELTABLE]) {
                [db jq_createTable:CQHUSERMODELTABLE dicOrModel:userModel];
            }
//            model.outTradeNo = [userDefaults objectForKey:OUTTradeNo];
//            model.receiptData = receiptData;
//            model.platformCode = PLATFORMCODE;
//            model.userId = [userDefaults objectForKey:USERID];
            userModel.accountName = responseObject[@"data"][@"accountName"];
            userModel.password = responseObject[@"data"][@"password"];
            userModel.username = responseObject[@"data"][@"username"];
            [db jq_insertTable:CQHUSERMODELTABLE dicOrModel:userModel];
            
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userModel];
            
            [userDefaults setObject:data forKey:CQHUSERMODEL];
            
            [userDefaults synchronize];
            
            NSArray *personArr = [db jq_lookupTable:CQHUSERMODELTABLE dicOrModel:userModel whereFormat:nil];
            for (CQHUserModel *model in personArr) {
                NSLog(@"%@,%@",model.accountName,model.password);
            }
            
            NSMutableDictionary *respon = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"]];
            [respon removeObjectForKey:@"md5Password"];
            [respon removeObjectForKey:@"password"];
            
            
            if ([wsdk.delegate respondsToSelector:@selector(loginSuccessWithResponse:)]) {
                [wsdk.delegate loginSuccessWithResponse:respon];
                
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
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
            if ([wsdk.delegate respondsToSelector:@selector(loginFailed)]) {
                [wsdk.delegate loginFailed];
            }
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
//            hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(responseObject[@"message"], @"HUD message title");
            [hud hideAnimated:YES afterDelay:2.f];
            return ;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
        if ([wsdk.delegate respondsToSelector:@selector(loginFailed)]) {
            [wsdk.delegate loginFailed];
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
//        hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"登录失败，请查看网络!", @"HUD message title");
        [hud hideAnimated:YES afterDelay:2.f];
    }];
}

- (void)youkeBtnClick:(UIButton *)btn
{
    if (_xieyiBtn.selected) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请阅读并同意协议！！！";
        [hud hideAnimated:YES afterDelay:1.f];
        return ;
    }
    
    CQHUsernameLoginView *usernameLoginView = [[CQHUsernameLoginView alloc] init];
    usernameLoginView.frame = self.bounds;
    [self addSubview:usernameLoginView];
}

- (void)tongyiBtnClick:(UIButton *)btn
{
    CQHAgreementView *agreementView = [CQHAgreementView sharedAgreementView];
    [agreementView setBackgroundColor:[UIColor whiteColor]];
    agreementView.frame = CGRectMake(0, 0, self.width, self.height);
    agreementView.layer.cornerRadius = 5.0;
    agreementView.layer.masksToBounds = YES;
    
    NSTimeInterval duration = 0.5;
    [UIView animateWithDuration:duration animations:^{
        agreementView.alpha = 1.f;
    } completion:^(BOOL finished) {
        [self addSubview:agreementView];
    }];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    UIImage *image = [CQHTools bundleForImage:@"logo-en" packageName:@""];
    _imageView.frame = CGRectMake(self.width*0.5/3.0 , 10*H_Adapter, self.width*2.0/3.0, self.width*2.0/3.0 *image.size.height/image.size.width);
    _line.frame = CGRectMake(20, CGRectGetMaxY(_imageView.frame) +10*H_Adapter, self.width - 40, 1);
    _wxBtn.frame = CGRectMake(20, CGRectGetMaxY(_line.frame)+20*H_Adapter, self.width - 40, 40*H_Adapter);
    _phontBtn.frame = CGRectMake(20, CGRectGetMaxY(_wxBtn.frame) + 20*H_Adapter, self.width - 40, 40*H_Adapter);
    _kuaisuBtn.frame = CGRectMake(20, CGRectGetMaxY(_phontBtn.frame)+20*H_Adapter, self.width - 40, 40*H_Adapter);
    _xieyiBtn.frame = CGRectMake(20, CGRectGetMaxY(_kuaisuBtn.frame)+25*H_Adapter, 65, 20);
    _tongyiBtn.frame = CGRectMake(CGRectGetMaxX(_xieyiBtn.frame)+8*W_Adapter, CGRectGetMaxY(_kuaisuBtn.frame)+25*H_Adapter, _tongyiBtn.width, 20);
    _redLine.frame = CGRectMake(CGRectGetMaxX(_xieyiBtn.frame)+8*W_Adapter, CGRectGetMaxY(_tongyiBtn.frame), _tongyiBtn.width, 1);
    _youkeBtn.frame = CGRectMake(self.width -_youkeBtn.width - 20  , CGRectGetMaxY(_kuaisuBtn.frame)+25*H_Adapter, _youkeBtn.width, 20);
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
