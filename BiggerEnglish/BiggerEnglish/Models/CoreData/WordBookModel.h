//
//  WordBookModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/7/9.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WordModel;

@interface WordBookModel : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * defaulted;
@property (nonatomic, retain) NSSet *words;
@end

@interface WordBookModel (CoreDataGeneratedAccessors)

- (void)addWordsObject:(WordModel *)value;
- (void)removeWordsObject:(WordModel *)value;
- (void)addWords:(NSSet *)values;
- (void)removeWords:(NSSet *)values;

@end
