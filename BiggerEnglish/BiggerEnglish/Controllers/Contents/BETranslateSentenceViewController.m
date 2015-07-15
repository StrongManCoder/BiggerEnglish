//
//  BETranslateSentenceViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/26.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BETranslateSentenceViewController.h"
#import "BETranslateExampleSentenceCell.h"
#import "BETranslateCETSentenceCell.h"
#import "BETranslationSentenceModel.h"
#import "BECETSentenceModel.h"

@interface BETranslateSentenceViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BETranslateSentenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.title isEqualToString:@"例句"]) {
        static NSString *ID = @"ExampleSentenceCell";
        BETranslateExampleSentenceCell *cell = (BETranslateExampleSentenceCell *)[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[BETranslateExampleSentenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        BETranslationSentenceModel *model = self.array[indexPath.row];
        cell.content = model.Network_en;
        cell.translate = model.Network_cn;
        cell.mp3 = model.tts_mp3;
        cell.size = model.tts_size;
        return cell;
    }
    else {
        static NSString *ID = @"CETSentenceCell";
        BETranslateCETSentenceCell *cell = (BETranslateCETSentenceCell *)[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[BETranslateCETSentenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        BECETSentenceModel *model = self.array[indexPath.row];
        cell.content = model.sentence;
        cell.translate = model.come;
        return cell;
    }
}

- (void)configureView {
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.tableView];
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
    
    return _tableView;
}

@end
