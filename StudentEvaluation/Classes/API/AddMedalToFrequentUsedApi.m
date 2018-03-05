//
//  AddMedalToFrequentUsedApi.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/5.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "AddMedalToFrequentUsedApi.h"
#import "BSSettings.h"

@implementation AddMedalToFrequentUsedApi
{
    NSString *_teacherId;
    NSString *_medalId;
}

- (id)initWithTeacherId:(NSString *)teacherId medalId:(NSString *)medalId
{
    self = [super init];
    
    if (self) {
        _teacherId = teacherId;
        _medalId = medalId;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"schoolApi/addModelToMedal";
}

- (id)requestArgument
{
    return @{@"appid": ([BSSettings appId] ? : @""),
             @"appkey": ([BSSettings appKey] ? : @""),
             @"teacherId": _teacherId ? : @"",
             @"medalId": _medalId ? : @""};
}

@end
