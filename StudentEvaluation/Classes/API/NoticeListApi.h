//
//  NoticeListApi.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/16.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BSBaseRequest.h"

@interface NoticeListApi : BSBaseRequest

- (id)initWithUserId:(NSString *)userId page:(NSNumber *)page count:(NSNumber *)count;

@end
