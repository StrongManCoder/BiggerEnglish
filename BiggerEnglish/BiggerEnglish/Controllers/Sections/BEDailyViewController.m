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

typedef NS_ENUM(NSInteger, DirectionMode) {
    ForwardDirection,
    BackwardDirection,
};


@interface BEDailyViewController() <BELazyScrollViewDelegate> {
    
    BELazyScrollView *lazyScrollView;
    NSMutableArray *viewControllerArray;
    NSMutableDictionary *dataArray;
}
@end


@implementation BEDailyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataArray = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self configureLeftButton];
    
    // PREPARE PAGES
//    NSUInteger numberOfPages = 100;
//    viewControllerArray = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
//    for (NSUInteger k = 0; k < numberOfPages; ++k) {
//        [viewControllerArray addObject:[NSNull null]];
//    }
    
    viewControllerArray = [[NSMutableArray alloc] initWithCapacity:3];
    for (NSUInteger k = 0; k < 3; ++k) {
        [viewControllerArray addObject:[[BEDailyDetailViewController alloc] init]];
    }

    
    // PREPARE LAZY VIEW
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    NSLog(@"%.2f",self.view.frame.size.height);
    lazyScrollView = [[BELazyScrollView alloc] initWithFrame:rect];
    [lazyScrollView setEnableCircularScroll:NO];
    [lazyScrollView setAutoPlay:NO];
    
    @weakify(self);
    lazyScrollView.dataSource = ^(NSUInteger index) {
        @strongify(self);
        return [self controllerAtIndex:index];
    };
    //lazyScrollView.numberOfPages = numberOfPages;
    lazyScrollView.numberOfPages = 100;
    // lazyScrollView.controlDelegate = self;
    [self.view addSubview:lazyScrollView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor BEFrenchGrayColor];
}

- (UIViewController *) controllerAtIndex:(NSInteger) index {
    if (index == 99)  return nil;
    
    BEDailyDetailViewController *controller = [viewControllerArray objectAtIndex:index % 3];
    
    NSString *date = [self getPredate:[self getDate] dateCount:index];
    controller.date = date;
    NSObject *object = [dataArray objectForKey:date];
    if (object == nil) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager GET:[DailyWordUrl stringByAppendingString:date] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //json转换model
            BEDailyModel *model = [BEDailyModel jsonToObject:operation.responseString];
            controller.dailyModel = model;
            //加入缓存字典
            [dataArray setObject:model forKey:date];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    else
    {
        BEDailyModel *model = (BEDailyModel*)object;
        controller.dailyModel = model;
    }
    
    return controller;
}

-(void)configureLeftButton {
    UIButton *leftButton                  = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame                      = CGRectMake(0, 0, 25, 25);
    [leftButton setAdjustsImageWhenHighlighted:YES];
    UIImage *image                        = [UIImage imageNamed:@"navi_menu"];
    [leftButton setImage:[image imageWithTintColor:[UIColor BEDeepFontColor]] forState:UIControlStateNormal];
    [leftButton setImage:[image imageWithTintColor:[UIColor BEHighLightFontColor]] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(navigateSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem              = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = barItem;
}

#pragma Private Method

//获取当天日期
-(NSString *)getDate {
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString  = [formatter stringFromDate: [NSDate date]];
    return locationString;
}

//获取前一天日期
-(NSString *)getPredate:(NSString *)strDate dateCount:(NSInteger)count {
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *locationdate      = [formatter dateFromString:strDate];
    NSDate *predate           = [NSDate dateWithTimeInterval:-24*60*60*count sinceDate:locationdate];
    NSString *locationString  = [formatter stringFromDate:predate];
    return locationString;
}

#pragma mark - Notifications

- (void)navigateSetting {
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
}

@end
