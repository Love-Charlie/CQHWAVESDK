//
//  CQHVerificationSuccessView.m
//  WaveSDK
//
//  Created by Love Charlie on 2020/4/2.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "CQHVerificationSuccessView.h"
#import "CQHTools.h"
#import "UIView+Frame.h"
#import "CQHMainLoginView.h"
#import "WSDK.h"
#import "CQHHUDView.h"
#import "CQHRealNameVerificationView.h"

@interface CQHVerificationSuccessView()

@property (nonatomic , weak) UIImageView *imageview;
@property (nonatomic , weak) UILabel *labelSucc;
@property (nonatomic , weak) UILabel *label;
@property (nonatomic , weak) UIButton *intoGameBtn;

@end

@implementation CQHVerificationSuccessView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        [self setBackgroundColor:[UIColor whiteColor]];
        UIImageView *imageview = [[UIImageView alloc] init];
        _imageview = imageview;
        [imageview setImage:[CQHTools bundleForImage:@"认证成功icon" packageName:@""]];
        [self addSubview:imageview];
        
        UILabel *labelSucc = [[UILabel alloc] init];
        _labelSucc = labelSucc;
        labelSucc.text = @"认证成功";
        [labelSucc setFont:[UIFont systemFontOfSize:19.0]];
        [labelSucc sizeToFit];
        labelSucc.textColor = [UIColor blackColor];
        [self addSubview:labelSucc];
        
        UILabel *label = [[UILabel alloc] init];
        _label = label;
        label.textColor = [UIColor darkGrayColor];
        label.text = @"恭喜您，提交的实名信息认证成功，账号将根据具体实名情况，匹配相应的健康游戏时长。";
        [label setFont:[UIFont systemFontOfSize:12.0]];
        [label sizeToFit];
        label.numberOfLines = 0;
        [self addSubview:label];
        
        UIButton *intoGameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [intoGameBtn addTarget:self action:@selector(intoGameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _intoGameBtn = intoGameBtn;
        intoGameBtn.layer.cornerRadius = 5.0;
        intoGameBtn.layer.masksToBounds = YES;
        [intoGameBtn setTitle:@"进入游戏" forState:UIControlStateNormal];
        [intoGameBtn setBackgroundColor:[UIColor colorWithRed:226/255.0 green:88/255.0 blue:65/255.0 alpha:1]];
        [self addSubview:intoGameBtn];
    }
    return self;
}

- (void)intoGameBtnClick:(UIButton *)btn
{
    [self removeFromSuperview];
    [[CQHRealNameVerificationView sharedVerificationView] removeFromSuperview];
    [[CQHHUDView shareHUDView] removeFromSuperview];
//    [[CQHHUDView sharedCQHHUDView] removeFromSuperview];
//    [CQHHUDView dissCQHHUBView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIImage *image = [CQHTools bundleForImage:@"认证成功icon" packageName:@""];
    _imageview.frame = CGRectMake(self.width*0.75*0.5, 40, self.width*0.25, self.width*0.25/image.size.width*image.size.height);
    _labelSucc.frame = CGRectMake((self.width - _labelSucc.width)*0.5, CGRectGetMaxY(_imageview.frame)+5*H_Adapter, _labelSucc.width, _labelSucc.height);
    
    CGRect rect = [_label.text boundingRectWithSize:CGSizeMake(self.width - 50*W_Adapter, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_label.font} context:nil];
    _label.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_labelSucc.frame)+ 10*H_Adapter, self.width - 50*W_Adapter, CGRectGetHeight(rect));
    _intoGameBtn.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_label.frame)+(self.height - CGRectGetMaxY(_label.frame)- self.height/7.0)*0.5, self.width - 50*W_Adapter, self.height/7.0);
}

@end
