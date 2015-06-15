//
//  BETranslationCETModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/15.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BETranslationCETModel : NSObject

@property (copy, nonatomic) NSString *word;
@property (copy, nonatomic) NSString *count;
@property (strong, nonatomic) NSArray *kd;
@property (strong, nonatomic) NSArray *Sentence;

@end
