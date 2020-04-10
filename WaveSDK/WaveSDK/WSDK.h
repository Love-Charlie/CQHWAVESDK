//
//  WSDK.h
//  WaveSDK
//
//  Created by Love Charlie on 2020/3/17.
//  Copyright © 2020年 Love Charlie. All rights reserved.
//
//@class WXApi;

#import <Foundation/Foundation.h>
#import "CQHConfig.h"
//#import "CQHHUDView.h"

@protocol WAVESDKDelegate<NSObject>

//登录成功的代理
- (void)loginSuccessWithResponse:(id)response;
//登录失败的代理
- (void)loginFailed;

//换绑成功的回调
- (void)mobilePhoneRenewalSuccess;

//购买成功的回调

- (void)pSuccess;

//购买失败的回调
-(void)pFailed;

@end

@interface WSDK : NSObject

@property (nonatomic , weak) id<WAVESDKDelegate> delegate;


+ (instancetype)sharedCQHSDK;

/*! @brief 向微信注册微信登录
 *
 *
 */
+ (void)registerAppID:(NSString *)appID andUniversalLinks:(NSString *)UniversalLinks;

/*! @brief 微信登录
 *
 *
 */
+ (void)wechatLogin;

/*! @brief 登录
 *
 *
 */
+ (void)login;

/*! @brief 设置微信回调代理
 *
 *
 */
+ (BOOL)handleOpenURL:(NSURL *)url delegate:(nullable id)delegate;


/*! @brief 初始化
 *
 *
 */
+ (void)initWithSDKWithConfig:(CQHConfig *)config;


/*! @brief show蒙版
 *
 *
 */

+(void)showHUDView;

+ (void)dissHUDView;

/*! @brief 苹果支付
 *
 *
 */
+ (void)payAppleWithServerId:(NSString *)serverId andServerName:(NSString *)serverName andProductName:(NSString *)productName andProductPrice:(NSString *)productPrice andProductCode:(NSString *)productCode andCpOrderId:(NSString *)cpOrderId andRoleId:(NSString *)roleId andRoleName:(NSString *)roleName andRoleLevel:(NSString *)rolLevel andRoleCreateTime:(NSString *)roleCreateTime andNotifyUrl:(NSString *)notifyUrl andExtendParams:(NSString *)extendParams andProduceCode:(NSString *)produceCode;
@end
