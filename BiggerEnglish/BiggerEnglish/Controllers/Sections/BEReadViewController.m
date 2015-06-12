//
//  BEReadViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/4.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEReadViewController.h"
#import "BEReadViewCell.h"
#import "MJRefresh.h"
#import "BEReadDetailViewController.h"
#import "BEReadModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BEWebViewController.h"

@interface BEReadViewController () <UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate> {
    
    NSInteger pageIndex;//页数索引
    NSInteger pageSize;//每页条数
}
@property (nonatomic, strong) NSMutableArray *readArray;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *labelTitle;

@property (nonatomic, copy) NSString *headerUrl;

@end

@implementation BEReadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _readArray = [NSMutableArray array];
        pageIndex = 1;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            pageSize = 10;
        }
        else {
            pageSize = 20;
        }
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.title = @"阅读";
    [self configureLeftButton];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor BEFrenchGrayColor];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Method

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

- (void)navigateSetting {
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
}

- (void)networkRequest {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:GetRecommendList((int)pageIndex, (int)pageSize) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //json转换model
        NSString *result = operation.responseString;
        result = [result stringByReplacingOccurrencesOfString:@"description" withString:@"descript"];
        BEReadModel *model = [BEReadModel jsonToObject:result];
        BEReadDetailModel *detailModel = (BEReadDetailModel *)model.message;
        if (pageIndex == 1) {
            NSDictionary *dicFirstData = (NSDictionary *)[detailModel.data objectAtIndex:0];
            //配置headerView
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:[dicFirstData objectForKey:@"thumb"]]
                              placeholderImage:nil
                                       options:SDWebImageRetryFailed];
            self.labelTitle.text = [dicFirstData objectForKey:@"title"];
            self.headerUrl = [dicFirstData objectForKey:@"link"];
            //移除第一页头一条head数据
            [detailModel.data removeObjectAtIndex:0];
            //保存到userdefault，无网络的时候使用
            [CacheManager manager].lastReadList = result;
        }
        NSArray *array = [BEReadDetailDataModel objectArrayWithKeyValuesArray:detailModel.data];
        if (pageIndex == 1) {
            [self.tableView.header endRefreshing];
            [self.readArray removeAllObjects];
            self.tableView.footer.hidden = NO;
        } else {
            [self.tableView.footer endRefreshing];
        }
        for (BEReadDetailDataModel *detailDataModel in array) {
            [self.readArray addObject: detailDataModel];
        }
        [self.tableView reloadData];
        pageIndex++;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (pageIndex == 1) {
            NSString *result = [CacheManager manager].lastReadList;
            if (result != nil) {
                BEReadModel *model = [BEReadModel jsonToObject:result];
                BEReadDetailModel *detailModel = (BEReadDetailModel *)model.message;
                [detailModel.data removeObjectAtIndex:0];
                NSArray *array = [BEReadDetailDataModel objectArrayWithKeyValuesArray:detailModel.data];
                [self.readArray removeAllObjects];
                self.tableView.footer.hidden = NO;
                for (BEReadDetailDataModel *detailDataModel in array) {
                    [self.readArray addObject: detailDataModel];
                }
                [self.tableView reloadData];
                pageIndex++;
            }
        }
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showText:@"没有网络连接哦！"];
    }];
}

- (void)showText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.delegate = self;
    [hud hide:YES afterDelay:1.5];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.readArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"BEReadViewCell";
    BEReadViewCell *cell = (BEReadViewCell *)[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BEReadViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    BEReadDetailDataModel *model = (BEReadDetailDataModel *)self.readArray[indexPath.row];
    cell.pic = model.thumb;
    cell.title = model.title;
    cell.content = model.descript;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BEReadDetailViewController *controller = [[BEReadDetailViewController alloc] init];
    BEReadDetailDataModel *model = (BEReadDetailDataModel *)self.readArray[indexPath.row];
    controller.contentID = [model.id intValue];
    controller.descript = model.descript;
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
    hud.delegate = nil;
    hud = nil;
}

#pragma mark - Event Response

- (void)onHeaderViewClick {
    BEWebViewController *controller = [[BEWebViewController alloc] init];
    controller.url = [NSURL URLWithString:self.headerUrl];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Getter / Setter

- (UITableView *)tableView {
    if (_tableView !=nil) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height - 64)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 44.0f;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    //下拉刷新
    @weakify(self);
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        pageIndex = 1;
        [self.tableView.footer endRefreshing];
        self.tableView.footer.hidden = YES;
        [self networkRequest];
    }];
    //上拉刷新
    [_tableView addLegendFooterWithRefreshingBlock:^{
        @strongify(self);
        [self networkRequest];
    }];
    _tableView.footer.automaticallyRefresh = NO;
    [_tableView.footer setTitle:@"点击或上拉加载更多！" forState:MJRefreshFooterStateIdle];
    [_tableView.footer setTitle:@"正在加载中 ..." forState:MJRefreshFooterStateRefreshing];
    _tableView.footer.hidden = YES;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth / 2)];
    headerView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:self.imageView];
    [headerView addSubview:self.labelTitle];
    _tableView.tableHeaderView = headerView;

    return _tableView;
}

- (UIImageView *)imageView {
    if (_imageView != nil) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth / 2)];
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeaderViewClick)];
    [_imageView addGestureRecognizer:tap];

    return _imageView;
}

- (UILabel *)labelTitle {
    if (_labelTitle != nil) {
        return _labelTitle;
    }
    _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, (ScreenWidth / 2) - 30, ScreenWidth, 30)];
    _labelTitle.textAlignment = NSTextAlignmentLeft;
    _labelTitle.textColor = [UIColor whiteColor];
    _labelTitle.font = [UIFont systemFontOfSize:16];
    
    return _labelTitle;
}

@end
