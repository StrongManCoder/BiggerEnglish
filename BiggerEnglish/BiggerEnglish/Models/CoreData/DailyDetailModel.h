//
//  DailyDetailModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/11.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DailyDetailModel : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * dateline;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * translation;
@property (nonatomic, retain) NSString * picture2;
@property (nonatomic, retain) NSString * love;
@property (nonatomic, retain) NSString * tts;
@property (nonatomic, retain) NSString * ttsSize;
@property (nonatomic, retain) NSString * sid;
@property (nonatomic, retain) NSString * ttsMd5;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSNumber * boolLove;

@end
