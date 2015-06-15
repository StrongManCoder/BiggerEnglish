//
//  BETranslationModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/15.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseSuper.h"   
#import "BETranslationMessageModel.h"   

@interface BETranslationModel : ResponseSuper

@property (copy, nonatomic) NSString *status;
@property (retain, nonatomic) BETranslationMessageModel *message;

@end
