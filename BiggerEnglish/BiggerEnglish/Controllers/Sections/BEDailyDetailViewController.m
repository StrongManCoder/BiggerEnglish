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
#import "FavourModel.h"
#import "LoveModel.h"
#import "BEDailyModel.h"
#import "BEDailyDetailModel.h"
#import "BEDiscussModel.h"
#import "BEDailyCommentCell.h"

@interface BEDailyDetailViewController() {
    
    NSDictionary *dictionaryMonth;
    BEDailyDetailModel *dailyModel;
    
    AVAudioPlayer *player;
    
    NSMutableArray *commentArray;
    
    NSInteger pageIndex;//评论页数索引
    NSInteger pageSize;//评论每页条数
    
    NSString *textStyle;
    NSString *textStyleWithNoReplyName;
}

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
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self configureHeaderView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setDailyModel:(BEDailyDetailModel *)model {
    dailyModel = model;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.picture2]
                 placeholderImage:nil];
    
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
    self.date = date;
    [commentArray removeAllObjects];
    [self.tableView reloadData];
    [self.tableView.header endRefreshing];
    NSObject *object = [[CacheManager manager].arrayData objectForKey:date];
    if (object == nil) {
        self.imageLoading.hidden = NO;
        [self networkRequest];
    } else {
        BEDailyDetailModel *model = (BEDailyDetailModel*)object;
        self.dailyModel = model;
    }
}

- (void)loadFavourModelData:(FavourModel *)favour {
    self.date = favour.title;

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

#pragma mark - Private Method

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
    [self.tableView beginUpdates];
    self.tableView.tableHeaderView = view;
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

- (void)loadCommentData {
    [[AFHTTPRequestOperationManager manager] GET:DailyWordCommentUrl(dailyModel.sid, (int)++pageIndex, (int)pageSize) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BEDiscussModel *discussModel = [BEDiscussModel jsonToObject:operation.responseString];
        BEDiscussMessageModel *discussMessageModel = (BEDiscussMessageModel *)discussModel.message;
        NSArray *array = [BEDiscussDetailModel objectArrayWithKeyValuesArray:discussMessageModel.data];
        for (BEDiscussDetailModel *discussDetailModel in array) {
            [commentArray addObject: discussDetailModel];
        }
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"loadCommentData Error: %@", error);
        [self.tableView.footer endRefreshing];
    }];
}

- (void)reloadData {
    
}

- (void)networkRequest {
    [commentArray removeAllObjects];
    [self.tableView reloadData];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:DailyWordUrl(self.date) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //json转换model
        BEDailyModel *model = [BEDailyModel jsonToObject:operation.responseString];
        BEDailyDetailModel *detailModel = (BEDailyDetailModel *)model.message;
        self.dailyModel = detailModel;
        //加入缓存字典
        [[CacheManager manager].arrayData setObject:detailModel forKey:self.date];
        [self.tableView.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.imageLoading.hidden = YES;
        self.imageError.hidden = NO;
        [self.tableView.header endRefreshing];
    }];
}

//点赞
- (void) onImageLoveClick {
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    if ([[CacheManager manager].arrayLove containsObject:self.date]) {
        
    } else {
        dailyModel.love =  [NSString stringWithFormat:@"%d", [dailyModel.love intValue] + 1];
        self.labelLoveCount.text = dailyModel.love;
        
        self.imageLove.image = [[UIImage imageNamed:@"icon_love_highlight"] imageWithTintColor:[UIColor BEHighLightFontColor]];
        //加入缓存
        [[CacheManager manager].arrayLove addObject:self.date];
        //添加到数据库
        LoveModel *model=(LoveModel *)[NSEntityDescription insertNewObjectForEntityForName:@"LoveModel" inManagedObjectContext:managedObjectContext];
        model.date = self.date;
        if (![managedObjectContext save:nil]) {
            NSLog(@"error!");
        } else {
            NSLog(@"save ok.");
        }
        //Get
        [[AFHTTPRequestOperationManager manager] GET:DailyWordLoveUrl(dailyModel.sid) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"love ok.");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error!");
        }];
    }
}

//收藏
- (void) onImageFavourClick {
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    
    if ([[CacheManager manager].arrayFavour containsObject:self.date]) {
        self.imageFavour.image = [[UIImage imageNamed:@"icon_favour"] imageWithTintColor:[UIColor BEHighLightFontColor]];
        //移除缓存
        [[CacheManager manager].arrayFavour removeObject:self.date];
        //数据库删除
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"FavourModel" inManagedObjectContext:managedObjectContext]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title==%@", self.date]];
        NSArray* results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
        if ([results count] > 0) {
            [managedObjectContext deleteObject:[results objectAtIndex:0]];
            if (![managedObjectContext save:nil]) {
                NSLog(@"error!");
            } else {
                NSLog(@"deleteObject ok.");
            }
        }
    } else {
        self.imageFavour.image = [[UIImage imageNamed:@"icon_favour_highlight"] imageWithTintColor:[UIColor BEHighLightFontColor]];
        //加入缓存
        [[CacheManager manager].arrayFavour addObject:self.date];
        //添加到数据库
        FavourModel *model = (FavourModel *)[NSEntityDescription insertNewObjectForEntityForName:@"FavourModel" inManagedObjectContext:managedObjectContext];
        model.title = self.date;
        model.sid = dailyModel.sid;
        model.tts = dailyModel.tts;
        model.content = dailyModel.content;
        model.note = dailyModel.note;
        model.love = dailyModel.love;
        model.translation = dailyModel.translation;
        model.picture2 = dailyModel.picture2;
        model.url = dailyModel.url;
        if (![managedObjectContext save:nil]) {
            NSLog(@"error!");
        } else {
            NSLog(@"save ok.");
        }
    }
}

//分享
- (void) onImageShareClick {
    
}

//播放mp3
- (void) onImagePlayClick {
    NSString *urlStr = dailyModel.tts;
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    NSData * audioData = [NSData dataWithContentsOfURL:url];
    //将数据保存到本地指定位置
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath , @"temp"];
    [audioData writeToFile:filePath atomically:YES];
    //播放本地音乐
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    [player play];
}

//计算Label高度
- (CGSize)calculateLabelHeight:(NSString *)value FontSize:(CGFloat) font {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(ScreenWidth - 20, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size;
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

#pragma mark - Getter

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
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadCommentData)];
    _tableView.footer.automaticallyRefresh = NO;
    _tableView.footer.textColor = [UIColor BEDeepFontColor];
    [_tableView.footer setTitle:@"点击或上拉载更多评论！" forState:MJRefreshFooterStateIdle];
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
    _imagePlay.image = [[UIImage imageNamed:@"icon_sound2"] imageWithTintColor:[UIColor BEHighLightFontColor]];
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
    //_imageError.image = [UIImage imageNamed:@"action_favorite"];
    _imageError.backgroundColor = [UIColor blackColor];
    _imageError.contentMode = UIViewContentModeScaleAspectFit;
    return _imageError;
}

- (UIImageView *)imageLoading {
    if (_imageLoading != nil) {
        return _imageLoading;
    }
    
    _imageLoading = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _imageLoading.hidden = NO;
    //_imageLoading.image = [UIImage imageNamed:@"action_favorite"];
    _imageLoading.backgroundColor = [UIColor whiteColor];
    _imageLoading.contentMode = UIViewContentModeScaleAspectFit;
    return _imageLoading;
}


@end
