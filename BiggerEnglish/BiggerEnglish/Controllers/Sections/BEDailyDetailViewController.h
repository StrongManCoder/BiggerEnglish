//
//  BEDailyDetailViewController.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/18.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BEDailyDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *date;

- (void)loadData:(NSString *)date;

@end
