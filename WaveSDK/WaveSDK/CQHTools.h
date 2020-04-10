//
//  CQHTools.h
//  CQHTCSDK
//
//  Created by Love Charlie on 2019/5/24.
//  Copyright © 2019年 Love Charlie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CQHTools : NSObject

//获取时间戳
+(NSString *)getNowTimeStamp2;

// 传入一个原始字典，依据ascii码从小到大排序，回传一个排好序的待签名字符串
+ (NSString *)sortArrWithDictionary:(NSDictionary *)dictionary;

//md5加密
+(NSString *) md5: (NSString *) inPutText;

//-对一个字符串进行base64编码，并返回
+(NSString *)base64EncodeString:(NSString *)string;

//生成16位随机数
+(NSString *)randomNumber;

//字典转字符串
+(NSString *)convertToJsonData:(NSDictionary *)dict;
//唯一标识
+ (NSString *)getUDID;
//字符串截取
+ (NSString *)stringJieQu:(NSString *)string;
//加载bundle里面的图片
+ (UIImage *)bundleForImage:(NSString *)imageName packageName:(NSString *)packageName;
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;
//密码加密
+(NSString *)jiami:(NSString *)string;
@end
