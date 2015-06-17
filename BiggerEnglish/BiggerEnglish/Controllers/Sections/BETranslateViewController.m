//
//  BETranslateViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/13.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BETranslateViewController.h"
#import "BETranslationModel.h"

@interface BETranslateViewController() <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *searchTextField;

@property (nonatomic, strong) UILabel *searchLabel;
//@property (nonatomic, strong) UILabel *searchLabel;
//@property (nonatomic, strong) UILabel *searchLabel;
//@property (nonatomic, strong) UILabel *searchLabel;
//@property (nonatomic, strong) UILabel *searchLabel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *blankView;

@property (nonatomic, strong) UIView *baseInfoView;
@property (nonatomic, strong) UIView *chineseView;
@property (nonatomic, strong) UIView *englishView;
@property (nonatomic, strong) UILabel *phenLabel;
@property (nonatomic, strong) UILabel *phamLabel;
@property (nonatomic, strong) UILabel *chineseResultLabel;


@property (nonatomic, strong) UIView *sentenceView;


@end

@implementation BETranslateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self textFieldResignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    self.searchLabel.text = self.searchTextField.text;
    
    
    if ([self.searchLabel.text containChinese]) { //中转其他
        
    }
    else { //英转中
        self.chineseView.hidden = YES;
        [self Translator:self.searchLabel.text];
    }
    
    return YES;
}

//收起键盘
- (void) textFieldResignFirstResponder{
    [self.searchTextField resignFirstResponder];
}

#pragma mark - Event Response

- (void)navigateSetting {
    [self.searchTextField resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
}

- (void)Translator:(NSString *)str {
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:str,@"word", nil];
    
    [[AFHTTPRequestOperationManager manager] POST:Translater parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BETranslationModel *model = [BETranslationModel jsonToObject:operation.responseString];
        
        NSArray *phModelArray = [BEBaseinfoSymbolsModel objectArrayWithKeyValuesArray:model.message.baesInfo.symbols];
        BEBaseinfoSymbolsModel *phModel = [phModelArray objectAtIndex:0];
        if ([phModel.ph_en isEqualToString:@""]) {
            self.phenLabel.hidden = YES;
            self.phenLabel.text = nil;
        }
        else {
            self.phenLabel.hidden = NO;
            self.phenLabel.text = [NSString stringWithFormat:@"英 ［%@］", phModel.ph_en];
        }
        if ([phModel.ph_am isEqualToString:@""]) {
            self.phamLabel.hidden = YES;
            self.phamLabel.text = nil;
        }
        else {
            self.phamLabel.hidden = NO;
            self.phamLabel.text = [NSString stringWithFormat:@"美 ［%@］", phModel.ph_am];
        }
        
        NSArray *partsModelArray = [BESymbolsPartsModel objectArrayWithKeyValuesArray:phModel.parts];
        
        NSString *chineseResultTemp = @"";
        BESymbolsPartsModel *partsModelTemp;
        int partsModelArrayCount = (int)[partsModelArray count];
        for (int i = 0; i < partsModelArrayCount; i++) {
            partsModelTemp = (BESymbolsPartsModel*)partsModelArray[i];
            chineseResultTemp = [NSString stringWithFormat:@"%@ %@ %@", chineseResultTemp,
                                 partsModelTemp.part,
                                 [partsModelTemp.means componentsJoinedByString:@"；"]];
            if (partsModelArrayCount > 0 && i != partsModelArrayCount - 1) {
                chineseResultTemp = [NSString stringWithFormat:@"%@%@", chineseResultTemp, @"\n"];
            }
        }
        
        self.chineseResultLabel.text = [chineseResultTemp trim];
        
        [self configureLayout];
        
//        NSLog(@"%@",model.message.baesInfo.word_name);
//        NSLog(@"%@",[model.message.baesInfo.exchange.word_pl objectAtIndex:0]);
//        NSLog(@"%@",model.message.sentence );
//        
//        NSArray *array = [BETranslationSentenceModel objectArrayWithKeyValuesArray:model.message.sentence];
//        for (BETranslationSentenceModel *translationSentenceModel in array) {
//            NSLog(@"%@",translationSentenceModel.Network_en);
//        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ error", operation.description);
    }];
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
    leftLabel.font                         = [UIFont boldSystemFontOfSize:18];
    leftLabel.text                         = @"翻译";
    UIBarButtonItem *leftLabelItem         = [[UIBarButtonItem alloc] initWithCustomView:leftLabel];
    
    NSArray *itemArray                     = [[NSArray alloc]initWithObjects:leftButtonItem, leftLabelItem, nil];
    self.navigationItem.leftBarButtonItems = itemArray;
}

- (void)configureView {
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.englishView addSubview:self.phenLabel];
    [self.englishView addSubview:self.phamLabel];
    [self.englishView addSubview:self.chineseResultLabel];

    [self.baseInfoView addSubview:self.chineseView];
    [self.baseInfoView addSubview:self.englishView];
    [self.scrollView addSubview:self.searchLabel];
    [self.scrollView addSubview:self.baseInfoView];
    [self.scrollView addSubview:self.sentenceView];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.blankView];
}

- (void)configureLayout {
    
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).with.offset(10);
        make.left.equalTo(self.scrollView.mas_left).with.offset(10);
        make.right.equalTo(self.scrollView.mas_right).with.offset(-10);
        make.bottom.equalTo(self.baseInfoView.mas_top).with.offset(-10);
    }];
    [self.baseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchLabel.mas_bottom).with.offset(0);
        make.left.equalTo(self.scrollView.mas_left).with.offset(0);
        make.right.equalTo(self.scrollView.mas_right).with.offset(0);
        make.bottom.equalTo(self.sentenceView.mas_top).with.offset(0);
    }];
    [self.sentenceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseInfoView.mas_bottom).with.offset(0);
        make.left.equalTo(self.scrollView.mas_left).with.offset(0);
        make.right.equalTo(self.scrollView.mas_right).with.offset(0);
        make.bottom.equalTo(self.scrollView.mas_bottom).with.offset(0);
    }];
    
    [self.chineseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseInfoView.mas_top).with.offset(0);
        make.left.equalTo(self.baseInfoView.mas_left).with.offset(0);
        make.right.equalTo(self.baseInfoView.mas_right).with.offset(0);
        make.bottom.equalTo(self.baseInfoView.mas_bottom).with.offset(0);
    }];
    [self.englishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseInfoView.mas_top).with.offset(0);
        make.left.equalTo(self.baseInfoView.mas_left).with.offset(0);
        make.right.equalTo(self.baseInfoView.mas_right).with.offset(0);
        make.bottom.equalTo(self.baseInfoView.mas_bottom).with.offset(0);
    }];
    
    [self.phenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.englishView.mas_top).with.offset(0);
        make.left.equalTo(self.englishView.mas_left).with.offset(10);
        make.right.equalTo(self.englishView.mas_right).with.offset(0);
        make.bottom.equalTo(self.phamLabel.mas_top).with.offset(-5);
    }];
    [self.phamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phenLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.englishView.mas_left).with.offset(10);
        make.right.equalTo(self.englishView.mas_right).with.offset(0);
        make.bottom.equalTo(self.chineseResultLabel.mas_top).with.offset(-10);
    }];

    [self.chineseResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phamLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.englishView.mas_left).with.offset(10);
        make.right.equalTo(self.englishView.mas_right).with.offset(0);
        make.bottom.equalTo(self.englishView.mas_bottom).with.offset(-10);
    }];

}

//判断中文还是英文
- (BOOL)containChinese:(NSString*)str {
    int length = (int)[str length];
    for (int i = 0; i < length; ++i) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [str substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3) {
            return YES;
        }
    }
    return NO;
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

- (UIView *)baseInfoView {
    if (_baseInfoView != nil) {
        return _baseInfoView;
    }
    
    _baseInfoView = [[UIView alloc] init];
    
    return _baseInfoView;
}

- (UIView *)chineseView {
    if (_chineseView != nil) {
        return _chineseView;
    }
    
    _chineseView = [[UIView alloc] init];
    _chineseView.backgroundColor = [UIColor redColor];
    return _chineseView;
}

- (UIView *)englishView {
    if (_englishView != nil) {
        return _englishView;
    }
    
    _englishView = [[UIView alloc] init];
    _chineseView.backgroundColor = [UIColor blueColor];
    return _englishView;
}

- (UILabel *)searchLabel {
    if (_searchLabel != nil) {
        return _searchLabel;
    }
    
    _searchLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _searchLabel.textAlignment = NSTextAlignmentLeft;
    _searchLabel.textColor = [UIColor BEFontColor];
    _searchLabel.font = [UIFont systemFontOfSize:20];
    return _searchLabel;
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

- (UILabel *)chineseResultLabel {
    if (_chineseResultLabel != nil) {
        return _chineseResultLabel;
    }
    
    _chineseResultLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _chineseResultLabel.textAlignment = NSTextAlignmentLeft;
    _chineseResultLabel.textColor = [UIColor BEFontColor];
    _chineseResultLabel.font = [UIFont systemFontOfSize:18];
    _chineseResultLabel.numberOfLines = 0;
    _chineseResultLabel.preferredMaxLayoutWidth = ScreenWidth - 20;
    return _chineseResultLabel;
}

- (UIView *)sentenceView {
    if (_sentenceView != nil) {
        return _sentenceView;
    }
    
    _sentenceView = [[UIView alloc] init];
    return _sentenceView;
}


@end
