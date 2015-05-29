//
//  BEFavouriteViewCell.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/29.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEFavouriteViewCell.h"

@interface BEFavouriteViewCell()

@property (nonatomic, strong) UILabel *labelDate;
@property (nonatomic, strong) UILabel *labelContent;
@property (nonatomic, strong) UILabel *labelNote;

@end

@implementation BEFavouriteViewCell

@synthesize labelDate = _labelDate;
@synthesize labelContent = _labelContent;
@synthesize labelNote = _labelNote;
@synthesize date = _date;
@synthesize content = _content;
@synthesize note = _note;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self configureViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)configureViews {

    [self.contentView addSubview:self.labelDate];
    [self.contentView addSubview:self.labelContent];
    [self.contentView addSubview:self.labelNote];
    
    [self.labelDate mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).with.offset(-50);
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.bottom.equalTo(self.labelContent).with.offset(-10);
    }];
    
    [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.labelDate).with.offset(60);
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.bottom.equalTo(self.labelNote).with.offset(-10);
    }];
    
    [self.labelNote mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.labelContent).with.offset(70);
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.bottom.equalTo(self.contentView).with.offset(-10);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UILabel *)labelDate {
    if (_labelDate != nil) {
        return _labelDate;
    }
    _labelDate = [[UILabel alloc] init];
    _labelDate.textAlignment = NSTextAlignmentLeft;
    _labelDate.textColor = [UIColor BEHighLightFontColor];
    _labelDate.font = [UIFont systemFontOfSize:20];

    return _labelDate;
}


- (UILabel *)labelContent {
    if (_labelContent != nil) {
        return _labelContent;
    }
    _labelContent = [[UILabel alloc] init];
    _labelContent.textAlignment = NSTextAlignmentLeft;
    _labelContent.textColor = [UIColor BEFontColor];
    _labelContent.font = [UIFont systemFontOfSize:16];
    _labelContent.numberOfLines = 0;

    return _labelContent;
}

- (UILabel *)labelNote {
    if (_labelNote != nil) {
        return _labelNote;
    }
    _labelNote = [[UILabel alloc] init];
    _labelNote.textAlignment = NSTextAlignmentLeft;
    _labelNote.textColor = [UIColor BEDeepFontColor];
    _labelNote.font = [UIFont systemFontOfSize:16];
    _labelNote.numberOfLines = 0;
    
    return _labelNote;
}

- (void)setDate:(NSString *)date {
    NSArray * array = [date componentsSeparatedByString:@"-"];
    NSString *stringDay = [array objectAtIndex:2];
    NSDictionary *dictionaryMonth = @{ @"01": @"January", @"02": @"February", @"03": @"March", @"04": @"April", @"05": @"May", @"06": @"June", @"07": @"July", @"08": @"August", @"09": @"September", @"10": @"October", @"11": @"November", @"12": @"December" };
    NSString *stringMonth = [dictionaryMonth valueForKey:[array objectAtIndex:1]];
    _date = [[stringDay stringByAppendingString:@" "] stringByAppendingString:stringMonth];
    _labelDate.text = _date;
}

- (void)setContent:(NSString *)content {
    _content = content;
    _labelContent.text = content;
}

- (void)setNote:(NSString *)note {
    _note = note;
    _labelNote.text = note;
}

@end
