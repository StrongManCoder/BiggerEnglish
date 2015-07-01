//
//  BETranslateCETSentenceCell.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/26.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BETranslateCETSentenceCell.h"

@interface BETranslateCETSentenceCell()

@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UITextView *translateTextView;

@end

@implementation BETranslateCETSentenceCell


@synthesize content = _content;
@synthesize translate = _translate;

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
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(0);
        make.left.equalTo(self.contentView).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-5);
        make.bottom.equalTo(self.translateTextView.mas_top).with.offset(8);
    }];
    [self.translateTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTextView.mas_bottom).with.offset(-8);
        make.left.equalTo(self.contentView).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-5);
        make.bottom.equalTo(self.contentView).with.offset(-3);
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
