//
//  CQHButton.m
//  WaveSDK
//
//  Created by  Charlie on 2020/4/19.
//  Copyright © 2020 Love Charlie. All rights reserved.
//

#import "CQHButton.h"
#import "UIView+Frame.h"

@implementation CQHButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    [self setImageEdgeInsets:UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height, 0, 0, -self.titleLabel.intrinsicContentSize.width)];
//    [self setTitleEdgeInsets:UIEdgeInsetsMake(self.currentImage.size.height + 20, -self.currentImage.size.width, 0, 0)];
//}

//- (CGRect)imageRectForContentRect:(CGRect)bounds{
//
//        return CGRectMake(5.0, 0.0, self.width - 10, self.width - 10);
//}
//
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0.0, self.height - 20+2, self.width, 20);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
     return CGRectMake(8, 0, self.width - 16, self.width - 16);
}

@end
