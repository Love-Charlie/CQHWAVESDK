//
//  UIView+Frame.m
//  CQHTCSDK
//
//  Created by Love Charlie on 2019/6/10.
//  Copyright © 2019年 Love Charlie. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

//实现set、get方法
- (CGFloat)origin_x
{
    return self.frame.origin.x;
}
- (CGFloat)origin_y
{
    return self.frame.origin.y;
}
- (CGFloat)width
{
    return self.frame.size.width;
}
- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setWidth:(CGFloat)width
{
    if (width != self.frame.size.width) {
        CGRect newframe = self.frame;
        newframe.size.width = width;
        self.frame = newframe;
    }
}
- (void)setHeight:(CGFloat)height
{
    if (height != self.frame.size.height)
    {
        CGRect newframe = self.frame;
        newframe.size.height = height;
        self.frame = newframe;
    }
}
- (void)setOrigin_x:(CGFloat)origin_x
{
    if (origin_x != self.frame.origin.x)
    {
        CGRect newframe = self.frame;
        newframe.origin.x = origin_x;
        self.frame = newframe;
    }
}
- (void)setOrigin_y:(CGFloat)origin_y
{
    if (origin_y != self.frame.origin.y)
    {
        CGRect newframe = self.frame;
        newframe.origin.y = origin_y;
        self.frame = newframe;
    }
}

@end
