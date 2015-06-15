//
//  BETranslationMessageModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/15.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BETranslationBaesInfoModel.h"  
#import "BEBaseinfoExchangeModel.h"
#import "BEBaseinfoSymbolsModel.h"
#import "BESymbolsPartsModel.h"
#import "BETranslationSentenceModel.h"
#import "BESentenceDetailModel.h"
#import "BETranslationOxfordModel.h"
#import "BEOxfordStatisticsModel.h"
#import "BETranslationCETModel.h"
#import "BECETSentenceModel.h"

@interface BETranslationMessageModel : NSObject

@property (retain, nonatomic) BETranslationBaesInfoModel *baesInfo;
@property (retain, nonatomic) NSArray *sentence;
@property (retain, nonatomic) BETranslationOxfordModel *oxford_stat;
@property (strong, nonatomic) NSArray *cetFour;
@property (strong, nonatomic) NSArray *cetSix;

@end
