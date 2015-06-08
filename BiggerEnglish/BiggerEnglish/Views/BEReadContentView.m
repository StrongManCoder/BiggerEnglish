//
//  BEReadContentView.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/8.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEReadContentView.h"

@interface BEReadContentView()

@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIImageView *imagePic;
@property (nonatomic, strong) UILabel *labelContent;

@end

@implementation BEReadContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.labelTitle];
        [self addSubview:self.imagePic];
        [self addSubview:self.labelContent];

//        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).with.offset(10);
//            make.left.equalTo(self).with.offset(10);
//            make.right.equalTo(self).with.offset(-10);
//            make.bottom.equalTo(self.imagePic.mas_top).with.offset(-10);
//        }];
//        [self.imagePic mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.labelTitle.mas_bottom).with.offset(10);
//            make.width.mas_equalTo(ScreenWidth - 20);
//            make.height.mas_equalTo((ScreenWidth - 20) * 450 / 720);
//            make.left.equalTo(self).with.offset(10);
//            make.right.equalTo(self).with.offset(-10);
//            make.bottom.equalTo(self.scrollView.mas_bottom).with.offset(-10);
//        }];
//        [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.imagePic.mas_bottom).with.offset(10);
//            make.width.mas_equalTo(ScreenWidth - 20);
//            
//            make.width.mas_equalTo(300);
//            
//            make.left.equalTo(self.scrollView.mas_left).with.offset(10);
//            make.right.equalTo(self.scrollView.mas_right).with.offset(-10);
//            make.bottom.equalTo(self.scrollView.mas_bottom).with.offset(-10);
//        }];
        
    }
    return self;
}

- (UILabel *)labelTitle {
    if (_labelTitle != nil) {
        return _labelTitle;
    }
    _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.textColor = [UIColor BEFontColor];
    _labelTitle.font = [UIFont systemFontOfSize:16];
    _labelTitle.numberOfLines = 0;
    _labelTitle.preferredMaxLayoutWidth = ScreenWidth - 20;
    
    return _labelTitle;
}

- (UIImageView *)imagePic {
    if (_imagePic != nil) {
        return _imagePic;
    }
    _imagePic = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imagePic.contentMode = UIViewContentModeScaleAspectFit;
    
    return _imagePic;
}

- (UILabel *)labelContent {
    if (_labelContent != nil) {
        return _labelContent;
    }
    _labelContent = [[UILabel alloc] initWithFrame:CGRectZero];
    _labelContent.textAlignment = NSTextAlignmentLeft;
    _labelContent.textColor = [UIColor BEFontColor];
    _labelContent.font = [UIFont systemFontOfSize:30];
    _labelContent.numberOfLines = 0;
    _labelContent.preferredMaxLayoutWidth = ScreenWidth - 20;
    
    return _labelContent;
}

@end
