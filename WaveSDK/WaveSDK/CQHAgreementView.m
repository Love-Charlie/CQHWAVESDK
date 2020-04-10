//
//  CQHAgreementView.m
//  WaveSDK
//
//  Created by Love Charlie on 2020/3/30.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "CQHAgreementView.h"
#import "CQHTools.h"
#import <WebKit/WebKit.h>
#import "UIView+Frame.h"

@interface CQHAgreementView()

@property (nonatomic , weak) WKWebView *wkWebView;
@property (nonatomic , weak) UIView *topView ;
@property (nonatomic , weak) UILabel *xieyiLabel ;
@property (nonatomic , weak) UIButton *backBtn ;
@property (nonatomic , weak) UIView *line;

@end

@implementation CQHAgreementView

static CQHAgreementView *agreementView;
+ (CQHAgreementView *)sharedAgreementView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agreementView = [[self alloc] init];
        agreementView.alpha = 0.0;
    });
    return agreementView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *topView = [[UIView alloc] init];
        _topView = topView;
        
        UILabel *xieyiLabel = [[UILabel alloc] init];
        _xieyiLabel = xieyiLabel;
        xieyiLabel.text = @"用户协议";
        [xieyiLabel sizeToFit];
        xieyiLabel.textColor = [UIColor blackColor];
        [topView addSubview:xieyiLabel];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backBtn setTitle:@"< 返回" forState:UIControlStateNormal];
        [backBtn setImage:[CQHTools bundleForImage:@"箭头" packageName:@""] forState:UIControlStateNormal];
        [backBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [backBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = backBtn;
//        [backBtn sizeToFit];
        [topView addSubview:backBtn];
        
        
        WKWebView *wkWebview = [[WKWebView alloc] init];
        _wkWebView = wkWebview;
        [wkWebview.scrollView setBackgroundColor:[UIColor clearColor]];
        [wkWebview setBackgroundColor:[UIColor clearColor]];
        [wkWebview setOpaque:NO];
        
        // 2.1 创建一个远程URL
        NSString *url = [NSString stringWithFormat:@"%@sdk/notice/%@",BASE_URL,PLATFORMCODE];
        NSURL *remoteURL = [NSURL URLWithString:url];
        
        static NSOperationQueue *queue;
        queue=[[NSOperationQueue alloc]init];
        NSInvocationOperation *op=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(downLoadWeb) object:nil];
        [queue addOperation:op];
        
        [self addSubview:topView];
        [self addSubview:wkWebview];
        
        UIView *line = [[UIView alloc] init];
        _line = line;
        [line setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:line];
        
    }
    return self;
}

-(void)downLoadWeb
{
    
//    NSString *url = [NSString stringWithFormat:@"%@sdk/notice/%@",BASE_URL,PLATFORMCODE];@"http://test.sdk.wavesdk.com/sdk/agree"
    NSString *url = @"http://test.sdk.wavesdk.com/sdk/agree";
    
    NSURL *remoteURL = [NSURL URLWithString:url];
    
    NSError *error;
    
    NSString *strData=[NSString stringWithContentsOfURL:remoteURL encoding:NSUTF8StringEncoding error:&error];
    
    NSData *data=[strData dataUsingEncoding:NSUTF8StringEncoding];
    
    if (data !=nil) {
        
        [self performSelectorOnMainThread:@selector(downLoad_completed:) withObject:data waitUntilDone:NO];
        
    }
    else
    {
        NSLog(@"error when download:%@",error);
    }
}

-(void)downLoad_completed:(NSData *)data
{
    
    NSString *url = [NSString stringWithFormat:@"%@sdk/notice/%@",BASE_URL,PLATFORMCODE];
    NSURL *remoteURL = [NSURL URLWithString:url];
    NSString *nameType=[self mimeType:remoteURL];
    
    //    [_webView loadData:data MIMEType:nameType textEncodingName:@"UTF-8" baseURL:remoteURL];
    //    [_wkWebView loadData:data MIMEType:nameType textEncodingName:@"UTF-8" baseURL:remoteURL];
    [_wkWebView loadData:data MIMEType:nameType characterEncodingName:@"UTF-8" baseURL:remoteURL];
}

- (NSString *)mimeType:(NSURL *)url
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //使用同步方法后去MIMEType
    NSURLResponse *response = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    return response.MIMEType;
}

//网页加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView.scrollView.subviews enumerateObjectsUsingBlock:^( id obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ([obj isKindOfClass:[UIImageView class]]) {
             UIImageView * imageView = [[UIImageView alloc] init];
             imageView = obj;
             //必须先设置imageView的image为空的，否则颜色显示偏灰，之前默认的颜色会对背景颜色有影响，然后再设置背景颜色
             imageView.image = [UIImage imageNamed:@""];
             imageView.backgroundColor = [UIColor colorWithRed:27/255.0 green:172/255.0 blue:177/255.0 alpha:1];;
         }
     }];
}

- (void)backBtnClick:(UIButton *)btn
{
    NSTimeInterval duration = 0.5;
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _topView.frame = CGRectMake(0, 0, self.width, 44*H_Adapter);
    _xieyiLabel.frame = CGRectMake((self.width - _xieyiLabel.width)*0.5, (44*H_Adapter - _xieyiLabel.height)*0.5, _xieyiLabel.width, _xieyiLabel.height);
    _wkWebView.frame = CGRectMake(0, 44*H_Adapter, self.width, self.height - 44*H_Adapter);
    
    _backBtn.frame = CGRectMake(15*W_Adapter, (44*H_Adapter - 12)*0.5, 15, 12);
    _line.frame = CGRectMake(0, 44*H_Adapter, self.width, 1);
    
}

@end
