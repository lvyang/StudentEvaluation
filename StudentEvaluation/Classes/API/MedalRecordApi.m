//
//  MedalRecordApi.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/13.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "MedalRecordApi.h"
#import "BSSettings.h"

@implementation MedalRecordApi
{
    NSString *_classId;
    NSString *_teacherId;
    NSNumber *_page;
    NSNumber *_pageSize;
}

- (id)initWithClassId:(NSString *)classId teacherId:(NSString *)teacherId page:(NSNumber *)page pageSize:(NSNumber *)pageSize
{
    self = [super init];
    
    if (self) {
        _classId = classId;
        _teacherId = teacherId;
        
        _page = page;
        _pageSize = pageSize;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"appapi/medal/queryMedalByTime";
}

- (id)requestArgument
{
    return @{@"appid": ([BSSettings appId] ? : @""),
             @"appkey": ([BSSettings appKey] ? : @""),
             @"classId": _classId ? : @"",
             @"teacherId": _teacherId ? : @"",
             @"curpage": _page ? : @0,
             @"pagesize": _pageSize ? : @0};
}

@end
