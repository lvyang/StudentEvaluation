//
//  NetworkManager.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/1.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

// 获取验证码
+ (void)getVerficationCode:(NSString *)phone userId:(NSString *)userId completed:(void(^)(NSError *error ,NSString *code))completed;

// 重置密码
+ (void)resetPassword:(NSString *)password verifyCode:(NSString *)verifyCode phone:(NSString *)phone completed:(void(^)(NSError *error))completed;

// 常用勋章
+ (void)fequentlyUsedMedalForTeacher:(NSString *)teacherId class:(NSString *)classId medalType:(NSNumber *)medalType completed:(void(^)(NSError *error,NSArray *result))completed;

// 获取班级列表
+ (void)classListForTeacherId:(NSString *)teacherId completed:(void(^)(NSError *error,NSArray *result))completed;

// 勋章库
+ (void)loadMedalLibraryForTeacher:(NSString *)teacherId class:(NSString *)classId medalType:(NSNumber *)medalType completed:(void(^)(NSError *error,NSArray *result))completed;

// 将勋章添加到常用
+ (void)addMedalToFrequent:(NSString *)medalId teacherId:(NSString *)teacherId completed:(void(^)(NSError *error))completed;

@end
