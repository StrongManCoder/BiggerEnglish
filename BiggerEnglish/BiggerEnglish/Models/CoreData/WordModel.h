//
//  WordModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/7/9.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SentenceModel;

@interface WordModel : NSManagedObject

@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSString * translate;
@property (nonatomic, retain) NSString * phen;
@property (nonatomic, retain) NSString * phenmp3;
@property (nonatomic, retain) NSString * pham;
@property (nonatomic, retain) NSString * phammp3;
@property (nonatomic, retain) NSString * exchange;
@property (nonatomic, retain) NSSet *sentences;
@end

@interface WordModel (CoreDataGeneratedAccessors)

- (void)addSentencesObject:(SentenceModel *)value;
- (void)removeSentencesObject:(SentenceModel *)value;
- (void)addSentences:(NSSet *)values;
- (void)removeSentences:(NSSet *)values;

@end
