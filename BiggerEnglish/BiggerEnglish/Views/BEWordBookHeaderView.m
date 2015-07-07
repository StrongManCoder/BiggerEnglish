//
//  BEWordBookHeaderView.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/7/7.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEWordBookHeaderView.h"

@interface BEWordBookHeaderView()

@property (nonatomic, strong) UIView *wordView;
@property (nonatomic, strong) UIView *historyView;

@property (nonatomic, strong) UIButton *addWordBookButton;

@end

@implementation BEWordBookHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor BEFrenchGrayColor];
        [self addSubview:self.wordView];
        [self addSubview:self.historyView];
        [self addSubview:self.addWordBookButton];
    }
    return self;
}

- (UIView *)wordView {
    if (_wordView != nil) {
        return _wordView;
    }
    _wordView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, (ScreenWidth - 30) / 2, (ScreenWidth - 30) / 2)];
    _wordView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wordViewAction)];
    [_wordView addGestureRecognizer:singleTap];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, _wordView.width, _wordView.height / 2)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    if (DeviceIsPhone) {
        titleLabel.font = [UIFont boldSystemFontOfSize:30];
    } else {
        titleLabel.font = [UIFont boldSystemFontOfSize:80];
    }
    titleLabel.backgroundColor = [UIColor BEHighLightFontColor];
    titleLabel.text = @"Words";
    [_wordView addSubview:titleLabel];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _wordView.height / 2, _wordView.width, _wordView.height / 4)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor BEFontColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    nameLabel.text = @"我的生词本";
    [_wordView addSubview:nameLabel];

    UILabel *descriptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (_wordView.height / 2) + 10, _wordView.width, _wordView.height / 2)];
    descriptLabel.textAlignment = NSTextAlignmentCenter;
    descriptLabel.textColor = [UIColor BEDeepFontColor];
    descriptLabel.font = [UIFont systemFontOfSize:14];
    descriptLabel.text = @"收录了n个单词";
    [_wordView addSubview:descriptLabel];

    return _wordView;
}

- (UIView *)historyView {
    if (_historyView != nil) {
        return _historyView;
    }
    _historyView = [[UIView alloc] initWithFrame:CGRectMake(20 + (ScreenWidth - 30) / 2, 15, (ScreenWidth - 30) / 2, (ScreenWidth - 30) / 2)];
    _historyView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(historyViewAction)];
    [_historyView addGestureRecognizer:singleTap];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, _wordView.width, _wordView.height / 2)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    if (DeviceIsPhone) {
        titleLabel.font = [UIFont boldSystemFontOfSize:30];
    } else {
        titleLabel.font = [UIFont boldSystemFontOfSize:80];
    }
    titleLabel.backgroundColor = [UIColor BEHighLightFontColor];
    titleLabel.text = @"History";
    [_historyView addSubview:titleLabel];

    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _wordView.height / 2, _wordView.width, _wordView.height / 4)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor BEFontColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    nameLabel.text = @"历史纪录";
    [_historyView addSubview:nameLabel];

    UILabel *descriptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (_wordView.height / 2) + 10, _wordView.width, _wordView.height / 2)];
    descriptLabel.textAlignment = NSTextAlignmentCenter;
    descriptLabel.textColor = [UIColor BEDeepFontColor];
    descriptLabel.font = [UIFont systemFontOfSize:14];
    descriptLabel.text = @"已查了n个词";
    [_historyView addSubview:descriptLabel];

    return _historyView;
}

- (UIButton *)addWordBookButton {
    if (_addWordBookButton != nil) {
        return _addWordBookButton;
    }
    _addWordBookButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _addWordBookButton.frame = CGRectMake(ScreenWidth / 2 - 100, 20 + ((ScreenWidth - 30) / 2), 200, 30);
    _addWordBookButton.tintColor = [UIColor BEHighLightFontColor];
    _addWordBookButton.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [_addWordBookButton setTitle:@"点击添加单词本" forState:UIControlStateNormal];
    [_addWordBookButton addTarget:self action:@selector(addWordBookAction) forControlEvents:UIControlEventTouchUpInside];

    return _addWordBookButton;
}

- (void)addWordBookAction {
    self.addWordBookBlock();
}

- (void)wordViewAction {
    self.wordViewBlock();
}

- (void)historyViewAction {
    self.historyViewBlock();
}

@end
