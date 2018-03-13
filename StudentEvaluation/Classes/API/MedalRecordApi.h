//
//  MedalRecordApi.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/13.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BSBaseRequest.h"

@interface MedalRecordApi : BSBaseRequest

- (id)initWithClassId:(NSString *)classId teacherId:(NSString *)teacherId page:(NSNumber *)page pageSize:(NSNumber *)pageSize;

@end
