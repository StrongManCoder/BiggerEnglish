//
//  BEBaseinfoSymbolsModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/15.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BEBaseinfoSymbolsModel : NSObject

@property (copy, nonatomic) NSString *ph_en;
@property (copy, nonatomic) NSString *ph_am;
@property (copy, nonatomic) NSString *ph_other;
@property (copy, nonatomic) NSString *ph_en_mp3;
@property (copy, nonatomic) NSString *ph_am_mp3;
@property (copy, nonatomic) NSString *ph_tts_mp3;

@property (copy, nonatomic) NSString *word_symbol;
@property (copy, nonatomic) NSString *symbol_mp3;

@property (strong, nonatomic) NSArray *parts;

- (NSString *)partsStringWithFormat;

@end
