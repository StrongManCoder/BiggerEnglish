//
//  BEWordBookDetailViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/7/7.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEWordBookDetailViewController.h"
#import "BEWordBookCell.h"

@interface BEWordBookDetailViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BEWordBookDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    BEWordBookCell *cell = (BEWordBookCell *)[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BEWordBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.wordLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.row];
    cell.translateLabel.text = @"1111111111111111111111111111111111111111111111111111111111111111";
    cell.rowNumberLabel.text = @"2222";
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (DeviceIsPhone) {
        return 110;
    } else {
        return 120;
    }
}

#pragma mark - Private Method

- (void)configureView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];

}

#pragma mark - Getters / Setters

- (UITableView *)tableView {
    if (_tableView != nil) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableView.layer.anchorPoint = CGPointMake(0, 0);//先设置锚点再设置frame！！
    if (DeviceIsPhone) {
        _tableView.frame = CGRectMake(0, ScreenHeight - 64, 110, ScreenWidth);
    } else {
        _tableView.frame = CGRectMake(0, ScreenHeight - 64, 120, ScreenWidth);
    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    _tableView.backgroundColor = [UIColor BEFrenchGrayColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    return _tableView;
}

@end
