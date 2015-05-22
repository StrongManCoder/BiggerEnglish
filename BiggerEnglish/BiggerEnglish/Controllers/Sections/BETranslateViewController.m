//
//  BETranslateViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/13.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BETranslateViewController.h"

@implementation BETranslateViewController

- (void)loadView {
    [super loadView];
    
    [self configureLeftButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getMoodStatData];
}

-(void)configureLeftButton {
    UIButton *leftButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame       = CGRectMake(0, 0, 25, 25);
    [leftButton setAdjustsImageWhenHighlighted:YES];
    UIImage *image = [UIImage imageNamed:@"navi_menu"];
    [leftButton setImage:[image imageWithTintColor:[UIColor BEDeepFontColor]] forState:UIControlStateNormal];
    [leftButton setImage:[image imageWithTintColor:[UIColor BEHighLightFontColor]] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(navigateSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem              = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = barItem;
}

- (void)navigateSetting {
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
}

- (void) getMoodStatData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:@"http://open.iciba.com/dsapi/?date=2013-05-03" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@ ",operation.responseString);
        
        //        GetMoodStatDataResponse *getMoodStatDataResponse = [GetMoodStatDataResponse jsonToObject:operation.responseString];
        //        if ([getMoodStatDataResponse.rsCode isEqual: @"SUCCESS"]) {
        //
        //            NSLog(@"%@",getMoodStatDataResponse.rsCode);
        //            NSLog(@"%@",getMoodStatDataResponse.rsDesc);
        //            NSLog(@"%@",getMoodStatDataResponse.data);
        //
        //            NSArray *array = [GetMoodStatDataDataResponse objectArrayWithKeyValuesArray:getMoodStatDataResponse.data];
        //            for (GetMoodStatDataDataResponse *item in array) {
        //                NSLog(@"type=%d, happy=%d, normal=%d, unhappy=%d", item.type, item.happy, item.normal, item.unhappy);
        //            }
        //        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

@end
