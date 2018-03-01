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
             @"userName":@"user_name",
             @"nickName":@"nickname",
             @"userIcon":@"imgurl",
             @"roleId":@"user_status",
             @"sex":@"sex",
             @"phone":@"phone"};
}

@end
