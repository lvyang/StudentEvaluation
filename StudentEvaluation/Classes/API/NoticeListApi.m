//
//  NoticeListApi.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/16.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "NoticeListApi.h"
#import "BSSettings.h"

@implementation NoticeListApi
{
    NSString *_userId;
    NSNumber *_page;
    NSNumber *_count;
}

- (id)initWithUserId:(NSString *)userId page:(NSNumber *)page count:(NSNumber *)count
{
    self = [super init];
    
    if (self) {
        _userId = userId;
        _page = page;
        _count = count;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"appapi/selfProve/querySelfProveByTime";
}

- (id)requestArgument
{
    return @{@"appid": ([BSSettings appId] ? : @""),
             @"appkey": ([BSSettings appKey] ? : @""),
             @"teacherId": _userId ? : @"",
             @"curpage": _page ? : @0,
             @"pagesize": _count ? : @0};
}

@end
