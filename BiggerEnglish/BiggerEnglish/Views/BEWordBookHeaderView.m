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

@property (nonatomic, strong) UIImageView *plusImage;
@property (nonatomic, strong) UIButton *addWordBookButton;
@property (nonatomic, strong) UILabel *wordViewDescriptLabel;
@property (nonatomic, strong) UILabel *historyViewDescriptLabel;

@end

@implementation BEWordBookHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor BEFrenchGrayColor];
        [self addSubview:self.wordView];
        [self addSubview:self.historyView];
        [self addSubview:self.plusImage];
        [self addSubview:self.addWordBookButton];
    }
    return self;
}

- (void)setWordViewText:(NSString *)wordViewText {
    _wordViewText = wordViewText;
    self.wordViewDescriptLabel.text = [NSString stringWithFormat:@"收录 %@ 个单词", wordViewText];
}

- (void)setHistoryViewText:(NSString *)historyViewText {
    _historyViewText = historyViewText;
    self.historyViewDescriptLabel.text = [NSString stringWithFormat:@"已查 %@ 个词", historyViewText];
}

- (UIView *)wordView {
    if (_wordView != nil) {
        return _wordView;
    }
    _wordView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, (ScreenWidth - 30) / 2, (ScreenWidth - 30) / 2)];
    _wordView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wordViewAction)];
    [_wordView addGestureRecognizer:singleTap];
    UILongPressGestureRecognizer * wordViewLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(wordViewLongPressAction:)];
    wordViewLongPress.minimumPressDuration = 1.0;
    [_wordView addGestureRecognizer:wordViewLongPress];

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

    _wordViewDescriptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (_wordView.height / 2) + 10, _wordView.width, _wordView.height / 2)];
    _wordViewDescriptLabel.textAlignment = NSTextAlignmentCenter;
    _wordViewDescriptLabel.textColor = [UIColor BEDeepFontColor];
    _wordViewDescriptLabel.font = [UIFont systemFontOfSize:14];
    _wordViewDescriptLabel.text = @"收录了n个单词";
    [_wordView addSubview:_wordViewDescriptLabel];

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
    UILongPressGestureRecognizer * historyViewLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(historyViewLongPressAction:)];
    historyViewLongPress.minimumPressDuration = 1.0;
    [_historyView addGestureRecognizer:historyViewLongPress];

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

    _historyViewDescriptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (_wordView.height / 2) + 10, _wordView.width, _wordView.height / 2)];
    _historyViewDescriptLabel.textAlignment = NSTextAlignmentCenter;
    _historyViewDescriptLabel.textColor = [UIColor BEDeepFontColor];
    _historyViewDescriptLabel.font = [UIFont systemFontOfSize:14];
    _historyViewDescriptLabel.text = @"已查了n个词";
    [_historyView addSubview:_historyViewDescriptLabel];

    return _historyView;
}

- (UIButton *)addWordBookButton {
    if (_addWordBookButton != nil) {
        return _addWordBookButton;
    }
    _addWordBookButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _addWordBookButton.frame = CGRectMake(ScreenWidth / 2 - 100, 20 + ((ScreenWidth - 30) / 2), 200, 30);
    _addWordBookButton.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [_addWordBookButton setTitleColor:[UIColor BEHighLightFontColor] forState:UIControlStateNormal];
    [_addWordBookButton setTitle:@"点击新建单词本" forState:UIControlStateNormal];
    [_addWordBookButton addTarget:self action:@selector(addWordBookAction) forControlEvents:UIControlEventTouchUpInside];
    
    return _addWordBookButton;
}

- (UIImageView *)plusImage {
    if (_plusImage != nil) {
        return _plusImage;
    }
    _plusImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 80, 25 + ((ScreenWidth - 30) / 2), 20, 20)];
    _plusImage.image = [[UIImage imageNamed:@"icon_plus"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    
    return _plusImage;
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

- (void)wordViewLongPressAction:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.wordViewLongPressBlock();
    }
}

- (void)historyViewLongPressAction:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.historyViewLongPressBlock();
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.4);
    CGContextSetStrokeColorWithColor(context, [UIColor BESeparatorLineColor].CGColor);
    CGContextMoveToPoint(context, 10, self.frame.size.height - 1);
    CGContextAddLineToPoint(context, ScreenWidth, self.frame.size.height - 1);
    CGContextStrokePath(context);
}


@end
