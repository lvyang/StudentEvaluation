//
//  BindPhoneApi.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/20.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BSBaseRequest.h"

@interface BindPhoneApi : BSBaseRequest

- (id)initWithUserId:(NSString *)userId phone:(NSString *)phone identifyCode:(NSString *)identifyCode;

@end
