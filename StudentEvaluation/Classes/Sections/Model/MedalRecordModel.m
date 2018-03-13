//
//  MedalRecordModel.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/13.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "MedalRecordModel.h"

@implementation MedalRecordModel


+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"classId":@"class_id",
             @"createDate":@"createTime",
             @"day":@"day",
             @"dayTime":@"dayTime",
             @"desc":@"description",
             @"imageUrl":@"img_url",
             @"isValid":@"is_valid",
             @"medalName":@"medal_name",
             @"medalSource":@"medal_source",
             @"medalType":@"medal_type",
             @"medalScoreId":@"medalscore_id",
             @"score":@"score",
             @"source":@"source",
             @"studentId":@"student_id",
             @"studentName":@"student_name",
             @"teacherId":@"teacher_id",
             @"teacherName":@"teacher_name",
             @"fieldId":@"veidoo_id"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    if ([[dic objectForKey:@"createTime"] isKindOfClass:[NSNumber class]]) {
        self.createDate = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"createTime"] doubleValue]];
    }
    
    return YES;
}

@end
