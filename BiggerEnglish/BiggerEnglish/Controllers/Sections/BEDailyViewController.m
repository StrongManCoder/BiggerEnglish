//
//  BEDailyViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/13.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEDailyViewController.h"
#import "BEDailyDetailViewController.h"
#import "BELazyScrollView.h"
#import "BEDailyModel.h"
#import <CoreData/CoreData.h>
#import "FavourModel.h"
#import "LoveModel.h"

static int const MaxPage = 100;
static int const ViewControllerArrayCount = 3;

@interface BEDailyViewController()

@property (strong, nonatomic) NSMutableArray *viewControllerArray;
@property (strong, nonatomic) BELazyScrollView *lazyScrollView;

@end

@implementation BEDailyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initCacheData];
    }
    return self;
}

- (void)loadView {
    [super loadView];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"每日一句";
    
    [self configureLeftButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.lazyScrollView];
}

#pragma mark - Private Methods

- (void)initCacheData {
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"FavourModel" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSArray *favourResults=[[managedObjectContext executeFetchRequest:request error:nil] copy];
    
    for (FavourModel *favour in favourResults) {
        [[CacheManager manager].arrayFavour addObject:favour.title];
    }
    
    entity = [NSEntityDescription entityForName:@"LoveModel" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSArray *loveResults=[[managedObjectContext executeFetchRequest:request error:nil] copy];
    for (LoveModel *love in loveResults) {
        [[CacheManager manager].arrayLove addObject:love.date];
    }
}

-(void)configureLeftButton {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton setAdjustsImageWhenHighlighted:YES];
    UIImage *image = [UIImage imageNamed:@"icon_hamberger"];
    [leftButton setImage:[image imageWithTintColor:[UIColor BEDeepFontColor]] forState:UIControlStateNormal];
    [leftButton setImage:[image imageWithTintColor:[UIColor BEHighLightFontColor]] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(navigateSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = barItem;
}

//获取当天日期
-(NSString *)getDate {
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString = [formatter stringFromDate: [NSDate date]];
    return locationString;
}

//获取前一天日期
-(NSString *)getPredate:(NSString *)strDate dateCount:(NSInteger)count {
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *locationdate = [formatter dateFromString:strDate];
    NSDate *predate = [NSDate dateWithTimeInterval:-24*60*60*count sinceDate:locationdate];
    NSString *locationString = [formatter stringFromDate:predate];
    return locationString;
}

#pragma mark - Event Response

- (void)navigateSetting {
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
}

- (UIViewController *) controllerAtIndex:(NSInteger) index {
    if (index == MaxPage - 1) {
        return nil;
    }
    BEDailyDetailViewController *controller = [self.viewControllerArray objectAtIndex:index % ViewControllerArrayCount];
    NSString *date = [self getPredate:[self getDate] dateCount:index];
    [controller loadData:date];
    return controller;
}

#pragma mark - Getters and Setters

- (NSMutableArray *)viewControllerArray {
    if (_viewControllerArray != nil) {
        return _viewControllerArray;
    }
    _viewControllerArray = [[NSMutableArray alloc] initWithCapacity:ViewControllerArrayCount];
    for (NSUInteger k = 0; k < ViewControllerArrayCount; ++k) {
        [_viewControllerArray addObject:[[BEDailyDetailViewController alloc] init]];
    }

    return _viewControllerArray;
}

- (BELazyScrollView *)lazyScrollView {
    if (_lazyScrollView != nil) {
        return _lazyScrollView;
    }
    _lazyScrollView = [[BELazyScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    _lazyScrollView.enableCircularScroll = NO;
    _lazyScrollView.autoPlay = NO;
    @weakify(self);
    _lazyScrollView.dataSource = ^(NSUInteger index) {
        @strongify(self);
        return [self controllerAtIndex:index];
    };
    _lazyScrollView.numberOfPages = MaxPage;

    return _lazyScrollView;
}

@end
