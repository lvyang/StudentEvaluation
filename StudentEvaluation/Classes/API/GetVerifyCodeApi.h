//
//  GetVerifyCodeApi.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/1.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BSBaseRequest.h"

@interface GetVerifyCodeApi : BSBaseRequest

- (id)initPhoneNumber:(NSString *)phoneNumber userId:(NSString *)userId;

@end
