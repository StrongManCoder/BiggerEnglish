//
//  BESettingViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/3.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BESettingViewController.h"

@interface BESettingViewController ()

@end

@implementation BESettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self configureView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configureView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    UIButton *closeButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame       = CGRectMake(20, 32, 30, 30);
    [closeButton setAdjustsImageWhenHighlighted:YES];
    UIImage *image = [UIImage imageNamed:@"icon_close"];
    [closeButton setImage:[image imageWithTintColor:[UIColor BEDeepFontColor]] forState:UIControlStateNormal];
    [closeButton setImage:[image imageWithTintColor:[UIColor BEHighLightFontColor]] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
