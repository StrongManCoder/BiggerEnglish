//
//  BEWordBookCell.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/7/7.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEWordBookCell.h"

@interface BEWordBookCell()


@end

@implementation BEWordBookCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor BEFrenchGrayColor];
        [self configureViews];
    }
    return self;
}

- (void)configureViews {
    [self.contentView addSubview:self.wordLabel];
    [self.contentView addSubview:self.translateLabel];
    [self.contentView addSubview:self.rowNumberLabel];
    
    [self.wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(5);
        make.left.equalTo(self.contentView).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-5);
        make.bottom.equalTo(self.translateLabel.mas_top).with.offset(0);
        make.height.mas_equalTo(@30);
    }];
    [self.translateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wordLabel.mas_bottom).with.offset(0);
        make.left.equalTo(self.contentView).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-5);
        make.bottom.equalTo(self.rowNumberLabel.mas_top).with.offset(-5);
    }];
    [self.rowNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.translateLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.contentView).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-5);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(@30);
    }];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.4);
    CGContextSetStrokeColorWithColor(context, [UIColor BESeparatorLineColor].CGColor);
    CGContextMoveToPoint(context, 0, self.frame.size.height - 1);
    CGContextAddLineToPoint(context, self.frame.size.width - 10, self.frame.size.height - 1);
    CGContextStrokePath(context);
}

- (UILabel *)wordLabel {
    if (_wordLabel != nil) {
        return _wordLabel;
    }
    _wordLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _wordLabel.textAlignment = NSTextAlignmentLeft;
    _wordLabel.textColor = [UIColor BEFontColor];
    _wordLabel.font = [UIFont systemFontOfSize:16];
    _wordLabel.numberOfLines = 1;
    _wordLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    return _wordLabel;
}

- (UILabel *)translateLabel {
    if (_translateLabel != nil) {
        return _translateLabel;
    }
    _translateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _translateLabel.textAlignment = NSTextAlignmentLeft;
    _translateLabel.textColor = [UIColor BEDeepFontColor];
    _translateLabel.font = [UIFont systemFontOfSize:15];
    _translateLabel.numberOfLines = 0;
    _translateLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    return _translateLabel;
}

- (UILabel *)rowNumberLabel {
    if (_rowNumberLabel != nil) {
        return _rowNumberLabel;
    }
    _rowNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _rowNumberLabel.textAlignment = NSTextAlignmentRight;
    _rowNumberLabel.textColor = [UIColor BEDeepFontColor];
    _rowNumberLabel.font = [UIFont systemFontOfSize:15];
    _rowNumberLabel.numberOfLines = 0;
    
    return _rowNumberLabel;
}

@end
