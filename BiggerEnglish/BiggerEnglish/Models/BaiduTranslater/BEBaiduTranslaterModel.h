//
//  BEBaiduTranslaterModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/19.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseSuper.h"
#import "BEBaiduTranslaterResultModel.h"

@interface BEBaiduTranslaterModel : ResponseSuper

@property (copy, nonatomic) NSString *from;
@property (copy, nonatomic) NSString *to;
@property (retain, nonatomic) NSArray *trans_result;

- (NSString *)partsStringWithFormat;

@end
