//
//  CacheManager.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/26.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "CacheManager.h"

@implementation CacheManager
@synthesize lastReadList = _lastReadList;

- (void)setLastReadList:(NSString *)code {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"lastReadList"];
    [settings setObject:code forKey:@"lastReadList"];
    [settings synchronize];
}

- (NSString *)lastReadList {
    if(_lastReadList != nil){
        return _lastReadList;
    }
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *value = [setting objectForKey:@"lastReadList"];
    _lastReadList = value;
    
    return _lastReadList;
}

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
