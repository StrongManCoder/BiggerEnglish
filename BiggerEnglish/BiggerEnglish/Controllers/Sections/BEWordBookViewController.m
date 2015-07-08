//
//  BEWordBookViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/14.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEWordBookViewController.h"
#import "BEWordBookCell.h"
#import "BEWordBookHeaderView.h"
#import "BEWordBookDetailViewController.h"
#import "BEPopupTableView.h"

@interface BEWordBookViewController() <UITableViewDelegate, UITableViewDataSource, BEPopupTableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) BEWordBookHeaderView *headerView;

@end

@implementation BEWordBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.title = @"单词本";
    
    [self configureLeftButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}

-(void)configureLeftButton {
    UIButton *leftButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame       = CGRectMake(0, 0, 25, 25);
    [leftButton setAdjustsImageWhenHighlighted:YES];
    UIImage *image = [UIImage imageNamed:@"icon_hamberger"];
    [leftButton setImage:[image imageWithTintColor:[UIColor BEDeepFontColor]] forState:UIControlStateNormal];
    [leftButton setImage:[image imageWithTintColor:[UIColor BEHighLightFontColor]] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(navigateSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem              = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = barItem;
}

- (void)configureView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    
}

- (void)navigateSetting {
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString *ID = @"cell";
    //    BEWordBookCell *cell = (BEWordBookCell *)[tableView dequeueReusableCellWithIdentifier:ID];
    //    if (cell == nil) {
    //        cell = [[BEWordBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    //    }
    //
    //    cell.wordLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.row];
    //    cell.translateLabel.text = @"1111111111111111111111111111111111111111111111111111111111111111";
    //    cell.rowNumberLabel.text = @"2222";
    //    return cell;
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.row];
    return cell;
    
}

#pragma mark - BEPopupTableViewDelegate

- (void)popupTableView:(BEPopupTableView *)popupTableViewView didSelectIndexPath:(NSIndexPath *)indexPath {
    if (popupTableViewView.tag == 0) {
        
    }
    else //清空历史纪录
    {
        
    }
}

#pragma mark - Getters / Setters

- (UITableView *)tableView {
    if (_tableView != nil) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _tableView.backgroundColor = [UIColor BEFrenchGrayColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPress.minimumPressDuration = 1.0;
    [_tableView addGestureRecognizer:longPress];
    
    return _tableView;
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.tableView];
        //判断是否在列表中长按
        if (point.y > self.tableView.tableHeaderView.height) {
            NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
            NSLog(@"%d", indexPath.row);
            if(indexPath == nil) return ;
            
            BEPopupTableView *popupTableView = [[BEPopupTableView alloc] initWithView];
            popupTableView.dataArray = [[NSArray alloc] initWithObjects:@"默认添加到此生词本", @"清空生词本", @"删除生词本", nil];
            popupTableView.tag = 2;
            popupTableView.delegate = self;
            [popupTableView show];
        }
    }
}

- (UIView *)headerView {
    if (_headerView != nil) {
        return _headerView;
    }
    _headerView = [[BEWordBookHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60 + (ScreenWidth - 30) / 2)];
    _headerView.addWordBookBlock = ^(){
        NSLog(@"addWordBookBlock");
    };
    @weakify(self);
    _headerView.wordViewBlock = ^(){
        @strongify(self);
        BEWordBookDetailViewController *controller = [[BEWordBookDetailViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    };
    _headerView.wordViewLongPressBlock = ^(){
        @strongify(self);
        BEPopupTableView *popupTableView = [[BEPopupTableView alloc] initWithView];
        popupTableView.dataArray = [[NSArray alloc] initWithObjects:@"默认添加到此生词本", @"清空生词本", nil];
        popupTableView.tag = 0;
        popupTableView.delegate = self;
        [popupTableView show];
    };
    _headerView.historyViewBlock = ^(){
        @strongify(self);
        BEWordBookDetailViewController *controller = [[BEWordBookDetailViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    };
    _headerView.historyViewLongPressBlock = ^(){
        @strongify(self);
        BEPopupTableView *popupTableView = [[BEPopupTableView alloc] initWithView];
        popupTableView.tag = 1;
        popupTableView.dataArray = [[NSArray alloc] initWithObjects:@"清空历史纪录", nil];
        popupTableView.delegate = self;
        [popupTableView show];
    };
    
    return _headerView;
}

@end
