//
//  BEDailyDetailViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/18.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreData/CoreData.h>

#import "BEDailyDetailViewController.h"
#import "MJRefresh.h"
#import "LoveModel.h"
#import "BEDailyModel.h"
#import "BEDailyDetailModel.h"
#import "BEDiscussModel.h"
#import "BEDailyCommentCell.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "DailyDetailModel.h"

@interface BEDailyDetailViewController() <AVAudioPlayerDelegate, MBProgressHUDDelegate> {
    
    NSDictionary *dictionaryMonth;
    BEDailyDetailModel *dailyModel;
    
    NSMutableArray *commentArray;
    
    NSInteger pageIndex;//评论页数索引
    NSInteger pageSize;//评论每页条数
    
    NSString *textStyle;
    NSString *textStyleWithNoReplyName;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *labelDate;
@property (nonatomic, strong) UILabel *labelContent;
@property (nonatomic, strong) UILabel *labelNote;
@property (nonatomic, strong) UIImageView *imageLove;
@property (nonatomic, strong) UILabel * labelLoveCount;
@property (nonatomic, strong) UIImageView *imageFavour;
@property (nonatomic, strong) UIImageView *imageShare;
@property (nonatomic, strong) UIImageView *imagePlay;
@property (nonatomic, strong) UIImageView *imageDivideLine;
@property (nonatomic, strong) UILabel *labelTranslation;
@property (nonatomic, strong) UIImageView *imageError;
@property (nonatomic, strong) UIImageView *imageLoading;

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, strong) NSArray *soundImageArray;

@end

@implementation BEDailyDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dictionaryMonth = @{ @"01": @"January", @"02": @"February", @"03": @"March", @"04": @"April", @"05": @"May", @"06": @"June", @"07": @"July", @"08": @"August", @"09": @"September", @"10": @"October", @"11": @"November", @"12": @"December" };
        commentArray = [NSMutableArray array];
        pageIndex = 0;
        pageSize = 10;
        
        textStyle = @"<p><font color=#93B4DA>%@</font> <font color=#333333>回复: %@</font></p>";
        textStyleWithNoReplyName = @"<p><font color=#93B4DA>%@</font> <font color=#333333>回复</font> <font color=#93B4DA>%@</font><font color=#333333>: %@</font></p>";
        
        self.soundImageArray = [NSArray arrayWithObjects:
                                (id)[[UIImage imageNamed:@"icon_sound3"]imageWithTintColor:[UIColor BEHighLightFontColor]].CGImage,
                                (id)[[UIImage imageNamed:@"icon_sound2"] imageWithTintColor:[UIColor BEHighLightFontColor]].CGImage,
                                (id)[[UIImage imageNamed:@"icon_sound1"] imageWithTintColor:[UIColor BEHighLightFontColor]].CGImage, nil];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureHeaderView];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    if (self.imageError.hidden == NO) {
//        [self networkRequest];
//    }
//}

- (void)setDailyModel:(BEDailyDetailModel *)model {
    dailyModel = model;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.picture2]
                      placeholderImage:nil
                               options:SDWebImageRetryFailed];
    
    NSArray * array = [self.date componentsSeparatedByString:@"-"];
    NSString *stringDay = [array objectAtIndex:2];
    NSString *stringMonth = [dictionaryMonth valueForKey:[array objectAtIndex:1]];
    self.labelDate.text = [[stringDay stringByAppendingString:@" "] stringByAppendingString:stringMonth];
    self.labelContent.text = model.content;
    self.labelNote.text = model.note;
    self.labelTranslation.text = model.translation;
    self.labelLoveCount.text = model.love;
    
    if ([[CacheManager manager].arrayFavour containsObject:self.date]) {
        self.imageFavour.image = [[UIImage imageNamed:@"icon_favour_highlight"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    } else {
        self.imageFavour.image = [[UIImage imageNamed:@"icon_favour"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    }
    if ([[CacheManager manager].arrayLove containsObject:self.date]) {
        self.imageLove.image = [[UIImage imageNamed:@"icon_love_highlight"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    } else {
        self.imageLove.image = [[UIImage imageNamed:@"icon_love"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    }
    
    //更新布局
    [self layoutFrame];
    [self.tableView.header endRefreshing];
    //滑动到顶部
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    self.imageLoading.hidden = YES;
    self.imageError.hidden = YES;
    self.tableView.hidden = NO;
    //加栽评论
    pageIndex = 0;
    [self.tableView.footer beginRefreshing];
}

- (void)loadData:(NSString *)date {
    if (![self.date isEqual:date]) {
        self.date = date;
        [commentArray removeAllObjects];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        NSObject *object = [[CacheManager manager].arrayData objectForKey:date];
        if (object == nil) {
            self.imageLoading.hidden = NO;
            self.imageError.hidden = YES;
            self.tableView.hidden = YES;
            [self networkRequest];
        } else {
            BEDailyDetailModel *model = (BEDailyDetailModel*)object;
            self.dailyModel = model;
        }
    }
}

- (void)loadFavourModelData:(DailyDetailModel *)favour {
    self.date = favour.date;
    
    BEDailyDetailModel *model = [[BEDailyDetailModel alloc] init];
    model.title = favour.title;
    model.content = favour.content;
    model.note = favour.note;
    model.translation = favour.translation;
    model.picture2 = favour.picture2;
    model.love = favour.love;
    model.tts = favour.tts;
    model.url = favour.url;
    model.sid = favour.sid;
    self.dailyModel = model;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    BEDailyCommentCell *cell = (BEDailyCommentCell *)[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BEDailyCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    BEDiscussDetailModel *discussDetailModel = (BEDiscussDetailModel *)commentArray[indexPath.row];
    if ([discussDetailModel.reply_name isEqualToString:@""]) {
        cell.rtLabel.text = [NSString stringWithFormat:textStyle, discussDetailModel.user_name, discussDetailModel.restext];
    } else {
        cell.rtLabel.text = [NSString stringWithFormat:textStyleWithNoReplyName, discussDetailModel.user_name, discussDetailModel.reply_name, discussDetailModel.restext];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RTLabel *rtLabel = [BEDailyCommentCell textLabel];
    BEDiscussDetailModel *discussDetailModel = (BEDiscussDetailModel *)commentArray[indexPath.row];
    if ([discussDetailModel.reply_name isEqualToString:@""]) {
        rtLabel.text = [NSString stringWithFormat:textStyle, discussDetailModel.user_name, discussDetailModel.restext];
    } else {
        rtLabel.text = [NSString stringWithFormat:textStyleWithNoReplyName, discussDetailModel.user_name, discussDetailModel.reply_name, discussDetailModel.restext];
    }
    CGSize optimumSize = [rtLabel optimumSize];
    
    return optimumSize.height + 10;
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag{
    //播放结束时执行的动作
    [self.imagePlay.layer removeAllAnimations];
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
    hud.delegate = nil;
    hud = nil;
}

#pragma mark - Private Methods

- (void)configureHeaderView {
    [self.headerView addSubview:self.imageView];
    [self.headerView addSubview:self.labelDate];
    [self.headerView addSubview:self.labelContent];
    [self.headerView addSubview:self.labelNote];
    [self.headerView addSubview:self.imageLove];
    [self.headerView addSubview:self.labelLoveCount];
    [self.headerView addSubview:self.imageFavour];
    [self.headerView addSubview:self.imageShare];
    [self.headerView addSubview:self.imagePlay];
    [self.headerView addSubview:self.imageDivideLine];
    [self.headerView addSubview:self.labelTranslation];
    [self.view addSubview:self.imageError];
    [self.view addSubview:self.imageLoading];
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)layoutFrame {
    
    CGFloat height                 = 0;
    CGFloat imageHeight            = ScreenWidth / 1.615;
    
    self.imageView.frame           = CGRectMake(0, 0, ScreenWidth, imageHeight);
    
    height                         = imageHeight + 10;
    CGSize labelDateSize           = [self calculateLabelHeight:self.labelDate.text FontSize:20];
    self.labelDate.frame           = CGRectMake(10, height, ScreenWidth - 20, labelDateSize.height);
    
    height                         = height + labelDateSize.height + 10;
    CGSize labelContentSize        = [self calculateLabelHeight:self.labelContent.text FontSize:16];
    self.labelContent.frame        = CGRectMake(10, height, ScreenWidth - 20, labelContentSize.height);
    
    height                         = height + labelContentSize.height + 10;
    CGSize labelNoteSize           = [self calculateLabelHeight:self.labelNote.text FontSize:16];
    self.labelNote.frame           = CGRectMake(10, height, ScreenWidth - 20, labelNoteSize.height);
    
    height                         = height + self.labelNote.height + 15;
    self.imageLove.frame           = CGRectMake(10, height, 30, 30);
    self.labelLoveCount.frame      = CGRectMake(45, height, 70, 30);
    self.imageFavour.frame         = CGRectMake(((ScreenWidth - 140) / 3) + 40, height, 30, 30);
    self.imageShare.frame          = CGRectMake(((ScreenWidth - 140) / 3) * 2 + 70, height, 30, 30);
    self.imagePlay.frame           = CGRectMake(ScreenWidth - 40, height, 30, 30);
    
    self.imageDivideLine.frame     = CGRectMake(10, height + 50, ScreenWidth - 20, 0.5);
    
    height                         = height + 60;
    CGSize labelTranslationSize    = [self calculateLabelHeight:self.labelTranslation.text FontSize:14];
    self.labelTranslation.frame    = CGRectMake(15, height, ScreenWidth - 30, labelTranslationSize.height);
    
    height                         = height + self.labelTranslation.height + 10;
    self.headerView.frame          = CGRectMake(0, 0, ScreenWidth, height);
    
    UIView *view                   = self.tableView.tableHeaderView;
    view.frame                     = self.headerView.frame;
    self.tableView.tableHeaderView = view;
    
    [self.tableView reloadData];
}

- (void)networkRequest {
    [commentArray removeAllObjects];
    [self.tableView reloadData];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyDetailModel" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    request.predicate = [NSPredicate predicateWithFormat:@"date == %@", self.date];
    NSArray *dailyDetailResults = [[self.managedObjectContext executeFetchRequest:request error:nil] copy];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:GetSentence(self.date) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //json转换model
        BEDailyModel *model = [BEDailyModel jsonToObject:operation.responseString];
        BEDailyDetailModel *detailModel = (BEDailyDetailModel *)model.message;
        self.dailyModel = detailModel;
        //加入缓存字典
        [[CacheManager manager].arrayData setObject:detailModel forKey:self.date];
        
        if ([dailyDetailResults count] == 1) {
            //更新点赞数
            DailyDetailModel *dailyDetailModel = (DailyDetailModel *)[dailyDetailResults objectAtIndex:0];
            dailyDetailModel.love = detailModel.love;
            if (![self.managedObjectContext save:nil]) {
                NSLog(@"error!");
            } else {
                NSLog(@"update ok.");
            }
        } else {
            //加入数据库
            DailyDetailModel *dailyDetailModel=(DailyDetailModel *)[NSEntityDescription insertNewObjectForEntityForName:@"DailyDetailModel" inManagedObjectContext:self.managedObjectContext];
            dailyDetailModel.date = self.date;
            dailyDetailModel.title = detailModel.title;
            dailyDetailModel.dateline = detailModel.dateline;
            dailyDetailModel.content = detailModel.content;
            dailyDetailModel.note = detailModel.note;
            dailyDetailModel.translation = detailModel.translation;
            dailyDetailModel.picture2 = detailModel.picture2;
            dailyDetailModel.love = detailModel.love;
            dailyDetailModel.tts = detailModel.tts;
            dailyDetailModel.ttsSize = detailModel.ttsSize;
            dailyDetailModel.sid = detailModel.sid;
            dailyDetailModel.ttsMd5 = detailModel.ttsMd5;
            dailyDetailModel.url = detailModel.url;
            if (![self.managedObjectContext save:nil]) {
                NSLog(@"error!");
            } else {
                NSLog(@"save ok.");
            }
        }
        
        [self.tableView.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //从数据库读
        if ([dailyDetailResults count] == 1) {
            DailyDetailModel *dailyDetailModel = (DailyDetailModel *)[dailyDetailResults objectAtIndex:0];
            BEDailyDetailModel *detailModel = [[BEDailyDetailModel alloc] init];
            detailModel.title = dailyDetailModel.title;
            detailModel.dateline = dailyDetailModel.dateline;
            detailModel.content = dailyDetailModel.content;
            detailModel.note = dailyDetailModel.note;
            detailModel.translation = dailyDetailModel.translation;
            detailModel.picture2 = dailyDetailModel.picture2;
            detailModel.love = dailyDetailModel.love;
            detailModel.tts = dailyDetailModel.tts;
            detailModel.ttsSize = dailyDetailModel.ttsSize;
            detailModel.sid = dailyDetailModel.sid;
            detailModel.ttsMd5 = dailyDetailModel.ttsMd5;
            detailModel.url = dailyDetailModel.url;
            self.dailyModel = detailModel;
        } else {
            self.imageLoading.hidden = YES;
            self.imageError.hidden = NO;
            self.tableView.hidden = YES;
        }
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadCommentData {
    [[AFHTTPRequestOperationManager manager] GET:GetDiscussList(dailyModel.sid, (int)++pageIndex, (int)pageSize) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BEDiscussModel *discussModel = [BEDiscussModel jsonToObject:operation.responseString];
        BEDiscussMessageModel *discussMessageModel = (BEDiscussMessageModel *)discussModel.message;
        NSArray *array = [BEDiscussDetailModel objectArrayWithKeyValuesArray:discussMessageModel.data];
        for (BEDiscussDetailModel *discussDetailModel in array) {
            [commentArray addObject: discussDetailModel];
        }
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        //        [_tableView.footer setTitle:@"点击或上拉加载更多评论！" forState:MJRefreshFooterStateIdle];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [_tableView.footer setTitle:@"没有网络连接哦！" forState:MJRefreshFooterStateIdle];
        [self.tableView.footer endRefreshing];
    }];
}

- (void)showText:(NSString *)text {
    
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //    hud.mode = MBProgressHUDModeText;
    //    hud.labelText = text;
    //    hud.margin = 10.f;
    //    hud.removeFromSuperViewOnHide = YES;
    //    hud.delegate = self;
    //    [hud hide:YES afterDelay:1.5];
}

//计算Label高度
- (CGSize)calculateLabelHeight:(NSString *)value FontSize:(CGFloat) font {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(ScreenWidth - 20, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size;
}

#pragma mark - Event Response

//点赞
- (void) onImageLoveClick {
    if ([[CacheManager manager].arrayLove containsObject:self.date]) {
        
    } else {
        dailyModel.love =  [NSString stringWithFormat:@"%d", [dailyModel.love intValue] + 1];
        self.labelLoveCount.text = dailyModel.love;
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values =  [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:1.0],
                             [NSNumber numberWithDouble:1.4],
                             [NSNumber numberWithDouble:0.9],
                             [NSNumber numberWithDouble:1.0],nil];
        animation.duration = 0.5f;
        animation.calculationMode = kCAAnimationCubic;
        [self.imageLove.layer addAnimation:animation forKey:@"bounceAnimation"];
        
        self.imageLove.image = [[UIImage imageNamed:@"icon_love_highlight"] imageWithTintColor:[UIColor BEHighLightFontColor]];
        //加入缓存
        [[CacheManager manager].arrayLove addObject:self.date];
        //添加到数据库
        LoveModel *model=(LoveModel *)[NSEntityDescription insertNewObjectForEntityForName:@"LoveModel" inManagedObjectContext:self.managedObjectContext];
        model.date = self.date;
        if (![self.managedObjectContext save:nil]) {
            NSLog(@"error!");
        } else {
            NSLog(@"save ok.");
        }
        //Get
        [[AFHTTPRequestOperationManager manager] GET:SetPraise(dailyModel.sid) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"love ok.");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error!");
        }];
    }
}

//收藏
- (void) onImageFavourClick {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"DailyDetailModel" inManagedObjectContext:self.managedObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"date==%@", self.date]];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if ([[CacheManager manager].arrayFavour containsObject:self.date]) {
        self.imageFavour.image = [[UIImage imageNamed:@"icon_favour"] imageWithTintColor:[UIColor BEHighLightFontColor]];
        //移除缓存
        [[CacheManager manager].arrayFavour removeObject:self.date];
        //数据库更新
        if ([results count] > 0) {
            DailyDetailModel *dailyDetailModel = [results objectAtIndex:0];
            dailyDetailModel.boolLove = [NSNumber numberWithBool:NO];
            if (![self.managedObjectContext save:nil]) {
                NSLog(@"error!");
            } else {
                NSLog(@"updateLoveNO ok.");
            }
        }
    } else {
        self.imageFavour.image = [[UIImage imageNamed:@"icon_favour_highlight"] imageWithTintColor:[UIColor BEHighLightFontColor]];
        //动画
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values =  [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:1.0],
                             [NSNumber numberWithDouble:1.4],
                             [NSNumber numberWithDouble:0.9],
                             [NSNumber numberWithDouble:1.15],
                             [NSNumber numberWithDouble:1.0],nil];
        animation.duration = 0.5f;
        animation.calculationMode = kCAAnimationCubic;
        [self.imageFavour.layer addAnimation:animation forKey:@"bounceAnimation"];
        
        //加入缓存
        [[CacheManager manager].arrayFavour addObject:self.date];
        //添加到数据库
        if ([results count] > 0) {
            DailyDetailModel *dailyDetailModel = [results objectAtIndex:0];
            dailyDetailModel.boolLove = [NSNumber numberWithBool:YES];
            if (![self.managedObjectContext save:nil]) {
                NSLog(@"error!");
            } else {
                NSLog(@"updateLoveYES ok.");
            }
        }
    }
}

//分享
- (void) onImageShareClick {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"分享还没实现T_T";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.delegate = self;
    [hud hide:YES afterDelay:1.5];
}

//播放mp3
- (void) onImagePlayClick {
    [self.imagePlay.layer removeAllAnimations];

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.calculationMode = kCAAnimationDiscrete;
    animation.duration = 1;
    animation.values = self.soundImageArray;
    animation.repeatCount = HUGE_VALF;
    [self.imagePlay.layer addAnimation:animation forKey:@"frameAnimation"];

    NSURL *url = [[NSURL alloc]initWithString:dailyModel.tts];
    NSData * audioData = [NSData dataWithContentsOfURL:url];
    //将数据保存到本地指定位置
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath , self.date];
    [audioData writeToFile:filePath atomically:YES];
    //播放本地音乐
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    if (self.player == nil) {
        [self.imagePlay.layer removeAllAnimations];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"播放错误～";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        hud.delegate = self;
        [hud hide:YES afterDelay:1.5];
    } else {
        self.player.delegate = self;
        [self.player play];
    }
}

#pragma mark - Getters and Setters

- (UITableView *)tableView {
    if (_tableView != nil) {
        return _tableView;
    }
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.hidden = YES;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    //下拉刷新
    @weakify(self);
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self);
        [self networkRequest];
    }];
    //上拉加载评论
    [_tableView addLegendFooterWithRefreshingBlock:^{
        @strongify(self);
        [self loadCommentData];
    }];
    _tableView.footer.automaticallyRefresh = NO;
    _tableView.footer.textColor = [UIColor BEDeepFontColor];
    [_tableView.footer setTitle:@"点击或上拉加载更多评论！" forState:MJRefreshFooterStateIdle];
    [_tableView.footer setTitle:@"正在加载中 ..." forState:MJRefreshFooterStateRefreshing];
    [_tableView.footer setTitle:@"No more data" forState:MJRefreshFooterStateNoMoreData];
    
    return _tableView;
}

- (UIView *)headerView {
    if (_headerView != nil) {
        return _headerView;
    }
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    return _headerView;
}

- (UIImageView *)imageView {
    if (_imageView != nil) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return _imageView;
}

- (UILabel *)labelDate {
    if (_labelDate != nil) {
        return _labelDate;
    }
    _labelDate = [[UILabel alloc] init];
    _labelDate.textAlignment = NSTextAlignmentLeft;
    _labelDate.textColor = [UIColor BEHighLightFontColor];
    _labelDate.font = [UIFont boldSystemFontOfSize:20];
    
    return _labelDate;
}

- (UILabel *)labelContent {
    if (_labelContent != nil) {
        return _labelContent;
    }
    _labelContent = [[UILabel alloc] init];
    _labelContent.textAlignment = NSTextAlignmentLeft;
    _labelContent.textColor = [UIColor BEFontColor];
    _labelContent.font = [UIFont systemFontOfSize:16];
    _labelContent.numberOfLines = 0;
    
    return _labelContent;
}

- (UILabel *)labelNote {
    if (_labelNote != nil) {
        return _labelNote;
    }
    _labelNote = [[UILabel alloc] init];
    _labelNote.textAlignment = NSTextAlignmentLeft;
    _labelNote.textColor = [UIColor BEDeepFontColor];
    _labelNote.font = [UIFont systemFontOfSize:16];
    _labelNote.numberOfLines = 0;
    
    return _labelNote;
}

- (UIImageView *)imageLove {
    if (_imageLove != nil) {
        return _imageLove;
    }
    _imageLove  = [[UIImageView alloc] init];
    _imageLove.image = [[UIImage imageNamed:@"icon_love"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    _imageLove.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageLoveSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageLoveClick)];
    [_imageLove addGestureRecognizer:imageLoveSingleTap];
    
    return _imageLove;
}

- (UILabel *)labelLoveCount {
    if (_labelLoveCount != nil) {
        return _labelLoveCount;
    }
    _labelLoveCount = [[UILabel alloc] init];
    _labelLoveCount.textAlignment = NSTextAlignmentLeft;
    _labelLoveCount.textColor = [UIColor BEHighLightFontColor];
    _labelLoveCount.font = [UIFont systemFontOfSize:14];
    _labelLoveCount.numberOfLines = 0;
    
    return _labelLoveCount;
}

- (UIImageView *)imageFavour {
    if (_imageFavour != nil) {
        return _imageFavour;
    }
    _imageFavour = [[UIImageView alloc] init];
    _imageFavour.image = [[UIImage imageNamed:@"icon_favour"] imageWithTintColor:[UIColor BEHighLightFontColor]];
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
    _imageShare.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageShareSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageShareClick)];
    [_imageShare addGestureRecognizer:imageShareSingleTap];
    
    return _imageShare;
}

- (UIImageView *)imagePlay {
    if (_imagePlay != nil) {
        return _imagePlay;
    }
    _imagePlay = [[UIImageView alloc] init];
    _imagePlay.image = [[UIImage imageNamed:@"icon_sound1"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    _imagePlay.userInteractionEnabled = YES;
    UITapGestureRecognizer *imagePlaySingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImagePlayClick)];
    [_imagePlay addGestureRecognizer:imagePlaySingleTap];
    
    return _imagePlay;
}

- (UIImageView *)imageDivideLine {
    if (_imageDivideLine != nil) {
        return _imageDivideLine;
    }
    _imageDivideLine = [[UIImageView alloc] init];
    _imageDivideLine.backgroundColor = [UIColor BEHighLightFontColor];
    _imageDivideLine.contentMode = UIViewContentModeScaleAspectFill;
    _imageDivideLine.image = [UIImage imageNamed:@"section_divide"];
    _imageDivideLine.clipsToBounds = YES;
    
    return _imageDivideLine;
}

- (UILabel *)labelTranslation {
    if (_labelTranslation != nil) {
        return _labelTranslation;
    }
    _labelTranslation = [[UILabel alloc] init];
    _labelTranslation.textAlignment = NSTextAlignmentLeft;
    _labelTranslation.textColor = [UIColor BEFontColor];
    _labelTranslation.font = [UIFont systemFontOfSize:14];
    _labelTranslation.numberOfLines = 0;
    
    return _labelTranslation;
}

- (UIImageView *)imageError {
    if (_imageError != nil) {
        return _imageError;
    }
    _imageError = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _imageError.hidden = YES;
    _imageError.image = [UIImage imageNamed:@"image_error"];
    _imageError.backgroundColor = [UIColor whiteColor];
    _imageError.contentMode = UIViewContentModeScaleAspectFit;
    
    return _imageError;
}

- (UIImageView *)imageLoading {
    if (_imageLoading != nil) {
        return _imageLoading;
    }
    _imageLoading = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _imageLoading.hidden = NO;
//    _imageLoading.image = [UIImage imageNamed:@"image_loading"];
    _imageLoading.backgroundColor = [UIColor whiteColor];
    _imageLoading.contentMode = UIViewContentModeScaleAspectFit;
    
    return _imageLoading;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    id delegate = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = [delegate managedObjectContext];
    
    return _managedObjectContext;
}


@end
