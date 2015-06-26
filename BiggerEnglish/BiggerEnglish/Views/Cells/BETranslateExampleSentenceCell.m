//
//  BETranslateExampleSentenceCell.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/26.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BETranslateExampleSentenceCell.h"

@interface BETranslateExampleSentenceCell()

@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UITextView *translateTextView;
@property (nonatomic, strong) UIImageView *playImage;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UIImageView *imageSeparator;

@end

@implementation BETranslateExampleSentenceCell

@synthesize content = _content;
@synthesize translate = _translate;
@synthesize mp3 = _mp3;
@synthesize size = _size;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureViews];
    }
    return self;
}

- (void)configureViews {
    [self.contentView addSubview:self.contentTextView];
    [self.contentView addSubview:self.translateTextView];
    [self.contentView addSubview:self.playImage];
    [self.contentView addSubview:self.sizeLabel];
    [self.contentView addSubview:self.imageSeparator];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(0);
        make.left.equalTo(self.contentView).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-60);
        make.bottom.equalTo(self.translateTextView.mas_top).with.offset(8);
    }];
    [self.translateTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTextView.mas_bottom).with.offset(-8);
        make.left.equalTo(self.contentView).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-60);
        make.bottom.equalTo(self.imageSeparator.mas_top).with.offset(0);
    }];
    [self.playImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@25);
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playImage.mas_bottom).with.offset(-5);
        make.centerX.mas_equalTo(self.playImage.mas_centerX);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@30);
    }];
    [self.imageSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(0);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(@0.6);
    }];
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentTextView.text = content;
}

- (void)setTranslate:(NSString *)translate {
    _translate = translate;
    self.translateTextView.text = translate;
}

- (void)setMp3:(NSString *)mp3 {
    _mp3 = mp3;
}

- (void)setSize:(NSString *)size {
    _size = size;
    self.sizeLabel.text = size;
}

- (UITextView *)contentTextView {
    if (_contentTextView != nil) {
        return _contentTextView;
    }
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 20, 30)];
    _contentTextView.textColor = [UIColor BEFontColor];
    _contentTextView.font = [UIFont systemFontOfSize:16];
    _contentTextView.scrollEnabled = NO;
    _contentTextView.editable = NO;
    
    return _contentTextView;
}

- (UITextView *)translateTextView {
    if (_translateTextView != nil) {
        return _translateTextView;
    }
    _translateTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 20, 30)];
    _translateTextView.textColor = [UIColor BEDeepFontColor];
    _translateTextView.font = [UIFont systemFontOfSize:16];
    _translateTextView.scrollEnabled = NO;
    _translateTextView.editable = NO;
    
    return _translateTextView;
}

- (UIImageView *)playImage {
    if (_playImage != nil) {
        return _playImage;
    }
    _playImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _playImage.image = [[UIImage imageNamed:@"icon_sound2"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    _playImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *imagePlaySingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImagePlayClick)];
    [_playImage addGestureRecognizer:imagePlaySingleTap];

    return _playImage;
}

- (UILabel *)sizeLabel {
    if (_sizeLabel != nil) {
        return _sizeLabel;
    }
    _sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _sizeLabel.textAlignment = NSTextAlignmentLeft;
    _sizeLabel.textColor = [UIColor BEDeepFontColor];
    _sizeLabel.font = [UIFont systemFontOfSize:14];
    _sizeLabel.numberOfLines = 0;
    
    return _sizeLabel;
}

- (UIImageView *)imageSeparator {
    if (_imageSeparator != nil) {
        return _imageSeparator;
    }
    _imageSeparator = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageSeparator.backgroundColor = [UIColor BEHighLightFontColor];
    _imageSeparator.contentMode = UIViewContentModeScaleAspectFill;
    _imageSeparator.image = [UIImage imageNamed:@"section_divide"];
    _imageSeparator.clipsToBounds = YES;
    
    return _imageSeparator;
}

@end
