//
//  DataManager.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/2.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSClassModel.h"
#import "NetworkManager.h"
#import "BSMedalModel.h"

@interface DataManager : NSObject

@property (nonatomic, strong) BSClassModel *currentClass;
@property (nonatomic, strong) NSArray *classList;

@property (nonatomic, strong) NSArray *praiseMedals; // 已添加的表扬勋章
@property (nonatomic, strong) NSArray *critismMedal; // 已添加的批评勋章

+ (instancetype)shareManager;

- (void)loadMedal:(MedalType)type forClass:(NSString *)classId completed:(void(^)(NSError *error, NSArray *result))completed;

@end
