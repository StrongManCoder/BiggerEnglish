//
//  ResponseSuper.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/21.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "ResponseSuper.h"
#import "MJExtension.h"

@implementation ResponseSuper

+ (id) jsonToObject:(NSString*) json{
    NSData* data = [[NSData alloc] initWithData:[[NSString stringWithString:json] dataUsingEncoding:NSUTF8StringEncoding]];
    NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (error != nil) return nil;
    
    NSLog(@"Json to object:%@",result);
    return [self objectWithKeyValues:result];
}

@end
