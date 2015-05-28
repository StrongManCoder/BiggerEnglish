//
//  BEDailyCommentCell.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/28.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEDailyCommentCell.h"

@implementation BEDailyCommentCell

@synthesize rtLabel = _rtLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _rtLabel = [BEDailyCommentCell textLabel];
        _rtLabel.lineSpacing = 3;
        [self.contentView addSubview:_rtLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self configureViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize optimumSize = [self.rtLabel optimumSize];
    CGRect frame = [self.rtLabel frame];
    frame.size.height = (int)optimumSize.height;
    [self.rtLabel setFrame:frame];
}

- (void)configureViews {

}

+ (RTLabel*)textLabel {
    RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(15, 15, ScreenWidth - 30,0)];
    [label setParagraphReplacement:@""];
    return label;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
