//
//  BEWordBookDetailViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/7/7.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEWordBookDetailViewController.h"
#import "BEWordBookCell.h"

#define IPADSQUARESIZE 120
#define IPHONESQUARESIZE 110

@interface BEWordBookDetailViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *topTableView;

@property (nonatomic, strong) UITableView *bottomTableView;

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
    if (tableView.tag == 0) {
        return 0;
    }
    else {
        return 20;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        return nil;
    }
    else {
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
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        return 44;
    }
    else {
        if (DeviceIsPhone) {
            return IPHONESQUARESIZE;
        } else {
            return IPADSQUARESIZE;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Private Method

- (void)configureView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.topTableView];
    [self.view addSubview:self.bottomTableView];
}

#pragma mark - Getters / Setters

- (UITableView *)topTableView {
    if (_topTableView != nil) {
        return _topTableView;
    }
    _topTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    if (DeviceIsPhone) {
        _topTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - IPHONESQUARESIZE);
    } else {
        _topTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - IPADSQUARESIZE);
    }
    _topTableView.showsVerticalScrollIndicator = NO;
    _topTableView.dataSource = self;
    _topTableView.delegate = self;
    _topTableView.tag = 0;
    
    return _topTableView;
}

- (UITableView *)bottomTableView {
    if (_bottomTableView != nil) {
        return _bottomTableView;
    }
    _bottomTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _bottomTableView.layer.anchorPoint = CGPointMake(0, 0);//先设置锚点再设置frame！！
    if (DeviceIsPhone) {
        _bottomTableView.frame = CGRectMake(0, ScreenHeight - 64, IPHONESQUARESIZE, ScreenWidth);
    } else {
        _bottomTableView.frame = CGRectMake(0, ScreenHeight - 64, IPADSQUARESIZE, ScreenWidth);
    }
    _bottomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bottomTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    _bottomTableView.backgroundColor = [UIColor BEFrenchGrayColor];
    _bottomTableView.showsVerticalScrollIndicator = NO;
    _bottomTableView.dataSource = self;
    _bottomTableView.delegate = self;
    _bottomTableView.tag = 1;
    
    return _bottomTableView;
}

@end
