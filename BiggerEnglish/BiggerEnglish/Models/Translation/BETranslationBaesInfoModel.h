//
//  BETranslationBaesInfoModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/15.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BEBaseinfoExchangeModel.h"

@interface BETranslationBaesInfoModel : NSObject

@property (copy, nonatomic) NSString *word_name;
@property (copy, nonatomic) NSString *is_CRI;
@property (retain, nonatomic) BEBaseinfoExchangeModel *exchange;
@property (strong, nonatomic) NSArray *symbols;
@property (copy, nonatomic) NSString *translate_type;

@end
