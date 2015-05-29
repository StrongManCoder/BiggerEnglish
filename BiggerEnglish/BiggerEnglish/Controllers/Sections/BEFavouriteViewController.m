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
#import "BEFavouriteDetailViewController.h" 

@interface BEFavouriteViewController() <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *favourArray;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BEFavouriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"收藏";
        favourArray = [NSMutableArray array];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self configureLeftButton];
    [self initFavourData];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return favourArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    BEFavouriteViewCell *cell = (BEFavouriteViewCell *)[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BEFavouriteViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    FavourModel *favourModel = (FavourModel *)favourArray[indexPath.row];
    cell.date = favourModel.title;
    cell.content = favourModel.content;
    cell.note = favourModel.note;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BEFavouriteDetailViewController *favouriteDetailViewController = [[BEFavouriteDetailViewController alloc] init];
    [self.navigationController pushViewController:favouriteDetailViewController animated:YES];
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

- (void)initFavourData {
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"FavourModel" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSArray *favourResults=[[managedObjectContext executeFetchRequest:request error:nil] copy];
    
    for (FavourModel *favour in favourResults) {
        [favourArray addObject:favour];
    }
}

#pragma mark - Notification

- (void)navigateSetting {
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
}

#pragma mark - Getter / Setter

- (UITableView *)tableView {
    if (_tableView !=nil) {
        return _tableView;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height - 64)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 44.0f;
    _tableView.rowHeight = UITableViewAutomaticDimension;

    return _tableView;
}


@end
