//
//  CQHKeyboardProcess.m
//  CQHKeyboardProcess
//
//  Created by Love Charlie on 2019/7/19.
//  Copyright © 2019年 Love Charlie. All rights reserved.
//
#define KEYWINDOW [[[UIApplication sharedApplication] delegate] window]

#import "CQHKeyboardProcess.h"
#import "UIResponder+FirstResponder.h"

@interface CQHKeyboardProcess()

@property (assign, nonatomic) BOOL haveRegisterObserver;
@property (nonatomic , weak)  UIView *responderView;
@property (nonatomic , assign) CGRect viewFrame;
@property (nonatomic , weak) UIView *targetView;

@end

@implementation CQHKeyboardProcess

- (void)changeFrameWithView:(UIView *)targetView
{
    [self registerObserver];
    
    if (!targetView.superview) {
        _viewFrame = [targetView convertRect:targetView.frame toView:KEYWINDOW];
    }else{
        _viewFrame = [targetView.superview convertRect:targetView.frame toView:KEYWINDOW];
    }
    _targetView = targetView;
}

- (void)registerObserver
{
    if (_haveRegisterObserver) {
        return;
    }
    _haveRegisterObserver = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haha) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)haha
{
    [self changeFrameWithView:_targetView];
}


- (void)KeyboardWillShowNotification:(NSNotification *)noti
{
    UIView *responderView = [UIResponder currentFirstResponder];
    _responderView = responderView;
    CGRect responderViewFrame = [_responderView.superview convertRect:_responderView.frame toView:KEYWINDOW];
    
    CGRect keyboardFrame = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (responderViewFrame.origin.y + responderViewFrame.size.height < keyboardFrame.origin.y) {
        return;
    }
    
    CGFloat changeHeight = responderViewFrame.origin.y + responderViewFrame.size.height - keyboardFrame.origin.y;
    
    CGRect newViewFrame = CGRectMake(_viewFrame.origin.x, _viewFrame.origin.y - changeHeight-10, _viewFrame.size.width, _viewFrame.size.height);
    
    _targetView.frame = newViewFrame;
    
//    [self haha];
}

- (void)KeyboardWillHideNotification:(NSNotification *)noti
{
    _targetView.frame = _viewFrame;
    
//    [self haha];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

@end
