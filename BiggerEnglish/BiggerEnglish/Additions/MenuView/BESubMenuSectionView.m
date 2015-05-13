//
//  BESubMenuSectionView.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/13.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BESubMenuSectionView.h"

#import "BESubMenuSectionCell.h"

@interface BESubMenuSectionView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BESubMenuSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configureTableView];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveThemeChangeNotification) name:kThemeDidChangeNotification object:nil];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureTableView {
    
    self.tableView                 = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.contentInsetTop = 44;
    [self addSubview:self.tableView];
    
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = (CGRect){0, 0, self.width, self.height};
//    self.tableView.backgroundColor = kBackgroundColorWhiteDark;
        self.tableView.backgroundColor = [UIColor redColor];

    NSUInteger row = 0;
    /*
    
     
     if (self.isFavorite) {
        row = [V2SettingManager manager].favoriteSelectedSectionIndex;
    } else {
        row = [V2SettingManager manager].categoriesSelectedSectionIndex;
    }
     
     
     */
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Setters

//- (void)setSelectedIndex:(NSInteger)selectedIndex {
//
//    if (selectedIndex < self.sectionTitleArray.count) {
//        _selectedIndex = selectedIndex;
//
//        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
//
//    }
//
//}

- (void)setSectionTitleArray:(NSArray *)sectionTitleArray {
    _sectionTitleArray = sectionTitleArray;
    
    [self.tableView reloadData];
}


#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightCellForIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    BESubMenuSectionCell *cell = (BESubMenuSectionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BESubMenuSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return [self configureWithCell:cell IndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.didSelectedIndexBlock) {
        self.didSelectedIndexBlock(indexPath.row);
    }
    
}

#pragma mark - Configure TableCell

- (CGFloat)heightCellForIndexPath:(NSIndexPath *)indexPath {
    
    return [BESubMenuSectionCell getCellHeight];
    
}

- (BESubMenuSectionCell *)configureWithCell:(BESubMenuSectionCell *)cell IndexPath:(NSIndexPath *)indexPath {
    
    cell.title     = self.sectionTitleArray[indexPath.row];
    
    return cell;
    
}

#pragma mark - Notifications

- (void)didReceiveThemeChangeNotification {
    
    [self.tableView reloadData];
    [self setNeedsLayout];
    //    NSIndexPath *selectedIndex = [self.tableView indexPathForSelectedRow];
    //    [self.tableView reloadData];
    //    [self.tableView selectRowAtIndexPath:selectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
    
}

@end