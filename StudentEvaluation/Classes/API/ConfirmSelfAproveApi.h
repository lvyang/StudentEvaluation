//
//  ConfirmSelfAproveApi.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/16.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BSBaseRequest.h"

@interface ConfirmSelfAproveApi : BSBaseRequest

- (id)initWithTeacherId:(NSString *)teacherId comment:(NSString *)comment studentId:(NSString *)studentId score:(NSNumber *)score studentSelfId:(NSString *)studentSelfId voices:(NSArray *)voices photos:(NSArray *)attachment;

@end
