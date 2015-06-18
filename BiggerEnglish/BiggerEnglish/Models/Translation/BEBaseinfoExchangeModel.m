//
//  BEBaseinfoExchangeModel.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/15.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEBaseinfoExchangeModel.h"

@implementation BEBaseinfoExchangeModel

- (NSString *)stringWithFormat {
    NSString *result = @"";
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"形容词", @"_word_adj",
                         @"word_adv", @"_word_adv",
                         @"word_conn", @"_word_conn",
                         @"完成时", @"_word_done",
                         @"word_er", @"_word_er",
                         @"最高级", @"_word_est",
                         @"正在进行时", @"_word_ing",
                         @"word_noun", @"_word_noun",
                         @"过去时", @"_word_past",
                         @"复数", @"_word_pl",
                         @"word_prep", @"_word_prep",
                         @"第三人称", @"_word_third",
                         @"动词", @"_word_verb", nil];
    
    Class cls = [self class];
    unsigned int ivarsCnt = 0;
    //　获取类成员变量列表，ivarsCnt为类成员数量
    Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);
    //　遍历成员变量列表，其中每个变量都是Ivar类型的结构体
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
    {
        Ivar const ivar = *p;
        //　获取变量名
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 若此变量未在类结构体中声明而只声明为Property，则变量名加前缀 '_'下划线
        // 比如 @property(retain) NSString *abc;则 key == _abc;
        //　获取变量值
        NSArray *value = [self valueForKey:key];
        
        if ([value count] > 0)
        {
            result = [NSString stringWithFormat:@"%@%@：%@\n", result, [dic objectForKey:key] , [value componentsJoinedByString:@"；"]];
        }
    }
    NSLog(@"%@", result);
    return result;
}

@end
