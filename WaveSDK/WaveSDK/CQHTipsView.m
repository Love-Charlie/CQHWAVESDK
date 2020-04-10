//
//  CQHTipsView.m
//  WaveSDK
//
//  Created by Love Charlie on 2020/4/2.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "CQHTipsView.h"
#import "CQHTools.h"
#import "UIView+Frame.h"
#import "CQHHUDView.h"

@interface CQHTipsView()
@property (nonatomic , weak) UIImageView *imageview;
@property (nonatomic , weak) UILabel *labelSucc;
@property (nonatomic , weak) UILabel *label;
@property (nonatomic , weak) UIButton *btn1;
@property (nonatomic , weak) UIButton *btn2;
@end

@implementation CQHTipsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        UIImageView *imageview = [[UIImageView alloc] init];
        _imageview = imageview;
        [imageview setImage:[CQHTools bundleForImage:@"警示" packageName:@""]];
        [self addSubview:imageview];
        
        UILabel *labelSucc = [[UILabel alloc] init];
        _labelSucc = labelSucc;
        labelSucc.text = @"提示";
        [labelSucc setFont:[UIFont systemFontOfSize:19.0]];
        [labelSucc sizeToFit];
        labelSucc.textColor = [UIColor blackColor];
        [self addSubview:labelSucc];
        
        UILabel *label = [[UILabel alloc] init];
        _label = label;
        label.textColor = [UIColor darkGrayColor];
        label.text = @"您在使用游客模式登录游戏，体验时长为1小时。体验期间无法进行充值。";
        [label setFont:[UIFont systemFontOfSize:12.0]];
        [label sizeToFit];
        label.numberOfLines = 0;
        [self addSubview:label];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
        _btn1 = btn1;
        [btn1 setTitle:@"更换登录方式" forState:UIControlStateNormal];
        [btn1.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        btn1.layer.cornerRadius = 5.0;
        btn1.layer.masksToBounds = YES;
        [btn1 setBackgroundColor:[UIColor colorWithRed:226/255.0 green:88/255.0 blue:65/255.0 alpha:1]];
        [self addSubview:btn1];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
        _btn2 = btn2;
        [btn2 setTitle:@"进入游戏" forState:UIControlStateNormal];
        [btn2.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        btn2.layer.cornerRadius = 5.0;
        btn2.layer.masksToBounds = YES;
        [btn2 setBackgroundColor:[UIColor colorWithRed:226/255.0 green:88/255.0 blue:65/255.0 alpha:1]];
        [self addSubview:btn2];
    }
    return self;
}

- (void)btn1Click:(UIButton *)btn
{
    [[CQHHUDView sharedCQHHUDView] removeFromSuperview];
    [CQHHUDView dissCQHHUBView];
    [CQHHUDView sharedCQHHUDView];
}

- (void)btn2Click:(UIButton *)btn
{
    [[CQHHUDView sharedCQHHUDView] removeFromSuperview];
    [CQHHUDView dissCQHHUBView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIImage *image = [CQHTools bundleForImage:@"认证成功icon" packageName:@""];
    _imageview.frame = CGRectMake(self.width*0.75*0.5, 40, self.width*0.25, self.width*0.25/image.size.height*image.size.width);
    _labelSucc.frame = CGRectMake((self.width - _labelSucc.width)*0.5, CGRectGetMaxY(_imageview.frame)+5*H_Adapter, _labelSucc.width, _labelSucc.height);
    
    CGRect rect = [_label.text boundingRectWithSize:CGSizeMake(self.width - 50*W_Adapter, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_label.font} context:nil];
    _label.frame = CGRectMake(25*W_Adapter, CGRectGetMaxY(_labelSucc.frame)+ 10*H_Adapter, self.width - 50*W_Adapter, CGRectGetHeight(rect));
    _btn1.frame = CGRectMake(self.width/9.0,  (self.height - CGRectGetMaxY(_label.frame)-35)*0.5 +CGRectGetMaxY(_label.frame), self.width/3.0, 40*H_Adapter);
    _btn2.frame = CGRectMake(CGRectGetMaxX(_btn1.frame)+self.width/9.0, CGRectGetMinY(_btn1.frame), self.width/3.0, 40*H_Adapter);
}
@end
