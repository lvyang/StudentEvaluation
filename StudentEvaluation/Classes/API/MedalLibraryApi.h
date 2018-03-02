//
//  MedalLibraryApi.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/2.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BSBaseRequest.h"

@interface MedalLibraryApi : BSBaseRequest

- (id)initWithTeacherId:(NSString *)teacherId classId:(NSString *)classId medalType:(NSNumber *)medalType;

@end
