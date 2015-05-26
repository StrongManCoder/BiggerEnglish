//
//  FavourModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/26.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FavourModel : NSManagedObject

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * dateline;
@property (nonatomic, retain) NSString * fenxiang_img;
@property (nonatomic, retain) NSString * love;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSString * picture2;
@property (nonatomic, retain) NSString * s_pv;
@property (nonatomic, retain) NSString * sid;
@property (nonatomic, retain) NSString * sp_pv;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSString * translation;
@property (nonatomic, retain) NSString * tts;

@end
