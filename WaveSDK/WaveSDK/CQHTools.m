//
//  CQHTools.m
//  CQHTCSDK
//
//  Created by Love Charlie on 2019/5/24.
//  Copyright © 2019年 Love Charlie. All rights reserved.
//

#import "CQHTools.h"
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import <UIKit/UIKit.h>

@implementation CQHTools

//获取时间戳
+(NSString *)getNowTimeStamp2 {
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    return timeString;
    
}




+ (NSString *)getUDID
{
    NSString *udid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return udid;
}

// 传入一个原始字典，依据ascii码从小到大排序，回传一个排好序的待签名字符串
+ (NSString *)sortArrWithDictionary:(NSDictionary *)dictionary {
    // 取出所有的key值
    NSArray *keys = [dictionary allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    // 将排好的序的key值重新赋值
    NSMutableArray *jsonArr = [NSMutableArray array];
    [sortedArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 取出每一个keyValue值
        //        NSString *str = [NSString stringWithFormat:@"\"%@\":\"%@\"", obj, dictionary[obj]];
        
        NSString *str1 = [NSString stringWithFormat:@"%@=%@", obj, dictionary[obj]];
        [jsonArr addObject:str1];
    }];
    // 将做好排序的数组转出字符串
    NSString *result = [jsonArr componentsJoinedByString:@"&"];
    result = [NSString stringWithFormat:@"%@", result];
    return result;
}

//md5加密
+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             
             result[0], result[1], result[2], result[3],
             
             result[4], result[5], result[6], result[7],
             
             result[8], result[9], result[10], result[11],
             
             result[12], result[13], result[14], result[15]
             
             ] uppercaseString];
    
}


+(NSString *)jiami:(NSString *)string
{
    NSString *newString = [NSString stringWithFormat:@"%@%@",string,PhoneKey];
     return [[self md5:newString] lowercaseString];
}


#pragma mark -对一个字符串进行base64编码，并返回
+(NSString *)base64EncodeString:(NSString *)string{
    //1、先转换成二进制数据
    NSData *data =[string dataUsingEncoding:NSUTF8StringEncoding];
    //2、对二进制数据进行base64编码，完成后返回字符串
    return [data base64EncodedStringWithOptions:0];
}


//生成16位随机数
+(NSString *)randomNumber{
    
    NSTimeInterval random=[NSDate timeIntervalSinceReferenceDate];
    //    NSLog(@"now:%.16f",random);
    NSString *randomString = [NSString stringWithFormat:@"%.16f",random];
    NSString *randomNumber = [[randomString componentsSeparatedByString:@"."]objectAtIndex:1];
    return randomNumber;
    
}

//字典转字符串
+(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
    
}

//字符串截取
+ (NSString *)stringJieQu:(NSString *)string
{
    NSString *str = [string substringWithRange:NSMakeRange(2,4)];
    return str;
}

//加载bundle里面的图片
+ (UIImage *)bundleForImage:(NSString *)imageName packageName:(NSString *)packageName
{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"waveimage" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    NSString *file = [bundle pathForResource:imageName ofType:@"png" inDirectory:packageName];
    UIImage *image = [UIImage imageWithContentsOfFile:file];

    return image;
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
