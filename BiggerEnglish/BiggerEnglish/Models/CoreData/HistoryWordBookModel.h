//
//  HistoryWordBookModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/7/10.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WordModel;

@interface HistoryWordBookModel : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *words;
@end

@interface HistoryWordBookModel (CoreDataGeneratedAccessors)

- (void)addWordsObject:(WordModel *)value;
- (void)removeWordsObject:(WordModel *)value;
- (void)addWords:(NSSet *)values;
- (void)removeWords:(NSSet *)values;

@end
