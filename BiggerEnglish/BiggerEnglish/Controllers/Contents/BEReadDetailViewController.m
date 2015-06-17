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
#import "ReadContentModel.h"

@interface BEReadDetailViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelTime;
@property (nonatomic, strong) UIImageView *imagePic;
@property (nonatomic, strong) UILabel *labelContent;
@property (nonatomic, strong) UIImageView *imageSeparator;
@property (nonatomic, strong) UIImageView *imageFavour;
@property (nonatomic, strong) UIImageView *imageShare;

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

#pragma mark - Private Method

- (void)configureView {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.labelTitle];
    [self.scrollView addSubview:self.labelTime];
    [self.scrollView addSubview:self.imagePic];
    [self.scrollView addSubview:self.labelContent];
    [self.scrollView addSubview:self.imageSeparator];
    [self.scrollView addSubview:self.imageFavour];
    [self.scrollView addSubview:self.imageShare];
    
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
        make.bottom.equalTo(self.imageSeparator.mas_top).with.offset(-20);
    }];
    [self.imageSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labelContent.mas_bottom).with.offset(20);
        make.left.equalTo(self.scrollView.mas_left).with.offset(10);
        make.right.equalTo(self.scrollView.mas_right).with.offset(-10);
        make.bottom.equalTo(self.scrollView.mas_bottom).with.offset(-60);
//        make.bottom.equalTo(self.imageShare.mas_top).with.offset(-10);
        
        make.height.mas_equalTo(@0.6);
    }];
    [self.imageFavour mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.imageSeparator.mas_bottom).with.offset(20);
        make.right.equalTo(self.scrollView.mas_right).with.offset(-100);
        make.bottom.equalTo(self.scrollView.mas_bottom).with.offset(-20);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    [self.imageShare mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.imageSeparator.mas_bottom).with.offset(20);
        make.right.equalTo(self.scrollView.mas_right).with.offset(-40);
        make.bottom.equalTo(self.scrollView.mas_bottom).with.offset(-20);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
}

- (void)loadData {
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"ReadContentModel" inManagedObjectContext:managedObjectContext];
    request.entity = entity;
    request.predicate = [NSPredicate predicateWithFormat:@"contentid == %d", self.contentID];
    NSArray *results = [[managedObjectContext executeFetchRequest:request error:nil] copy];

    //从数据库读取
    if ([results count] == 1) {
        ReadContentModel *model = (ReadContentModel *)[results objectAtIndex:0];
        [self setPage:model.title time:model.inputtime image:model.img content:model.content];
        if ([model.favour isEqualToNumber: [NSNumber numberWithInteger:1]]) {
            self.imageFavour.image = [[UIImage imageNamed:@"icon_favour_highlight"] imageWithTintColor:[UIColor BEHighLightFontColor]];
        }
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[AFHTTPRequestOperationManager manager] GET:GetContent(self.contentID) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            BEGetContentModel *model = [BEGetContentModel jsonToObject:operation.responseString];
            BEGetContentDetailModel *detailModel = (BEGetContentDetailModel *)model.message;
            
            NSString *title = detailModel.title;
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *inputtime = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[detailModel.inputtime intValue]]];
            NSString *img = detailModel.img;
            NSString *content = [detailModel.content componentsJoinedByString:@"\n\n"];
            
            //界面更新
            [self setPage:title time:inputtime image:img content:content];
            //数据库新增数据
            ReadContentModel *newModel=(ReadContentModel *)[NSEntityDescription insertNewObjectForEntityForName:@"ReadContentModel" inManagedObjectContext:managedObjectContext];
            newModel.contentid = [NSString stringWithFormat:@"%d",self.contentID];
            newModel.title = title;
            newModel.inputtime = inputtime;
            newModel.content = content;
            newModel.img = img;
            newModel.favour = [NSNumber numberWithInteger:0];
            newModel.descript = self.descript;
            if (![managedObjectContext save:nil]) {
                NSLog(@"error!");
            } else {
                NSLog(@"save ok.");
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

- (void)setPage:(NSString *)title time:(NSString *)time image:(NSString *)img content:(NSString *)content {
    self.labelTitle.text = title;
    self.labelTime.text = time;
    [self.imagePic sd_setImageWithURL:[NSURL URLWithString:img]
                     placeholderImage:nil
                              options:SDWebImageRetryFailed];
    self.labelContent.text = content;
    
    _imageSeparator.hidden = NO;
    _imageFavour.hidden = NO;
    _imageShare.hidden = NO;
}

//收藏
- (void) onImageFavourClick {
    
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"ReadContentModel" inManagedObjectContext:managedObjectContext];
    request.entity = entity;
    request.predicate = [NSPredicate predicateWithFormat:@"contentid == %d", self.contentID];
    NSArray *results = [[managedObjectContext executeFetchRequest:request error:nil] copy];
    if ([results count] == 1) {
        ReadContentModel *model = (ReadContentModel *)[results objectAtIndex:0];
        model.title = [model.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        model.descript = [model.descript stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([model.favour isEqualToNumber: [NSNumber numberWithInteger:0]]) {
            model.favour = [NSNumber numberWithInteger:1];
            self.imageFavour.image = [[UIImage imageNamed:@"icon_favour_highlight"] imageWithTintColor:[UIColor BEHighLightFontColor]];
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values =  [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:1.0],
                                 [NSNumber numberWithDouble:1.4],
                                 [NSNumber numberWithDouble:0.9],
                                 [NSNumber numberWithDouble:1.15],
                                 [NSNumber numberWithDouble:1.0],nil];
            animation.duration = 0.5f;
            animation.calculationMode = kCAAnimationCubic;
            [self.imageFavour.layer addAnimation:animation forKey:@"bounceAnimation"];
        } else {
            model.favour = [NSNumber numberWithInteger:0];
            self.imageFavour.image = [[UIImage imageNamed:@"icon_favour"] imageWithTintColor:[UIColor BEHighLightFontColor]];
        }
        
        if ([managedObjectContext save:nil]) {
            NSLog(@"update ok");
        } else {
            NSLog(@"update faild");
        }
    }
}

//分享
- (void) onImageShareClick {
    
}


#pragma mark - Getters / Setters

- (UIScrollView *)scrollView {
    if (_scrollView != nil) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = NO;
    
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

- (UIImageView *)imageSeparator {
    if (_imageSeparator != nil) {
        return _imageSeparator;
    }
    _imageSeparator = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageSeparator.backgroundColor = [UIColor BEHighLightFontColor];
    _imageSeparator.contentMode = UIViewContentModeScaleAspectFill;
    _imageSeparator.image = [UIImage imageNamed:@"section_divide"];
    _imageSeparator.clipsToBounds = YES;
    _imageSeparator.hidden = YES;
    
    return _imageSeparator;
}

- (UIImageView *)imageFavour {
    if (_imageFavour != nil) {
        return _imageFavour;
    }
    _imageFavour = [[UIImageView alloc] init];
    _imageFavour.image = [[UIImage imageNamed:@"icon_favour"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    _imageFavour.hidden = YES;
    _imageFavour.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageLoveSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageFavourClick)];
    [_imageFavour addGestureRecognizer:imageLoveSingleTap];
    
    return _imageFavour;
}

- (UIImageView *)imageShare {
    if (_imageShare != nil) {
        return _imageShare;
    }
    _imageShare = [[UIImageView alloc] init];
    _imageShare.image = [[UIImage imageNamed:@"icon_share"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    _imageShare.hidden = YES;
    _imageShare.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageShareSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageShareClick)];
    [_imageShare addGestureRecognizer:imageShareSingleTap];
    return _imageShare;
}


@end
