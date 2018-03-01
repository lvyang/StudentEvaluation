//
//  GetVerifyCodeApi.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/1.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "GetVerifyCodeApi.h"
#import "BSSettings.h"

@implementation GetVerifyCodeApi
{
    NSString *_phoneNumber;
    NSString *_userId;
}

- (id)initPhoneNumber:(NSString *)phoneNumber userId:(NSString *)userId
{
    self = [super init];
    
    if (self) {
        _phoneNumber = phoneNumber;
        _userId = userId;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"appapi/phoneSms/getCodePhone";
}

- (id)requestArgument
{
    return @{@"appid": ([BSSettings appId] ? : @""),
             @"appkey": ([BSSettings appKey] ? : @""),
             @"userid": _userId ? : @"",
             @"phone": _phoneNumber};
}

@end
