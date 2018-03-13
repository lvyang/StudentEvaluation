//
//  RevokeMedalApi.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/13.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "RevokeMedalApi.h"
#import "BSSettings.h"

@implementation RevokeMedalApi
{
    NSString *_recordId;
    NSString *_teacherId;
}

- (id)initWithMedalRecordId:(NSString *)recordId teacherId:(NSString *)teacherId
{
    self = [super init];
    
    if (self) {
        _recordId = recordId;
        _teacherId = teacherId;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"schoolApi/revocationMedal";
}

- (id)requestArgument
{
    return @{@"appid": ([BSSettings appId] ? : @""),
             @"appkey": ([BSSettings appKey] ? : @""),
             @"id": _recordId ? : @"",
             @"teacherId": _teacherId ? : @""};
}

@end
