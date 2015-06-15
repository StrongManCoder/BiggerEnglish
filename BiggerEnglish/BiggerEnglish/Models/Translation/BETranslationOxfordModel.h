//
//  BETranslationOxfordModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/15.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BEOxfordStatisticsModel.h"

@interface BETranslationOxfordModel : NSObject

@property (copy, nonatomic) NSString *phrase;
@property (strong, nonatomic) BEOxfordStatisticsModel *statistics;

@end
