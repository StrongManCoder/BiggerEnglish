//
//  SettingManager.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/13.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "SettingManager.h"

#define userDefaults [NSUserDefaults standardUserDefaults]

#define kLineColorBlackDarkDefault    RGB(0xdbdbdb, 1.0)
#define kLineColorBlackLightDefault   RGB(0xebebeb, 1.0)

#define kFontColorBlackDarkDefault    RGB(0x333333, 1.0)
#define kFontColorBlackDarkMiddle     RGB(0x777777, 1.0)
#define kFontColorBlackLightDefault   RGB(0x999999, 1.0)
#define kFontColorBlackBlueDefault    RGB(0x778087, 1.0)
#define kColorBlueDefault             RGB(0x3fb7fc, 1.0)

static NSString *const kSelectedSectionIndex = @"SelectedSectionIndex";
static NSString *const kCategoriesSelectedSectionIndex = @"CategoriesSelectedSectionIndex";
static NSString *const kFavoriteSelectedSectionIndex = @"FavoriteSelectedSectionIndex";

static NSString *const kTheme           = @"Theme";
static NSString *const kThemeAutoChange = @"ThemeAutoChange";

static NSString *const kCheckInNotiticationOn = @"CheckInNotitication";
static NSString *const kNewNotificationOn     = @"NewNotification";
static NSString *const kNavigationBarHidden   = @"NavigationBarHidden";

static NSString *const kTrafficeSaveOn = @"TrafficeSaveOn";
static NSString *const kPreferHttps = @"PreferHttps";

@interface SettingManager () {
    
    BOOL _trafficSaveModeOn;
    
}

@end

@implementation SettingManager

- (instancetype)init {
    if (self = [super init]) {
        
        self.selectedSectionIndex = [[userDefaults objectForKey:kSelectedSectionIndex] unsignedIntegerValue];
        self.categoriesSelectedSectionIndex = [[userDefaults objectForKey:kCategoriesSelectedSectionIndex] unsignedIntegerValue];
        self.favoriteSelectedSectionIndex = [[userDefaults objectForKey:kFavoriteSelectedSectionIndex] unsignedIntegerValue];
        
        
        id themeAutoChange = [userDefaults objectForKey:kThemeAutoChange];
        if (themeAutoChange) {
            _themeAutoChange = [themeAutoChange boolValue];
        } else {
            _themeAutoChange = YES;
        }
        
        id checkInNotiticationOn = [userDefaults objectForKey:kCheckInNotiticationOn];
        if (checkInNotiticationOn) {
            _checkInNotiticationOn = [checkInNotiticationOn boolValue];
        } else {
            _checkInNotiticationOn = YES;
        }
        
        id newNotificationOn = [userDefaults objectForKey:kNewNotificationOn];
        if (newNotificationOn) {
            _newNotificationOn = [newNotificationOn boolValue];
        } else {
            _newNotificationOn = YES;
        }
        
        
        id navigationBarHidden = [userDefaults objectForKey:kNavigationBarHidden];
        if (navigationBarHidden) {
            _navigationBarAutoHidden = [navigationBarHidden boolValue];
        } else {
            _navigationBarAutoHidden = YES;
        }
        
        id trafficSaveOn = [userDefaults objectForKey:kTrafficeSaveOn];
        if (trafficSaveOn) {
            _trafficSaveModeOn = [trafficSaveOn boolValue];
        } else {
            _trafficSaveModeOn = NO;
        }
        
        id preferHttps = [userDefaults objectForKey:kPreferHttps];
        if (preferHttps) {
            _preferHttps = [preferHttps boolValue];
        } else {
            _preferHttps = NO;
        }
        
        
    }
    return self;
}

+ (instancetype)manager {
    static SettingManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SettingManager alloc] init];
    });
    return manager;
}

#pragma mark - Index

- (void)setSelectedSectionIndex:(NSUInteger)selectedSectionIndex {
    _selectedSectionIndex = selectedSectionIndex;
    
    [userDefaults setObject:@(selectedSectionIndex) forKey:kSelectedSectionIndex];
    [userDefaults synchronize];
    
}

- (void)setCategoriesSelectedSectionIndex:(NSUInteger)categoriesSelectedSectionIndex {
    _categoriesSelectedSectionIndex = categoriesSelectedSectionIndex;
    
    [userDefaults setObject:@(categoriesSelectedSectionIndex) forKey:kCategoriesSelectedSectionIndex];
    [userDefaults synchronize];
    
}

- (void)setFavoriteSelectedSectionIndex:(NSUInteger)favoriteSelectedSectionIndex {
    _favoriteSelectedSectionIndex = favoriteSelectedSectionIndex;
    
    [userDefaults setObject:@(favoriteSelectedSectionIndex) forKey:kFavoriteSelectedSectionIndex];
    [userDefaults synchronize];
    
}

#pragma mark - Theme



- (void)setThemeAutoChange:(BOOL)themeAutoChange {
    _themeAutoChange = themeAutoChange;
    
    [userDefaults setObject:@(themeAutoChange) forKey:kThemeAutoChange];
    [userDefaults synchronize];
}

#pragma mark - Alpha


#pragma mark - Notification

- (void)setCheckInNotiticationOn:(BOOL)checkInNotiticationOn {
    _checkInNotiticationOn = checkInNotiticationOn;
    
    [userDefaults setObject:@(checkInNotiticationOn) forKey:kCheckInNotiticationOn];
    [userDefaults synchronize];
    
}

- (void)setNewNotificationOn:(BOOL)newNotificationOn {
    _newNotificationOn = newNotificationOn;
    
    [userDefaults setObject:@(newNotificationOn) forKey:kNewNotificationOn];
    [userDefaults synchronize];
    
}

#pragma mark - Navigation Bar

- (void)setNavigationBarAutoHidden:(BOOL)navigationBarAutoHidden {
    _navigationBarAutoHidden = navigationBarAutoHidden;
    
    [userDefaults setObject:@(navigationBarAutoHidden) forKey:kNavigationBarHidden];
    [userDefaults synchronize];
    
}

#pragma mark - Traffic

- (void)setTrafficSaveModeOn:(BOOL)trafficSaveModeOn {
    _trafficSaveModeOn = trafficSaveModeOn;
    
    [userDefaults setObject:@(trafficSaveModeOn) forKey:kTrafficeSaveOn];
    [userDefaults synchronize];
    
}


- (BOOL)trafficSaveModeOnSetting {
    return _trafficSaveModeOn;
}


@end


