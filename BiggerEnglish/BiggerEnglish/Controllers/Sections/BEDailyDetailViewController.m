//
//  BEDailyDetailViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/18.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEDailyDetailViewController.h"
#import <SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface BEDailyDetailViewController() {
    
    BEDailyModel *dailyModel;

    UIView *headerView;
    UIImageView *imageView;
    UILabel *labelDate;
    UILabel *labelContent;
    UILabel *labelNote;
    UILabel *labelTranslation;

}
@end

@implementation BEDailyDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self configureHeaderView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self layoutFrame];
}

- (void)layoutFrame {
    
    CGFloat height = 0;
    CGFloat imageHeight            = ScreenWidth / 1.615;
    
    imageView.frame                = CGRectMake(0, 0, ScreenWidth, imageHeight);
    
    height = imageHeight + 10;
    CGSize labelDateSize           = [self CalculateLabelHeight:labelDate.text FontSize:16];
    labelDate.frame                = CGRectMake(10, height, ScreenWidth - 20, labelDateSize.height);
    
    height = height + labelDateSize.height + 10;
    CGSize labelContentSize        = [self CalculateLabelHeight:labelContent.text FontSize:16];
    labelContent.frame             = CGRectMake(10, height, ScreenWidth - 20, labelContentSize.height);
    
    height = height + labelContentSize.height + 10;
    CGSize labelNoteSize           = [self CalculateLabelHeight:labelNote.text FontSize:16];
    labelNote.frame                = CGRectMake(10, height, ScreenWidth - 20, labelNoteSize.height);
    
    height = height + labelNoteSize.height + 10;
    CGSize labelTranslationSize    = [self CalculateLabelHeight:labelTranslation.text FontSize:14];
    labelTranslation.frame         = CGRectMake(10, height, ScreenWidth - 20, labelTranslationSize.height);

    height = height + labelTranslationSize.height + 10;
    headerView.frame               = CGRectMake(0, 0, ScreenWidth, height);

    UIView *view                   = self.tableView.tableHeaderView;
    view.frame                     = headerView.frame;
    [self.tableView beginUpdates];
    self.tableView.tableHeaderView =view;
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

- (CGSize)CalculateLabelHeight:(NSString *)value FontSize:(CGFloat) font {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(ScreenWidth - 20, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

    return size;
}

- (void)setDailyModel:(BEDailyModel *)model {
    dailyModel = model;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.picture2]
                 placeholderImage:nil];
    labelDate.text = self.date;
    labelContent.text = model.content;
    labelNote.text = model.note;
    labelTranslation.text = model.translation;
    
    [self layoutFrame];
}

- (void)configureHeaderView {
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    headerView = [[UIView alloc] initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor BEFrenchGrayColor];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    labelDate = [[UILabel alloc] initWithFrame:CGRectZero];
    labelDate.textAlignment = NSTextAlignmentLeft;
    labelDate.tintColor = [UIColor BEDeepFontColor];
    labelDate.font            = [UIFont systemFontOfSize:16];

    labelContent = [[UILabel alloc] initWithFrame:CGRectZero];
    labelContent.textAlignment = NSTextAlignmentLeft;
    labelContent.tintColor = [UIColor BEDeepFontColor];
    labelContent.font            = [UIFont systemFontOfSize:16];
    labelContent.numberOfLines   = 0;
    
    labelNote = [[UILabel alloc] initWithFrame:CGRectZero];
    labelNote.textAlignment = NSTextAlignmentLeft;
    labelNote.tintColor = [UIColor BEDeepFontColor];
    labelNote.font            = [UIFont systemFontOfSize:16];
    labelNote.numberOfLines   = 0;
    
    labelTranslation = [[UILabel alloc] initWithFrame:CGRectZero];
    labelTranslation.textAlignment = NSTextAlignmentLeft;
    labelTranslation.tintColor = [UIColor BEDeepFontColor];
    labelTranslation.font            = [UIFont systemFontOfSize:14];
    labelTranslation.numberOfLines   = 0;
    
    
    [headerView addSubview:imageView];
    [headerView addSubview:labelDate];
    [headerView addSubview:labelContent];
    [headerView addSubview:labelNote];
    [headerView addSubview:labelTranslation];

    self.tableView.tableHeaderView = headerView;
}

- (void)reloadData {
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"%d",indexPath.row+1];
    return cell;
}


@end
