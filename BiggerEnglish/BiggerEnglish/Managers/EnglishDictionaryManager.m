//
//  EnglishDictionaryManager.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/29.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "EnglishDictionaryManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface EnglishDictionaryManager()

@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) NSURL *modelURL;

@end

@implementation EnglishDictionaryManager

- (id)init
{
    self = [super init];
    if (self) {
        _modelURL = [[NSBundle mainBundle] URLForResource:@"dictionary" withExtension:@"db"];
        _database = [FMDatabase databaseWithPath: _modelURL.relativeString];
    }
    return self;
}

- (NSMutableArray *)translateEnglish:(NSString *)word {
    NSMutableArray *array = [NSMutableArray array];
    if (![self.database open])
    {
        return nil;
    }
    NSString *sql = [NSString stringWithFormat:@"select * from t_words where english like '%@%%' limit 20 ", word];
    FMResultSet *resultSet = [self.database executeQuery:sql];
    while ([resultSet next])
    {
        [array addObject:([NSString stringWithFormat:@"%@； %@", [resultSet stringForColumn: @"english"], [resultSet stringForColumn: @"chinese"]])];
    }
    return array;
}

- (NSMutableArray *)translateChinese:(NSString *)word {
    NSMutableArray *array = [NSMutableArray array];
    if (![self.database open])
    {
        return nil;
    }
    NSString *sql = [NSString stringWithFormat:@"select * from t_words where chinese like '%%%@%%' limit 20 ", word];
    FMResultSet *resultSet = [self.database executeQuery:sql];
    while ([resultSet next])
    {
        [array addObject:([NSString stringWithFormat:@"%@；", [resultSet stringForColumn: @"chinese"]])];
    }
    return array;
}

- (NSDictionary *)randomWord {
    NSDictionary *dictionary;
    if (![self.database open])
    {
        return nil;
    }
    NSString *sql = [NSString stringWithFormat:@"select * from t_words where LENGTH(english)>8 ORDER BY random() LIMIT 1 "];
    FMResultSet *resultSet = [self.database executeQuery:sql];
    while ([resultSet next])
    {
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[resultSet stringForColumn: @"chinese"], [resultSet stringForColumn: @"english"], nil];
    }
    return dictionary;
}

- (void)dealloc {
    [self.database close];
}

@end
