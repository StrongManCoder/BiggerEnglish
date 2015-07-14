//
//  BEWordBookTitleCell.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/7/9.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEWordBookTitleCell.h"

@interface BEWordBookTitleCell()

@property (nonatomic, strong) UIImageView *bookImage;

@end

@implementation BEWordBookTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor BEFrenchGrayColor];
        [self configureViews];
    }
    return self;
}

- (void)configureViews {
    [self.contentView addSubview:self.bookImage];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.wordCountLabel];
    [self.contentView addSubview:self.defaultView];
    
    [self.bookImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView).with.offset(15);
        make.width.mas_equalTo(@20);
        make.height.mas_equalTo(@20);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10);
        make.left.equalTo(self.bookImage.mas_right).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.bottom.equalTo(self.contentView).with.offset(-10);
    }];
    [self.wordCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.defaultView.mas_left).with.offset(-10);

    }];

    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
}

- (UIImageView *)bookImage {
    if (_bookImage != nil) {
        return _bookImage;
    }
    _bookImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bookImage.image = [[UIImage imageNamed:@"section_categories"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    
    return _bookImage;
}

- (UILabel *)titleLabel {
    if (_titleLabel != nil) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor BEDeepFontColor];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    
    return _titleLabel;
}

- (UILabel *)wordCountLabel {
    if (_wordCountLabel != nil) {
        return _wordCountLabel;
    }
    _wordCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _wordCountLabel.textAlignment = NSTextAlignmentLeft;
    _wordCountLabel.textColor = [UIColor BEDeepFontColor];
    _wordCountLabel.font = [UIFont systemFontOfSize:15];
    
    return _wordCountLabel;
}

- (UIImageView *)defaultView {
    if (_defaultView != nil) {
        return _defaultView;
    }
    _defaultView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _defaultView.image = [[UIImage imageNamed:@"icon_yes"] imageWithTintColor:[UIColor BEHighLightFontColor]];
    
    return _defaultView;
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
