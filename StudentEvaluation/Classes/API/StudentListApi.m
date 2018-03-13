//
//  StudentListApi.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/12.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "StudentListApi.h"
#import "BSSettings.h"

@implementation StudentListApi
{
    NSString *_classId;
}

- (id)initWithClassId:(NSString *)classId
{
    self = [super init];
    
    if (self) {
        _classId = classId;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"appapi/classInfo/getStudentsByOldClassId";
}

- (id)requestArgument
{
    return @{@"appid": ([BSSettings appId] ? : @""),
             @"appkey": ([BSSettings appKey] ? : @""),
             @"classId": _classId ? : @""};
}

@end
