//
//  BEPopupTableView.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/7/8.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEPopupTableView.h"

@interface BEPopupTableView ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) UIControl *overlayView;

@property (nonatomic, assign) CGRect tableViewFrame;

- (void)defalutInit;
- (void)fadeIn;
- (void)fadeOut;

@end


@implementation BEPopupTableView

@synthesize datasource = _datasource;
@synthesize delegate = _delegate;

@synthesize tableView = _tableView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self defalutInit];
        
        _tableViewFrame = frame;
    }
    return self;
}

- (id)initWithView
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self defalutInit];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            _tableViewFrame = CGRectMake(20, 0, self.bounds.size.width - 40.0f, 0);
        } else {
            _tableViewFrame = CGRectMake(self.bounds.size.width / 4, 0, self.bounds.size.width / 2, 0);
        }
    }
    return self;
}

- (void)defalutInit
{
    _rowHeight = 35;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if(self.datasource &&
    //       [self.datasource respondsToSelector:@selector(popupTableView:numberOfRowsInSection:)])
    //    {
    //        return [self.datasource popupTableView:self numberOfRowsInSection:section];
    //    }
    //
    //    return 0;
    
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.datasource &&
       [self.datasource respondsToSelector:@selector(popupTableView:cellForIndexPath:)])
    {
        return [self.datasource popupTableView:self cellForIndexPath:indexPath];
    }
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:identifier];
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor BEHighLightFontColor];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if(self.delegate &&
    //       [self.delegate respondsToSelector:@selector(popupTableView:heightForRowAtIndexPath:)])
    //    {
    //        return [self.delegate popupTableView:self heightForRowAtIndexPath:indexPath];
    //    }
    //
    //    return 0.0f;
    
    return self.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(popupTableView:didSelectIndexPath:)])
    {
        [self.delegate popupTableView:self didSelectIndexPath:indexPath];
    }
    
    [self dismiss];
}

#pragma mark - animations

- (void)fadeIn
{
    self.alpha = 0;
    [UIView animateWithDuration:.1 animations:^{
        self.alpha = 1;
    }];
}

- (void)fadeOut
{
    [UIView animateWithDuration:.2 animations:^{
        self.alpha = 0.0;
        self.overlayView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.overlayView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

- (void)show
{
    CGFloat tableViewHeight = [self.dataArray count] * self.rowHeight - 1;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.tableViewFrame = CGRectMake(20, (self.frame.size.height - tableViewHeight) / 2, self.bounds.size.width - 40.0f, tableViewHeight);
    } else {
        self.tableViewFrame = CGRectMake(self.bounds.size.width / 4, (self.frame.size.height - tableViewHeight) / 2, self.bounds.size.width / 2, tableViewHeight);
    }
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    //    [self addSubview:self.titleView];
    [self addSubview:self.tableView];
    
    [keywindow addSubview:self.overlayView];
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
}

#define mark - UITouch

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupTableViewCancel:)]) {
        [self.delegate popupTableViewCancel:self];
    }
    [self dismiss];
}

#pragma mark - Setters

- (void)setTitle:(NSString *)title
{
    _titleView.text = title;
}

#pragma mark - Getters

- (UILabel *)titleView {
    if (_titleView != nil) {
        return _titleView;
    }
    _titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleView.font = [UIFont systemFontOfSize:17.0f];
    _titleView.backgroundColor = [UIColor colorWithRed:59./255.
                                                 green:89./255.
                                                  blue:152./255.
                                                 alpha:1.0f];
    _titleView.textAlignment = NSTextAlignmentCenter;
    _titleView.textColor = [UIColor whiteColor];
    _titleView.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleView.frame = CGRectMake(0, 0, self.bounds.size.width, 32.0f);
    
    return _titleView;
}

- (UITableView *)tableView {
    if (_tableView != nil) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:self.tableViewFrame];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    //    _tableView.layer.borderWidth = 1.0f;
    _tableView.layer.cornerRadius = 5.0f;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    
    return _tableView;
}

- (UIControl *)overlayView {
    if (_overlayView != nil) {
        return _overlayView;
    }
    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.2];
    [_overlayView addTarget:self
                     action:@selector(dismiss)
           forControlEvents:UIControlEventTouchUpInside];
    
    return _overlayView;
}

@end
