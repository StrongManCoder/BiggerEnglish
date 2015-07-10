//
//  BEWordBookTitleCell.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/7/9.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEWordBookTitleCell.h"

@interface BEWordBookTitleCell()


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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.defaultView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10);
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.bottom.equalTo(self.contentView).with.offset(-10);
    }];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
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
