//
//  CQHHUDView.m
//  WaveSDK
//
//  Created by Love Charlie on 2020/3/24.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "CQHHUDView.h"
#import "CQHMainLoginView.h"
#import "CQHRealNameVerificationView.h"

@interface CQHHUDView()

@property (nonatomic , weak) CQHMainLoginView *mainLoginView;

@end

@implementation CQHHUDView

static CQHHUDView *sharedCQHHUDView = nil;
static dispatch_once_t onceToken;
+ (instancetype)sharedCQHHUDView {
    dispatch_once(&onceToken, ^{
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        
        sharedCQHHUDView = [[self alloc] init];
        [sharedCQHHUDView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        sharedCQHHUDView.frame = KEYWINDOW.bounds;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [KEYWINDOW addSubview:sharedCQHHUDView];
            
             double a = [UIScreen mainScreen].bounds.size.height >  [UIScreen mainScreen].bounds.size.width?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height;
            CQHMainLoginView *mainLoginView = [CQHMainLoginView sharedMainLoginView];
//            CQHMainLoginView *mainLoginView = [[CQHMainLoginView alloc] init];
            mainLoginView.bounds = CGRectMake(0, 0, a - 30, a - 30);
            mainLoginView.center = CGPointMake(sharedCQHHUDView.frame.size.width *0.5, sharedCQHHUDView.frame.size.height *0.5);
            [sharedCQHHUDView addSubview:mainLoginView];
        }];
        
       
    });
    return sharedCQHHUDView;
}


+ (instancetype)sharedCQHVerView {
    
        sharedCQHHUDView = [[self alloc] init];
        [sharedCQHHUDView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        sharedCQHHUDView.frame = KEYWINDOW.bounds;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [KEYWINDOW addSubview:sharedCQHHUDView];
            
            double a = [UIScreen mainScreen].bounds.size.height >  [UIScreen mainScreen].bounds.size.width?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height;
            //            CQHMainLoginView *mainLoginView = [CQHMainLoginView sharedMainLoginView];
            CQHRealNameVerificationView *verificationView = [CQHRealNameVerificationView sharedVerificationView];
            verificationView.bounds = CGRectMake(0, 0, a - 30, a - 30);
            verificationView.center = CGPointMake(sharedCQHHUDView.frame.size.width *0.5, sharedCQHHUDView.frame.size.height *0.5);
            [sharedCQHHUDView addSubview:verificationView];
            [[CQHMainLoginView sharedMainLoginView] removeFromSuperview];
        }];

    return sharedCQHHUDView;
}

+ (void)dissCQHHUBView
{
    [[CQHMainLoginView sharedMainLoginView] removeFromSuperview];
    [CQHMainLoginView deallocMainLoginView];
    onceToken = 0;
    sharedCQHHUDView = nil;
}

//-(instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        CQHMainLoginView *mainLoginView = [CQHMainLoginView sharedMainLoginView];
//        _mainLoginView = mainLoginView;
//    }
//    return self;
//}

+ (void)statusBarOrientationChange
{
   double a = [UIScreen mainScreen].bounds.size.height >  [UIScreen mainScreen].bounds.size.width?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height;
    CQHHUDView *sharedCQHHUDView = [self sharedCQHHUDView];
    sharedCQHHUDView.frame = KEYWINDOW.bounds;
    CQHMainLoginView *mainLoginView = [CQHMainLoginView sharedMainLoginView];
    mainLoginView.bounds = CGRectMake(0, 0, a - 30, a - 30);
    mainLoginView.center = CGPointMake(sharedCQHHUDView.frame.size.width *0.5, sharedCQHHUDView.frame.size.height *0.5);
    
    CQHRealNameVerificationView *verificationView = [CQHRealNameVerificationView sharedVerificationView];
    verificationView.bounds = CGRectMake(0, 0, a - 30, a - 30);
    verificationView.center = CGPointMake(sharedCQHHUDView.frame.size.width *0.5, sharedCQHHUDView.frame.size.height *0.5);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.window resignFirstResponder];
    [self.window endEditing:YES];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

@end
