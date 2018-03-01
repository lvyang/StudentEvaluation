//
//  BSUserRelationshipModel.m
//  Pods
//
//  Created by Yang.Lv on 2017/4/13.
//
//

#import "BSUserRelationshipModel.h"
#import "BSUserModel.h"

@implementation BSUserRelationshipModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
               @"schoolId":@"school_id",
               @"schoolName":@"school_name",
               @"schoolYear":@"school_year",
               @"schoolType":@"school_type",
               @"schoolCountyCode":@"school_county_code",
               @"schoolCountyName":@"school_county_name",
               @"schoolCityCode":@"school_city_code",
               @"schoolCityName":@"school_city_name",
               @"schoolProvinceCode":@"school_province_code",
               @"schoolProvinceName":@"school_province_name",

               @"classId":@"class_id",
               @"className":@"class_name",
               @"classLogo":@"class_logo",
               @"classInvitationCode":@"class_invitation_code",
               @"classScore":@"class_score",
               @"teacherCount":@"teachers_count",
               @"studentCount":@"students_count",
               @"parentCount":@"parents_count",
               @"totalCount":@"total",
               
               @"classAdmins":@"class_admin",
               @"teacherSubject":@"teacher_subject",

               @"gradeCode":@"grade_code",
               @"gradeName":@"grade"
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"teacherSubject" : [BSSubjectModel class],
             @"classAdmins" : [BSUserModel class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    NSArray         *schoolAdmins = [dic objectForKey:@"school_admins"];
    NSMutableArray  *tempArray = [NSMutableArray array];

    for (NSDictionary *dic in schoolAdmins) {
        if ([dic objectForKey:@"user_id"]) {
            [tempArray addObject:[dic objectForKey:@"user_id"]];
        }
    }

    self.schoolAdmins = tempArray;
    return YES;
}

@end
