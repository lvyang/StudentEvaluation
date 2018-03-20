//
//  BindPhoneApi.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/20.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BindPhoneApi.h"
#import "BSSettings.h"

@implementation BindPhoneApi
{
    NSString *_userId;
    NSString *_phone;
    NSString *_identifyCode;
}

- (id)initWithUserId:(NSString *)userId phone:(NSString *)phone identifyCode:(NSString *)identifyCode
{
    self = [super init];
    
    if (self) {
        _userId = userId;
        _phone = phone;
        _identifyCode = identifyCode;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"appapi/phoneSms/changeBindingPhone";
}

- (id)requestArgument
{
    return @{@"appid": ([BSSettings appId] ? : @""),
             @"appkey": ([BSSettings appKey] ? : @""),
             @"userid": _userId ? : @"",
             @"phone": _phone ? : @"",
             @"identifyCode": _identifyCode ? : @""};
}

@end
