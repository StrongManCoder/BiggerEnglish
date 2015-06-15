//
//  BETranslationSentenceModel.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/15.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BETranslationSentenceModel : NSObject

@property (copy, nonatomic) NSString *Network_id;
@property (copy, nonatomic) NSString *Network_en;
@property (copy, nonatomic) NSString *Network_cn;
@property (copy, nonatomic) NSString *tts_mp3;
@property (copy, nonatomic) NSString *tts_size;

@end
