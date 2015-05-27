//
//  BEDiscussModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/27.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BEDiscussMessageModel.h"   

@interface BEDiscussModel : NSObject

@property (copy, nonatomic) NSString *status;
@property (retain, nonatomic) BEDiscussMessageModel *message;

@end
