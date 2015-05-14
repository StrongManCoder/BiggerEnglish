//
//  BEMenuView.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/13.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BEMenuView : UIView

@property (nonatomic, copy) void (^didSelectedIndexBlock)(NSInteger index);

- (void)setDidSelectedIndexBlock:(void (^)(NSInteger index))didSelectedIndexBlock;

@property (nonatomic, strong) UIImage *blurredImage;

- (void)setOffsetProgress:(CGFloat)progress;

@end
