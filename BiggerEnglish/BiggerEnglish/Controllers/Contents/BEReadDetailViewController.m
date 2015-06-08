//
//  BEReadDetailViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/4.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEReadDetailViewController.h"
#import "BEGetContentModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BEReadDetailViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelTime;
@property (nonatomic, strong) UIImageView *imagePic;
@property (nonatomic, strong) UILabel *labelContent;

@end

@implementation BEReadDetailViewController

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

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"详情";
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureView {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.labelTitle];
    [self.scrollView addSubview:self.labelTime];
    [self.scrollView addSubview:self.imagePic];
    [self.scrollView addSubview:self.labelContent];
    
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).with.offset(10);
        make.left.equalTo(self.scrollView.mas_left).with.offset(10);
        make.right.equalTo(self.scrollView.mas_right).with.offset(-10);
        make.bottom.equalTo(self.labelTime.mas_top).with.offset(-5);
    }];
    [self.labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labelTitle.mas_bottom).with.offset(5);
        make.left.equalTo(self.scrollView.mas_left).with.offset(10);
        make.right.equalTo(self.scrollView.mas_right).with.offset(-10);
        make.bottom.equalTo(self.imagePic.mas_top).with.offset(-10);
    }];

    [self.imagePic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labelTime.mas_bottom).with.offset(10);
        make.width.mas_equalTo(ScreenWidth - 20);
        make.height.mas_equalTo((ScreenWidth - 20) * 450 / 720);
        make.left.equalTo(self.scrollView.mas_left).with.offset(10);
        make.right.equalTo(self.scrollView.mas_right).with.offset(-10);
        make.bottom.equalTo(self.labelContent.mas_top).with.offset(-10);
    }];
    [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imagePic.mas_bottom).with.offset(10);
        make.left.equalTo(self.scrollView.mas_left).with.offset(10);
        make.right.equalTo(self.scrollView.mas_right).with.offset(-10);
        make.bottom.equalTo(self.scrollView.mas_bottom).with.offset(-10);
    }];

}

- (void)loadData {
    
    NSLog(@"%d",self.contentID);
    [[AFHTTPRequestOperationManager manager] GET:GetContent(self.contentID) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        BEGetContentModel *model = [BEGetContentModel jsonToObject:operation.responseString];
        BEGetContentDetailModel *detailModel = (BEGetContentDetailModel *)model.message;

        
        self.labelTitle.text = detailModel.title;
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.labelTime.text = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[detailModel.inputtime intValue]]];
        [self.imagePic sd_setImageWithURL:[NSURL URLWithString:detailModel.img]
                     placeholderImage:nil
                              options:SDWebImageCacheMemoryOnly];
        self.labelContent.text =  [detailModel.content componentsJoinedByString:@"\n\n"]; ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

#pragma mark - Getter

- (UIScrollView *)scrollView {
    if (_scrollView != nil) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = NO;
//    _scrollView.bounces = NO;
//    _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);

    return _scrollView;
}

- (UILabel *)labelTitle {
    if (_labelTitle != nil) {
        return _labelTitle;
    }
    _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.textColor = [UIColor BEFontColor];
    _labelTitle.font = [UIFont systemFontOfSize:18];
    _labelTitle.numberOfLines = 0;
    _labelTitle.preferredMaxLayoutWidth = ScreenWidth - 20;

    return _labelTitle;
}

- (UILabel *)labelTime {
    if (_labelTime != nil) {
        return _labelTime;
    }
    _labelTime = [[UILabel alloc] initWithFrame:CGRectZero];
    _labelTime.textAlignment = NSTextAlignmentCenter;
    _labelTime.textColor = [UIColor BEDeepFontColor];
    _labelTime.font = [UIFont systemFontOfSize:16];
    _labelTime.numberOfLines = 0;
    _labelTime.preferredMaxLayoutWidth = ScreenWidth - 20;
    
    return _labelTime;
}

- (UIImageView *)imagePic {
    if (_imagePic != nil) {
        return _imagePic;
    }
    _imagePic = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imagePic.contentMode = UIViewContentModeScaleAspectFit;

    return _imagePic;
}

- (UILabel *)labelContent {
    if (_labelContent != nil) {
        return _labelContent;
    }
    _labelContent = [[UILabel alloc] initWithFrame:CGRectZero];
    _labelContent.textAlignment = NSTextAlignmentLeft;
    _labelContent.textColor = [UIColor BEDeepFontColor];
    _labelContent.font = [UIFont systemFontOfSize:16];
    _labelContent.numberOfLines = 0;
    _labelContent.preferredMaxLayoutWidth = ScreenWidth - 20;

    return _labelContent;
}


@end
