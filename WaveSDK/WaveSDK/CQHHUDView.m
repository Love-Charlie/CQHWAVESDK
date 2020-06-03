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
#import "CQHAutoLoginView.h"

@interface CQHHUDView()

@property (nonatomic , weak) CQHMainLoginView *mainLoginView;

@end

@implementation CQHHUDView

static CQHHUDView *sharedHUDView = nil;
static dispatch_once_t onceTokenHUDView;
+(instancetype)shareHUDView
{
    dispatch_once(&onceTokenHUDView, ^{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChangeCQH) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    sharedHUDView = [[self alloc] init];
    [sharedHUDView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    sharedHUDView.frame = KEYWINDOW.bounds;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [KEYWINDOW addSubview:sharedHUDView];
    }];
    });
    return sharedHUDView;
}

+(instancetype)showMainView
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [KEYWINDOW addSubview:[CQHHUDView shareHUDView]];
        [[CQHHUDView shareHUDView].subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        double a = [UIScreen mainScreen].bounds.size.height >  [UIScreen mainScreen].bounds.size.width?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height;
        CQHMainLoginView *mainLoginView = [CQHMainLoginView sharedMainLoginView];
        mainLoginView.bounds = CGRectMake(0, 0, a - 30, a - 30);
        mainLoginView.center = CGPointMake([CQHHUDView shareHUDView].frame.size.width *0.5, [CQHHUDView shareHUDView].frame.size.height *0.5);
        [[CQHHUDView shareHUDView] addSubview:mainLoginView];
        
    }];
    return [CQHHUDView shareHUDView];
}

+(instancetype)showAutoView
{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [KEYWINDOW addSubview:[CQHHUDView shareHUDView]];
                    
                            [[CQHHUDView shareHUDView].subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

                                CQHAutoLoginView *autoLoginView = [CQHAutoLoginView sharedAutoLoginView];
                                CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
                              
                                double a = [UIScreen mainScreen].bounds.size.height >  [UIScreen mainScreen].bounds.size.width?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height;
                                autoLoginView.frame = CGRectMake((SCREENW - a +60)*0.5, statusBarFrame.size.height, a - 60, 44);
                                autoLoginView.layer.cornerRadius = 20;
                                autoLoginView.layer.masksToBounds = YES;
                                
                                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                NSData *data = [userDefaults objectForKey:CQHUSERMODEL];
                                CQHUserModel*userMdoel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                                

                                [[CQHHUDView shareHUDView] addSubview:autoLoginView];
                                autoLoginView.userModel = userMdoel;
                }];
    return [CQHHUDView shareHUDView];

               
}


+(instancetype)showVerView
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [KEYWINDOW addSubview:[CQHHUDView shareHUDView]];
        
        [[CQHHUDView shareHUDView].subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        double a = [UIScreen mainScreen].bounds.size.height >  [UIScreen mainScreen].bounds.size.width?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height;
        CQHRealNameVerificationView *verView = [CQHRealNameVerificationView sharedVerificationView];
        verView.bounds = CGRectMake(0, 0, a - 30, a - 30);
        verView.center = CGPointMake([CQHHUDView shareHUDView].frame.size.width *0.5, sharedHUDView.frame.size.height *0.5);
        [[CQHHUDView shareHUDView] addSubview:verView];
        
    }];
    return [CQHHUDView shareHUDView];
}

+(void)statusBarOrientationChangeCQH
{
    double a = [UIScreen mainScreen].bounds.size.height >  [UIScreen mainScreen].bounds.size.width?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height;
    CQHHUDView *hudview = [CQHHUDView shareHUDView];
    hudview.frame = KEYWINDOW.bounds;
    
    CQHMainLoginView *mainView = [CQHMainLoginView sharedMainLoginView];
    mainView.bounds = CGRectMake(0, 0, a - 30, a - 30);
    mainView.center = CGPointMake(hudview.frame.size.width *0.5, hudview.frame.size.height *0.5);
    
    CQHRealNameVerificationView *verView = [CQHRealNameVerificationView sharedVerificationView];
    verView.bounds = CGRectMake(0, 0, a - 30, a - 30);;
    verView.center = CGPointMake(hudview.frame.size.width *0.5, hudview.frame.size.height *0.5);
    
     CQHAutoLoginView *autoLoginView = [CQHAutoLoginView sharedAutoLoginView];
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    autoLoginView.frame = CGRectMake((SCREENW - a +60)*0.5, statusBarFrame.size.height, a - 60, 40);
    autoLoginView.layer.cornerRadius = 20;
    autoLoginView.layer.masksToBounds = YES;
    
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static CQHHUDView *sharedCQHHUDView = nil;
static dispatch_once_t onceToken;
+ (instancetype)sharedCQHHUDView {
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        
        sharedCQHHUDView = [[self alloc] init];
        [sharedCQHHUDView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        sharedCQHHUDView.frame = KEYWINDOW.bounds;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [KEYWINDOW addSubview:sharedCQHHUDView];
            
             double a = [UIScreen mainScreen].bounds.size.height >  [UIScreen mainScreen].bounds.size.width?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height;
            CQHMainLoginView *mainLoginView = [CQHMainLoginView sharedMainLoginView];
            mainLoginView.bounds = CGRectMake(0, 0, a - 30, a - 30);
            mainLoginView.center = CGPointMake(sharedCQHHUDView.frame.size.width *0.5, sharedCQHHUDView.frame.size.height *0.5);
            [sharedCQHHUDView addSubview:mainLoginView];

        }];
        
       
    });
    return sharedCQHHUDView;
}


static dispatch_once_t onceToken1;
+ (instancetype)sharedCQHAutoLoginView {
    dispatch_once(&onceToken1, ^{

         [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange1) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

        sharedCQHHUDView = [[self alloc] init];
        [sharedCQHHUDView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        sharedCQHHUDView.frame = KEYWINDOW.bounds;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [KEYWINDOW addSubview:sharedCQHHUDView];

            CQHAutoLoginView *autoLoginView = [CQHAutoLoginView sharedAutoLoginView];
            CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
          
            double a = [UIScreen mainScreen].bounds.size.height >  [UIScreen mainScreen].bounds.size.width?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height;
            autoLoginView.frame = CGRectMake((SCREENW - a +60)*0.5, statusBarFrame.size.height, a - 60, 40);
            autoLoginView.layer.cornerRadius = 20;
            autoLoginView.layer.masksToBounds = YES;
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSData *data = [userDefaults objectForKey:CQHUSERMODEL];
            CQHUserModel*userMdoel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
          
//            autoLoginView.userModel = userMdoel;
            [[CQHMainLoginView sharedMainLoginView] removeFromSuperview];
            

            [sharedCQHHUDView addSubview:autoLoginView];
            [CQHHUDView dissCQHHUBView];
            autoLoginView.userModel = userMdoel;
            
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
            CQHRealNameVerificationView *verificationView = [CQHRealNameVerificationView sharedVerificationView];
            verificationView.bounds = CGRectMake(0, 0, a - 30, a - 30);
            verificationView.center = CGPointMake(sharedCQHHUDView.frame.size.width *0.5, sharedCQHHUDView.frame.size.height *0.5);
            [sharedCQHHUDView addSubview:verificationView];
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

+ (void)statusBarOrientationChange1
{
    
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        double a = [UIScreen mainScreen].bounds.size.height >  [UIScreen mainScreen].bounds.size.width?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height;
            CQHAutoLoginView *autoLoginView = [CQHAutoLoginView sharedAutoLoginView];
    autoLoginView.superview.frame = KEYWINDOW.bounds;
            CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        //    NSLog(@"%@",statusBarFrame);
            autoLoginView.frame = CGRectMake((SCREENW - a +60)*0.5, statusBarFrame.size.height, a - 60, 40);
//    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.window resignFirstResponder];
    [self.window endEditing:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
