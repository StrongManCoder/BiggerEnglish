//
//  BEWordBookHeaderView.h
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/7/7.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BEWordBookHeaderView : UIView

typedef void (^AddWordBookBlock)(void);
@property (nonatomic, copy) AddWordBookBlock addWordBookBlock;

typedef void (^WordViewBlock)(void);
@property (nonatomic, copy) WordViewBlock wordViewBlock;

typedef void (^HistoryViewBlock)(void);
@property (nonatomic, copy) HistoryViewBlock historyViewBlock;


@end
