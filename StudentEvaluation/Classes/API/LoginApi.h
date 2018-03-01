//
//  LoginApi.h
//  ClassicsReading
//
//  Created by Yang.Lv on 2017/9/23.
//  Copyright © 2017年 bosheng. All rights reserved.
//

#import "BSBaseRequest.h"

@interface LoginApi : BSBaseRequest

- (id)initWithUsername:(NSString *)username password:(NSString *)password;

@end
