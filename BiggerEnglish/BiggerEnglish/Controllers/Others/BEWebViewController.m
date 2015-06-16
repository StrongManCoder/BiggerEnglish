//
//  BEWebViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/12.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEWebViewController.h"

@interface BEWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation BEWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureWebView];
    
    if (self.url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
        [self.webView loadRequest:request];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureWebView {
    
    [self.view addSubview:self.webView];
}

#pragma mark - Getters and Setters

- (UIWebView *)webView {
    if (_webView != nil) {
        return _webView;
    }
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.opaque=NO;
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    
    return _webView;
}


@end
