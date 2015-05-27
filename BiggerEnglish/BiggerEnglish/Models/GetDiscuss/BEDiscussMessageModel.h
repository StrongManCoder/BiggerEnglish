//
//  BEDiscussMessageModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/27.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BEDiscussDetailModel.h"

@interface BEDiscussMessageModel : NSObject

@property (copy, nonatomic) NSString *count;
@property (retain, nonatomic) BEDiscussDetailModel *data;

@end
