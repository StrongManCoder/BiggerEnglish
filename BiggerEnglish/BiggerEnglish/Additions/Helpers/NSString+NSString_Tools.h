//
//  NSString+NSString_Tools.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/17.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_Tools)

- (instancetype)trim;

- (NSArray*)split:(NSString*)seprate;

- (instancetype)replace:(NSString*)src dest:(NSString*)dest;

- (instancetype)subStr:(NSInteger)pos length:(NSInteger)len;

- (instancetype)substrFrom:(NSInteger)begin toIndex:(NSInteger)end;

//转换成小写
- (instancetype)toLowerCase;

//转换成大写
- (instancetype)toUpperCase;

//对比两个字符串内容是否一致
- (BOOL) equals:(NSString*)string;

//判断字符串是否以指定的前缀开头
- (BOOL) startsWith:(NSString*)prefix;

//判断字符串是否以指定的后缀结束
- (BOOL) endsWith:(NSString*)suffix;

//判断字符串是否包含中文
- (BOOL)containChinese;

@end
