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

@property (nonatomic, strong) UIImageView *imagePic;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelContent;
@property (nonatomic, strong) UIImageView *imageSeparator;

@end

@implementation BEReadViewCell
int width;
@synthesize pic = _pic;
@synthesize title = _title;
@synthesize content = _content;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        width = (ScreenWidth - 40) * 5 / 8;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        [self configureViews];
    }
    return self;
}

- (void)awakeFromNib {
    
}

- (void)configureViews {
    [self.contentView addSubview:self.imagePic];
    [self.contentView addSubview:self.labelTitle];
    [self.contentView addSubview:self.labelContent];
    [self.contentView addSubview:self.imageSeparator];
    
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        _labelTitle.preferredMaxLayoutWidth = ScreenWidth - 90;
        _labelContent.preferredMaxLayoutWidth = ScreenWidth - 90;

        [self.imagePic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(10);
            make.bottom.equalTo(self.labelContent.mas_top).with.offset(0);
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(60);
        }];
        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.equalTo(self.imagePic.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.bottom.equalTo(self.labelContent.mas_top).with.offset(-5);
        }];
        [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imagePic.mas_bottom).with.offset(0);
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.bottom.equalTo(self.imageSeparator.mas_top).with.offset(-5);
        }];
        [self.imageSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelContent.mas_bottom).with.offset(5);
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(0);
            make.bottom.equalTo(self.contentView).with.offset(0);
            make.height.mas_equalTo(@0.6);
        }];
    }
    else {
        
        _labelTitle.preferredMaxLayoutWidth = ScreenWidth - 110;
        _labelContent.preferredMaxLayoutWidth = ScreenWidth - 110;
        
        [self.imagePic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(10);
            make.bottom.equalTo(self.imageSeparator.mas_top).with.offset(-10);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(80);
        }];
        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.equalTo(self.imagePic.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.bottom.equalTo(self.labelContent.mas_top).with.offset(-5);
        }];
        [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelTitle.mas_bottom).with.offset(5);
            make.left.equalTo(self.imagePic.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.bottom.equalTo(self.imageSeparator.mas_top).with.offset(-5);
        }];
        [self.imageSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelContent.mas_bottom).with.offset(5);
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(0);
            make.bottom.equalTo(self.contentView).with.offset(0);
            make.height.mas_equalTo(@0.6);
        }];
    }
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateConstraintsIfNeeded];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
}

- (UIImageView *)imagePic {
    if (_imagePic != nil) {
        return _imagePic;
    }
    _imagePic = [[UIImageView alloc] init];
    _imagePic.contentMode = UIViewContentModeScaleAspectFit;
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
    _labelTitle.preferredMaxLayoutWidth = ScreenWidth - 90;
    
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
    _labelContent.preferredMaxLayoutWidth = ScreenWidth - 90;
    
    return _labelContent;
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

- (void)setPic:(NSString *)pic {
    _pic = pic;
    [_imagePic sd_setImageWithURL:[NSURL URLWithString:pic]
                 placeholderImage:nil
                          options:SDWebImageCacheMemoryOnly];
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
