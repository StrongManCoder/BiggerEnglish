//
//  BEFavouriteViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/14.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEFavouriteViewController.h"
#import "BEFavouriteViewCell.h"
#import "FavourModel.h" 
#import "BEDailyDetailViewController.h" 

@interface BEFavouriteViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation BEFavouriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"收藏";
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self configureLeftButton];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark - UITableViewDataSource
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.tableView reloadData]; // to reload selected cell
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    NSLog(@"%d",[sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    BEFavouriteViewCell *cell = (BEFavouriteViewCell *)[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BEFavouriteViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }

    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.date = [object valueForKey:@"title"];
    cell.content = [object valueForKey:@"content"];
    cell.note = [object valueForKey:@"note"];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BEDailyDetailViewController *controller = [[BEDailyDetailViewController alloc] init];
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:controller animated:YES];
    [controller loadFavourModelData:(FavourModel *)object];
}

#pragma mark - Fetched results controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
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
    [self.tableView endUpdates];
}

#pragma mark - Notification

- (void)navigateSetting {
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
}

#pragma mark - Private Method

-(void)configureLeftButton {
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

#pragma mark - Getter / Setter

- (UITableView *)tableView {
    if (_tableView !=nil) {
        return _tableView;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height - 64)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 44.0f;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    footerView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = footerView;

    return _tableView;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FavourModel" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
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
