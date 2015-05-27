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
#import <AVFoundation/AVFoundation.h>
#import "MJRefresh.h"
#import "FavourModel.h"
#import "LoveModel.h"
#import "BEDailyModel.h"
#import "BEDailyDetailModel.h"
#import <CoreData/CoreData.h>

@interface BEDailyDetailViewController() {
    
    NSDictionary *dictionaryMonth;
    BEDailyDetailModel *dailyModel;
    
    UITableView *tableView;
    UIView *headerView;
    UIImageView *imageView;
    UILabel *labelDate;
    UILabel *labelContent;
    UILabel *labelNote;
    UILabel *labelTranslation;
    UIImageView *imageLove;
    UILabel * labelLoveCount;
    UIImageView *imageFavour;
    UIImageView *imageShare;
    UIImageView *imagePlay;
    
    UIImageView *imageError;
    UIImageView *imageLoading;
    
    AVAudioPlayer *player;
    
    NSMutableArray *commentArray;
    
    NSInteger pageIndex;//评论页数索引
    NSInteger pageSize;//评论每页条数
}

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
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self configureHeaderView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setDailyModel:(BEDailyDetailModel *)model {
    dailyModel = model;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.picture2]
                 placeholderImage:nil];
    
    NSArray * array = [self.date componentsSeparatedByString:@"-"];
    NSString *stringDay = [array objectAtIndex:2];
    NSString *stringMonth = [dictionaryMonth valueForKey:[array objectAtIndex:1]];
    labelDate.text = [[stringDay stringByAppendingString:@" "] stringByAppendingString:stringMonth];
    labelContent.text = model.content;
    labelNote.text = model.note;
    labelTranslation.text = model.translation;
    labelLoveCount.text = model.love;
    
    if ([[CacheManager manager].arrayFavour containsObject:self.date]) {
        imageFavour.image = [[UIImage imageNamed:@"icon_favour_highlight"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    } else {
        imageFavour.image = [[UIImage imageNamed:@"icon_favour"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    }
    if ([[CacheManager manager].arrayLove containsObject:self.date]) {
        imageLove.image = [[UIImage imageNamed:@"icon_love_highlight"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    } else {
        imageLove.image = [[UIImage imageNamed:@"icon_love"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    }
    
    //更新布局
    [self layoutFrame];
    [tableView.header endRefreshing];
    //滑动到顶部
    [tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    imageLoading.hidden = YES;
    imageError.hidden = YES;
    
//    [tableView.footer beginRefreshing];
//    [self loadCommentData];
}

- (void)loadData:(NSString *)date {
    self.date = date;
//    [commentArray removeAllObjects];
//    [tableView reloadData];
    [tableView.header endRefreshing];
    NSObject *object = [[CacheManager manager].arrayData objectForKey:date];
    if (object == nil) {
        imageLoading.hidden = NO;
        [self networkRequest];
    } else {
        BEDailyDetailModel *model = (BEDailyDetailModel*)object;
        self.dailyModel = model;
    }
}

#pragma mark - Private Method

- (void)configureHeaderView {
    
    tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    cell.selectionStytle = UITableViewCellSelectionStyleNone；
    tableView.dataSource = self;
    tableView.delegate = self;

    [self.view addSubview:tableView];
    //下拉刷新
    @weakify(self);
    [tableView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self);
        [self networkRequest];
    }];
    //上拉加载评论
    [tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadCommentData)];
    tableView.footer.automaticallyRefresh = NO;
    
    headerView = [[UIView alloc] initWithFrame:CGRectZero];
    headerView.backgroundColor       = [UIColor whiteColor];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    labelDate = [[UILabel alloc] initWithFrame:CGRectZero];
    labelDate.textAlignment = NSTextAlignmentLeft;
    labelDate.textColor = [UIColor BEHighLightFontColor];
    labelDate.font = [UIFont boldSystemFontOfSize:20];
    
    labelContent = [[UILabel alloc] initWithFrame:CGRectZero];
    labelContent.textAlignment = NSTextAlignmentLeft;
    labelContent.textColor = [UIColor BEFontColor];
    labelContent.font = [UIFont systemFontOfSize:16];
    labelContent.numberOfLines = 0;
    
    labelNote = [[UILabel alloc] initWithFrame:CGRectZero];
    labelNote.textAlignment = NSTextAlignmentLeft;
    labelNote.textColor = [UIColor BEDeepFontColor];
    labelNote.font = [UIFont systemFontOfSize:16];
    labelNote.numberOfLines = 0;
    
    imageLove  = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageLove.image = [[UIImage imageNamed:@"icon_love"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    imageLove.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageLoveSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageLoveClick)];
    [imageLove addGestureRecognizer:imageLoveSingleTap];
    
    labelLoveCount = [[UILabel alloc] initWithFrame:CGRectZero];
    labelLoveCount.textAlignment = NSTextAlignmentLeft;
    labelLoveCount.textColor = [UIColor BEHighLightFontColor];
    labelLoveCount.font = [UIFont systemFontOfSize:14];
    labelLoveCount.numberOfLines = 0;
    
    imageFavour = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageFavour.image = [[UIImage imageNamed:@"icon_favour"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    
    imageFavour.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageFavourSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageFavourClick)];
    [imageFavour addGestureRecognizer:imageFavourSingleTap];
    
    imageShare = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageShare.image = [[UIImage imageNamed:@"icon_share"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    imageShare.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageShareSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageShareClick)];
    [imageShare addGestureRecognizer:imageShareSingleTap];
    
    imagePlay = [[UIImageView alloc] initWithFrame:CGRectZero];
    imagePlay.image = [[UIImage imageNamed:@"icon_sound2"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    imagePlay.userInteractionEnabled = YES;
    UITapGestureRecognizer *imagePlaySingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImagePlayClick)];
    [imagePlay addGestureRecognizer:imagePlaySingleTap];
    
    labelTranslation = [[UILabel alloc] initWithFrame:CGRectZero];
    labelTranslation.textAlignment = NSTextAlignmentLeft;
    labelTranslation.textColor = [UIColor BEFontColor];
    labelTranslation.font = [UIFont systemFontOfSize:14];
    labelTranslation.numberOfLines = 0;
    
    imageError = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    imageError.hidden = YES;
    //imageError.image = [UIImage imageNamed:@"action_favorite"];
    imageError.backgroundColor = [UIColor blackColor];
    imageError.contentMode = UIViewContentModeScaleAspectFit;
    
    imageLoading = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    imageLoading.hidden = YES;
    //imageLoading.image = [UIImage imageNamed:@"action_favorite"];
    imageLoading.backgroundColor = [UIColor whiteColor];
    imageLoading.contentMode = UIViewContentModeScaleAspectFit;
    
    [headerView addSubview:imageView];
    [headerView addSubview:labelDate];
    [headerView addSubview:labelContent];
    [headerView addSubview:labelNote];
    [headerView addSubview:imageLove];
    [headerView addSubview:labelLoveCount];
    [headerView addSubview:imageFavour];
    [headerView addSubview:imageShare];
    [headerView addSubview:imagePlay];
    [headerView addSubview:labelTranslation];
    [self.view addSubview:imageError];
    [self.view addSubview:imageLoading];
    
    tableView.tableHeaderView = headerView;
}

- (void)layoutFrame {
    
    CGFloat height                 = 0;
    CGFloat imageHeight            = ScreenWidth / 1.615;
    
    imageView.frame                = CGRectMake(0, 0, ScreenWidth, imageHeight);
    
    height                         = imageHeight + 10;
    CGSize labelDateSize           = [self calculateLabelHeight:labelDate.text FontSize:20];
    labelDate.frame                = CGRectMake(10, height, ScreenWidth - 20, labelDateSize.height);
    
    height                         = height + labelDateSize.height + 10;
    CGSize labelContentSize        = [self calculateLabelHeight:labelContent.text FontSize:16];
    labelContent.frame             = CGRectMake(10, height, ScreenWidth - 20, labelContentSize.height);
    
    height                         = height + labelContentSize.height + 10;
    CGSize labelNoteSize           = [self calculateLabelHeight:labelNote.text FontSize:16];
    labelNote.frame                = CGRectMake(10, height, ScreenWidth - 20, labelNoteSize.height);
    
    height                         = height + labelNote.height + 15;
    imageLove.frame                = CGRectMake(10, height, 30, 30);
    labelLoveCount.frame           = CGRectMake(45, height, 70, 30);
    imageFavour.frame              = CGRectMake(((ScreenWidth - 140) / 3) + 40, height, 30, 30);
    imageShare.frame               = CGRectMake(((ScreenWidth - 140) / 3) * 2 + 70, height, 30, 30);
    imagePlay.frame                = CGRectMake(ScreenWidth - 40, height, 30, 30);
    
    height                         = height + 45;
    CGSize labelTranslationSize    = [self calculateLabelHeight:labelTranslation.text FontSize:14];
    labelTranslation.frame         = CGRectMake(10, height, ScreenWidth - 20, labelTranslationSize.height);
    
    height                         = height + labelTranslation.height + 10;
    headerView.frame               = CGRectMake(0, 0, ScreenWidth, height);
    
    UIView *view                   = tableView.tableHeaderView;
    view.frame                     = headerView.frame;
    [tableView beginUpdates];
    tableView.tableHeaderView = view;
    [tableView endUpdates];
    [tableView reloadData];
}

- (void)loadCommentData {
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        [commentArray addObject: [NSString stringWithFormat:@"%d", i]];
    }
    
    [[AFHTTPRequestOperationManager manager] GET:@"http://dict-mobile.iciba.com/interface/index.php?client=4&type=1&timestamp=1432540461&c=discuss&m=getlist&sign=6829bd45117bde5e&field=1,3,4,5&wid=1300&page=3&size=10&zid=14" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [tableView reloadData];
        [tableView.footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"loadCommentData Error: %@", error);
    }];
}

- (void)reloadData {
    
}

- (void)networkRequest {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DailyWordUrl stringByAppendingString:self.date] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //json转换model
        BEDailyModel *model = [BEDailyModel jsonToObject:operation.responseString];
        BEDailyDetailModel *detailModel = (BEDailyDetailModel *)model.message;
        self.dailyModel = detailModel;
        //加入缓存字典
        [[CacheManager manager].arrayData setObject:detailModel forKey:self.date];
        [tableView.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        imageLoading.hidden = YES;
        imageError.hidden = NO;
        [tableView.header endRefreshing];
    }];
}

//点赞
- (void) onImageLoveClick {
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    if ([[CacheManager manager].arrayLove containsObject:self.date]) {
        
    } else {
        dailyModel.love =  [NSString stringWithFormat:@"%d", [dailyModel.love intValue] + 1];
        labelLoveCount.text = dailyModel.love;
        
        imageLove.image = [[UIImage imageNamed:@"icon_love_highlight"] imageWithTintColor:[UIColor BEHighLightFontColor]];
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
        [[AFHTTPRequestOperationManager manager] GET:[DailyWordLoveUrl stringByAppendingString:dailyModel.sid] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        imageFavour.image = [[UIImage imageNamed:@"icon_favour"] imageWithTintColor:[UIColor BEHighLightFontColor]];
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
        imageFavour.image = [[UIImage imageNamed:@"icon_favour_highlight"] imageWithTintColor:[UIColor BEHighLightFontColor]];
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

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 20;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
//    }
//    cell.textLabel.text=[NSString stringWithFormat:@"%d",indexPath.row+1];
//    return cell;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }

    cell.textLabel.text = commentArray[indexPath.row];;

    return cell;
}

@end
