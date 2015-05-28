//
//  BEDailyCommentCell.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/28.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface BEDailyCommentCell : UITableViewCell

@property (nonatomic, strong) RTLabel *rtLabel;

+ (RTLabel*)textLabel;

@end
