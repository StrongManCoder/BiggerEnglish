//
//  BETranslateViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/13.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BETranslateViewController.h"
#import "BETranslationModel.h"

@implementation BETranslateViewController

- (void)loadView {
    [super loadView];
    
    [self configureLeftButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self networkRequest];
}

-(void)configureLeftButton {
    UIButton *leftButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame       = CGRectMake(0, 0, 25, 25);
    [leftButton setAdjustsImageWhenHighlighted:YES];
    UIImage *image = [UIImage imageNamed:@"icon_hamberger"];
    [leftButton setImage:[image imageWithTintColor:[UIColor BEDeepFontColor]] forState:UIControlStateNormal];
    [leftButton setImage:[image imageWithTintColor:[UIColor BEHighLightFontColor]] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(navigateSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem              = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = barItem;
}

- (void)navigateSetting {
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

@end
