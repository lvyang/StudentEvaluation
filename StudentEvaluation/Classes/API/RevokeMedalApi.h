//
//  RevokeMedalApi.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/13.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BSBaseRequest.h"

@interface RevokeMedalApi : BSBaseRequest

- (id)initWithMedalRecordId:(NSString *)recordId teacherId:(NSString *)teacherId;

@end
