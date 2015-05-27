//
//  FavourModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/27.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FavourModel : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * translation;
@property (nonatomic, retain) NSString * picture2;
@property (nonatomic, retain) NSString * love;
@property (nonatomic, retain) NSString * tts;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * sid;

@end
