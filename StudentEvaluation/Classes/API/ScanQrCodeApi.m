//
//  ScanQrCodeApi.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/14.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "ScanQrCodeApi.h"
#import "BSSettings.h"

@implementation ScanQrCodeApi
{
    NSString *_text;
    NSString *_userId;
}

- (id)initWithText:(NSString *)text userId:(NSString *)userId
{
    self = [super init];
    
    if (self) {
        _text = text;
        _userId = userId;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"appapi/qrCode/receiveQrCode";
}

- (id)requestArgument
{
    return @{@"appid": ([BSSettings appId] ? : @""),
             @"appkey": ([BSSettings appKey] ? : @""),
             @"userid": _userId ? : @"",
             @"infoStrs": _text ? : @""};
}

@end
