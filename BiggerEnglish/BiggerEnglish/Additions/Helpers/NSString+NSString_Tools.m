//
//  NSString+NSString_Tools.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/17.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "NSString+NSString_Tools.h"

@implementation NSString (NSString_Tools)

- (instancetype)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSArray*)split:(NSString*)seprate{
    return [self componentsSeparatedByString:seprate];
}

- (instancetype)replace:(NSString*)src dest:(NSString*)dest{
    return [self stringByReplacingOccurrencesOfString:src withString:dest];
}

- (instancetype)subStr:(NSInteger)pos length:(NSInteger)len{
    NSRange range ;
    range.location = pos;
    range.length = len;
    return [self substringWithRange:range];
}

- (instancetype)substrFrom:(NSInteger)begin toIndex:(NSInteger)end {
    if (end <= begin) {
        return @"";
    }
    NSRange range = NSMakeRange(begin, end - begin);
    return [self substringWithRange:range];
}

//转换成小写
- (instancetype)toLowerCase {
    return [self lowercaseString];
}

//转换成大写
- (instancetype)toUpperCase {
    return [self uppercaseString];
}

//对比两个字符串内容是否一致
- (BOOL) equals:(NSString*)string {
    return [self isEqualToString:string];
}

//判断字符串是否以指定的前缀开头
- (BOOL) startsWith:(NSString*)prefix {
    return [self hasPrefix:prefix];
}

//判断字符串是否以指定的后缀结束
- (BOOL) endsWith:(NSString*)suffix {
    return [self hasSuffix:suffix];
}

//判断字符串是否包含中文
- (BOOL)containChinese {
    int length = (int)[self length];
    for (int i = 0; i < length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3) {
            return YES;
        }
    }
    return NO;
}

@end
