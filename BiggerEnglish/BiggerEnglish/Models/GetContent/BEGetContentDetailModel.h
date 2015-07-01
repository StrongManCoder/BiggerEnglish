//
//  BEGetContentDetailModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/7/1.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BEGetContentDetailModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *thumb;
@property (copy, nonatomic) NSString *inputtime;
@property (strong, nonatomic) NSArray *content;
@property (copy, nonatomic) NSString *catid;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *copyfrom;
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *img;
@property (copy, nonatomic) NSString *alt;

@end
