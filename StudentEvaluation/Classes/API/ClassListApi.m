//
//  ClassListApi.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/2.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "ClassListApi.h"
#import "BSSettings.h"

@implementation ClassListApi
{
    NSString *_teacherId;
}

- (id)initWithTeacherId:(NSString *)teacherId
{
    self = [super init];
    
    if (self) {
        _teacherId = teacherId;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"appapi/classInfo/getClassInfoByTeacherId";
}

- (id)requestArgument
{
    return @{@"appid": ([BSSettings appId] ? : @""),
             @"appkey": ([BSSettings appKey] ? : @""),
             @"teacherId": _teacherId ? : @""};
}

@end
