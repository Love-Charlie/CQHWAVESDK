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

@interface CQHAutoLoginView()

@property (nonatomic , weak) UILabel *accountNameLabel;
@property (nonatomic , weak) UIButton *changeLoginBtn ;
@end

@implementation CQHAutoLoginView


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
        _accountNameLabel = accountNameLabel;
//        [accountNameLabel setTextColor:[UIColor redColor]];
        [accountNameLabel setFont:[UIFont systemFontOfSize:11.0]];
//        accountNameLabel.text = @"312312423";
        
        
        
        UIButton *changeLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [changeLoginBtn addTarget:self action:@selector(changeLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _changeLoginBtn = changeLoginBtn;
        [changeLoginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [changeLoginBtn setTitle:@"切换账号" forState:UIControlStateNormal];
        [changeLoginBtn.titleLabel  setFont:[UIFont systemFontOfSize:11.0]];
        [changeLoginBtn sizeToFit];
        
        
        
        [self addSubview:accountNameLabel];
        [self addSubview:changeLoginBtn];
    }
    return self;
}

- (void)setUserModel:(CQHUserModel *)userModel
{
    _userModel = userModel;
    
    NSMutableAttributedString *Att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ , 正在登录...",userModel.accountName]];
    NSUInteger length = [userModel.accountName length];
    [Att addAttribute:NSForegroundColorAttributeName value:[UIColor  redColor] range:NSMakeRange(0,length)];
    _accountNameLabel.attributedText = Att;
    _accountNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
}


- (void)changeLoginBtnClick:(UIButton *)btn
{
//    [self.superview removeFromSuperview];
    
//    [WSDK showHUDView];
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
