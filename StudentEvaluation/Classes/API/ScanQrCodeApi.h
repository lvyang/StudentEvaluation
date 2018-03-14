//
//  ScanQrCodeApi.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/14.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BSBaseRequest.h"

@interface ScanQrCodeApi : BSBaseRequest

- (id)initWithText:(NSString *)text userId:(NSString *)userId;

@end
