//
//  BEReadModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/4.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseSuper.h"
#import "BEReadDetailModel.h"

@interface BEReadModel : ResponseSuper

@property (copy, nonatomic) NSString *status;
@property (retain, nonatomic) BEReadDetailModel *message;

@end
