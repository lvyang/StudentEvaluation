//
//  BSUserRelationshipModel.h
//  Pods
//
//  Created by Yang.Lv on 2017/4/13.
//
//

#import <Foundation/Foundation.h>
#import "BSSubjectModel.h"
#import "YYModel.h"
@class BSUserModel;

// 学段枚举
typedef NS_ENUM (NSInteger, BSSchoolType) {
    BSSchoolTypePrimary = 1,    // 小学
    BSSchoolTypeMiddle,         // 初中
    BSSchoolTypeSenior          // 高中
};

/**
 *  用户关系信息
 */
@interface BSUserRelationshipModel : NSObject

/**
 *  学校信息
 */
@property (nonatomic, strong) NSNumber      *schoolId;                      // 学校ID
@property (nonatomic, strong) NSString      *schoolName;                    // 学校名称
@property (nonatomic, strong) NSNumber      *schoolYear;                    // 入学年
@property (nonatomic, assign) BSSchoolType  schoolType;                     // 学段

@property (nonatomic, strong) NSString  *schoolCountyCode;                  // 学校所属区县代码
@property (nonatomic, strong) NSString  *schoolCountyName;                  // 学校所属区县
@property (nonatomic, strong) NSString  *schoolCityCode;                    // 学校所属城市代码
@property (nonatomic, strong) NSString  *schoolCityName;                    // 学校所属城市
@property (nonatomic, strong) NSString  *schoolProvinceCode;                // 学校所属省代码
@property (nonatomic, strong) NSString  *schoolProvinceName;                // 学校所属省

@property (nonatomic, strong) NSArray <NSString *> *schoolAdmins;           // 学校管理员用户id数组列表

/**
 *  班级信息
 */
@property (nonatomic, strong) NSNumber  *classId;                               // 班级id
@property (nonatomic, strong) NSString  *className;                             // 班级名称
@property (nonatomic, strong) NSString  *classLogo;                             // 班级图标
@property (nonatomic, strong) NSString  *classInvitationCode;                   // 班级邀请码
@property (nonatomic, strong) NSNumber  *classScore;                            // 班级积分
@property (nonatomic, strong) NSNumber  *teacherCount;                          // 教师数量
@property (nonatomic, strong) NSNumber  *studentCount;                          // 学生数量
@property (nonatomic, strong) NSNumber  *parentCount;                           // 家长数量
@property (nonatomic, strong) NSNumber  *totalCount;                            // 总成员数量

@property (nonatomic, strong) NSArray <BSUserModel *>       *classAdmins;       // 教师学科列表
@property (nonatomic, strong) NSArray <BSSubjectModel *>    *teacherSubject;    // 教师学科列表

/**
 *  年级信息
 */
@property (nonatomic, strong) NSNumber  *gradeCode; // 用户当前年级代码，仅学生角色有本字段返回
@property (nonatomic, strong) NSString  *gradeName; // 用户当前学年名称，仅学生角色有本字段返回

@end
