//
//  BSUserModel.h
//  Pods
//
//  Created by Yang.Lv on 2017/3/18.
//
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import "BSUserRelationshipModel.h"
#import <UIKit/UIKit.h>

// 用户角色类型枚举
typedef NS_ENUM (NSInteger, BSUserRoleType) {
    BSUserRoleTypeUnknow,       // 未知类型
    BSUserRoleTypeStudent,      // 学生
    BSUserRoleTypeTeacher,      // 老师
    BSUserRoleTypeParent,       // 家长
    BSUserRoleTypeTeachingStaff // 教育工作者
};

@interface BSUserModel : NSObject

/**
 * 用户基本信息
 */
@property (nonatomic, strong) NSString  *userId;                            // 用户ID
@property (nonatomic, strong) NSString  *userName;                          // 用户账号
@property (nonatomic, strong) NSString  *nickName;                          // 昵称
@property (nonatomic, strong) NSString  *userIcon;                          // 用户头像
@property (nonatomic, strong) NSNumber  *roleId;                            // 角色
@property (nonatomic, strong) NSString  *sex;                               // 性别
@property (nonatomic, strong) NSString  *phone;                             // 电话

@end
