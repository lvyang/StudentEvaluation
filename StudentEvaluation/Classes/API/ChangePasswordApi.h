//
//  ChangePasswordApi.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/1.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BSBaseRequest.h"

@interface ChangePasswordApi : BSBaseRequest

- (id)initWithUserName:(NSString *)userName oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword;

@end
