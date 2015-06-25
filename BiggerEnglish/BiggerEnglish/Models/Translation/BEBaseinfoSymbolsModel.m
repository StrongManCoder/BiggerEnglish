//
//  BEBaseinfoSymbolsModel.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/15.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BEBaseinfoSymbolsModel.h"
#import "BESymbolsPartsModel.h"

@implementation BEBaseinfoSymbolsModel

- (NSString *)partsStringWithFormat {
    NSArray *partsModelArray = [BESymbolsPartsModel objectArrayWithKeyValuesArray:self.parts];
    
    NSString *chineseResultTemp = @"";
    BESymbolsPartsModel *partsModelTemp;
    int partsModelArrayCount = (int)[partsModelArray count];
    for (int i = 0; i < partsModelArrayCount; i++) {
        partsModelTemp = (BESymbolsPartsModel*)partsModelArray[i];
        chineseResultTemp = [NSString stringWithFormat:@"%@%@ %@", chineseResultTemp,
                             [partsModelTemp.part trim],
                             [[partsModelTemp.means componentsJoinedByString:@"；\n"] trim]];
        if (partsModelArrayCount > 0 && i != partsModelArrayCount - 1) {
            chineseResultTemp = [NSString stringWithFormat:@"%@%@", chineseResultTemp, @"\n"];
        }
    }
    return [chineseResultTemp trim];
}

@end
