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
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 30, 30);
    
    [leftButton addTarget:self action:@selector(navigateSetting) forControlEvents:UIControlEventTouchUpInside];
    //设置leftBarButtonItem
    UIBarButtonItem  *barItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    barItem.title = @"123";
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)navigateSetting {
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
}

@end
