//
//  BEFavouriteViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/14.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEFavouriteViewController.h"
#import "BEFavouriteViewCell.h"
#import "BEDailyDetailViewController.h"
#import "BEReadViewCell.h"
#import "BEReadDetailViewController.h"  
#import "ReadContentModel.h"
#import "DailyDetailModel.h"

@interface BEFavouriteViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *dailyTableView;
@property (nonatomic, strong) UITableView *readTableView;
@property (strong, nonatomic) NSFetchedResultsController *favourModelResults;
@property (strong, nonatomic) NSFetchedResultsController *readContentModelResults;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation BEFavouriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self configureLeftButton];
    [self configureSegment];
    [self.view addSubview:self.dailyTableView];
    [self.view addSubview:self.readTableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo;
    if (tableView.tag == 0) {
        sectionInfo = [self.favourModelResults sections][section];
        return [sectionInfo numberOfObjects];
    } else {
        sectionInfo = [self.readContentModelResults sections][section];
        return [sectionInfo numberOfObjects];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    if (tableView.tag == 0) {
        BEFavouriteViewCell *cell = (BEFavouriteViewCell *)[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[BEFavouriteViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        NSManagedObject *object = [self.favourModelResults objectAtIndexPath:indexPath];
        cell.date = [object valueForKey:@"title"];
        cell.content = [object valueForKey:@"content"];
        cell.note = [object valueForKey:@"note"];
        return cell;
    } else {
        BEReadViewCell *cell = (BEReadViewCell *)[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[BEReadViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        NSManagedObject *object = [self.readContentModelResults objectAtIndexPath:indexPath];

        cell.pic = [object valueForKey:@"img"];
        cell.title = [object valueForKey:@"title"] ;
        cell.content = [object valueForKey:@"descript"];

        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        BEDailyDetailViewController *controller = [[BEDailyDetailViewController alloc] init];
        NSManagedObject *object = [self.favourModelResults objectAtIndexPath:indexPath];
        [self.navigationController pushViewController:controller animated:YES];
        [controller loadFavourModelData:(DailyDetailModel *)object];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        BEReadDetailViewController *controller = [[BEReadDetailViewController alloc] init];
        NSManagedObject *object = [self.readContentModelResults objectAtIndexPath:indexPath];
        controller.contentID = [((ReadContentModel *)object).contentid intValue];
        [self.navigationController pushViewController:controller animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Fetched results controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if ([controller.fetchRequest.entityName isEqualToString:@"DailyDetailModel"]) {
        [self.dailyTableView beginUpdates];
    } else {
        [self.readTableView beginUpdates];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView;
    if ([controller.fetchRequest.entityName isEqualToString:@"DailyDetailModel"]) {
        tableView = self.dailyTableView;
    } else {
        tableView = self.readTableView;
    }
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            break;
            
        case NSFetchedResultsChangeMove:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([controller.fetchRequest.entityName isEqualToString:@"DailyDetailModel"]) {
        [self.dailyTableView endUpdates];
    } else {
        [self.readTableView endUpdates];
    }
}

#pragma mark - Notification

- (void)navigateSetting {
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
}

#pragma mark - Private Method

- (void)configureLeftButton {
    UIButton *leftButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame       = CGRectMake(0, 0, 25, 25);
    [leftButton setAdjustsImageWhenHighlighted:YES];
    UIImage *image = [UIImage imageNamed:@"icon_hamberger"];
    [leftButton setImage:[image imageWithTintColor:[UIColor BEDeepFontColor]] forState:UIControlStateNormal];
    [leftButton setImage:[image imageWithTintColor:[UIColor BEHighLightFontColor]] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(navigateSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem              = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = barItem;
}

- (void)configureSegment {
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"每日一句", @"阅读"]];
    segment.tintColor = [UIColor BEHighLightFontColor];
    segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segment;
    [segment addTarget:self action:@selector(Segmentselected:) forControlEvents:UIControlEventValueChanged];
}

- (void)Segmentselected:(id)sender{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
            self.dailyTableView.hidden = NO;
            self.readTableView.hidden = YES;
            break;
        case 1:
            self.dailyTableView.hidden = YES;
            self.readTableView.hidden = NO;
            break;
        default:
            break;
    }
}

#pragma mark - Getters / Setters

- (UITableView *)dailyTableView {
    if (_dailyTableView !=nil) {
        return _dailyTableView;
    }
    
    _dailyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height - 64)];
    _dailyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dailyTableView.dataSource = self;
    _dailyTableView.delegate = self;
    _dailyTableView.estimatedRowHeight = 44.0f;
    _dailyTableView.rowHeight = UITableViewAutomaticDimension;
    _dailyTableView.tag = 0;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    footerView.backgroundColor = [UIColor whiteColor];
    _dailyTableView.tableFooterView = footerView;
    
    return _dailyTableView;
}

- (UITableView *)readTableView {
    if (_readTableView !=nil) {
        return _readTableView;
    }
    
    _readTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height - 64)];
    _readTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _readTableView.dataSource = self;
    _readTableView.delegate = self;
    _readTableView.estimatedRowHeight = 44.0f;
    _readTableView.rowHeight = UITableViewAutomaticDimension;
    _readTableView.tag = 1;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    footerView.backgroundColor = [UIColor whiteColor];
    _readTableView.tableFooterView = footerView;
    _readTableView.hidden = YES;
    
    return _readTableView;
}


- (NSFetchedResultsController *)favourModelResults
{
    if (_favourModelResults != nil) {
        return _favourModelResults;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyDetailModel" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"boolLove==%d", 1]];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    _favourModelResults = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.favourModelResults performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _favourModelResults;
}

- (NSFetchedResultsController *)readContentModelResults
{
    if (_readContentModelResults != nil) {
        return _readContentModelResults;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ReadContentModel" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"inputtime" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"favour == %d", 1];

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    _readContentModelResults = aFetchedResultsController;
    
    NSError *error = nil;
    if (![_readContentModelResults performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _readContentModelResults;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    id delegate = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = [delegate managedObjectContext];
    
    return _managedObjectContext;
}

@end
