//
//  BELazyScrollView.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/20.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BELazyScrollView;

enum {
    DMLazyScrollViewDirectionHorizontal =   0,
    DMLazyScrollViewDirectionVertical   =   1,
};typedef NSUInteger DMLazyScrollViewDirection;


enum {
    DMLazyScrollViewTransitionAuto      =   0,
    DMLazyScrollViewTransitionForward   =   1,
    DMLazyScrollViewTransitionBackward  =   2
}; typedef NSUInteger DMLazyScrollViewTransition;

@protocol BELazyScrollViewDelegate <NSObject>

@optional
- (void)lazyScrollViewWillBeginDragging:(BELazyScrollView *)pagingView;
//Called when it scrolls, except from as the result of self-driven animation.
- (void)lazyScrollViewDidScroll:(BELazyScrollView *)pagingView at:(CGPoint) visibleOffset;
//Called whenever it scrolls: through user manipulation, setup, or self-driven animation.
- (void)lazyScrollViewDidScroll:(BELazyScrollView *)pagingView at:(CGPoint) visibleOffset withSelfDrivenAnimation:(BOOL)selfDrivenAnimation;
- (void)lazyScrollViewDidEndDragging:(BELazyScrollView *)pagingView;
- (void)lazyScrollViewWillBeginDecelerating:(BELazyScrollView *)pagingView;
- (void)lazyScrollViewDidEndDecelerating:(BELazyScrollView *)pagingView atPageIndex:(NSInteger)pageIndex;
- (void)lazyScrollView:(BELazyScrollView *)pagingView currentPageChanged:(NSInteger)currentPageIndex;

@end

typedef UIViewController *(^BELazyScrollViewDataSource)(NSUInteger index);

@interface BELazyScrollView : UIScrollView

@property (copy)                BELazyScrollViewDataSource      dataSource;
@property (nonatomic, assign)   id<BELazyScrollViewDelegate>    controlDelegate;

@property (nonatomic,assign)    NSUInteger                      numberOfPages;
@property (readonly)            NSUInteger                      currentPage;
@property (readonly)            DMLazyScrollViewDirection       direction;

@property (nonatomic, assign) BOOL autoPlay;
@property (nonatomic, assign) CGFloat autoPlayTime; //default 3 seconds

- (id)initWithFrameAndDirection:(CGRect)frame
                      direction:(DMLazyScrollViewDirection)direction
                 circularScroll:(BOOL) circularScrolling;

- (void)setEnableCircularScroll:(BOOL)circularScrolling;
- (BOOL)circularScrollEnabled;

- (void) reloadData;

- (void) setPage:(NSInteger) index animated:(BOOL) animated;
- (void) setPage:(NSInteger) newIndex transition:(DMLazyScrollViewTransition) transition animated:(BOOL) animated;
- (void) moveByPages:(NSInteger) offset animated:(BOOL) animated;

- (UIViewController *) visibleViewController;

@end
