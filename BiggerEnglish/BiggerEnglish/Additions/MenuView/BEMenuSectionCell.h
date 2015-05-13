//
//  BEMenuSectionCell.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/13.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BEMenuSectionCell : UITableViewCell

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *badge;

+ (CGFloat)getCellHeight;

@end
