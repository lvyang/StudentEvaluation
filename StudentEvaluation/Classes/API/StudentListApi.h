//
//  StudentListApi.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/12.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BSBaseRequest.h"

@interface StudentListApi : BSBaseRequest

- (id)initWithClassId:(NSString *)classId;

@end
