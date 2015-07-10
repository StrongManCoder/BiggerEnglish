//
//  SentenceModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/7/10.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SentenceModel : NSManagedObject

@property (nonatomic, retain) NSString * mp3;
@property (nonatomic, retain) NSString * sentence;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * translate;

@end
