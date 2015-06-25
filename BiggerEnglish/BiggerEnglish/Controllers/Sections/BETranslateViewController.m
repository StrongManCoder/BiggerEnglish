//
//  BETranslateViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/13.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BETranslateViewController.h"
#import "BETranslationModel.h"
#import "BEBaiduTranslaterModel.h"

typedef NS_ENUM(NSInteger, BETransLateType) {
    BETransLateTypeEnglish,
    BETransLateTypeChinese
};


@interface BETranslateViewController() <UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *blankView;



@property (nonatomic, strong) NSMutableDictionary *sentenceDicionary;

@property (nonatomic, strong) UITextField *searchTextField;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *chineseView;
@property (nonatomic, strong) UILabel *searchChineseLabel;
@property (nonatomic, strong) UILabel *symbolLabel;
@property (nonatomic, strong) UITextView *otherLanguageResultLabel;
@property (nonatomic, strong) UISegmentedControl *languageSegment;
@property (nonatomic, strong) UIImageView *separatorChineseImage;

@property (nonatomic, strong) UIView *englishView;
@property (nonatomic, strong) UILabel *searchEnglishLabel;
@property (nonatomic, strong) UILabel *phenLabel;
@property (nonatomic, strong) UIImageView *phenPlayImage;
@property (nonatomic, strong) UILabel *phamLabel;
@property (nonatomic, strong) UIImageView *phamPlayImage;
@property (nonatomic, strong) UITextView *chineseResultLabel;
@property (nonatomic, strong) UILabel *exchangeLabel;
@property (nonatomic, strong) UIImageView *separatorEnglishImage;


@end

@implementation BETranslateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.sentenceDicionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self configureLeftItems];
    self.navigationItem.titleView = self.searchTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
    [self configureLayout];
    
    //    [self networkRequest];
    
    //    [self.view addSubview:self.chineseResultLabel];
    
}


//-(void)textViewDidChange:(UITextView *)textView {
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 5;
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont systemFontOfSize:16],
//                                 NSParagraphStyleAttributeName:paragraphStyle
//                                 };
//    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
//}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self textFieldResignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if ([self.searchTextField.text containChinese]) { //中转其他
        self.chineseView.hidden = NO;
        self.englishView.hidden = YES;
        self.languageSegment.selectedSegmentIndex = 0;
        self.chineseResultLabel.text = @"";
        self.exchangeLabel.text = @"";
        
        self.searchChineseLabel.text = self.searchTextField.text;
        
        [self chineseTranslator:self.searchChineseLabel.text];
    }
    else { //英转中
        self.englishView.hidden = NO;
        self.chineseView.hidden = YES;
        
        self.searchEnglishLabel.text = self.searchTextField.text;

        [self englishTranslator:self.searchEnglishLabel.text];
    }
    
    return YES;
}

//收起键盘
- (void) textFieldResignFirstResponder{
    [self.searchTextField resignFirstResponder];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.sentenceDicionary count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.sentenceDicionary allKeys] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.sentenceDicionary objectForKey:[[self.sentenceDicionary allKeys] objectAtIndex:section]];
    if ([array count] > 2) {
        return 2;
    }
    else {
        return [array count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    NSArray *array = [self.sentenceDicionary objectForKey:[[self.sentenceDicionary allKeys] objectAtIndex:indexPath.section]];
    if ([[[self.sentenceDicionary allKeys] objectAtIndex:indexPath.section] isEqual: @"例句"]) {
        BETranslationSentenceModel *model = array[indexPath.row];
        cell.textLabel.text = model.Network_en;
        return cell;
    }
    else {
        BECETSentenceModel *model = array[indexPath.row];
        cell.textLabel.text = model.sentence;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - Event Response

- (void)navigateSetting {
    [self.searchTextField resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
}

- (void)chineseTranslator:(NSString *)str {
    [self translatorRequest:str success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BETranslationModel *model = [BETranslationModel jsonToObject:operation.responseString];
        NSArray *phModelArray = [BEBaseinfoSymbolsModel objectArrayWithKeyValuesArray:model.message.baesInfo.symbols];
        BEBaseinfoSymbolsModel *phModel = [phModelArray objectAtIndex:0];
        if (phModel == nil || phModel.word_symbol == nil) {
            self.symbolLabel.text = @"";
        }
        else {
            self.symbolLabel.text = [NSString stringWithFormat:@"[%@]",phModel.word_symbol];
        }
        self.otherLanguageResultLabel.text = [phModel partsStringWithFormat];
        
        [self updateLayout:BETransLateTypeChinese];
        
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
            self.phenPlayImage.hidden = NO;
        }
        if ([phModel.ph_am isEqualToString:@""] || phModel.ph_am == nil || phModel == nil) {
            self.phamLabel.text = nil;
            self.phamPlayImage.hidden = YES;
        }
        else {
            self.phamLabel.text = [NSString stringWithFormat:@"美 [%@]", phModel.ph_am];
            self.phamPlayImage.hidden = NO;
        }
        
        self.chineseResultLabel.text = [phModel partsStringWithFormat];
//        [self resetUITextViewContent:self.chineseResultLabel];
        
        BEBaseinfoExchangeModel *exchangeModel = model.message.baesInfo.exchange;
        self.exchangeLabel.text = [exchangeModel stringWithFormat];
//        [self resetUILabelContent:self.exchangeLabel];
        
        [self updateLayout:BETransLateTypeEnglish];
        
        self.sentenceDicionary = nil;
        
        self.sentenceDicionary = [[NSMutableDictionary alloc] init];
        
        NSArray *sentenceArray = [BETranslationSentenceModel objectArrayWithKeyValuesArray:model.message.sentence];
        [self.sentenceDicionary setValue:sentenceArray forKey:@"例句"];
        NSArray *cetFourArray = [BETranslationCETModel objectArrayWithKeyValuesArray:model.message.cetFour];
        if ([cetFourArray count] == 1) {
            BETranslationCETModel *cetFourModel = (BETranslationCETModel *)[cetFourArray objectAtIndex:0];
            NSArray *cetFourSentenceArray = [BECETSentenceModel objectArrayWithKeyValuesArray:cetFourModel.Sentence];
            
            [self.sentenceDicionary setValue:cetFourSentenceArray forKey:@"CET-4"];

        }
        else {
            
        }
        
        NSArray *cetSixArray = [BETranslationCETModel objectArrayWithKeyValuesArray:model.message.cetSix];
        if ([cetSixArray count] == 1) {
            BETranslationCETModel *cetSixModel = (BETranslationCETModel *)[cetSixArray objectAtIndex:0];
            NSArray *cetSixSentenceArray = [BECETSentenceModel objectArrayWithKeyValuesArray:cetSixModel.Sentence];
            
            [self.sentenceDicionary setValue:cetSixSentenceArray forKey:@"CET-6"];
        }
        else {
            
        }

        //        NSLog(@"%@",model.message.baesInfo.word_name);
        //        NSLog(@"%@",[model.message.baesInfo.exchange.word_pl objectAtIndex:0]);
        //        NSLog(@"%@",model.message.sentence );
        //
        //        NSArray *array = [BETranslationSentenceModel objectArrayWithKeyValuesArray:model.message.sentence];
        //        for (BETranslationSentenceModel *translationSentenceModel in array) {
        //            NSLog(@"%@",translationSentenceModel.Network_en);
        //        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ error", operation.description);
    }];
}

- (void)BaiduTranslater:(NSString *)str languages:(NSString *)languages{
    [[AFHTTPRequestOperationManager manager] GET:BaiduTranslater([str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"zh", languages) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        BEBaiduTranslaterModel *model = [BEBaiduTranslaterModel jsonToObject:operation.responseString];
        self.otherLanguageResultLabel.text = [model partsStringWithFormat];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ error", operation.description);
    }];
}

- (void)Segmentselected:(id)sender{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    NSString *result;
    if (control.selectedSegmentIndex == 0) {
        [self chineseTranslator:self.searchChineseLabel.text];
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
        [self BaiduTranslater:self.searchChineseLabel.text languages:result];
    }
}


#pragma mark - Private Methods

- (void)configureLeftItems {
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
}

- (void)configureView {
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self.chineseView addSubview:self.symbolLabel];
//    [self.chineseView addSubview:self.otherLanguageResultLabel];
//    [self.chineseView addSubview:self.languageSegment];
//    
//    [self.englishView addSubview:self.phenLabel];
//    [self.englishView addSubview:self.phenPlayImage];
//    [self.englishView addSubview:self.phamLabel];
//    [self.englishView addSubview:self.phamPlayImage];
//    [self.englishView addSubview:self.chineseResultLabel];
//    [self.englishView addSubview:self.exchangeLabel];
//    
//    [self.sentenceView addSubview:self.sentenceTableView];
//    
//    [self.baseInfoView addSubview:self.chineseView];
//    [self.baseInfoView addSubview:self.englishView];
//    [self.scrollView addSubview:self.searchLabel];
//    [self.scrollView addSubview:self.baseInfoView];
//    [self.scrollView addSubview:self.separatorImage];
//    [self.scrollView addSubview:self.sentenceView];
//    
//    [self.view addSubview:self.scrollView];
    
    [self.view addSubview:self.tableView];
    //[self.view addSubview:self.blankView];
    
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
        self.separatorEnglishImage.frame    = CGRectMake(10, self.englishView.frame.size.height - 0.5, ScreenWidth - 20, 0.5);
        
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
        self.chineseView.frame              = CGRectMake(0, 0, ScreenWidth, 80 + otherLanguageResultLabelSize.height + 40);
        self.separatorChineseImage.frame    = CGRectMake(10, self.chineseView.frame.size.height - 0.5, ScreenWidth - 20, 0.5);
        
        UIView *view                        = self.tableView.tableHeaderView;
        view.frame                          = self.chineseView.frame;
        self.tableView.tableHeaderView      = view;
    }
}

- (void)configureLayout {
//    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.scrollView.mas_top).with.offset(10);
//        make.left.equalTo(self.scrollView.mas_left).with.offset(10);
//        make.right.equalTo(self.scrollView.mas_right).with.offset(-10);
//        make.bottom.equalTo(self.baseInfoView.mas_top).with.offset(-10);
//    }];
//    [self.baseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.searchLabel.mas_bottom).with.offset(10);
//        make.left.equalTo(self.scrollView.mas_left).with.offset(0);
//        make.width.equalTo(@ScreenWidth);
//        make.bottom.equalTo(self.separatorImage.mas_top).with.offset(0);
//    }];
//    [self.separatorImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.baseInfoView.mas_bottom).with.offset(0);
//        make.left.equalTo(self.scrollView.mas_left).with.offset(10);
//        make.height.mas_equalTo(@0.6);
//        make.width.mas_equalTo(ScreenWidth - 20);
//    }];
//    [self.sentenceView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.separatorImage.mas_bottom).with.offset(10);
//        make.left.equalTo(self.scrollView.mas_left).with.offset(0);
//        make.bottom.equalTo(self.scrollView.mas_bottom).with.offset(0);
//        make.height.equalTo(@250);//fuck
//        make.width.equalTo(@ScreenWidth);
//    }];
//
//    [self.sentenceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.sentenceView.mas_top).with.offset(0);
//        make.left.equalTo(self.sentenceView.mas_left).with.offset(0);
//        make.right.equalTo(self.sentenceView.mas_right).with.offset(0);
//        make.bottom.equalTo(self.sentenceView.mas_bottom).with.offset(0);
//    }];
//    
//    [self.chineseView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.baseInfoView.mas_top).with.offset(0);
//        make.left.equalTo(self.baseInfoView.mas_left).with.offset(0);
//        make.right.equalTo(self.baseInfoView.mas_right).with.offset(0);
//        make.bottom.equalTo(self.baseInfoView.mas_bottom).with.offset(0);
//    }];
//    [self.symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.chineseView.mas_top).with.offset(0);
//        make.left.equalTo(self.chineseView.mas_left).with.offset(10);
//        make.right.equalTo(self.chineseView.mas_right).with.offset(-10);
//        make.bottom.equalTo(self.otherLanguageResultLabel.mas_top).with.offset(-10);
//    }];
//    [self.otherLanguageResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.symbolLabel.mas_bottom).with.offset(10);
//        make.left.equalTo(self.chineseView.mas_left).with.offset(10);
//        make.right.equalTo(self.chineseView.mas_right).with.offset(-10);
//        make.bottom.equalTo(self.languageSegment.mas_top).with.offset(-10);
//    }];
//    [self.languageSegment mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.otherLanguageResultLabel.mas_bottom).with.offset(10);
//        make.left.equalTo(self.chineseView.mas_left).with.offset(10);
//        make.right.equalTo(self.chineseView.mas_right).with.offset(-10);
//        make.bottom.equalTo(self.chineseView.mas_bottom).with.offset(-10);
//    }];
//    
//    [self.englishView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.baseInfoView.mas_top).with.offset(0);
//        make.left.equalTo(self.baseInfoView.mas_left).with.offset(0);
//        make.right.equalTo(self.baseInfoView.mas_right).with.offset(0);
//        make.bottom.equalTo(self.baseInfoView.mas_bottom).with.offset(0);
//    }];
//    [self.phenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.englishView.mas_top).with.offset(0);
//        make.left.equalTo(self.englishView.mas_left).with.offset(10);
//        make.right.equalTo(self.phenPlayImage.mas_left).with.offset(-5);
//        make.bottom.equalTo(self.chineseResultLabel.mas_top).with.offset(-10);
//    }];
//    [self.phenPlayImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.phenLabel);
//        make.left.equalTo(self.phenLabel.mas_right).with.offset(5);
//        make.right.equalTo(self.phamLabel.mas_left).with.offset(-10);
//        make.width.equalTo(@30);
//        make.height.equalTo(@30);
//    }];
//    [self.phamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.englishView.mas_top).with.offset(0);
//        make.left.equalTo(self.phenPlayImage.mas_right).with.offset(10);
//        make.right.equalTo(self.phamPlayImage.mas_left).with.offset(-5);
//        make.bottom.equalTo(self.chineseResultLabel.mas_top).with.offset(-10);
//    }];
//    [self.phamPlayImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.phamLabel);
//        make.left.equalTo(self.phamLabel.mas_right).with.offset(5);
//        make.width.equalTo(@30);
//        make.height.equalTo(@30);
//    }];
//    [self.chineseResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.phamLabel.mas_bottom).with.offset(10);
//        make.left.equalTo(self.englishView.mas_left).with.offset(6);
//        make.width.mas_equalTo(ScreenWidth - 12);
//        make.bottom.equalTo(self.exchangeLabel.mas_top).with.offset(-10);
//    }];
//    [self.exchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.chineseResultLabel.mas_bottom).with.offset(10);
//        make.left.equalTo(self.englishView.mas_left).with.offset(10);
//        make.right.equalTo(self.englishView.mas_right).with.offset(-10);
//        make.bottom.equalTo(self.englishView.mas_bottom).with.offset(15);
//    }];
}

- (void)resetUILabelContent:(UILabel *)label {
    if (label.text) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
        NSMutableParagraphStyle *paragraphStyle = [[ NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineSpacing = 5;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
        label.attributedText = attributedString;
        [label sizeToFit];
    }
}

- (void)resetUITextViewContent:(UITextView *)textView {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:16],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
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
    _blankView.hidden = YES;
    
    return _blankView;
}

- (UIView *)chineseView {
    if (_chineseView != nil) {
        return _chineseView;
    }
    _chineseView = [[UIView alloc] init];
//    _chineseView.backgroundColor = [UIColor greenColor];
    
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
    _phenPlayImage.image = [[UIImage imageNamed:@"icon_sound2"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    _phenPlayImage.hidden = YES;
    _phenPlayImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *imagePlaySingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImagePlayClick)];
    [_phenPlayImage addGestureRecognizer:imagePlaySingleTap];
    
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
    _phamPlayImage.image = [[UIImage imageNamed:@"icon_sound2"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    _phamPlayImage.hidden = YES;
    _phamPlayImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *imagePlaySingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImagePlayClick)];
    [_phamPlayImage addGestureRecognizer:imagePlaySingleTap];
    
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
    
    return _separatorChineseImage;
}

- (UITableView *)tableView {
    if (_tableView != nil) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 44.0f;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    return _tableView;
}


@end
