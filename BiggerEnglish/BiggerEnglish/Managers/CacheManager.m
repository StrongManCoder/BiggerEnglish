//
//  CacheManager.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/26.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "CacheManager.h"

@implementation CacheManager

- (instancetype)init {
    if (self = [super init]) {
        
        self.arrayData = [NSMutableDictionary dictionary];
        self.arrayFavour = [NSMutableArray array];
        self.arrayLove   = [NSMutableArray array];
    }
    
    return self;
}

+ (instancetype)manager {
    static CacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CacheManager alloc] init];
    });
    return manager;
}

@end
