//
//  ReadContentModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/9.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ReadContentModel : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * inputtime;
@property (nonatomic, retain) NSString * img;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * favour;
@property (nonatomic, retain) NSString * contentid;
@property (nonatomic, retain) NSString * descript;

@end
