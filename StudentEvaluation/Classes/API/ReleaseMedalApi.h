//
//  ReleaseMedalApi.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/12.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BSBaseRequest.h"

@interface ReleaseMedalApi : BSBaseRequest

- (id)initWithTeacherId:(NSString *)teacherId medalId:(NSString *)medalId studentIds:(NSString *)studentIds classId:(NSString *)classId score:(NSNumber *)score desc:(NSString *)desc voices:(NSArray *)voices photos:(NSArray *)attachment;

@end
