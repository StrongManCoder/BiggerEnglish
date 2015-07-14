//
//  BEWordBookHeaderView.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/7/7.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BEWordBookHeaderView : UIView

@property (nonatomic, copy) NSString *wordViewText;
@property (nonatomic, copy) NSString *historyViewText;

typedef void (^AddWordBookBlock)(void);
@property (nonatomic, copy) AddWordBookBlock addWordBookBlock;

typedef void (^WordViewBlock)(void);
@property (nonatomic, copy) WordViewBlock wordViewBlock;

typedef void (^WordViewLongPressBlock)(void);
@property (nonatomic, copy) WordViewLongPressBlock wordViewLongPressBlock;


typedef void (^HistoryViewBlock)(void);
@property (nonatomic, copy) HistoryViewBlock historyViewBlock;

typedef void (^HistoryViewLongPressBlock)(void);
@property (nonatomic, copy) HistoryViewLongPressBlock historyViewLongPressBlock;


@end
