//
//  BEPopupTableView.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/7/8.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BEPopupTableView;


@protocol BEPopupTableViewDataSource <NSObject>
@required

- (UITableViewCell *)popupTableView:(BEPopupTableView *)popupTableView
                    cellForIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)popupTableView:(BEPopupTableView *)popupTableView
       numberOfRowsInSection:(NSInteger)section;

@end

@protocol BEPopupTableViewDelegate <NSObject>
@optional

- (void)popupTableView:(BEPopupTableView *)popupTableView
     didSelectIndexPath:(NSIndexPath *)indexPath;

- (void)popupTableViewCancel:(BEPopupTableView *)popupTableView;

- (CGFloat)popupTableView:(BEPopupTableView *)popupTableView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface BEPopupTableView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<BEPopupTableViewDataSource> datasource;
@property (nonatomic, assign) id<BEPopupTableViewDelegate>   delegate;


@property (nonatomic, assign) NSInteger rowHeight;
@property (nonatomic, assign) NSInteger rowCount;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) NSString *titleValue;

- (instancetype)initWithView;

- (void)setTitle:(NSString *)title;
- (void)show;
- (void)dismiss;

@end
