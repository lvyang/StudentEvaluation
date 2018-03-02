//
//  BSClassModel.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/2.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BSClassModel.h"

@implementation BSClassModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"classCode":@"class_code",
             @"classId":@"class_id",
             @"classImageUrl":@"class_imageurl",
             @"className":@"class_nickname",
             @"courseName":@"course_name",
             @"gradeYear":@"grade_year",
             @"isClassTeacher":@"is_class_teacher",
             @"stageName":@"stage_name",
             @"teacherName":@"teacher_name"};
}

@end
