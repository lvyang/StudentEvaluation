//
//  LoginApi.m
//  ClassicsReading
//
//  Created by Yang.Lv on 2017/9/23.
//  Copyright © 2017年 bosheng. All rights reserved.
//

#import "LoginApi.h"
#import <UIKit/UIKit.h>
#import "BSSettings.h"

@interface LoginApi ()
{
    NSString    *_username;
    NSString    *_password;
}

@end

@implementation LoginApi

- (id)initWithUsername:(NSString *)username password:(NSString *)password
{
    self = [super init];
    
    if (self) {
        _username = username;
        _password = password;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"accountApi/getRoleByAccount";
}

- (id)requestArgument
{
    return @{@"username": _username,
             @"pwd": _password,
             @"appid": ([BSSettings appId] ? : @""),
             @"appkey": ([BSSettings appKey] ? : @"")};
}

@end
