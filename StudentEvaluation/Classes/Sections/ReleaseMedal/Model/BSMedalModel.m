//
//  BSMedalModel.m
//  BSCourseModule
//
//  Created by Yang.Lv on 2017/4/17.
//  Copyright © 2017年 lvyang. All rights reserved.
//

#import "BSMedalModel.h"

@implementation BSMedalModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"identifier":@"id",
             @"medalType":@"medal_type",
             @"medalName":@"medal_name",
             @"medalIcon":@"img_url",

             @"medalFieldId":@"veidoo_id",
             @"medalFieldName":@"veidoo_name"};
}

@end
