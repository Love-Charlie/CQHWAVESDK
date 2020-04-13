//
//  WSDK.m
//  WaveSDK
//
//  Created by Love Charlie on 2020/3/17.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//

#import "WSDK.h"
#import "WXApi.h"
#import "AFNetworking.h"
#import "CQHConfig.h"
#import "CQHTools.h"
#import "MBProgressHUD.h"
#import "CQHHUDView.h"
#import "YQInAppPurchaseTool.h"
#import "JQFMDB.h"
#import "CQHVerfityOrderModel.h"
#import "CQHMainLoginView.h"

@interface WSDK() <WXApiDelegate,YQInAppPurchaseToolDelegate>

//@property (nonatomic , copy) NSString *code;

@end

@implementation WSDK 

static NSString *code;

//解决AFN内存泄露的问题，使用单例模式解决
static AFHTTPSessionManager *manager ;
+ (AFHTTPSessionManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 20;
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"text/json",@"text/javascript", nil];
    });
    return manager;
}
//
static WSDK *sharedWSDK = nil;
static dispatch_once_t onceToken;
+ (instancetype)sharedCQHSDK {
    dispatch_once(&onceToken, ^{
        sharedWSDK = [[self alloc] init];
    });
    return sharedWSDK;
}

+ (void)registerAppID:(NSString *)appID andUniversalLinks:(NSString *)UniversalLinks
{
    [WXApi registerApp:appID universalLink:UniversalLinks];
}

+ (void)wechatLogin
{
    if([WXApi isWXAppInstalled]){
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo,snsapi_base";
        req.state = @"1";
        [WXApi sendReq:req completion:nil];
    }else{
//        [self setupAlertController];
    }
}

+ (void)login
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=%@",@"wx343790ea3256d6dc",@"94c855096b5f1209f22839ca688dec43",code,@"authorization_code"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableSet *mgrSet = [NSMutableSet set];
    mgrSet.set = manager.responseSerializer.acceptableContentTypes;
    [mgrSet addObject:@"text/html"];
    //因为微信返回的参数是text/plain 必须加上 会进入fail方法
    [mgrSet addObject:@"text/plain"];
    [mgrSet addObject:@"application/json"];
    manager.responseSerializer.acceptableContentTypes = mgrSet;
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        NSDictionary *resp = (NSDictionary*)responseObject;
        NSString *openid = resp[@"openid"];
        NSString *unionid = resp[@"unionid"];
        NSString *accessToken = resp[@"access_token"];
        NSString *refreshToken = resp[@"refresh_token"];
        if(accessToken && ![accessToken isEqualToString:@""] && openid && ![openid isEqualToString:@""]){
            [[NSUserDefaults standardUserDefaults] setObject:openid forKey:WX_OPEN_ID];
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:WX_ACCESS_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:WX_REFRESH_TOKEN];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
//        [self getUserInfo];
        NSLog(@"%@, %@ , %@ , %@",openid,unionid,accessToken,refreshToken);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

+ (BOOL)handleOpenURL:(NSURL *)url delegate:(nullable id<WXApiDelegate>)delegate
{
    [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
    return YES;
}
+ (void)onResp:(BaseResp *)resp
{
    NSLog(@"%@",resp);
    if([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp *resp2 = (SendAuthResp *)resp;
        code = [resp2 code];
        NSLog(@"%@",code);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wxLogin" object:resp2];

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSString *nonceStr = [CQHTools randomNumber];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
        dict[@"gameId"]=[userDefaults objectForKey:GAMEID];
        dict[@"channelId"]=[userDefaults objectForKey:CHANNELID];
        dict[@"platformCode"]=PLATFORMCODE;
        dict[@"nonceStr"]=nonceStr;
//        dict[@"sdkVersion"]=sdkVersion;
//        dict[@"imei"]= [CQHTools getUDID];
//        dict[@"packageId"] = [userDefaults objectForKey:PACKAGEID];
        dict[@"deviceType"] = @"1";
        dict[@"code"] = code;
 
        NSString *stringA = [CQHTools sortArrWithDictionary:dict];
        //sign
        NSString *sign = [NSString stringWithFormat:@"%@&key=%@",stringA,[userDefaults objectForKey:SIGNKEY]];
        //sign md5签名
        NSString *md5String = [CQHTools md5:sign];
        
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        dict1[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
        dict1[@"gameId"]=[userDefaults objectForKey:GAMEID];
        dict1[@"channelId"]=[userDefaults objectForKey:CHANNELID];
        dict1[@"platformCode"]=PLATFORMCODE;
        dict1[@"nonceStr"]=nonceStr;
//        dict1[@"sdkVersion"]=sdkVersion;
//        dict1[@"imei"]= [CQHTools getUDID];
//        dict1[@"packageId"] = [userDefaults objectForKey:PACKAGEID];
        dict1[@"deviceType"] = @"1";
        dict1[@"code"] = code;
        dict1[@"sign"] = md5String;
        
        NSString *dictString = [CQHTools convertToJsonData:dict1];
        NSString *base64String = [CQHTools base64EncodeString:dictString];
        //字符串前两位
        NSString *qianStr = [base64String substringToIndex:2];
        //字符串第六位开始后面的字符
        NSString *houStr = [base64String substringFromIndex:6];
        NSMutableString *newStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@%@",qianStr,houStr]];
        NSString *jiequStr = [CQHTools stringJieQu:base64String];
        [newStr insertString:jiequStr atIndex:newStr.length - 2];
        NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
        dict3[@"data"] = newStr;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
        hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
        hud.label.text = NSLocalizedString(@"微信登录中...", @"HUD loading title");
        WSDK *wsdk = [WSDK sharedCQHSDK];
        [[self sharedManager] POST:[NSString stringWithFormat:@"%@sdk/wx/login?data=%@",BASE_URL,newStr] parameters:dict3 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"code"] integerValue] == 200) {
               [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
                NSMutableDictionary *respon = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"]];
//                [respon removeObjectForKey:@"md5Password"];
                [userDefaults setObject:responseObject[@"data"][@"userId"] forKey:@"userId"];
                [userDefaults synchronize];
                [respon removeObjectForKey:@"password"];
//                [[CQHHUDView sharedCQHHUDView] removeFromSuperview];
//                [CQHHUDView dissCQHHUBView];
                [[CQHMainLoginView sharedMainLoginView] removeFromSuperview];
                [[CQHHUDView sharedCQHHUDView] removeFromSuperview];
                if ([wsdk.delegate respondsToSelector:@selector(loginSuccessWithResponse:)]) {
                    [wsdk.delegate loginSuccessWithResponse:respon];
                    if ([responseObject[@"data"][@"authStatus"] integerValue] == 1) {
                        
                        if ([responseObject[@"data"][@"authInfo"][@"idno"] isEqualToString:@""]) {
//                            NSLog(@"没有认证");
                            //
                            [CQHHUDView sharedCQHVerView];
                        }
                    }
                }
            }else{
                [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
                hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(responseObject[@"message"], @"HUD message title");
                [hud hideAnimated:YES afterDelay:2.f];
                if ([wsdk.delegate respondsToSelector:@selector(loginFailed)]) {
                    [wsdk.delegate loginFailed];
                }
                return ;
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
            hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"登录失败，请查看网络!", @"HUD message title");
            [hud hideAnimated:YES afterDelay:2.f];
            if ([wsdk.delegate respondsToSelector:@selector(loginFailed)]) {
                [wsdk.delegate loginFailed];
            }
        }];
        
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
        hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"授权失败，请查看网络!", @"HUD message title");
        [hud hideAnimated:YES afterDelay:2.f];
    }
}

+(void)initWithSDKWithConfig:(CQHConfig *)config
{
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    JQFMDB *db = [JQFMDB shareDatabase:VERTIFYORDERDB];
    if (![db jq_isExistTable:VERTIfyORDERTABLE]) {
        CQHVerfityOrderModel *model = [[CQHVerfityOrderModel alloc] init];
        [db jq_createTable:VERTIfyORDERTABLE dicOrModel:model];
    }
    CQHVerfityOrderModel *model = [[CQHVerfityOrderModel alloc] init];
    NSArray *personArr = [db jq_lookupTable:VERTIfyORDERTABLE dicOrModel:model whereFormat:nil];
    if (personArr.count != 0) {
        NSLog(@"haha");
        for (CQHVerfityOrderModel *model in personArr) {
//            NSLog(@"11111==%@",model.outTradeNo);
            NSString *url = [NSString stringWithFormat:@"%@sdk/pt/appstore/query?outTradeNo=%@&receiptData=%@&platformCode=%@&userId=%@",BASE_URL,model.outTradeNo,model.receiptData,model.platformCode,model.userId];
            [[self sharedManager] POST:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [db jq_deleteTable:VERTIfyORDERTABLE whereFormat:[NSString stringWithFormat:@"where outTradeNo='%@'",model.outTradeNo]];
//                NSArray *personArr = [db jq_lookupTable:VERTIfyORDERTABLE dicOrModel:model whereFormat:nil];

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
    }
    

    NSDictionary *dic = [userDefaults1 dictionaryRepresentation];
//    for (id  key in dic) {
//        [userDefaults1 removeObjectForKey:key];
//    }
    [userDefaults1 removeObjectForKey:GAMEID];
    [userDefaults1 removeObjectForKey:PACKAGEID];
    [userDefaults1 removeObjectForKey:CHANNELID];
    [userDefaults1 removeObjectForKey:USERID];
    [userDefaults1 synchronize];
    
    if (config.gameId == nil || config.packageId == nil || config.channelId ==nil || config.key == nil || config.configId == nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
            hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"初始化参数不全", @"HUD message title");
            [hud hideAnimated:YES afterDelay:2.f];
        });
        
        NSLog(@"初始化参数不全");
        return;
    }
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:config.gameId forKey:GAMEID];
    [userDefaults setObject:config.packageId forKey:PACKAGEID];
    [userDefaults setObject:config.channelId forKey:CHANNELID];
    [userDefaults setObject:config.key forKey:SIGNKEY];
    [userDefaults setObject:config.configId forKey:CONFIGID];
    [userDefaults setObject:config.appleID forKey:appleid];
    [userDefaults synchronize];
    //随机数
    NSString *nonceStr = [CQHTools randomNumber];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"sdkVersion"]=sdkVersion;
    dict[@"imei"]= [CQHTools getUDID];
    dict[@"gameId"]=config.gameId;
    dict[@"packageId"] = config.packageId;
    dict[@"channelId"]=config.channelId;
    dict[@"configId"] = config.configId;
    dict[@"platformCode"]=PLATFORMCODE;
    dict[@"nonceStr"]=nonceStr;
    
    NSString *stringA = [CQHTools sortArrWithDictionary:dict];
    //sign
    NSString *sign = [NSString stringWithFormat:@"%@&key=%@",stringA,config.key];
    //sign md5签名
    NSString *md5String = [CQHTools md5:sign];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[@"sdkVersion"]=sdkVersion;
    dict1[@"imei"]= [CQHTools getUDID];
    dict1[@"gameId"]=config.gameId;
    dict1[@"packageId"]=config.packageId;
    dict1[@"channelId"]=config.channelId;
    dict1[@"configId"] = config.configId;
    dict1[@"platformCode"]=PLATFORMCODE;
    dict1[@"nonceStr"]=nonceStr;
    dict1[@"sign"] = md5String;
    
    NSString *dictString = [CQHTools convertToJsonData:dict1];
    NSString *base64String = [CQHTools base64EncodeString:dictString];
    //字符串前两位
    NSString *qianStr = [base64String substringToIndex:2];
    //字符串第六位开始后面的字符
    NSString *houStr = [base64String substringFromIndex:6];
    NSMutableString *newStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@%@",qianStr,houStr]];
    NSString *jiequStr = [CQHTools stringJieQu:base64String];
    [newStr insertString:jiequStr atIndex:newStr.length - 2];
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    dict3[@"data"] = newStr;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    hud.label.text = NSLocalizedString(@"初始化...", @"HUD loading title");
    //    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
    [[self sharedManager] POST:[NSString stringWithFormat:@"%@sdk/init?data=%@",BASE_URL,newStr] parameters:dict3 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"message"]);
        if ([responseObject[@"code"] integerValue] == 200) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:responseObject[@"deviceId"] forKey:DEVICEId];
            [userDefaults synchronize];
            [self activationSDKWithGameId:config.gameId andPackageId:config.packageId andChannelId:config.channelId];
            
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
            hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(responseObject[@"message"], @"HUD message title");
            [hud hideAnimated:YES afterDelay:2.f];
            return ;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
        hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"初始化失败，请查看网络!", @"HUD message title");
        [hud hideAnimated:YES afterDelay:2.f];
    }];
}

#pragma mark 激活SDK
//激活SDK
+ (void)activationSDKWithGameId:(NSString *)gameId andPackageId:(NSString *)packageId andChannelId:(NSString *)channelId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //随机数
    NSString *nonceStr = [CQHTools randomNumber];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"sdkVersion"]=sdkVersion;
    dict[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
    dict[@"gameId"]=gameId;
    dict[@"packageId"] = packageId;
    dict[@"channelId"]=channelId;
    dict[@"platformCode"]=PLATFORMCODE;
    dict[@"nonceStr"]=nonceStr;
    dict[@"activeCode"] = ACTIVECODE;
    NSString *stringA = [CQHTools sortArrWithDictionary:dict];
    //sign
    NSString *sign = [NSString stringWithFormat:@"%@&key=%@",stringA,[userDefaults objectForKey:SIGNKEY]];
    //sign md5签名
    NSString *md5String = [CQHTools md5:sign];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[@"sdkVersion"]=sdkVersion;
    dict1[@"deviceId"]= [userDefaults objectForKey:DEVICEId];
    dict1[@"gameId"]=gameId;
    dict1[@"packageId"]=packageId;
    dict1[@"channelId"]=channelId;
    dict1[@"platformCode"]=PLATFORMCODE;
    dict1[@"nonceStr"]=nonceStr;
    dict1[@"activeCode"] = ACTIVECODE;
    dict1[@"sign"] = md5String;
    
    NSString *dictString = [CQHTools convertToJsonData:dict1];
    NSString *base64String = [CQHTools base64EncodeString:dictString];
    
    //字符串前两位
    NSString *qianStr = [base64String substringToIndex:2];
    //字符串第六位开始后面的字符
    NSString *houStr = [base64String substringFromIndex:6];
    NSMutableString *newStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@%@",qianStr,houStr]];
    NSString *jiequStr = [CQHTools stringJieQu:base64String];
    [newStr insertString:jiequStr atIndex:newStr.length - 2];
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    dict3[@"data"] = newStr;
    
//    CQHNetworkingTools *tools =  [self sharedSingleton];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    hud.label.text = NSLocalizedString(@"初始化...", @"HUD loading title");
    
    [[self sharedManager] POST:[NSString stringWithFormat:@"%@sdk/activate?data=%@",BASE_URL,newStr] parameters:dict3 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
            hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(responseObject[@"message"], @"HUD message title");
            [hud hideAnimated:YES afterDelay:1.f];
            [WSDK showHUDView];
        }else{
            //            [view removeFromSuperview];
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
            hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(responseObject[@"message"], @"HUD message title");
            [hud hideAnimated:YES afterDelay:1.f];
         
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
        [hud hideAnimated:YES];
        //        [view removeFromSuperview];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
        hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"激活失败，请查看网络!", @"HUD message title");
        [hud hideAnimated:YES afterDelay:1.f];
       
    }];
    
}

+(void)showHUDView
{
    [CQHHUDView sharedCQHHUDView];
}

+ (void)dissHUDView
{
    [CQHHUDView dissCQHHUBView];
}

+ (void)payAppleWithServerId:(NSString *)serverId andServerName:(NSString *)serverName andProductName:(NSString *)productName andProductPrice:(NSString *)productPrice andProductCode:(NSString *)productCode andCpOrderId:(NSString *)cpOrderId andRoleId:(NSString *)roleId andRoleName:(NSString *)roleName andRoleLevel:(NSString *)rolLevel andRoleCreateTime:(NSString *)roleCreateTime andNotifyUrl:(NSString *)notifyUrl andExtendParams:(NSString *)extendParams andProduceCode:(NSString *)produceCode
{
    if ([serverId isEqualToString:@""]) {
        serverId = nil;
    }
    if ([notifyUrl isEqualToString:@""]) {
        notifyUrl = nil;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nonceStr = [CQHTools randomNumber];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"deviceId"] = [userDefaults objectForKey:DEVICEId];
    dict[@"deviceType"] = @"1";
//    dict[@"imei"] = [CQHTools getUDID];
    dict[@"gameId"]= [userDefaults objectForKey:GAMEID];
    dict[@"serverId"] = serverId;
    dict[@"serverName"] = serverName;
    dict[@"platformCode"]=PLATFORMCODE;
    dict[@"nonceStr"]=nonceStr;
    dict[@"userId"]=[userDefaults objectForKey:@"userId"];
    dict[@"channelId"] = [userDefaults objectForKey:CHANNELID];
    dict[@"productName"] = productName;
    dict[@"productPrice"] = productPrice;
    dict[@"configId"] = [userDefaults objectForKey:CONFIGID];
    dict[@"cpOrderId"] = cpOrderId;
    dict[@"roleId"] = roleId;
    dict[@"roleName"] = roleName;
    dict[@"roleLevel"] = rolLevel;
    dict[@"roleCreateTime"] = roleCreateTime;
    dict[@"notifyUrl"] = notifyUrl;
    dict[@"extendParams"] = extendParams;
    
    
    NSString *stringA = [CQHTools sortArrWithDictionary:dict];
    //sign
    NSString *sign = [NSString stringWithFormat:@"%@&key=%@",stringA,[userDefaults objectForKey:SIGNKEY]];
    //sign md5签名
    NSString *md5String = [CQHTools md5:sign];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[@"deviceId"] = [userDefaults objectForKey:DEVICEId];
    dict1[@"deviceType"] = @"1";
//    dict1[@"imei"] = [CQHTools getUDID];
    dict1[@"gameId"]= [userDefaults objectForKey:GAMEID];
    dict1[@"serverId"] = serverId;
    dict1[@"serverName"] = serverName;
    dict1[@"platformCode"]=PLATFORMCODE;
    dict1[@"nonceStr"]=nonceStr;
    dict1[@"userId"]=[userDefaults objectForKey:@"userId"];
    dict1[@"channelId"] = [userDefaults objectForKey:CHANNELID];
    dict1[@"productName"] = productName;
    dict1[@"productPrice"] = productPrice;
    dict1[@"configId"] = [userDefaults objectForKey:CONFIGID];
    dict1[@"cpOrderId"] = cpOrderId;
    dict1[@"roleId"] = roleId;
    dict1[@"roleName"] = roleName;
    dict1[@"roleLevel"] = rolLevel;
    dict1[@"roleCreateTime"] = roleCreateTime;
    dict1[@"notifyUrl"] = notifyUrl;
    dict1[@"extendParams"] = extendParams;
    dict1[@"sign"] = md5String;
    
    NSString *dictString = [CQHTools convertToJsonData:dict1];
    NSString *base64String = [CQHTools base64EncodeString:dictString];
    //字符串前两位
    NSString *qianStr = [base64String substringToIndex:2];
    //字符串第六位开始后面的字符
    NSString *houStr = [base64String substringFromIndex:6];
    NSMutableString *newStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@%@",qianStr,houStr]];
    NSString *jiequStr = [CQHTools stringJieQu:base64String];
    [newStr insertString:jiequStr atIndex:newStr.length - 2];
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    dict3[@"data"] = newStr;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
    //    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    hud.label.text = NSLocalizedString(@"支付中...", @"HUD loading title");
//    WSDK *wsdk = [WSDK sharedCQHSDK];
    [[self sharedManager] POST:[NSString stringWithFormat:@"%@sdk/pay/appstore?data=%@",BASE_URL,newStr] parameters:dict3 success:^(NSURLSessionDataTask * _Nonnull task, NSMutableDictionary *responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
//            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
            [userDefaults setObject:responseObject[@"data"][@"outTradeNo"] forKey:OUTTradeNo];
            [userDefaults synchronize];
            
            //获取单例
            YQInAppPurchaseTool *IAPTool = [YQInAppPurchaseTool defaultTool];
            //设置代理
            IAPTool.delegate = self;
            [IAPTool requestProductsWithProductArray:@[produceCode]];
            
        }else{
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];

            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
            //            hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(responseObject[@"message"], @"HUD message title");
            [hud hideAnimated:YES afterDelay:2.f];
            return ;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
        //        hud.contentColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"支付失败，请查看网络!", @"HUD message title");
        [hud hideAnimated:YES afterDelay:2.f];
    }];
}


+ (void)IAPToolGotProducts:(NSMutableArray *)products
{
    if (products.count <= 0) {
        
        [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"无法获取商品信息";//NSLocalizedString(@"Message here!", @"HUD message title");
        hud.label.textColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
        [hud hideAnimated:YES afterDelay:2.f];
        return;
    }
    
    //    [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
    [[YQInAppPurchaseTool defaultTool]buyProduct:[[products firstObject]productIdentifier]];
}

//支付失败/取消
+(void)IAPToolCanceldWithProductID:(NSString *)productID {
    [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"购买失败!";//NSLocalizedString(@"Message here!", @"HUD message title");
    hud.label.textColor = [UIColor colorWithRed:30/255.0 green:175/255.0 blue:170/255.0 alpha:1];
    [hud hideAnimated:YES afterDelay:2.f];
    NSLog(@"购买失败");
}


//购买成功
+ (void)CQHToolBoughtProductSuccessedWithProductID:(SKPaymentTransaction *)transaction andInfo:(NSDictionary *)infoDic
{
    [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
//    NSLog(@"购买成功");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
//    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
//    NSData *receiptData1 = [NSData dataWithContentsOfURL:receiptURL];
//    NSString *receiptStr = [receiptData1 base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    
    NSData  *data = transaction.transactionReceipt;
    NSString *receiptData= [data base64EncodedStringWithOptions:0];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"outTradeNo"] = [userDefaults objectForKey:OUTTradeNo];
    dict[@"receiptData"] = receiptData;
    dict[@"platformCode"]=PLATFORMCODE;
    dict[@"userId"] = [userDefaults objectForKey:USERID];
    
//    JQFMDB *db = [JQFMDB shareDatabase:@"vertifyOrderDB"];
//    [db jq_createTable:@"vertifyOrderTable" dicOrModel:@{@"dict":@"TEXT"}];
//    [db jq_insertTable:@"vertifyOrderTable" dicOrModel:@{@"dict":dict}];
//
//    NSArray *personArr = [db jq_lookupTable:@"vertifyOrderTable" dicOrModel:dict whereFormat:nil];
//    NSLog(@"%@",personArr);
//    JQFMDB *db = [JQFMDB shareDatabase:USERDB];
//    if (![db jq_isExistTable:USERMODELTABLE]) {
//        [db jq_createTable:USERMODELTABLE dicOrModel:[CQHUserModel class]];
//    }
    JQFMDB *db = [JQFMDB shareDatabase:VERTIFYORDERDB];
    if (![db jq_isExistTable:VERTIfyORDERTABLE]) {
        CQHVerfityOrderModel *model = [[CQHVerfityOrderModel alloc] init];
        [db jq_createTable:VERTIfyORDERTABLE dicOrModel:model];
    }
    CQHVerfityOrderModel *model = [[CQHVerfityOrderModel alloc] init];
    model.outTradeNo = [userDefaults objectForKey:OUTTradeNo];
    model.receiptData = receiptData;
    model.platformCode = PLATFORMCODE;
    model.userId = [userDefaults objectForKey:USERID];
    [db jq_insertTable:VERTIfyORDERTABLE dicOrModel:model];
    NSLog(@"00000=%@",model.outTradeNo);
    
    NSArray *personArr = [db jq_lookupTable:VERTIfyORDERTABLE dicOrModel:model whereFormat:nil];
    for (CQHVerfityOrderModel *model in personArr) {
        NSLog(@"11111==%@",model.outTradeNo);
    }
    
    NSString *url = [NSString stringWithFormat:@"%@sdk/pt/appstore/query?outTradeNo=%@&receiptData=%@&platformCode=%@&userId=%@",BASE_URL,[userDefaults objectForKey:OUTTradeNo],receiptData,PLATFORMCODE,[userDefaults objectForKey:USERID]];
    [[self sharedManager] POST:url parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [db jq_deleteTable:VERTIfyORDERTABLE whereFormat:[NSString stringWithFormat:@"where outTradeNo='%@'",model.outTradeNo]];
//        NSArray *personArr = [db jq_lookupTable:VERTIfyORDERTABLE dicOrModel:model whereFormat:nil];
//        NSLog(@"%ld",personArr.count);
//        for (CQHVerfityOrderModel *model in personArr) {
//            NSLog(@"22222=%@",model.outTradeNo);
//        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     
    }];
    
}

@end
