//
//  BEWordBookDetailViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/7/7.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "BEWordBookDetailViewController.h"
#import "BEWordBookCell.h"
#import "WordBookModel.h"
#import "WordModel.h"
#import "SentenceModel.h"
#import "BETranslationSentenceModel.h"
#import "BECETSentenceModel.h"

#import "BETranslateCheckMoreCell.h"
#import "BETranslateCETSentenceCell.h"
#import "BETranslateExampleSentenceCell.h"

#import "BETranslateSentenceViewController.h"
#import "HistoryWordBookModel.h"

#define IPADSQUARESIZE 120
#define IPHONESQUARESIZE 110

typedef NS_ENUM(NSInteger, BESentenceExampleType) {
    BESentenceExample,
    BESentenceCETFourExample,
    BESentenceCETSixExample
};

static NSString * const SENTENCEEXAMPLE = @"例句";
static NSString * const SENTENCECETFOUREXAMPLE = @"CET-4";
static NSString * const SENTENCECETSIXEXAMPLE = @"CET-6";

@interface BEWordBookDetailViewController() <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate,AVAudioPlayerDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) UITableView *topTableView;

@property (nonatomic, strong) UITableView *bottomTableView;

@property (nonatomic, strong) NSMutableArray *wordBookModelResultArray;

@property (nonatomic, strong) NSFetchedResultsController *wordBookModelResults;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) UIView *englishView;
@property (nonatomic, strong) UILabel *searchEnglishLabel;
@property (nonatomic, strong) UILabel *phenLabel;
@property (nonatomic, copy) NSString *ph_en_mp3;
@property (nonatomic, strong) UIImageView *phenPlayImage;
@property (nonatomic, strong) UILabel *phamLabel;
@property (nonatomic, copy) NSString *ph_am_mp3;
@property (nonatomic, strong) UIImageView *phamPlayImage;
@property (nonatomic, strong) UITextView *chineseResultLabel;
@property (nonatomic, strong) UILabel *exchangeLabel;
@property (nonatomic, strong) UIImageView *separatorEnglishImage;

@property (nonatomic, strong) NSMutableDictionary *sentenceDicionary;

@property (nonatomic, strong) NSArray *soundImageArray;
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation BEWordBookDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _history = NO;
        self.soundImageArray = [NSArray arrayWithObjects:
                                (id)[[UIImage imageNamed:@"icon_sound3"]imageWithTintColor:[UIColor BEHighLightFontColor]].CGImage,
                                (id)[[UIImage imageNamed:@"icon_sound2"] imageWithTintColor:[UIColor BEHighLightFontColor]].CGImage,
                                (id)[[UIImage imageNamed:@"icon_sound1"] imageWithTintColor:[UIColor BEHighLightFontColor]].CGImage, nil];
    }
    return self;
}

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.workBook) {
        self.title = self.workBook;
    } else {
        self.title = @"历史记录";
    }
    [self configureRightButton];
    [self configureView];
    [self initData];
    [self configureData:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 0) {
        return [self.sentenceDicionary count];
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 0) {
        return [[self.sentenceDicionary allKeys] objectAtIndex:section];
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        NSArray *array = [self.sentenceDicionary objectForKey:[[self.sentenceDicionary allKeys] objectAtIndex:section]];
        if ([array count] > 3) {
            return 3;
        } else {
            return [array count];
        }
    }
    else {
//        id <NSFetchedResultsSectionInfo> sectionInfo = [self.wordBookModelResults sections][section];
//        WordBookModel *model = [[sectionInfo objects] objectAtIndex:0];
//        return [model.words count];
        return [self.wordBookModelResultArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        NSArray *array = [self.sentenceDicionary objectForKey:[[self.sentenceDicionary allKeys] objectAtIndex:indexPath.section]];
        NSString *sectionKey = [[self.sentenceDicionary allKeys] objectAtIndex:indexPath.section];
        if ([sectionKey isEqual: SENTENCECETFOUREXAMPLE]){
            return [self configureCell:BESentenceCETFourExample tableView:tableView cellForRowAtIndexPath:indexPath data:array];
        }
        else if ([sectionKey isEqual: SENTENCECETSIXEXAMPLE]){
            return [self configureCell:BESentenceCETSixExample tableView:tableView cellForRowAtIndexPath:indexPath data:array];
        }
        else //例句
        {
            return [self configureCell:BESentenceExample tableView:tableView cellForRowAtIndexPath:indexPath data:array];
        }
    }
    else {
        static NSString *ID = @"cell";
        BEWordBookCell *cell = (BEWordBookCell *)[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[BEWordBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
//        id <NSFetchedResultsSectionInfo> sectionInfo = [self.wordBookModelResults sections][0];
//        WordBookModel *wordBookModel = [[sectionInfo objects] objectAtIndex:0];
//        NSArray *array = [wordBookModel.words allObjects];
//        WordModel *wordModel = [array objectAtIndex:indexPath.row];
//        
//        cell.wordLabel.text = wordModel.word;
//        cell.translateLabel.text = wordModel.translate;
//        cell.rowNumberLabel.text = [NSString stringWithFormat:@"%d/%d", (int)indexPath.row + 1, (int)[array count]];
//        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
//        return cell;
        
        WordModel *wordModel = [self.wordBookModelResultArray objectAtIndex:indexPath.row];
        
        cell.wordLabel.text = wordModel.word;
        cell.translateLabel.text = wordModel.translate;
        cell.rowNumberLabel.text = [NSString stringWithFormat:@"%d/%d", (int)indexPath.row + 1, (int)[self.wordBookModelResultArray count]];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        return cell;

    }
}

- (UITableViewCell *)configureCell:(BESentenceExampleType)type tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath data:(NSArray *)array {
    if (indexPath.row == 2) {
        static NSString *ID = @"checkMoreCell";
        BETranslateCheckMoreCell *cell = (BETranslateCheckMoreCell *)[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[BETranslateCheckMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        switch (type) {
            case BESentenceExample:
                cell.checkMoreButton.tag = 0;
                break;
            case BESentenceCETFourExample:
                cell.checkMoreButton.tag = 1;
                break;
            case BESentenceCETSixExample:
                cell.checkMoreButton.tag = 2;
                break;
        }
        [cell.checkMoreButton addTarget:self action:@selector(navigateSentenceDetailView:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else {
        if (type == BESentenceExample) {
            static NSString *ID = @"ExampleSentenceCell";
            BETranslateExampleSentenceCell *cell = (BETranslateExampleSentenceCell *)[tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[BETranslateExampleSentenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            BETranslationSentenceModel *model = array[indexPath.row];
            cell.content = model.Network_en;
            cell.translate = model.Network_cn;
            cell.mp3 = model.tts_mp3;
            cell.size = model.tts_size;
            return cell;
        } else {
            static NSString *ID = @"CETSentenceCell";
            BETranslateCETSentenceCell *cell = (BETranslateCETSentenceCell *)[tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[BETranslateCETSentenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            BECETSentenceModel *model = array[indexPath.row];
            cell.content = model.sentence;
            cell.translate = model.come;
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (tableView.tag == 0) {
    ////        return 0;
    //    }
    //    else {
    if (DeviceIsPhone) {
        return IPHONESQUARESIZE;
    } else {
        return IPADSQUARESIZE;
    }
    //    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        
    }
    else {
        [self configureData:indexPath.row];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Fetched results controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.bottomTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.bottomTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.bottomTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.bottomTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.bottomTableView endUpdates];
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag{
    //播放结束时执行的动作
    [self.phamPlayImage.layer removeAllAnimations];
    [self.phenPlayImage.layer removeAllAnimations];
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
    hud.delegate = nil;
    hud = nil;
}

#pragma mark - Event Response

- (void)navigateSentenceDetailView:(UIButton *)sender {
    BETranslateSentenceViewController *controller = [[BETranslateSentenceViewController alloc] init];
    switch (sender.tag) {
        case 0:
            controller.title = SENTENCEEXAMPLE;
            controller.array = [self.sentenceDicionary objectForKey:SENTENCEEXAMPLE];
            break;
        case 1:
            controller.title = SENTENCECETFOUREXAMPLE;
            controller.array = [self.sentenceDicionary objectForKey:SENTENCECETFOUREXAMPLE];
            break;
        case 2:
            controller.title = SENTENCECETSIXEXAMPLE;
            controller.array = [self.sentenceDicionary objectForKey:SENTENCECETSIXEXAMPLE];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onPlayImageClick:(id)sender {
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.calculationMode = kCAAnimationDiscrete;
    animation.duration = 1;
    animation.values = self.soundImageArray;
    animation.repeatCount = HUGE_VALF;
    
    NSURL *url;
    if ([singleTap view].tag == 0) {
        [self.phenPlayImage.layer removeAllAnimations];
        [self.phenPlayImage.layer addAnimation:animation forKey:@"frameAnimation"];
        url = [[NSURL alloc]initWithString:self.ph_en_mp3];
    }
    else {
        [self.phamPlayImage.layer removeAllAnimations];
        [self.phamPlayImage.layer addAnimation:animation forKey:@"frameAnimation"];
        url = [[NSURL alloc]initWithString:self.ph_am_mp3];
    }
    NSData * audioData = [NSData dataWithContentsOfURL:url];
    //将数据保存到本地指定位置
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath , @"phtemp"];
    [audioData writeToFile:filePath atomically:YES];
    //播放本地音乐
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    if (self.player == nil) {
        [self.phenPlayImage.layer removeAllAnimations];
        [self.phamPlayImage.layer removeAllAnimations];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"播放出现错误～";
        hud.delegate = self;
        [hud hide:YES afterDelay:1.5];
    } else {
        self.player.delegate = self;
        [self.player play];
    }
}

- (void)deleteWord {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"WordBookModel" inManagedObjectContext:self.managedObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title==%@", self.workBook]];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    WordBookModel *wordBookModel = (WordBookModel *)[results firstObject];
    for (WordModel *item in [wordBookModel.words allObjects]) {
        if ([item.word isEqualToString:self.searchEnglishLabel.text]) {
            [self.managedObjectContext deleteObject:item];
            break;
        }
    }
    
    int count = (int)[self.wordBookModelResultArray count];
    WordModel *wordModel;
    for (int i = 0; i < count; i++) {
        wordModel = [self.wordBookModelResultArray objectAtIndex:i];
        if ([wordModel.word isEqualToString:self.searchEnglishLabel.text]) {
            [self.wordBookModelResultArray removeObjectAtIndex:i];
            [self.bottomTableView reloadData];
            break;
        }
    }

    if (![self.managedObjectContext save:nil]) {
        NSLog(@"error!");
    } else {
        NSLog(@"ok.");
    }
    [self configureData:0];

}

#pragma mark - Private Method

- (void)initData {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    if (self.history) {
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"HistoryWordBookModel" inManagedObjectContext:self.managedObjectContext]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title==%@", self.workBook]];
        NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        WordBookModel *wordBookModel = (WordBookModel *)[results firstObject];
        self.wordBookModelResultArray = [NSMutableArray arrayWithArray:[wordBookModel.words allObjects]];
    }
    else {
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"WordBookModel" inManagedObjectContext:self.managedObjectContext]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title==%@", self.workBook]];
        NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        WordBookModel *wordBookModel = (WordBookModel *)[results firstObject];
        self.wordBookModelResultArray = [NSMutableArray arrayWithArray:[wordBookModel.words allObjects]];
    }
}

- (void)configureRightButton {
    if (!self.history) {
    UIButton *rightButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame       = CGRectMake(0, 0, 25, 25);
    [rightButton setAdjustsImageWhenHighlighted:YES];
    UIImage *image = [UIImage imageNamed:@"icon_trash"];
    [rightButton setImage:[image imageWithTintColor:[UIColor BEDeepFontColor]] forState:UIControlStateNormal];
    [rightButton setImage:[image imageWithTintColor:[UIColor BEHighLightFontColor]] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(deleteWord) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem              = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = barItem;
    }
}

- (void)configureView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.topTableView];
    [self.view addSubview:self.bottomTableView];
    
    [self.englishView addSubview:self.searchEnglishLabel];
    [self.englishView addSubview:self.phenLabel];
    [self.englishView addSubview:self.phenPlayImage];
    [self.englishView addSubview:self.phamLabel];
    [self.englishView addSubview:self.phamPlayImage];
    [self.englishView addSubview:self.chineseResultLabel];
    [self.englishView addSubview:self.exchangeLabel];
    [self.englishView addSubview:self.separatorEnglishImage];
    
    self.topTableView.tableHeaderView= self.englishView;
}

- (void)configureData:(NSUInteger)index {
    if ([self.wordBookModelResultArray count] > 0) {
        WordModel *wordModel = [self.wordBookModelResultArray objectAtIndex:index];
        self.searchEnglishLabel.text = wordModel.word;
        self.phenLabel.text = wordModel.phen;
        self.ph_en_mp3 = wordModel.phenmp3;
        self.phamLabel.text = wordModel.pham;
        self.ph_am_mp3 = wordModel.phammp3;
        self.chineseResultLabel.text = wordModel.translate;
        self.exchangeLabel.text = wordModel.exchange;
        
        [self updateLayout];
        [self configureSentence:wordModel.sentences];
    } else {
        self.topTableView.hidden = YES;
        self.bottomTableView.hidden = YES;
    }
}

- (void)updateLayout {
    
    self.searchEnglishLabel.frame       = CGRectMake(10, 10, ScreenWidth - 20, 25);
    CGSize phenLabelSize                = [self calculateLabelSize:self.phenLabel.text FontSize:16];
    self.phenLabel.frame                = CGRectMake(10, 40, phenLabelSize.width, phenLabelSize.height);
    self.phenPlayImage.frame            = CGRectMake(20 + phenLabelSize.width, 35, 30, 30);
    CGSize phamLabelSize                = [self calculateLabelSize:self.phamLabel.text FontSize:16];
    self.phamLabel.frame                = CGRectMake(70 + phenLabelSize.width, 40, phamLabelSize.width, phamLabelSize.height);
    self.phamPlayImage.frame            = CGRectMake(80 + phenLabelSize.width + phamLabelSize.width, 35, 30, 30);
    CGSize chineseResultLabelSize       = [self calculateTextViewSize:self.chineseResultLabel];
    if ([self.chineseResultLabel.text isEqualToString:@""]) {
        chineseResultLabelSize.height = 0;
    }
    self.chineseResultLabel.frame       = CGRectMake(5, 60, ScreenWidth - 10, chineseResultLabelSize.height);
    CGSize exchangeLabelSize            = [self calculateLabelSize:self.exchangeLabel.text FontSize:16];
    if ([self.exchangeLabel.text isEqualToString:@""]) {
        exchangeLabelSize.height = 0;
    }
    self.exchangeLabel.frame = CGRectMake(10, 70 + chineseResultLabelSize.height, ScreenWidth - 20, exchangeLabelSize.height);
    self.englishView.frame = CGRectMake(0, 0, ScreenWidth, 70 + chineseResultLabelSize.height + exchangeLabelSize.height);
    self.separatorEnglishImage.frame = CGRectMake(0, self.englishView.frame.size.height - 0.5, ScreenWidth, 0.5);
    
    if (self.ph_en_mp3 == nil ) {
        self.phenPlayImage.hidden = YES;
    } else {
        self.phenPlayImage.hidden = NO;
    }
    if (self.ph_am_mp3 == nil) {
        self.phamPlayImage.hidden = YES;
    } else {
        self.phamPlayImage.hidden = NO;
    }
    
    UIView *view = self.topTableView.tableHeaderView;
    view.frame = self.englishView.frame;
    self.topTableView.tableHeaderView = view;
}

- (void)configureSentence:(NSSet *)sentences {
    self.sentenceDicionary = [[NSMutableDictionary alloc] init];
    NSArray *array = [sentences allObjects];
    for (SentenceModel *sentenceModel in array) {
        if ([sentenceModel.type isEqualToString:SENTENCEEXAMPLE]) {
            BETranslationSentenceModel *translationSentenceModel = [[BETranslationSentenceModel alloc] init];
            translationSentenceModel.Network_en = sentenceModel.sentence;
            translationSentenceModel.Network_cn = sentenceModel.translate;
            translationSentenceModel.tts_mp3 = sentenceModel.mp3;
            translationSentenceModel.tts_size = sentenceModel.size;
            if ([[self.sentenceDicionary allKeys] containsObject:SENTENCEEXAMPLE]) {
                [[self.sentenceDicionary valueForKey:SENTENCEEXAMPLE] addObject:translationSentenceModel];
            } else {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [array addObject:translationSentenceModel];
                [self.sentenceDicionary setObject:array forKey:SENTENCEEXAMPLE];
            }
        } else if ([sentenceModel.type isEqualToString:SENTENCECETFOUREXAMPLE]) {
            BECETSentenceModel *cetSentenceModel = [[BECETSentenceModel alloc] init];
            cetSentenceModel.sentence = sentenceModel.sentence;
            cetSentenceModel.come = sentenceModel.translate;
            if ([[self.sentenceDicionary allKeys] containsObject:SENTENCECETFOUREXAMPLE]) {
                [[self.sentenceDicionary valueForKey:SENTENCECETFOUREXAMPLE] addObject:cetSentenceModel];
            } else {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [array addObject:cetSentenceModel];
                [self.sentenceDicionary setObject:array forKey:SENTENCECETFOUREXAMPLE];
            }
        } else if ([sentenceModel.type isEqualToString:SENTENCECETSIXEXAMPLE]) {
            BECETSentenceModel *cetSentenceModel = [[BECETSentenceModel alloc] init];
            cetSentenceModel.sentence = sentenceModel.sentence;
            cetSentenceModel.come = sentenceModel.translate;
            if ([[self.sentenceDicionary allKeys] containsObject:SENTENCECETSIXEXAMPLE]) {
                [[self.sentenceDicionary valueForKey:SENTENCECETSIXEXAMPLE] addObject:cetSentenceModel];
            } else {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [array addObject:cetSentenceModel];
                [self.sentenceDicionary setObject:array forKey:SENTENCECETSIXEXAMPLE];
            }
        }
    }
    
    [self.topTableView reloadData];
}

- (CGSize)calculateLabelSize:(NSString *)value FontSize:(CGFloat) font {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(ScreenWidth - 20, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size;
}

- (CGSize)calculateTextViewSize:(UITextView *)textView {
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(textView.contentSize.width - fPadding, CGFLOAT_MAX);
    CGSize size = [textView.text sizeWithFont:textView.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    size.height = size.height + 16.0;
    
    return size;
}

#pragma mark - Getters / Setters

- (UITableView *)topTableView {
    if (_topTableView != nil) {
        return _topTableView;
    }
    _topTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    if (DeviceIsPhone) {
        _topTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - IPHONESQUARESIZE);
    } else {
        _topTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - IPADSQUARESIZE);
    }
    _topTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _topTableView.showsVerticalScrollIndicator = NO;
    _topTableView.estimatedRowHeight = 44.0f;
    _topTableView.rowHeight = UITableViewAutomaticDimension;
    _topTableView.dataSource = self;
    //    _topTableView.delegate = self;
    _topTableView.tag = 0;
    
    return _topTableView;
}

- (UITableView *)bottomTableView {
    if (_bottomTableView != nil) {
        return _bottomTableView;
    }
    _bottomTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _bottomTableView.layer.anchorPoint = CGPointMake(0, 0);//先设置锚点再设置frame！！
    if (DeviceIsPhone) {
        _bottomTableView.frame = CGRectMake(-1, ScreenHeight - 63, IPHONESQUARESIZE + 1, ScreenWidth + 2);
    } else {
        _bottomTableView.frame = CGRectMake(-1, ScreenHeight - 63, IPADSQUARESIZE + 1, ScreenWidth + 2);
    }
    _bottomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bottomTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    _bottomTableView.backgroundColor = [UIColor BEFrenchGrayColor];
    _bottomTableView.showsVerticalScrollIndicator = NO;
    _bottomTableView.dataSource = self;
    _bottomTableView.delegate = self;
    _bottomTableView.tag = 1;
    _bottomTableView.layer.borderWidth = 0.5;
    _bottomTableView.layer.borderColor = [UIColor BEHighLightFontColor].CGColor;
    
    return _bottomTableView;
}

- (NSFetchedResultsController *)wordBookModelResults
{
    if (_wordBookModelResults != nil) {
        return _wordBookModelResults;
    }
    //历史纪录
    if (self.history) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"HistoryWordBookModel" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        [fetchRequest setFetchBatchSize:20];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
        NSArray *sortDescriptors = @[sortDescriptor];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        aFetchedResultsController.delegate = self;
        _wordBookModelResults = aFetchedResultsController;
        
        NSError *error = nil;
        if (![_wordBookModelResults performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    else
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"WordBookModel" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        [fetchRequest setFetchBatchSize:20];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        NSArray *sortDescriptors = @[sortDescriptor];
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title==%@", self.workBook]];
        
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        aFetchedResultsController.delegate = self;
        _wordBookModelResults = aFetchedResultsController;
        
        NSError *error = nil;
        if (![_wordBookModelResults performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _wordBookModelResults;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    id delegate = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = [delegate managedObjectContext];
    
    return _managedObjectContext;
}

- (UIView *)englishView {
    if (_englishView != nil) {
        return _englishView;
    }
    _englishView = [[UIView alloc] init];
    
    return _englishView;
}

- (UILabel *)searchEnglishLabel {
    if (_searchEnglishLabel != nil) {
        return _searchEnglishLabel;
    }
    _searchEnglishLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _searchEnglishLabel.textAlignment = NSTextAlignmentLeft;
    _searchEnglishLabel.textColor = [UIColor BEFontColor];
    _searchEnglishLabel.font = [UIFont systemFontOfSize:22];
    
    return _searchEnglishLabel;
}

- (UILabel *)phenLabel {
    if (_phenLabel != nil) {
        return _phenLabel;
    }
    _phenLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _phenLabel.textAlignment = NSTextAlignmentLeft;
    _phenLabel.textColor = [UIColor BEDeepFontColor];
    _phenLabel.font = [UIFont systemFontOfSize:16];
    _phenLabel.numberOfLines = 0;
    
    return _phenLabel;
}

- (UIImageView *)phenPlayImage {
    if (_phenPlayImage != nil) {
        return _phenPlayImage;
    }
    _phenPlayImage = [[UIImageView alloc] init];
    _phenPlayImage.image = [[UIImage imageNamed:@"icon_sound1"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    _phenPlayImage.hidden = YES;
    _phenPlayImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *imagePlaySingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPlayImageClick:)];
    [_phenPlayImage addGestureRecognizer:imagePlaySingleTap];
    UIView *singleTapView = [imagePlaySingleTap view];
    singleTapView.tag = 0;
    
    return _phenPlayImage;
}

- (UILabel *)phamLabel {
    if (_phamLabel != nil) {
        return _phamLabel;
    }
    _phamLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _phamLabel.textAlignment = NSTextAlignmentLeft;
    _phamLabel.textColor = [UIColor BEDeepFontColor];
    _phamLabel.font = [UIFont systemFontOfSize:16];
    _phamLabel.numberOfLines = 0;
    
    return _phamLabel;
}

- (UIImageView *)phamPlayImage {
    if (_phamPlayImage != nil) {
        return _phamPlayImage;
    }
    _phamPlayImage = [[UIImageView alloc] init];
    _phamPlayImage.image = [[UIImage imageNamed:@"icon_sound1"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    _phamPlayImage.hidden = YES;
    _phamPlayImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *imagePlaySingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPlayImageClick:)];
    [_phamPlayImage addGestureRecognizer:imagePlaySingleTap];
    UIView *singleTapView = [imagePlaySingleTap view];
    singleTapView.tag = 1;
    
    return _phamPlayImage;
}

- (UITextView *)chineseResultLabel {
    if (_chineseResultLabel != nil) {
        return _chineseResultLabel;
    }
    _chineseResultLabel = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 20, 30)];
    _chineseResultLabel.textColor = [UIColor BEFontColor];
    _chineseResultLabel.font = [UIFont systemFontOfSize:16];
    _chineseResultLabel.scrollEnabled = NO;
    _chineseResultLabel.editable = NO;
    _chineseResultLabel.delegate = self;
    
    return _chineseResultLabel;
}

- (UILabel *)exchangeLabel {
    if (_exchangeLabel != nil) {
        return _exchangeLabel;
    }
    _exchangeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _exchangeLabel.textAlignment = NSTextAlignmentLeft;
    _exchangeLabel.textColor = [UIColor BEFontColor];
    _exchangeLabel.font = [UIFont systemFontOfSize:16];
    _exchangeLabel.numberOfLines = 0;
    
    return _exchangeLabel;
}

- (UIImageView *)separatorEnglishImage {
    if (_separatorEnglishImage != nil) {
        return _separatorEnglishImage;
    }
    _separatorEnglishImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _separatorEnglishImage.backgroundColor = [UIColor BEHighLightFontColor];
    _separatorEnglishImage.contentMode = UIViewContentModeScaleAspectFill;
    _separatorEnglishImage.image = [UIImage imageNamed:@"section_divide"];
    _separatorEnglishImage.clipsToBounds = YES;
    _separatorEnglishImage.hidden = YES;
    return _separatorEnglishImage;
}

@end
