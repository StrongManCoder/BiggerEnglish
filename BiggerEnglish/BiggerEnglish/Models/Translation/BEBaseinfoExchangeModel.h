//
//  BEBaseinfoExchangeModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/15.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BEBaseinfoExchangeModel : NSObject

@property (nonatomic,strong) NSArray *word_pl;
@property (nonatomic,strong) NSArray *word_third;
@property (nonatomic,strong) NSArray *word_past;
@property (nonatomic,strong) NSArray *word_done;
@property (nonatomic,strong) NSArray *word_ing;
@property (nonatomic,strong) NSArray *word_er;
@property (nonatomic,strong) NSArray *word_est;
@property (nonatomic,strong) NSArray *word_prep;
@property (nonatomic,strong) NSArray *word_adv;
@property (nonatomic,strong) NSArray *word_verb;
@property (nonatomic,strong) NSArray *word_noun;
@property (nonatomic,strong) NSArray *word_adj;
@property (nonatomic,strong) NSArray *word_conn;

- (NSString *)stringWithFormat;

@end
