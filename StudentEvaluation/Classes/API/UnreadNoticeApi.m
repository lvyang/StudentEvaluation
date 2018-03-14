//
//  UnreadNoticeApi.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/14.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "UnreadNoticeApi.h"
#import "BSSettings.h"

@implementation UnreadNoticeApi
{
    NSString *_userId;
}

- (id)initWithUserId:(NSString *)userId
{
    self = [super init];
    
    if (self) {
        _userId = userId;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"appapi/selfProve/queryUnRedSelfProveCount";
}

- (id)requestArgument
{
    return @{@"appid": ([BSSettings appId] ? : @""),
             @"appkey": ([BSSettings appKey] ? : @""),
             @"teacherId": _userId ? : @""};
}

@end
