//
//  NSString+URL.h
//  LLWeChatLogin
//
//  Created by Love Charlie on 2019/3/25.
//  Copyright © 2019年 HWD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

/**
 *  URLEncode
 */
- (NSString *)URLEncodedString;

/**
 *  URLDecode
 */
-(NSString *)URLDecodedString;

@end
