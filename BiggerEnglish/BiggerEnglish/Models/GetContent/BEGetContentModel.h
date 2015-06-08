//
//  BEGetContentModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/8.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseSuper.h"
#import "BEGetContentDetailModel.h"

@interface BEGetContentModel : ResponseSuper

@property (copy, nonatomic) NSString *status;
@property (retain, nonatomic) BEGetContentDetailModel *message;

@end
