//
//  BEReadViewCell.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/4.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEReadViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BEReadViewCell()

@property (nonatomic, strong) UIView *viewBackground;
@property (nonatomic, strong) UIImageView *imagePic;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelContent;

@end

@implementation BEReadViewCell

@synthesize pic = _pic;
@synthesize title = _title;
@synthesize content = _content;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor BEFrenchGrayColor];
        [self configureViews];
    }
    return self;
}

- (void)awakeFromNib {
    
}

- (void)configureViews {
    [self.contentView addSubview:self.viewBackground];
    [self.contentView addSubview:self.imagePic];
    [self.contentView addSubview:self.labelTitle];
    [self.contentView addSubview:self.labelContent];
    
    //iphone
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        int width = (ScreenWidth - 40) * 5 / 8;
        [self.imagePic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(20);
            make.left.equalTo(self.contentView).with.offset(20);
            make.right.equalTo(self.contentView).with.offset(-20);
            make.bottom.equalTo(self.labelTitle.mas_top).with.offset(-10);
            make.height.mas_equalTo(width);
        }];
        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imagePic.mas_bottom).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(20);
            make.right.equalTo(self.contentView).with.offset(-20);
            make.bottom.equalTo(self.labelContent.mas_top).with.offset(-10);
        }];
        [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelTitle.mas_bottom).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(20);
            make.right.equalTo(self.contentView).with.offset(-20);
            make.bottom.equalTo(self.contentView).with.offset(-10);
        }];
        [self.viewBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.bottom.equalTo(self.contentView).with.offset(0);
        }];
    }
    else {  //ipad
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIView *)viewBackground {
    if (_viewBackground != nil) {
        return _viewBackground;
    }
    _viewBackground = [[UIView alloc] init];
    _viewBackground.backgroundColor = [UIColor whiteColor];
    _viewBackground.layer.borderWidth = 0.5;
    _viewBackground.layer.borderColor = [UIColor BEDeepFontColor].CGColor;
    _viewBackground.layer.cornerRadius = 3;
    return _viewBackground;
}

- (UIImageView *)imagePic {
    if (_imagePic != nil) {
        return _imagePic;
    }
    _imagePic = [[UIImageView alloc] init];
    
    return _imagePic;
}

- (UILabel *)labelTitle {
    if (_labelTitle != nil) {
        return _labelTitle;
    }
    
    _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _labelTitle.textAlignment = NSTextAlignmentLeft;
    _labelTitle.textColor = [UIColor BEFontColor];
    _labelTitle.font = [UIFont systemFontOfSize:16];
    _labelTitle.numberOfLines = 0;
    _labelTitle.preferredMaxLayoutWidth = ScreenWidth - 40;
    
    return _labelTitle;
}

- (UILabel *)labelContent {
    if (_labelContent != nil) {
        return _labelContent;
    }
    _labelContent = [[UILabel alloc] initWithFrame:CGRectZero];
    _labelContent.textAlignment = NSTextAlignmentLeft;
    _labelContent.textColor = [UIColor BEDeepFontColor];
    _labelContent.font = [UIFont systemFontOfSize:14];
    _labelContent.numberOfLines = 0;
    _labelContent.preferredMaxLayoutWidth = ScreenWidth - 40;
    
    return _labelContent;
}

- (void)setPic:(NSString *)pic {
    _pic = pic;
    [_imagePic sd_setImageWithURL:[NSURL URLWithString:pic]
                 placeholderImage:nil];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _labelTitle.text = title;
}

- (void)setContent:(NSString *)content {
    _content = content;
    _labelContent.text = content;
}


@end
