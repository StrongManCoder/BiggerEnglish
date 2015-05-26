//
//  CacheManager.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/26.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

+ (instancetype)manager;

@property (nonatomic, strong) NSMutableDictionary *arrayData;

@property (nonatomic, strong) NSMutableArray *arrayLove;

@property (nonatomic, strong) NSMutableArray *arrayFavour;

@end
