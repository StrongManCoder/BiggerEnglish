//
//  BEWordBookViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/14.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEWordBookViewController.h"
#import "BEWordBookCell.h"
#import "BEWordBookHeaderView.h"
#import "BEWordBookDetailViewController.h"
#import "BEPopupTableView.h"
#import "WordBookModel.h"
#import "WordModel.h"
#import "HistoryWordBookModel.h"
#import "BEWordBookTitleCell.h"

@interface BEWordBookViewController() <UITableViewDelegate, UITableViewDataSource, BEPopupTableViewDelegate, NSFetchedResultsControllerDelegate, UIAlertViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) BEWordBookHeaderView *headerView;

@property (nonatomic, strong) NSFetchedResultsController *wordBookModelResults;
@property (nonatomic, strong) NSFetchedResultsController *defaultWordBookModelResults;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation BEWordBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.title = @"单词本";
    
    [self configureLeftButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
    [self configureNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateWordBook];
    [self refreshWordBookModelResults];
    [self.tableView reloadData];
}

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

- (void)configureView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
}

- (void)configureNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWordBook) name:kUpdateWordBook object:nil];
}

- (void)navigateSetting {
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.wordBookModelResults sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"BEWordBookTitleCell";
    BEWordBookTitleCell *cell = (BEWordBookTitleCell *)[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BEWordBookTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSManagedObject *object = [self.wordBookModelResults objectAtIndexPath:indexPath];
    WordBookModel *wordBookModel = (WordBookModel *)object;
    cell.titleLabel.text = wordBookModel.title;
    NSArray *wordArray = [wordBookModel.words allObjects];
    //fucking shit
    int count = 0;
    for (WordModel *model in wordArray) {
        if (model.word != nil) {
            count++;
        }
    }
    cell.wordCountLabel.text = [NSString stringWithFormat:@"%d", count];
    if ([[object valueForKey:@"defaulted"] isEqualToString:@"1"]) {
        cell.defaultView.hidden = NO;
    }
    else {
        cell.defaultView.hidden = YES;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSManagedObject *object = [self.wordBookModelResults objectAtIndexPath:indexPath];
    WordBookModel *wordBookModel = (WordBookModel *)object;
    NSArray *wordArray = [wordBookModel.words allObjects];
    //fucking shit
    int count = 0;
    for (WordModel *model in wordArray) {
        if (model.word != nil) {
            count++;
        }
    }
    if (count == 0) {
        return;
    }
    [self navigateToDetailViewController:[object valueForKey:@"title"]];
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
    if ([controller.fetchRequest.predicate.predicateFormat isEqualToString:@"title==我的生词本"]) {
        NSLog(@"111");
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.defaultWordBookModelResults sections][0];
        self.headerView.wordViewText = [NSString stringWithFormat:@"%d" ,(int)[sectionInfo numberOfObjects]];
    } else {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - BEPopupTableViewDelegate

- (void)popupTableView:(BEPopupTableView *)popupTableViewView didSelectIndexPath:(NSIndexPath *)indexPath {
    if (popupTableViewView.tag == 0) {
        switch (indexPath.row) {
            case 0: //设为默认笔记本
            {
                [self SettingDefaultWordBook:popupTableViewView.titleValue];
                break;
            }
            case 1: //清空笔记本
            {
                [self clearWordBook:popupTableViewView.titleValue];
                [self updateWordBook];
                break;
            }
        }
    }
    else if (popupTableViewView.tag == 1)//清空历史纪录
    {
        [self clearHistoryWordBook];
        [self updateWordBook];
    }
    else if (popupTableViewView.tag == 2)
    {
        switch (indexPath.row) {
            case 0: //设为默认笔记本
            {
                [self SettingDefaultWordBook:popupTableViewView.titleValue];
                break;
            }
            case 1: //清空笔记本
            {
                [self clearWordBook:popupTableViewView.titleValue];
                break;
            }
            case 2: //删除笔记本
            {
                [self deleteWordBook:popupTableViewView.titleValue];
                break;
            }
        }
    }
}

- (void)testlog {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"WordBookModel" inManagedObjectContext:self.managedObjectContext]];
    NSArray* results1 = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    for (WordBookModel *wordBook in results1) {
        NSLog(@"wordBook.title   %@",wordBook.title);
        for (NSObject *object in [wordBook.words objectEnumerator]) {
            NSLog(@"((Word *)object).name   %@",((WordModel *)object).word);
        }
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    if (buttonIndex == 1) {
        if ([textField.text isEqualToString:@""]) {
            
            return;
        }
        WordBookModel *wordBookModel = [NSEntityDescription insertNewObjectForEntityForName:@"WordBookModel" inManagedObjectContext:self.managedObjectContext];
        wordBookModel.title = textField.text;
        wordBookModel.defaulted = @"0";
        wordBookModel.date = [self getDate];
        if (![self.managedObjectContext save:nil]) {
            NSLog(@"error!");
        } else {
            NSLog(@"ok.");
        }
    }
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
    hud.delegate = nil;
    hud = nil;
}

#pragma mark - Event Response

- (void)longPressToDo:(UILongPressGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gesture locationInView:self.tableView];
        //判断是否在列表中长按
        if (point.y > self.tableView.tableHeaderView.height) {
            NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
            if(indexPath == nil) {
                return ;
            }
            BEPopupTableView *popupTableView = [[BEPopupTableView alloc] initWithView];
            popupTableView.dataArray = [[NSArray alloc] initWithObjects:@"默认添加到此生词本", @"清空生词本", @"删除生词本", nil];
            NSManagedObject *object = [self.wordBookModelResults objectAtIndexPath:indexPath];
            popupTableView.titleValue = [object valueForKey:@"title"];
            popupTableView.tag = 2;
            popupTableView.delegate = self;
            [popupTableView show];
        }
    }
}

- (void)updateWordBook {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"WordBookModel" inManagedObjectContext:self.managedObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title==%@", @"我的生词本"]];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    WordBookModel *wordBookModel = [result objectAtIndex:0];
    self.headerView.wordViewText = [NSString stringWithFormat:@"%d", (int)[wordBookModel.words count]];
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"HistoryWordBookModel" inManagedObjectContext:self.managedObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title==%@", @"历史纪录"]];
    NSArray *historyResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    HistoryWordBookModel *historyWordBookModel = [historyResult objectAtIndex:0];
    self.headerView.historyViewText = [NSString stringWithFormat:@"%d", (int)[historyWordBookModel.words count]];
}

#pragma mark - Private Methods

- (void)SettingDefaultWordBook:(NSString *)wordBook {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"WordBookModel" inManagedObjectContext:self.managedObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"defaulted==%@", @"1"]];
    NSArray* defaultedResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    for (WordBookModel *wordBookModel in defaultedResults) {
        wordBookModel.defaulted = @"0";
    }
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title==%@", wordBook]];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    WordBookModel *wordBookModel = (WordBookModel *)[results firstObject];
    wordBookModel.defaulted = @"1";
    
    if (![self.managedObjectContext save:nil]) {
        NSLog(@"error!");
    } else {
        NSLog(@"ok.");
    }
}

- (void)clearWordBook:(NSString *)wordBook {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"WordBookModel" inManagedObjectContext:self.managedObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title==%@", wordBook]];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    WordBookModel *wordBookModel = (WordBookModel *)[results firstObject];
    wordBookModel.words = nil;
    if (![self.managedObjectContext save:nil]) {
        NSLog(@"error!");
    } else {
        NSLog(@"ok.");
    }
}

- (void)clearHistoryWordBook {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"HistoryWordBookModel" inManagedObjectContext:self.managedObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title==%@", @"历史纪录"]];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    HistoryWordBookModel *wordBookModel = (HistoryWordBookModel *)[results firstObject];
    wordBookModel.words = nil;
    if (![self.managedObjectContext save:nil]) {
        NSLog(@"error!");
    } else {
        NSLog(@"ok.");
    }
}

- (void)deleteWordBook:(NSString *)wordBook {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"WordBookModel" inManagedObjectContext:self.managedObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title==%@", wordBook]];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    WordBookModel *wordBookModel = (WordBookModel *)[results firstObject];
    wordBookModel.words = nil;
    if ([wordBookModel.defaulted isEqualToString:@"1"]) {
        [self SettingDefaultWordBook:@"我的生词本"];
    }
    [self.managedObjectContext deleteObject:wordBookModel];
    
    
    if (![self.managedObjectContext save:nil]) {
        NSLog(@"error!");
    } else {
        NSLog(@"ok.");
    }
}

-(NSString *)getDate {
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *locationString = [formatter stringFromDate: [NSDate date]];
    return locationString;
}

- (void)navigateToDetailViewController:(NSString *)workBook {
    BEWordBookDetailViewController *controller = [[BEWordBookDetailViewController alloc] init];
    controller.workBook = workBook;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Getters / Setters

- (UITableView *)tableView {
    if (_tableView != nil) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor BEFrenchGrayColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.estimatedRowHeight = 44.0f;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPress.minimumPressDuration = 1.0;
    [_tableView addGestureRecognizer:longPress];
    
    return _tableView;
}

- (BEWordBookHeaderView *)headerView {
    if (_headerView != nil) {
        return _headerView;
    }
    _headerView = [[BEWordBookHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60 + (ScreenWidth - 30) / 2)];
    @weakify(self);
    _headerView.addWordBookBlock = ^(){
        @strongify(self);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新建生词本"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert show];
    };
    _headerView.wordViewBlock = ^(){
        @strongify(self);
        if ([self.headerView.wordViewText intValue] > 0) {
            [self navigateToDetailViewController:@"我的生词本"];
        }
    };
    _headerView.wordViewLongPressBlock = ^(){
        @strongify(self);
        BEPopupTableView *popupTableView = [[BEPopupTableView alloc] initWithView];
        popupTableView.dataArray = [[NSArray alloc] initWithObjects:@"默认添加到此生词本", @"清空生词本", nil];
        popupTableView.tag = 0;
        popupTableView.titleValue = @"我的生词本";
        popupTableView.delegate = self;
        [popupTableView show];
    };
    _headerView.historyViewBlock = ^(){
        @strongify(self);
        if ([self.headerView.historyViewText intValue] > 0) {
            BEWordBookDetailViewController *controller = [[BEWordBookDetailViewController alloc] init];
            controller.workBook = @"历史纪录";
            controller.history = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
    };
    _headerView.historyViewLongPressBlock = ^(){
        @strongify(self);
        BEPopupTableView *popupTableView = [[BEPopupTableView alloc] initWithView];
        popupTableView.tag = 1;
        popupTableView.dataArray = [[NSArray alloc] initWithObjects:@"清空历史纪录", nil];
        popupTableView.delegate = self;
        [popupTableView show];
    };
    
    return _headerView;
}

- (NSFetchedResultsController *)wordBookModelResults
{
    if (_wordBookModelResults != nil) {
        return _wordBookModelResults;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WordBookModel" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title!=%@", @"我的生词本"]];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    _wordBookModelResults = aFetchedResultsController;
    
    NSError *error = nil;
    if (![_wordBookModelResults performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _wordBookModelResults;
}

- (void)refreshWordBookModelResults {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WordBookModel" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title!=%@", @"我的生词本"]];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.wordBookModelResults = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.wordBookModelResults performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

}

- (NSFetchedResultsController *)defaultWordBookModelResults
{
    if (_defaultWordBookModelResults != nil) {
        return _defaultWordBookModelResults;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WordBookModel" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title==我的生词本"]];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    _defaultWordBookModelResults = aFetchedResultsController;

    NSError *error = nil;
    if (![_defaultWordBookModelResults performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _defaultWordBookModelResults;
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
