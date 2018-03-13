//
//  StudentModel.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/12.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

@interface StudentModel : NSObject

@property (nonatomic, strong) NSString  *identifier;    // student id
@property (nonatomic, strong) NSString  *studentName;   // 学生名称
@property (nonatomic, strong) NSString  *studentCode;
@property (nonatomic, strong) NSString  *iconUrl;       // 学生头像
@property (nonatomic, strong) NSString  *phone;
@property (nonatomic, strong) NSString  *email;
@property (nonatomic, strong) NSString  *sex;

@property (nonatomic, strong) NSString  *classId;
@property (nonatomic, strong) NSString  *className;
@property (nonatomic, strong) NSString  *gradeName;
@property (nonatomic, strong) NSString  *schoolId;

@property (nonatomic, strong) NSDate    *createDate;
@property (nonatomic, strong) NSString  *idCard;
@property (nonatomic, assign) BOOL      isValid;
@property (nonatomic, strong) NSDate    *lastLoginTime;
@property (nonatomic, strong) NSString  *roleCode;
@property (nonatomic, strong) NSDate    *updateTime;
@property (nonatomic, strong) NSString  *userName;
@property (nonatomic, strong) NSString  *userPassword;

// 程序用
@property (nonatomic, strong) NSString *pinyinString;

@end
