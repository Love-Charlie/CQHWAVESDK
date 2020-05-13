//
//  CQHPhoneBindingView.m
//  WaveSDK
//
//  Created by Love Charlie on 2020/4/20.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "CQHPhoneBindingView.h"
#import "CQHTools.h"
#import "UIView+Frame.h"

@interface CQHPhoneBindingView()

@property (nonatomic , weak) UILabel *registerLabel ;
@property (nonatomic , weak) UIButton *backBtn ;
@property (nonatomic , weak) UIView *line;
@property (nonatomic , weak) UILabel *contentLabel;

@end

@implementation CQHPhoneBindingView

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
        [registerLabel setText:@"手机绑定"];
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
        
    }
    return self;
}

- (void)setUsername:(NSString *)username
{
    _username = username;
    if (username.length > 16) {
         username = [username stringByReplacingCharactersInRange:NSMakeRange(5, username.length - 10) withString:@"...."];
    }
    
    NSMutableAttributedString *Att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"正在给账号 : %@, 进行手机绑定",username]];
    [Att addAttribute:NSForegroundColorAttributeName value:[UIColor  redColor] range:NSMakeRange(8,username.length)];
    _contentLabel.attributedText = Att;
    _contentLabel.font = [UIFont systemFontOfSize:13.0];
    [_contentLabel sizeToFit];
}

- (void)backBtnClick:(UIButton *)btn
{
    [self removeFromSuperview];
}

- (void)statusBarOrientationChange1
{
    self.frame = self.superview.bounds;
    self.center = CGPointMake(self.superview.frame.size.width *0.5, self.superview.frame.size.height *0.5);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _registerLabel.frame = CGRectMake((self.width -_registerLabel.width)*0.5 , 15, _registerLabel.width, _registerLabel.height);
    _backBtn.frame = CGRectMake(25*W_Adapter, 20, _registerLabel.height , _registerLabel.height);
    _line.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_registerLabel.frame)+15, self.width - 50*W_Adapter, 1);
    _contentLabel.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_line.frame)+15, self.width - 50*W_Adapter, _contentLabel.height);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
