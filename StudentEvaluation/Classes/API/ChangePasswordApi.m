//
//  ChangePasswordApi.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/1.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "ChangePasswordApi.h"
#import "BSSettings.h"

@implementation ChangePasswordApi
{
    NSString *_phoneNumber;
    NSString *_code;
    NSString *_password;
}

- (id)initPhoneNumber:(NSString *)phoneNumber verifyCode:(NSString *)code password:(NSString *)password
{
    self = [super init];
    
    if (self) {
        _phoneNumber = phoneNumber;
        _code = code;
        _password = password;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"appapi/phoneSms/resetPassword";
}

- (id)requestArgument
{
    return @{@"appid": ([BSSettings appId] ? : @""),
             @"appkey": ([BSSettings appKey] ? : @""),
             @"phone": _phoneNumber ? : @"",
             @"identifyCode": _code ? : @"",
             @"newPwd": _password ? : @""};
}

@end
