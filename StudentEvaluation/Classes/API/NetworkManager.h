//
//  NetworkManager.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/1.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VoiceModel.h"
#import "BSAttachmentModel.h"
#import "StudentModel.h"
#import "BSClassModel.h"

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

// 某个班级下的学生列表
+ (void)loadStudentsList:(NSString *)classId completed:(void(^)(NSError *error,NSArray *result, NSArray *keys))completed;

// 颁发勋章
+ (void)releaseMedal:(NSString *)medalId toStudent:(NSArray <StudentModel *> *)students class:(BSClassModel *)class score:(NSNumber *)score teacher:(NSString *)teacherId desc:(NSString *)desc voice:(NSArray <VoiceModel *> *)voices attachments:(NSArray <BSAttachmentModel *> *)attachments completed:(void(^)(NSError *error))completed;

// 勋章颁发记录
+ (void)medalRecordForClass:(NSString *)classId teacher:(NSString *)teacherId page:(NSNumber *)page count:(NSNumber *)count completed:(void(^)(NSError *error,NSArray *result))completed;

// 撤回勋章
+ (void)revokeMedalRecord:(NSString *)medalRecordId teacherId:(NSString *)teacherId completed:(void(^)(NSError *error))completed;

@end
