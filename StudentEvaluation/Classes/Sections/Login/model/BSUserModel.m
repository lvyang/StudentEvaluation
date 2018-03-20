//
//  BSUserModel.m
//  Pods
//
//  Created by Yang.Lv on 2017/3/18.
//
//

#import "BSUserModel.h"

@implementation BSUserModel

/** @override */
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"userId":@"userid",
             @"userName":@"username",
             @"nickName":@"nickname",
             @"userIcon":@"imgurl",
             @"roleId":@"user_status",
             @"sex":@"sex",
             @"phone":@"phone",
             
             @"appId":@"appid",
             @"appkey":@"appkey"};
}

@end
