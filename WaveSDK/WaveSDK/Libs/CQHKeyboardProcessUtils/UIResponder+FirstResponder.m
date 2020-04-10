//
//  UIResponder+FirstResponder.m
//  ZYKeyboardUtil
//
//  Created by Love Charlie on 2019/7/19.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import "UIResponder+FirstResponder.h"

@implementation UIResponder (FirstResponder)
static __weak id currentFirstResponder;

+ (id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
    
}

- (void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}



@end
