//
//  AddMedalToFrequentUsedApi.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/5.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BSBaseRequest.h"

@interface AddMedalToFrequentUsedApi : BSBaseRequest

- (id)initWithTeacherId:(NSString *)teacherId medalId:(NSString *)medalId;

@end
