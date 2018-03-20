//
//  NoticeModel.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/16.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeModel : NSObject

@property (nonatomic, strong) NSString  *content;
@property (nonatomic, strong) NSDate    *createDate;
@property (nonatomic, strong) NSString  *day;
@property (nonatomic, strong) NSString  *dayTime;
@property (nonatomic, strong) NSString  *identifier;
@property (nonatomic, strong) NSString  *medalScoreId;
@property (nonatomic, strong) NSNumber  *readStatus;
@property (nonatomic, strong) NSNumber  *status;
@property (nonatomic, strong) NSString  *studentId;
@property (nonatomic, strong) NSString  *studentName;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, assign) BOOL      wheherEvaluate;

@end
