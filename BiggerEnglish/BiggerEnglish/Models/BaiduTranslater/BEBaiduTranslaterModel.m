//
//  BEBaiduTranslaterModel.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/19.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEBaiduTranslaterModel.h"

@implementation BEBaiduTranslaterModel

- (NSString *)partsStringWithFormat {
    NSArray *resultModelArray = [BEBaiduTranslaterResultModel objectArrayWithKeyValuesArray:self.trans_result];
    NSString *result = @"";
    BEBaiduTranslaterResultModel *resultModelTemp;
    int resultModelArrayCount = (int)[resultModelArray count];
    for (int i = 0; i < resultModelArrayCount; i++) {
        resultModelTemp = (BEBaiduTranslaterResultModel*)resultModelArray[i];
        result = [NSString stringWithFormat:@"%@%@", result,
                             resultModelTemp.dst ];
        if (resultModelArrayCount > 0 && i != resultModelArrayCount - 1) {
            result = [NSString stringWithFormat:@"%@%@", result, @"\n"];
        }
    }
    return [result trim];
}

@end


@implementation BEBaiduTranslaterResultModel

@end
