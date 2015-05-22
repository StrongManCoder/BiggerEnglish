//
//  BEDailyModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/18.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseSuper.h"   

@interface BEDailyModel : ResponseSuper

@property (copy, nonatomic) NSString *sid;
@property (copy, nonatomic) NSString *tts;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *note;
@property (copy, nonatomic) NSString *love;
@property (copy, nonatomic) NSString *translation;
@property (copy, nonatomic) NSString *picture;
@property (copy, nonatomic) NSString *picture2;
@property (copy, nonatomic) NSString *caption;
@property (copy, nonatomic) NSString *dateline;
@property (copy, nonatomic) NSString *s_pv;
@property (copy, nonatomic) NSString *sp_pv;
@property (copy, nonatomic) NSString *tags;
@property (copy, nonatomic) NSString *fenxiang_img;

@end
