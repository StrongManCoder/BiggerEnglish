//
//  BEDailyDetailViewController.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/18.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEDailyModel.h"

@interface BEDailyDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, copy) NSString *datetime;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, retain) BEDailyModel *dailyModel;

- (void)reloadData;

- (void)loadData:(NSString *)date;


@end
