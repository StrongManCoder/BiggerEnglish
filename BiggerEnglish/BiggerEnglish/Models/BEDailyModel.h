//
//  BEDailyModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/18.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseSuper.h"  
#import "BEDailyDetailModel.h"

@interface BEDailyModel : ResponseSuper

@property (copy, nonatomic) NSString *status;
@property (retain, nonatomic) BEDailyDetailModel *message;

@end
