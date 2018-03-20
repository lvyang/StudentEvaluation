//
//  ChangePasswordApi.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/20.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "ChangePasswordApi.h"
#import "BSSettings.h"

@implementation ChangePasswordApi
{
    NSString *_userName;
    NSString *_oldPassword;
    NSString *_newPassword;
}

- (id)initWithUserName:(NSString *)userName oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword
{
    self = [super init];
    
    if (self) {
        _userName = userName;
        _oldPassword = oldPassword;
        _newPassword = newPassword;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"accountApi/changePwd";
}

- (id)requestArgument
{
    return @{@"appid": ([BSSettings appId] ? : @""),
             @"appkey": ([BSSettings appKey] ? : @""),
             @"username": _userName ? : @"",
             @"oldpwd": _oldPassword ? : @"",
             @"newpwd": _newPassword ? : @""};
}


@end
