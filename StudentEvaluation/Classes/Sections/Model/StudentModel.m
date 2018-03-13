//
//  StudentModel.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/12.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "StudentModel.h"

@implementation StudentModel


- (BOOL)isEqual:(StudentModel *)object
{
    if (![object isKindOfClass:[StudentModel class]]) {
        return NO;
    }
    
    return [object.identifier isEqualToString:self.identifier];
}

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"identifier":@"id",
             @"studentName":@"student_name",
             @"studentCode":@"student_code",
             @"iconUrl":@"imgurl",
             @"phone":@"phone",
             @"email":@"email",
             @"sex":@"sex",
             @"classId":@"class_id",
             @"className":@"class_nickname",
             @"gradeName":@"grade_name",
             @"schoolId":@"school_id",
             @"createDate":@"createTime",
             @"idCard":@"idcard",
             @"isValid":@"is_valid",
             @"lastLoginTime":@"last_login_time",
             @"roleCode":@"roll_code",
             @"updateTime":@"updateTime",
             @"userName":@"user_name",
             @"userPassword":@"user_pwd"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    if ([[dic objectForKey:@"createTime"] isKindOfClass:[NSNumber class]]) {
        self.createDate = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"createTime"] doubleValue]];
    }
    if ([[dic objectForKey:@"last_login_time"] isKindOfClass:[NSNumber class]]) {
        self.lastLoginTime = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"last_login_time"] doubleValue]];
    }
    if ([[dic objectForKey:@"updateTime"] isKindOfClass:[NSNumber class]]) {
        self.updateTime = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"updateTime"] doubleValue]];
    }

    return YES;
}

@end
