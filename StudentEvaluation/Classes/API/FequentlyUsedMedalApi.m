//
//  FequentlyUsedMedalApi.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/2.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "FequentlyUsedMedalApi.h"
#import "BSSettings.h"

@implementation FequentlyUsedMedalApi
{
    NSString *_teacherId;
    NSString *_classId;
    NSNumber *_medalType;
}

- (id)initWithTeacherId:(NSString *)teacherId classId:(NSString *)classId medalType:(NSNumber *)medalType
{
    self = [super init];
    
    if (self) {
        _teacherId = teacherId;
        _classId = classId;
        _medalType = medalType;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"appapi/medal/getTeacherMedalByIdAndType";
}

- (id)requestArgument
{
    return @{@"appid": ([BSSettings appId] ? : @""),
             @"appkey": ([BSSettings appKey] ? : @""),
             @"teacherId": _teacherId ? : @"",
             @"classId": _classId ? : @"",
             @"medalType": _medalType ? : @""};
}

@end
