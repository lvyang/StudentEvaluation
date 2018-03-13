//
//  MedalRecordModel.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/13.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MedalRecordModel : NSObject

@property (nonatomic, strong) NSString *classId;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *dayTime;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) BOOL isValid;
@property (nonatomic, strong) NSString *medalName;
@property (nonatomic, strong) NSNumber *medalSource;
@property (nonatomic, strong) NSString *medalType; // 表扬 or 批评
@property (nonatomic, strong) NSString *medalScoreId;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *studentId;
@property (nonatomic, strong) NSString *studentName;
@property (nonatomic, strong) NSString *teacherId;
@property (nonatomic, strong) NSString *teacherName;
@property (nonatomic, strong) NSString *fieldId;  // 维度id

@end
