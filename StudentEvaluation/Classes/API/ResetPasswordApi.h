//
//  ChangePasswordApi.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/1.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BSBaseRequest.h"

@interface ResetPasswordApi : BSBaseRequest

- (id)initPhoneNumber:(NSString *)phoneNumber verifyCode:(NSString *)code password:(NSString *)password;

@end
