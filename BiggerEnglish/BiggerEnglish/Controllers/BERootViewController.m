//
//  BERootViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/13.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BERootViewController.h"
#import "BETranslateViewController.h"
#import "BEDailyViewController.h"
#import "BEFavouriteViewController.h"
#import "BEWordBookViewController.h"
#import "BEMenuView.h"

//static CGFloat const kMenuWidth = 200.0;

@interface BERootViewController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) BETranslateViewController       *translateViewController;
@property (nonatomic, strong) BEDailyViewController       *dailyViewController;
@property (nonatomic, strong) BEFavouriteViewController       *favouriteViewController;
@property (nonatomic, strong) BEWordBookViewController       *wordBookViewController;

@property (nonatomic, strong) UINavigationController       *translateNavigationController;
@property (nonatomic, strong) UINavigationController       *dailyNavigationController;
@property (nonatomic, strong) UINavigationController       *favouriteNavigationController;
@property (nonatomic, strong) UINavigationController       *wordBookNavigationController;

@property (nonatomic, strong) UIView *viewControllerContainView;
@property (nonatomic, strong) BEMenuView *menuView;
@property (nonatomic, strong) UIButton   *rootBackgroundButton;

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgePanRecognizer;

@property (nonatomic, assign) NSInteger currentSelectedIndex;

@end


@implementation BERootViewController

CGFloat sildeMenuWidth;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        sildeMenuWidth = 220;
        self.currentSelectedIndex = 0;
        [SettingManager manager];
        [CacheManager manager];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self configureViewControllers];
    [self configureViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureGestures];
    [self configureNotifications];
    
    self.edgesForExtendedLayout               = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.edgePanRecognizer.delegate                                    = self;
    self.navigationController.delegate                                 = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Layouts

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.viewControllerContainView.frame = self.view.frame;
    self.rootBackgroundButton.frame = self.view.frame;
}

#pragma mark - Configure Views

- (void)configureViews {
    self.rootBackgroundButton                 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rootBackgroundButton.alpha           = 0.0;
    self.rootBackgroundButton.backgroundColor = [UIColor blackColor];
    self.rootBackgroundButton.hidden          = YES;
    [self.view addSubview:self.rootBackgroundButton];
    
    self.menuView = [[BEMenuView alloc] initWithFrame:(CGRect){-sildeMenuWidth, 0, sildeMenuWidth, ScreenHeight}];
    [self.view addSubview:self.menuView];
    
    //灰色部分点击
    @weakify(self);
    [self.rootBackgroundButton bk_whenTapped:^{
        @strongify(self);
        
        [UIView animateWithDuration:0.3 animations:^{
            [self setMenuOffset:0.0f];
        }];
    }];
    
    //侧边栏切换
    [self.menuView setDidSelectedIndexBlock:^(NSInteger index) {
        @strongify(self);
        
        [self showViewControllerAtIndex:index animated:YES];
        [SettingManager manager].selectedSectionIndex = index;
    }];
}

- (void)configureViewControllers {
    
    self.viewControllerContainView = [[UIView alloc] initWithFrame:(CGRect){0, 0, ScreenWidth, ScreenHeight}];
    [self.view addSubview:self.viewControllerContainView];
    
    self.translateViewController = [[BETranslateViewController alloc] init];
    self.translateNavigationController = [[UINavigationController alloc] initWithRootViewController:self.translateViewController];
    
    self.dailyViewController = [[BEDailyViewController alloc] init];
    self.dailyNavigationController = [[UINavigationController alloc] initWithRootViewController:self.dailyViewController];
    
    self.favouriteViewController = [[BEFavouriteViewController alloc] init];
    self.favouriteNavigationController = [[UINavigationController alloc] initWithRootViewController:self.favouriteViewController];

    self.wordBookViewController = [[BEWordBookViewController alloc] init];
    self.wordBookNavigationController = [[UINavigationController alloc] initWithRootViewController:self.wordBookViewController];
    
    [self.viewControllerContainView addSubview:[self viewControllerForIndex:[SettingManager manager].selectedSectionIndex].view];
    self.currentSelectedIndex = [SettingManager manager].selectedSectionIndex;
}

- (void)configureNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveShowMenuNotification) name:kShowMenuNotification object:nil];
    /*
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveCancelInactiveDelegateNotifacation) name:kRootViewControllerCancelDelegateNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveResetInactiveDelegateNotification) name:kRootViewControllerResetDelegateNotification object:nil];
     */
    
//     @weakify(self);
     [[NSNotificationCenter defaultCenter] addObserverForName:kShowLoginVCNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//     @strongify(self);
     
     }];
}

- (void)configureGestures {
    
    self.edgePanRecognizer          = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgePanRecognizer:)];
    self.edgePanRecognizer.edges    = UIRectEdgeLeft;
    self.edgePanRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.edgePanRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanRecognizer:)];
    panRecognizer.delegate                = self;
    [self.rootBackgroundButton addGestureRecognizer:panRecognizer];
}

#pragma mark - Private Methods

- (void)showViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated {
    
    if (self.currentSelectedIndex != index) {
        @weakify(self);
        void (^showBlock)() = ^{
            @strongify(self);
            
            UIViewController *previousViewController = [self viewControllerForIndex:self.currentSelectedIndex];
            UIViewController *willShowViewController = [self viewControllerForIndex:index];
            
            if (willShowViewController) {
                BOOL isViewInRootView = NO;
                for (UIView *subView in self.view.subviews) {
                    if ([subView isEqual:willShowViewController.view]) {
                        isViewInRootView = YES;
                    }
                }
                if (isViewInRootView) {
                    willShowViewController.view.x = 320;
                    [self.viewControllerContainView bringSubviewToFront:willShowViewController.view];
                } else {
                    [self.viewControllerContainView addSubview:willShowViewController.view];
                    willShowViewController.view.x = 320;
                }
                
                if (animated) {
                    [UIView animateWithDuration:0.2 animations:^{
                        previousViewController.view.x += 20;
                    } completion:nil];
                    
                    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1.2 options:UIViewAnimationOptionCurveLinear animations:^{
                        willShowViewController.view.x = 0;
                    } completion:nil];
                    
                    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [self setMenuOffset:0.0f];
                    } completion:nil];
                } else {
                    previousViewController.view.x += 20;
                    willShowViewController.view.x = 0;
                    [self setMenuOffset:0.0f];
                }
                
                self.currentSelectedIndex = index;
            }
        };
        showBlock();
        
    } else {
        UIViewController *willShowViewController = [self viewControllerForIndex:index];
        [UIView animateWithDuration:0.4 animations:^{
            willShowViewController.view.x = 0;
        } completion:nil];
        [UIView animateWithDuration:0.5 animations:^{
            [self setMenuOffset:0.0f];
        }];
    }
}

- (UIViewController *)viewControllerForIndex:(NSInteger)index {
    
    UIViewController *viewController;
    switch (index) {
        case 0:
            viewController = self.translateNavigationController;
            break;
        case 1:
            viewController = self.dailyNavigationController;
            break;
        case 2:
            viewController = self.favouriteNavigationController;
            break;
        case 3:
            viewController = self.wordBookNavigationController;
            break;
        default:
            break;
    }
    
    return viewController;
}

- (void)setMenuOffset:(CGFloat)offset {
    
    self.menuView.x = offset - sildeMenuWidth;
    [self.menuView setOffsetProgress:offset/sildeMenuWidth];
    self.rootBackgroundButton.alpha = offset/sildeMenuWidth * 0.3;
    
    UIViewController *previousViewController = [self viewControllerForIndex:self.currentSelectedIndex];
    previousViewController.view.x            = offset/8.0;
}

#pragma mark - Gestures

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
            return YES;
        }
        if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)handlePanRecognizer:(UIPanGestureRecognizer *)recognizer {
    
    CGFloat progress = [recognizer translationInView:self.rootBackgroundButton].x / (self.rootBackgroundButton.bounds.size.width * 0.5);
    progress = - MIN(progress, 0);
    
    [self setMenuOffset:sildeMenuWidth - sildeMenuWidth * progress];
    
    static CGFloat sumProgress = 0;
    static CGFloat lastProgress = 0;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        sumProgress = 0;
        lastProgress = 0;
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (progress > lastProgress) {
            sumProgress += progress;
        } else {
            sumProgress -= progress;
        }
        lastProgress = progress;
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.3 animations:^{
            if (sumProgress > 0.1) {
                [self setMenuOffset:0];
            } else {
                [self setMenuOffset:sildeMenuWidth];
            }
        } completion:^(BOOL finished) {
            if (sumProgress > 0.1) {
                self.rootBackgroundButton.hidden = YES;
            } else {
                self.rootBackgroundButton.hidden = NO;
            }
        }];
    }
}

- (void)handleEdgePanRecognizer:(UIScreenEdgePanGestureRecognizer *)recognizer {
    CGFloat progress = [recognizer translationInView:self.view].x / sildeMenuWidth;
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.rootBackgroundButton.hidden = NO;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self setMenuOffset:sildeMenuWidth * progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        CGFloat velocity = [recognizer velocityInView:self.view].x;
        
        if (velocity > 20 || progress > 0.5) {
            [UIView animateWithDuration:(1-progress)/1.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:3.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [self setMenuOffset:sildeMenuWidth];
            } completion:nil];
        }
        else {
            [UIView animateWithDuration:progress/3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self setMenuOffset:0];
            } completion:^(BOOL finished) {
                self.rootBackgroundButton.hidden = YES;
                self.rootBackgroundButton.alpha = 0.0;
            }];
        }
    }
}

#pragma mark - Notifications

//弹出侧边栏
- (void)didReceiveShowMenuNotification {
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:3.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self setMenuOffset:sildeMenuWidth];
        self.rootBackgroundButton.hidden = NO;
    } completion:nil];
}

- (void)didReceiveResetInactiveDelegateNotification {
    
    self.edgePanRecognizer.enabled = YES;
}

- (void)didReceiveCancelInactiveDelegateNotifacation {
    
    self.edgePanRecognizer.enabled = NO;
}

@end
