//
//  BEMenuView.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/13.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEMenuView.h"
#import "BEMenuSectionView.h"

@interface BEMenuView ()

@property (nonatomic, strong) UIView      *backgroundContainView;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIImageView *leftShadowImageView;
@property (nonatomic, strong) UIView      *leftShdowImageMaskView;

@property (nonatomic, strong) BEMenuSectionView *sectionView;

@end

@implementation BEMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = NO;
        
        [self configureViews];
        [self configureShadowViews];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureViews {
    
    self.backgroundContainView               = [[UIView alloc] init];
    self.backgroundContainView.clipsToBounds = YES;
    [self addSubview:self.backgroundContainView];
    
    self.backgroundImageView = [[UIImageView alloc] init];
    [self.backgroundContainView addSubview:self.backgroundImageView];
    
    self.sectionView = [[BEMenuSectionView alloc] init];
    [self addSubview:self.sectionView];
    
    // Handles
    @weakify(self);
    [self.sectionView setDidSelectedIndexBlock:^(NSInteger index) {
        @strongify(self);
        
        if (self.didSelectedIndexBlock) {
            self.didSelectedIndexBlock(index);
        }
    }];
}

- (void)configureShadowViews {
    
    self.leftShdowImageMaskView               = [[UIView alloc] init];
    self.leftShdowImageMaskView.clipsToBounds = YES;
    [self addSubview:self.leftShdowImageMaskView];
    
    UIImage *shadowImage               = [UIImage imageNamed:@"Navi_Shadow"];
    shadowImage = shadowImage.imageForCurrentTheme;
    
    self.leftShadowImageView           = [[UIImageView alloc] initWithImage:shadowImage];
    self.leftShadowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    self.leftShadowImageView.alpha     = 0.0;
    [self.leftShdowImageMaskView addSubview:self.leftShadowImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.backgroundContainView.frame  = (CGRect){0, 0, self.width, ScreenHeight};
    self.backgroundImageView.frame    = (CGRect){ScreenWidth, 0, ScreenWidth, ScreenHeight};
    
    self.leftShdowImageMaskView.frame = (CGRect){self.width, 0, 10, ScreenHeight};
    self.leftShadowImageView.frame    = (CGRect){-5, 0, 10, ScreenHeight};
    
    self.sectionView.frame  = (CGRect){0, 0, self.width, ScreenHeight};
}

#pragma mark - Public Methods

- (void)setOffsetProgress:(CGFloat)progress {
    
    progress = MIN(MAX(progress, 0.0), 1.0);
    
    self.backgroundImageView.x     = self.width - ScreenWidth/2 * progress;
    
    self.leftShadowImageView.alpha = progress;
    self.leftShadowImageView.x     = -5 + progress * 5;
}

- (void)setBlurredImage:(UIImage *)blurredImage {
    _blurredImage = blurredImage;
    
    self.backgroundImageView.image = self.blurredImage;
}

#pragma mark - Notifications

- (void)didReceiveThemeChangeNotification {
    
    [self setNeedsLayout];
    
    UIImage *shadowImage           = [UIImage imageNamed:@"Navi_Shadow"];
    shadowImage                    = shadowImage.imageForCurrentTheme;
    
    self.leftShadowImageView.image = shadowImage;
    self.backgroundImageView.image = nil;
}

@end
