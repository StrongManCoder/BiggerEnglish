//
//  BEMenuSectionCell.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/13.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEMenuSectionCell.h"

static CGFloat const kCellHeight = 60;
static CGFloat const kFontSize   = 16;

@interface BEMenuSectionCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel     *titleLabel;

@property (nonatomic, strong) UIImage     *normalImage;
@property (nonatomic, strong) UIImage     *highlightedImage;
@property (nonatomic, strong) UILabel     *badgeLabel;

@property (nonatomic, assign) BOOL cellHighlighted;

@end

@implementation BEMenuSectionCell

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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    //    if (selected) {
    //
    //        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    //            self.cellHighlighted = selected;
    //        } completion:nil];
    //    } else {
    //
    //        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    //            self.cellHighlighted = selected;
    //        } completion:nil];
    //    }
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.cellHighlighted = selected;
    } completion:nil];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (self.isSelected) {
        return;
    }
    
    //    if (highlighted) {
    //
    //        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    //            self.cellHighlighted = highlighted;
    //        } completion:nil];
    //    } else {
    //
    //        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    //            self.cellHighlighted = highlighted;
    //        } completion:nil];
    //    }
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.cellHighlighted = highlighted;
    } completion:nil];
}

- (void)setCellHighlighted:(BOOL)cellHighlighted {
    _cellHighlighted = cellHighlighted;
    
    if (cellHighlighted) {
        
        self.titleLabel.textColor = [UIColor BEHighLightFontColor];
        self.backgroundColor = [UIColor BEFrenchGrayColor];
        self.iconImageView.image = self.highlightedImage;
    } else {
        
        self.titleLabel.textColor = [UIColor BEDeepFontColor];
        self.backgroundColor = [UIColor clearColor];
        self.iconImageView.image = self.normalImage;
    }
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = (CGRect){20, 21, 18, 18};
    self.titleLabel.frame    = (CGRect){55, 0, 110, self.height};
}

#pragma mark - Configure Views

- (void)configureViews {
    
    self.iconImageView              = [[UIImageView alloc] init];
    self.iconImageView.contentMode  = UIViewContentModeScaleAspectFill;
    [self addSubview:self.iconImageView];
    
    self.titleLabel                 = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor       = [UIColor BEDeepFontColor];
    self.titleLabel.textAlignment   = NSTextAlignmentLeft;
    self.titleLabel.font            = [UIFont systemFontOfSize:kFontSize];
    [self addSubview:self.titleLabel];
}

#pragma mark - Data Methods
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = self.title;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    
    NSString *highlightedImageName = [self.imageName stringByAppendingString:@"_highlighted"];
    
    /*
     self.highlightedImage= [[UIImage imageNamed:self.imageName] imageWithTintColor:kColorBlue];
     self.normalImage  = [[UIImage imageNamed:highlightedImageName] imageWithTintColor:kFontColorBlackMid];
     
     self.normalImage = self.normalImage.imageForCurrentTheme;
     self.iconImageView.alpha = kSetting.imageViewAlphaForCurrentTheme;
     */
    
    self.highlightedImage= [[UIImage imageNamed:self.imageName] imageWithTintColor:[UIColor BEHighLightFontColor]];
    self.normalImage  = [[UIImage imageNamed:highlightedImageName] imageWithTintColor:[UIColor BEDeepFontColor]];
    
    self.normalImage = self.normalImage.imageForCurrentTheme;
    self.iconImageView.alpha = 1;
}

- (void)setBadge:(NSString *)badge {
    _badge = badge;
    
    static const CGFloat kBadgeWidth = 6;
    
    if (!self.badgeLabel && badge) {
        self.badgeLabel = [[UILabel alloc] init];
        self.badgeLabel.backgroundColor = [UIColor redColor];
        self.badgeLabel.textColor = [UIColor whiteColor];
        self.badgeLabel.hidden = YES;
        self.badgeLabel.font = [UIFont systemFontOfSize:5];
        self.badgeLabel.layer.cornerRadius = kBadgeWidth/2.0;
        self.badgeLabel.clipsToBounds = YES;
        [self addSubview:self.badgeLabel];
    }
    
    if (badge) {
        self.badgeLabel.hidden = NO;
    } else {
        self.badgeLabel.hidden = YES;
    }
    
    self.badgeLabel.frame = (CGRect){80, 10, kBadgeWidth, kBadgeWidth};
    self.badgeLabel.text = badge;
}

#pragma mark - Class Methods

+ (CGFloat)getCellHeight {
    
    return kCellHeight;
}

@end