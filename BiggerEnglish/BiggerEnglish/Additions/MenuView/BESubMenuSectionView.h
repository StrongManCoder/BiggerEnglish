//
//  BESubMenuSectionView.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/13.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BESubMenuSectionView : UIView

@property (nonatomic, strong) NSArray *sectionTitleArray;
@property (nonatomic, assign, getter = isFavorite) BOOL favorite;

//@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) void (^didSelectedIndexBlock)(NSInteger index);

- (void)setDidSelectedIndexBlock:(void (^)(NSInteger index))didSelectedIndexBlock;

@end
