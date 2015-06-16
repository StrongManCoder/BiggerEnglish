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

@property (nonatomic, strong) UITextField *textField;

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
    self.navigationItem.titleView = self.textField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self networkRequest];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self textFieldResignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//收起键盘
- (void) textFieldResignFirstResponder{
    [self.textField resignFirstResponder];
}

#pragma mark - Event Response

- (void)navigateSetting {
    [self.textField resignFirstResponder];

    [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
}

- (void)networkRequest {
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"mainstream",@"word", nil];
    
    [[AFHTTPRequestOperationManager manager] POST:@"http://dict-mobile.iciba.com/interface/index.php?client=4&type=1&timestamp=1434339925&sign=278e1fd748b1441a&c=word&m=index&list=1,7,2002,8,21,22"
                                       parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           BETranslationModel *model = [BETranslationModel jsonToObject:operation.responseString];
                                           NSLog(@"%@",model.message.baesInfo.word_name);
                                           NSLog(@"%@",[model.message.baesInfo.exchange.word_pl objectAtIndex:0]);
                                           NSLog(@"%@",model.message.sentence );
                                           
                                           
                                           
                                           NSArray *array = [BETranslationSentenceModel objectArrayWithKeyValuesArray:model.message.sentence];
                                           for (BETranslationSentenceModel *translationSentenceModel in array) {
                                               NSLog(@"%@",translationSentenceModel.Network_en);
                                           }
                                           
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           
                                           NSLog(@"%@ error", operation.description);
                                           
                                       }];
    
}

#pragma mark - Private Methods

-(void)configureLeftItems {
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

#pragma mark - Getters and Setters

- (UITextField *)textField {
    if (_textField != nil) {
        return _textField;
    }
    
    _textField                           = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    _textField.textColor                 = [UIColor BEDeepFontColor];
    _textField.font                      = [UIFont systemFontOfSize:16];
    _textField.placeholder               = @"要翻译的单词和句子～";
    _textField.adjustsFontSizeToFitWidth = YES;
    _textField.clearButtonMode           = UITextFieldViewModeWhileEditing;
    _textField.borderStyle               = UITextBorderStyleRoundedRect;
    _textField.returnKeyType             = UIReturnKeySearch;
    _textField.enablesReturnKeyAutomatically = YES;
    _textField.delegate = self;
    return _textField;
}

@end
