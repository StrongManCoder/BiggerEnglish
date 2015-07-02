//
//  BETranslateViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/13.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

#import "BETranslateViewController.h"
#import "BETranslationModel.h"
#import "BEBaiduTranslaterModel.h"
#import "BETranslateCETSentenceCell.h"
#import "BETranslateExampleSentenceCell.h"
#import "BETranslateCheckMoreCell.h"
#import "BETranslateSentenceViewController.h"
#import "EnglishDictionaryManager.h"

typedef NS_ENUM(NSInteger, BETransLateType) {
    BETransLateTypeEnglish,
    BETransLateTypeChinese
};

typedef NS_ENUM(NSInteger, BESentenceExampleType) {
    BESentenceExample,
    BESentenceCETFourExample,
    BESentenceCETSixExample
};

static NSString * const SENTENCEEXAMPLE = @"例句";
static NSString * const SENTENCECETFOUREXAMPLE = @"CET-4";
static NSString * const SENTENCECETSIXEXAMPLE = @"CET-6";

@interface BETranslateViewController() <UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate,AVAudioPlayerDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) UIView *blankView;
@property (nonatomic, strong) UILabel *jokeLabel;

@property (nonatomic, strong) EnglishDictionaryManager *englishDictionaryManager;

@property (nonatomic, strong) NSMutableDictionary *sentenceDicionary;
@property (nonatomic, strong) NSMutableArray *wordArray;

@property (nonatomic, strong) NSMutableDictionary *cacheBaiduTranslateDictionary;

@property (nonatomic, strong) UITextField *searchTextField;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *searchTableView;

@property (nonatomic, strong) UIView *chineseView;
@property (nonatomic, strong) UILabel *searchChineseLabel;
@property (nonatomic, strong) UILabel *symbolLabel;
@property (nonatomic, strong) UITextView *otherLanguageResultLabel;
@property (nonatomic, strong) UISegmentedControl *languageSegment;
@property (nonatomic, strong) UIImageView *separatorChineseImage;

@property (nonatomic, strong) UIView *englishView;
@property (nonatomic, strong) UILabel *searchEnglishLabel;
@property (nonatomic, strong) UILabel *phenLabel;
@property (nonatomic, copy) NSString *ph_en_mp3;
@property (nonatomic, strong) UIImageView *phenPlayImage;
@property (nonatomic, strong) UILabel *phamLabel;
@property (nonatomic, copy) NSString *ph_am_mp3;
@property (nonatomic, strong) UIImageView *addWordImage;


@property (nonatomic, strong) UIImageView *phamPlayImage;
@property (nonatomic, strong) UITextView *chineseResultLabel;
@property (nonatomic, strong) UILabel *exchangeLabel;
@property (nonatomic, strong) UIImageView *separatorEnglishImage;

@property (nonatomic, strong) NSArray *soundImageArray;
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation BETranslateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _englishDictionaryManager = [[EnglishDictionaryManager alloc] init];
        _cacheBaiduTranslateDictionary = [NSMutableDictionary dictionaryWithCapacity:6];
        self.soundImageArray = [NSArray arrayWithObjects:
                                (id)[[UIImage imageNamed:@"icon_sound3"]imageWithTintColor:[UIColor BEHighLightFontColor]].CGImage,
                                (id)[[UIImage imageNamed:@"icon_sound2"] imageWithTintColor:[UIColor BEHighLightFontColor]].CGImage,
                                (id)[[UIImage imageNamed:@"icon_sound1"] imageWithTintColor:[UIColor BEHighLightFontColor]].CGImage, nil];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self configureNavigationItems];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
    [self configureGesture];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.searchTextField addTarget:self action:@selector(searchTextFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    self.searchTableView.hidden = YES;
    self.blankView.hidden = YES;
    self.tableView.hidden = NO;
    if ([self.searchTextField.text containChinese]) { //中转其他
        self.chineseView.hidden = NO;
        self.englishView.hidden = YES;
        self.languageSegment.selectedSegmentIndex = 0;
        self.chineseResultLabel.text = @"";
        self.exchangeLabel.text = @"";
        self.searchChineseLabel.text = self.searchTextField.text;
        [self.cacheBaiduTranslateDictionary removeAllObjects];
        [self chineseTranslator:self.searchChineseLabel.text];
    }
    else { //英转中
        self.englishView.hidden      = NO;
        self.chineseView.hidden      = YES;
        self.searchEnglishLabel.text = self.searchTextField.text;
        [self englishTranslator:self.searchEnglishLabel.text];
    }
    return YES;
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
    } else {
        return [self.wordArray count];
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
    } else {
        static NSString *ID = @"searchArrayCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.textLabel.text = [self.wordArray objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor BEDeepFontColor];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        UIView *view               = [[UIView alloc] init];
        view.backgroundColor       = [UIColor BEFrenchGrayColor];
        UILabel *titleLabel        = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
        titleLabel.textColor       = [UIColor BEDeepFontColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text            = [[self.sentenceDicionary allKeys] objectAtIndex:section];
        [view addSubview:titleLabel];
        return view;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        [self.searchTextField removeTarget:self action:@selector(searchTextFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.tableView.hidden = NO;
        self.blankView.hidden = YES;
        self.englishView.hidden = NO;
        self.chineseView.hidden = YES;
        self.searchTableView.hidden = YES;
        [self textFieldResignFirstResponder];
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        NSArray *array = [cell.textLabel.text split:@"；"];
        self.searchTextField.text = [array objectAtIndex:0];
        self.searchEnglishLabel.text = [array objectAtIndex:0];
        [self englishTranslator:self.searchTextField.text];
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchTextField resignFirstResponder];
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

- (void)navigateSetting {
    [self textFieldResignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
}

- (void) textFieldResignFirstResponder{
    [self.searchTextField removeTarget:self action:@selector(searchTextFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.searchTextField resignFirstResponder];
}

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

- (void)chineseTranslator:(NSString *)str {
    [self translatorRequest:str success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BETranslationModel *model = [BETranslationModel jsonToObject:operation.responseString];
        NSArray *phModelArray = [BEBaseinfoSymbolsModel objectArrayWithKeyValuesArray:model.message.baesInfo.symbols];
        BEBaseinfoSymbolsModel *phModel = [phModelArray objectAtIndex:0];
        if (phModel == nil || phModel.word_symbol == nil || [phModel.word_symbol isEqualToString:@""]) {
            self.symbolLabel.text = @"";
        }
        else {
            self.symbolLabel.text = [NSString stringWithFormat:@"[%@]",phModel.word_symbol];
        }
        self.otherLanguageResultLabel.text = [phModel partsStringWithFormat];
        [self.cacheBaiduTranslateDictionary setObject:self.otherLanguageResultLabel.text forKey:@"zh"];

        [self updateLayout:BETransLateTypeChinese];
        
        [self translatorRequest:str success:^(AFHTTPRequestOperation *operation, id responseObject) {
            BETranslationModel *model = [BETranslationModel jsonToObject:operation.responseString];
            [self configureSentence:model];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@ error", operation.description);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ error", operation.description);
    }];
}

- (void)englishTranslator:(NSString *)str {
    [self translatorRequest:str success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BETranslationModel *model = [BETranslationModel jsonToObject:operation.responseString];
        NSArray *phModelArray = [BEBaseinfoSymbolsModel objectArrayWithKeyValuesArray:model.message.baesInfo.symbols];
        BEBaseinfoSymbolsModel *phModel = [phModelArray objectAtIndex:0];
        if ([phModel.ph_en isEqualToString:@""] || phModel.ph_en == nil || phModel == nil ) {
            self.phenLabel.text = nil;
            self.phenPlayImage.hidden = YES;
        }
        else {
            self.phenLabel.text = [NSString stringWithFormat:@"英 [%@]", phModel.ph_en];
            self.ph_en_mp3 = phModel.ph_en_mp3;
            self.phenPlayImage.hidden = NO;
        }
        if ([phModel.ph_am isEqualToString:@""] || phModel.ph_am == nil || phModel == nil) {
            self.phamLabel.text = nil;
            self.phamPlayImage.hidden = YES;
        }
        else {
            self.phamLabel.text = [NSString stringWithFormat:@"美 [%@]", phModel.ph_am];
            self.ph_am_mp3 = phModel.ph_am_mp3;
            self.phamPlayImage.hidden = NO;
        }
        
        self.chineseResultLabel.text = [phModel partsStringWithFormat];
        
        BEBaseinfoExchangeModel *exchangeModel = model.message.baesInfo.exchange;
        self.exchangeLabel.text = [exchangeModel stringWithFormat];
        
        [self updateLayout:BETransLateTypeEnglish];
        [self configureSentence:model];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ error", operation.description);
    }];
}

- (void)BaiduTranslater:(NSString *)str languages:(NSString *)languages{
    [[AFHTTPRequestOperationManager manager] GET:BaiduTranslater([str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"zh", languages) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        BEBaiduTranslaterModel *model = [BEBaiduTranslaterModel jsonToObject:operation.responseString];
        self.otherLanguageResultLabel.text = [model partsStringWithFormat];
        [self.cacheBaiduTranslateDictionary setObject:self.otherLanguageResultLabel.text forKey:languages];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ error", operation.description);
    }];
}

- (void)Segmentselected:(id)sender{
    UISegmentedControl* control = (UISegmentedControl *)sender;
    NSString *result;
    if (control.selectedSegmentIndex == 0) {
        result = @"zh";
        if ([self.cacheBaiduTranslateDictionary valueForKey:result]) {
            self.otherLanguageResultLabel.text = [self.cacheBaiduTranslateDictionary valueForKey:@"zh"];
        }
        else {
            [self chineseTranslator:self.searchChineseLabel.text];
        }
    } else {
        switch (control.selectedSegmentIndex) {
            case 1://粤语
                result = @"yue";
                break;
            case 2://日语
                result = @"jp";
                break;
            case 3://韩语
                result = @"kor";
                break;
            case 4://德语
                result = @"de";
                break;
            case 5://法语
                result = @"fra";
                break;
        }
        if ([self.cacheBaiduTranslateDictionary valueForKey:result]) {
            self.otherLanguageResultLabel.text = [self.cacheBaiduTranslateDictionary valueForKey:result];
        }
        else {
            [self BaiduTranslater:self.searchChineseLabel.text languages:result];
        }
    }
}

- (void)searchTextFieldValueChanged:(id)sender {
    UITextField *textField = (UITextField *)sender;
    if ([textField.text isEqualToString:@""]) {
        if (self.tableView.hidden == YES) {
            self.blankView.hidden = NO;
        }
        self.searchTableView.hidden = YES;
        return;
    }
    if ([[textField.text trim] containChinese]) {
        self.searchTableView.hidden = YES;
        return;
    }
    
    self.wordArray = [self.englishDictionaryManager translateEnglish:[textField.text trim]];
    [self.searchTableView reloadData];
    
    self.blankView.hidden = YES;
    self.searchTableView.hidden = NO;
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
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath , @"temp"];
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
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        hud.delegate = self;
        [hud hide:YES afterDelay:1.5];
    } else {
        self.player.delegate = self;
        [self.player play];
    }
}

- (void)onAddWordImageClick {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"添加到生词本啦～";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.delegate = self;
    [hud hide:YES afterDelay:1.5];
}


#pragma mark - Private Methods

- (void)configureNavigationItems {
    UIButton *leftButton                   = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame                       = CGRectMake(0, 0, 25, 25);
    leftButton.adjustsImageWhenHighlighted = YES;
    UIImage *image                         = [UIImage imageNamed:@"icon_hamberger"];
    [leftButton setImage:[image imageWithTintColor:[UIColor BEDeepFontColor]] forState:UIControlStateNormal];
    [leftButton setImage:[image imageWithTintColor:[UIColor BEHighLightFontColor]] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(navigateSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem        = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UILabel *leftLabel                     = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    leftLabel.textAlignment                = NSTextAlignmentCenter;
    leftLabel.textColor                    = [UIColor BEDeepFontColor];
    leftLabel.font                         = [UIFont boldSystemFontOfSize:16];
    leftLabel.text                         = @"翻译";
    UIBarButtonItem *leftLabelItem         = [[UIBarButtonItem alloc] initWithCustomView:leftLabel];
    
    NSArray *itemArray                     = [[NSArray alloc]initWithObjects:leftButtonItem, leftLabelItem, nil];
    self.navigationItem.leftBarButtonItems = itemArray;
    
    self.navigationItem.titleView = self.searchTextField;
}

- (void)configureView {
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchTableView];
    [self.view addSubview:self.blankView];
    [self.blankView addSubview:self.jokeLabel];

    [self.blankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    [self.jokeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.blankView.mas_centerX);
        make.centerY.mas_equalTo(self.blankView.mas_centerY);
        make.width.mas_equalTo(ScreenWidth - 20);
    }];
    
    [self.chineseView addSubview:self.searchChineseLabel];
    [self.chineseView addSubview:self.symbolLabel];
    [self.chineseView addSubview:self.otherLanguageResultLabel];
    [self.chineseView addSubview:self.languageSegment];
    [self.chineseView addSubview:self.separatorChineseImage];
    
    [self.englishView addSubview:self.searchEnglishLabel];
    [self.englishView addSubview:self.phenLabel];
    [self.englishView addSubview:self.phenPlayImage];
    [self.englishView addSubview:self.phamLabel];
    [self.englishView addSubview:self.phamPlayImage];
    [self.englishView addSubview:self.chineseResultLabel];
    [self.englishView addSubview:self.exchangeLabel];
    [self.englishView addSubview:self.separatorEnglishImage];
    [self.englishView addSubview:self.addWordImage];
}

- (void)configureGesture {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldResignFirstResponder)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.blankView addGestureRecognizer:gesture];
    [self.tableView addGestureRecognizer:gesture];
}

- (void)updateLayout:(BETransLateType)type {
    if (type == BETransLateTypeEnglish) {
        self.tableView.tableHeaderView      = self.englishView;
        
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
        self.exchangeLabel.frame            = CGRectMake(10, 70 + chineseResultLabelSize.height, ScreenWidth - 20, exchangeLabelSize.height);
        self.englishView.frame              = CGRectMake(0, 0, ScreenWidth, 70 + chineseResultLabelSize.height + exchangeLabelSize.height);
        self.addWordImage.frame             = CGRectMake(ScreenWidth - 40, self.englishView.frame.size.height - 45, 30, 30);
        self.separatorEnglishImage.frame    = CGRectMake(0, self.englishView.frame.size.height - 0.5, ScreenWidth, 0.5);
        
        UIView *view                        = self.tableView.tableHeaderView;
        view.frame                          = self.englishView.frame;
        self.tableView.tableHeaderView      = view;
    }
    else {
        self.tableView.tableHeaderView      = self.chineseView;
        
        self.searchChineseLabel.frame       = CGRectMake(10, 10, ScreenWidth - 20, 25);
        self.symbolLabel.frame              = CGRectMake(10, 40, ScreenWidth - 20, 25);
        CGSize otherLanguageResultLabelSize = [self calculateTextViewSize:self.otherLanguageResultLabel];
        self.otherLanguageResultLabel.frame = CGRectMake(5, 65, ScreenWidth - 10, otherLanguageResultLabelSize.height);
        self.languageSegment.frame          = CGRectMake(10, 90 + otherLanguageResultLabelSize.height, ScreenWidth - 20, 30);
        self.chineseView.frame              = CGRectMake(0, 0, ScreenWidth, 140 + otherLanguageResultLabelSize.height);
        self.separatorChineseImage.frame    = CGRectMake(0, self.chineseView.frame.size.height - 0.5, ScreenWidth, 0.5);
        
        UIView *view                        = self.tableView.tableHeaderView;
        view.frame                          = self.chineseView.frame;
        self.tableView.tableHeaderView      = view;
    }
}

- (void)configureSentence:(BETranslationModel *)model {
    self.sentenceDicionary = nil;
    self.sentenceDicionary = [[NSMutableDictionary alloc] init];
    
    NSArray *sentenceArray = [BETranslationSentenceModel objectArrayWithKeyValuesArray:model.message.sentence];
    [self.sentenceDicionary setValue:sentenceArray forKey:SENTENCEEXAMPLE];
    NSArray *cetFourArray = [BETranslationCETModel objectArrayWithKeyValuesArray:model.message.cetFour];
    if ([cetFourArray count] == 1) {
        BETranslationCETModel *cetFourModel = (BETranslationCETModel *)[cetFourArray objectAtIndex:0];
        NSArray *cetFourSentenceArray = [BECETSentenceModel objectArrayWithKeyValuesArray:cetFourModel.Sentence];
        
        [self.sentenceDicionary setValue:cetFourSentenceArray forKey:SENTENCECETFOUREXAMPLE];
    }
    else {
    }
    
    NSArray *cetSixArray = [BETranslationCETModel objectArrayWithKeyValuesArray:model.message.cetSix];
    if ([cetSixArray count] == 1) {
        BETranslationCETModel *cetSixModel = (BETranslationCETModel *)[cetSixArray objectAtIndex:0];
        NSArray *cetSixSentenceArray = [BECETSentenceModel objectArrayWithKeyValuesArray:cetSixModel.Sentence];
        
        [self.sentenceDicionary setValue:cetSixSentenceArray forKey:SENTENCECETSIXEXAMPLE];
    }
    else {
    }
    
    [self.tableView reloadData];
}

- (void)translatorRequest:(NSString *)str
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:str,@"word", nil];
    [[AFHTTPRequestOperationManager manager] POST:Translater parameters:dic success:success failure:failure];
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

#pragma mark - Getters and Setters

- (UITextField *)searchTextField {
    if (_searchTextField != nil) {
        return _searchTextField;
    }
    _searchTextField                               = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    _searchTextField.textColor                     = [UIColor BEDeepFontColor];
    _searchTextField.font                          = [UIFont systemFontOfSize:14];
    _searchTextField.placeholder                   = @"输入要翻译的单词和句子";
    _searchTextField.adjustsFontSizeToFitWidth     = YES;
    _searchTextField.clearButtonMode               = UITextFieldViewModeWhileEditing;
    _searchTextField.borderStyle                   = UITextBorderStyleRoundedRect;
    _searchTextField.returnKeyType                 = UIReturnKeySearch;
    _searchTextField.enablesReturnKeyAutomatically = YES;
    _searchTextField.delegate                      = self;
    
    return _searchTextField;
}

- (UIView *)blankView {
    if (_blankView != nil) {
        return _blankView;
    }
    _blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    _blankView.hidden = NO;
    
    return _blankView;
}

- (UILabel *)jokeLabel {
    if (_jokeLabel != nil) {
        return _jokeLabel;
    }
    _jokeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _jokeLabel.textAlignment = NSTextAlignmentLeft;
    _jokeLabel.textColor = [UIColor BEDeepFontColor];
    _jokeLabel.font = [UIFont systemFontOfSize:16];
    _jokeLabel.numberOfLines = 0;
    _jokeLabel.text = @"不背单词，考英语就会是下面这种下场：\n我们知道賢鏛是在生活中很重要的。比如在鼙蠻和贎鬍里，有彃燊在罅鷄那里蘩墝，之前他们鏈鴊恆闳嘑傡彚槩滼鞷蕻賤鬡艐倏雫寬褲灣。\n1.鞷 在文中的意思？\n2.这篇文章的最佳标题？\n3.作者没有告诉我们什么？\n4.作者为什么说“恆闳嘑傡彚槩”？";
    
    return _jokeLabel;
}

- (UIView *)chineseView {
    if (_chineseView != nil) {
        return _chineseView;
    }
    _chineseView = [[UIView alloc] init];
    
    return _chineseView;
}

- (UILabel *)searchChineseLabel {
    if (_searchChineseLabel != nil) {
        return _searchChineseLabel;
    }
    _searchChineseLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _searchChineseLabel.textAlignment = NSTextAlignmentLeft;
    _searchChineseLabel.textColor = [UIColor BEFontColor];
    _searchChineseLabel.font = [UIFont systemFontOfSize:22];
    
    return _searchChineseLabel;
}

- (UILabel *)symbolLabel {
    if (_symbolLabel != nil) {
        return _symbolLabel;
    }
    _symbolLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _symbolLabel.textAlignment = NSTextAlignmentLeft;
    _symbolLabel.textColor = [UIColor BEDeepFontColor];
    _symbolLabel.font = [UIFont systemFontOfSize:16];
    
    return _symbolLabel;
}

- (UITextView *)otherLanguageResultLabel {
    if (_otherLanguageResultLabel != nil) {
        return _otherLanguageResultLabel;
    }
    _otherLanguageResultLabel = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 20, 30)];
    _otherLanguageResultLabel.textColor = [UIColor BEFontColor];
    _otherLanguageResultLabel.font = [UIFont systemFontOfSize:18];
    _otherLanguageResultLabel.scrollEnabled = NO;
    _otherLanguageResultLabel.editable = NO;
    
    return _otherLanguageResultLabel;
}

- (UISegmentedControl *)languageSegment {
    if (_languageSegment != nil) {
        return _languageSegment;
    }
    _languageSegment = [[UISegmentedControl alloc] initWithItems:@[@"英语", @"粤语", @"日语", @"韩语", @"德语", @"法语"]];
    _languageSegment.tintColor = [UIColor BEHighLightFontColor];
    _languageSegment.selectedSegmentIndex = 0;
    [_languageSegment addTarget:self action:@selector(Segmentselected:) forControlEvents:UIControlEventValueChanged];
    
    return _languageSegment;
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

- (UIImageView *)addWordImage {
    if (_addWordImage != nil) {
        return _addWordImage;
    }
    _addWordImage = [[UIImageView alloc] init];
    _addWordImage.image = [[UIImage imageNamed:@"icon_addword"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    _addWordImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *addWordImagePlaySingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddWordImageClick)];
    [_addWordImage addGestureRecognizer:addWordImagePlaySingleTap];
    
    return _addWordImage;
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

- (UIImageView *)separatorChineseImage {
    if (_separatorChineseImage != nil) {
        return _separatorChineseImage;
    }
    _separatorChineseImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _separatorChineseImage.backgroundColor = [UIColor BEHighLightFontColor];
    _separatorChineseImage.contentMode = UIViewContentModeScaleAspectFill;
    _separatorChineseImage.image = [UIImage imageNamed:@"section_divide"];
    _separatorChineseImage.clipsToBounds = YES;
    _separatorChineseImage.hidden = YES;
    
    return _separatorChineseImage;
}

- (UITableView *)tableView {
    if (_tableView != nil) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 44.0f;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tag = 0;
    _tableView.hidden = YES;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    return _tableView;
}

- (UITableView *)searchTableView {
    if (_searchTableView != nil) {
        return _searchTableView;
    }
    _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    _searchTableView.showsVerticalScrollIndicator = NO;
    _searchTableView.dataSource = self;
    _searchTableView.delegate = self;
    _searchTableView.estimatedRowHeight = 44.0f;
    _searchTableView.rowHeight = UITableViewAutomaticDimension;
    _searchTableView.tag = 1;
    _searchTableView.hidden =YES;

    return _searchTableView;
}

@end
