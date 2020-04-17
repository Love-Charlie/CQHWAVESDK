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
        [accountNameLabel setTextColor:[UIColor redColor]];
        [accountNameLabel setFont:[UIFont systemFontOfSize:11.0]];
        accountNameLabel.text = @"312312423";
        
        
        UIButton *changeLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [changeLoginBtn addTarget:self action:@selector(changeLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _changeLoginBtn = changeLoginBtn;
        [changeLoginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [changeLoginBtn setTitle:@"切换账号" forState:UIControlStateNormal];
        [changeLoginBtn.titleLabel  setFont:[UIFont systemFontOfSize:11.0]];
        
        
        
        [self addSubview:accountNameLabel];
        [self addSubview:changeLoginBtn];
    }
    return self;
}

- (void)changeLoginBtnClick:(UIButton *)btn
{
    [self.superview removeFromSuperview];
    [self removeFromSuperview];
    [WSDK showHUDView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _accountNameLabel.frame = CGRectMake(10, 0, self.width*0.5, self.height);
    _changeLoginBtn.frame = CGRectMake(self.width*0.5, 0, self.width*0.5, self.height);
}

@end
