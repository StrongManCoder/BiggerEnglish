//
//  BETranslateCheckMoreCell.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/26.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BETranslateCheckMoreCell.h"

@implementation BETranslateCheckMoreCell

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
    [self.contentView addSubview:self.checkMoreButton];
    [self.checkMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.bottom.equalTo(self.contentView).with.offset(-5);
    }];
}

- (UIButton *)checkMoreButton {
    if (_checkMoreButton != nil) {
        return _checkMoreButton;
    }
    _checkMoreButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _checkMoreButton.frame = CGRectMake(0, 0, 80, 30);
    _checkMoreButton.tintColor = [UIColor BEHighLightFontColor];
    _checkMoreButton.backgroundColor = [UIColor whiteColor];
    _checkMoreButton.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [_checkMoreButton setTitle:@"查看更多" forState:UIControlStateNormal];
    
    return _checkMoreButton;
}

@end
