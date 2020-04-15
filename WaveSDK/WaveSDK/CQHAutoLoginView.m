//
//  CQHAutoLoginView.m
//  WaveSDK
//
//  Created by Love Charlie on 2020/4/15.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "CQHAutoLoginView.h"

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
        [self setBackgroundColor:[UIColor blackColor]];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
