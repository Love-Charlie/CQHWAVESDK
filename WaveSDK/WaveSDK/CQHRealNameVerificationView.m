//
//  CQHRealNameVerificationView.m
//  WaveSDK
//
//  Created by Love Charlie on 2020/4/1.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "CQHRealNameVerificationView.h"
#import "UIView+Frame.h"
#import "CQHTools.h"
#import "CQHVerificationSuccessView.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CQHKeyboardProcess.h"
#import "CQHHUDView.h"
#import <objc/runtime.h>

@interface CQHRealNameVerificationView()<UITextFieldDelegate>

@property (nonatomic , weak) UILabel *titleLabel;
@property (nonatomic , weak) UIButton *backBtn;
@property (nonatomic , weak) UILabel *label1;
@property (nonatomic , weak) UILabel *label2;
@property (nonatomic , weak) UITextField *usernameTF;
@property (nonatomic , weak) UITextField *identityTF;
@property (nonatomic , weak) UILabel *desLabel;
@property (nonatomic , weak) UIImageView *imageView;
@property (nonatomic , weak) UIButton *tijiaoBtn;
@property (nonatomic , strong) CQHKeyboardProcess *process;
@end

@implementation CQHRealNameVerificationView

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

static CQHRealNameVerificationView *verificationView;
static dispatch_once_t onceToken;
+ (CQHRealNameVerificationView *)sharedVerificationView {
    
    dispatch_once(&onceToken, ^{
        verificationView = [[self alloc] init];
    });
    return verificationView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        CQHKeyboardProcess *process = [[CQHKeyboardProcess alloc] init];
        _process = process;
        [process changeFrameWithView:[CQHHUDView shareHUDView]];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        UILabel *titleLabel = [[UILabel alloc] init];
        _titleLabel = titleLabel;
        titleLabel.text = @"实名验证";
        [titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        titleLabel.textColor = [UIColor blackColor];
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];
        
        UIButton *backBtn = [[UIButton alloc] init];
        [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = backBtn;
        [backBtn setImage:[CQHTools bundleForImage:@"箭头" packageName:@""] forState:UIControlStateNormal];
//        [self addSubview:backBtn];
        
        UILabel *label1 = [[UILabel alloc] init];
        _label1 = label1;
        label1.text = @"为了使大家更好的平衡游戏与生活，激浪游戏【健康系统】全面升级。";
        [label1 setTextColor:[UIColor darkGrayColor]];
        [label1 setFont:[UIFont systemFontOfSize:12.0]];
        label1.numberOfLines = 0;
        [label1 sizeToFit];
        [self addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] init];
        _label2 = label2;
        label2.text = @"检查到您的认证信息不全，在您认证通过前，您将无法登录游戏，请尽快完善信息哦。";
        [label2 setTextColor:[UIColor darkGrayColor]];
        [label2 setFont:[UIFont systemFontOfSize:12.0]];
        label2.numberOfLines = 0;
        [label2 sizeToFit];
        [self addSubview:label2];
        
        UITextField *usernameTF = [[UITextField alloc] init];
        usernameTF.returnKeyType = UIReturnKeyNext;
        usernameTF.delegate = self;
        usernameTF.textColor = [UIColor blackColor];
        UIView *tempView = [[UIView alloc] init];
        tempView.frame = CGRectMake(0, 0, 10*W_Adapter, 2);
        usernameTF.leftView = tempView;
        usernameTF.leftViewMode = UITextFieldViewModeAlways;
        _usernameTF = usernameTF;
        usernameTF.placeholder = @"  请输入姓名";
//        [usernameTF setValue:[UIFont boldSystemFontOfSize:12.0] forKeyPath:@"_placeholderLabel.font"];
        
        Ivar ivar2 =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel2 = object_getIvar(usernameTF, ivar2);
        placeholderLabel2.textColor = [UIColor lightGrayColor];
        placeholderLabel2.text = @"  请输入姓名";
        [placeholderLabel2 setFont:[UIFont systemFontOfSize:12.0]];
        
        usernameTF.layer.cornerRadius = 6.0;
        usernameTF.layer.borderColor= [UIColor lightGrayColor].CGColor;
        usernameTF.layer.borderWidth= 1.0f;
        usernameTF.layer.masksToBounds = YES;
        usernameTF.tintColor = [UIColor colorWithRed:214.0/255.0 green:6.0/255.0 blue:0/255.0 alpha:1];
        
        [self addSubview:usernameTF];
        
        UITextField *identityTF = [[UITextField alloc] init];
        identityTF.delegate = self;
        identityTF.returnKeyType = UIReturnKeyDone;
        identityTF.textColor = [UIColor blackColor];
        UIView *tempView1 = [[UIView alloc] init];
        tempView1.frame = CGRectMake(0, 0, 10*W_Adapter, 2);
//        identityTF.frame = CGRectMake(0, 0, 10*W_Adapter, 2);
        identityTF.leftView = tempView1;
        identityTF.leftViewMode = UITextFieldViewModeAlways;
        _identityTF = identityTF;
        identityTF.placeholder = @"  请输入有效身份证号码";
//        [identityTF setValue:[UIFont boldSystemFontOfSize:12.0] forKeyPath:@"_placeholderLabel.font"];
        
        Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel = object_getIvar(identityTF, ivar);
        placeholderLabel.textColor = [UIColor lightGrayColor];
        placeholderLabel.text = @"  请输入有效身份证号码";
        [placeholderLabel setFont:[UIFont systemFontOfSize:12.0]];
        
        identityTF.layer.cornerRadius = 6.0;
        identityTF.layer.borderColor= [UIColor lightGrayColor].CGColor;
        identityTF.layer.borderWidth= 1.0f;
        identityTF.layer.masksToBounds = YES;
        identityTF.tintColor = [UIColor colorWithRed:214.0/255.0 green:6.0/255.0 blue:0/255.0 alpha:1];
        
        [self addSubview:identityTF];
        
        
        UILabel *desLabel = [[UILabel alloc] init];
        desLabel.numberOfLines = 0;
        _desLabel = desLabel;
        desLabel.text = @"您的隐私将受到保护，身份信息仅会用于实名验证";
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
        
        
        UIButton *tijiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tijiaoBtn addTarget:self action:@selector(tijiaoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        tijiaoBtn.layer.cornerRadius = 5.0;
        tijiaoBtn.layer.masksToBounds = YES;
        _tijiaoBtn = tijiaoBtn;
        [tijiaoBtn setTitle:@"提交验证" forState:UIControlStateNormal];
        [tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tijiaoBtn setBackgroundColor:[UIColor colorWithRed:226/255.0 green:88/255.0 blue:65/255.0 alpha:1]];
        [self addSubview:tijiaoBtn];
        
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:_usernameTF] && [string isEqualToString:@"\n"]) {
        [_identityTF becomeFirstResponder];
    }
    
    if ([textField isEqual:_identityTF] && [string isEqualToString:@"\n"]) {
        [_identityTF resignFirstResponder];
    }
    
    return YES;
}

- (void)tijiaoBtnClick:(UIButton *)btn
{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //随机数
    NSString *nonceStr = [CQHTools randomNumber];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"sdkVersion"]=sdkVersion;
    dict[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
    dict[@"gameId"]=[userDefaults objectForKey:GAMEID];
//    dict[@"packageId"] = packageId;
    dict[@"channelId"]=[userDefaults objectForKey:CHANNELID];
    dict[@"platformCode"]=PLATFORMCODE;
    dict[@"nonceStr"]=nonceStr;
    dict[@"userId"] = [userDefaults objectForKey:USERID];
    dict[@"realname"] = self.usernameTF.text;
    dict[@"idno"] = self.identityTF.text;
    NSString *stringA = [CQHTools sortArrWithDictionary:dict];
    //sign
    NSString *sign = [NSString stringWithFormat:@"%@&key=%@",stringA,[userDefaults objectForKey:SIGNKEY]];
    //sign md5签名
    NSString *md5String = [CQHTools md5:sign];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
    dict1[@"gameId"]=[userDefaults objectForKey:GAMEID];
    //    dict[@"packageId"] = packageId;
    dict1[@"channelId"]=[userDefaults objectForKey:CHANNELID];
    dict1[@"platformCode"]=PLATFORMCODE;
    dict1[@"nonceStr"]=nonceStr;
    dict1[@"userId"] = [userDefaults objectForKey:USERID];
    dict1[@"realname"] = self.usernameTF.text;
    dict1[@"idno"] = self.identityTF.text;
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
    hud.label.text = NSLocalizedString(@"认证中...", @"HUD loading title");
    
    [[self sharedManager] POST:[NSString stringWithFormat:@"%@sdk/user/bind/idno?data=%@",BASE_URL,newStr] parameters:dict3 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
            CQHVerificationSuccessView *verSuccessView = [[CQHVerificationSuccessView alloc] init];
            verSuccessView.frame = self.bounds;
            [self addSubview:verSuccessView];
        }else{
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
        hud.label.text = NSLocalizedString(@"激活失败，请查看网络!", @"HUD message title");
        [hud hideAnimated:YES afterDelay:1.f];
        
    }];
    
    
}

- (void)backBtnClick:(UIButton *)btn
{
    [self removeFromSuperview];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake((self.width -_titleLabel.width)*0.5 , 20*H_Adapter, _titleLabel.width, _titleLabel.height);
    _backBtn.frame = CGRectMake(25*W_Adapter,  20*H_Adapter, _titleLabel.height, _titleLabel.height);
    
    CGRect rect = [_label1.text boundingRectWithSize:CGSizeMake(self.width - 50*W_Adapter, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_label1.font} context:nil];
    _label1.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_titleLabel.frame)+10*H_Adapter, CGRectGetWidth(rect), CGRectGetHeight(rect));
    
    CGRect rect1 = [_label2.text boundingRectWithSize:CGSizeMake(self.width - 50*W_Adapter, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_label2.font} context:nil];
    _label2.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_label1.frame)+3*H_Adapter, CGRectGetWidth(rect1), CGRectGetHeight(rect1));
    
    _usernameTF.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_label2.frame)+10*H_Adapter, self.width - 50*W_Adapter, self.height/7.0);
    _identityTF.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_usernameTF.frame)+10*H_Adapter, self.width - 50*W_Adapter, self.height/7.0);
    _desLabel.frame = CGRectMake(40*W_Adapter, CGRectGetMaxY(_identityTF.frame)+10*H_Adapter, self.width - 50*W_Adapter-_desLabel.height, _desLabel.height);
    _imageView.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_identityTF.frame)+10*H_Adapter,  _desLabel.height,  _desLabel.height);
    _tijiaoBtn.frame = CGRectMake(25*W_Adapter, (self.height - CGRectGetMaxY(_desLabel.frame)-self.height/7.0)*0.5 +CGRectGetMaxY(_desLabel.frame), self.width - 50*W_Adapter, self.height/7.0);
}

@end
