//
//  EnglishDictionaryManager.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/29.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnglishDictionaryManager : NSObject

- (NSMutableArray *)translateEnglish:(NSString *)word;

- (NSMutableArray *)translateChinese:(NSString *)word;

- (NSDictionary *)randomWord;

@end
