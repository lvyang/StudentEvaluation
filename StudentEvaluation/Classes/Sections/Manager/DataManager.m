//
//  DataManager.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/2.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "DataManager.h"
#import "BSLoginManager.h"

@implementation DataManager

+ (instancetype)shareManager
{
    static id               manager = nil;
    static dispatch_once_t  onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (void)loadMedal:(MedalType)type forClass:(NSString *)classId completed:(void(^)(NSError *error, NSArray *result))completed
{
    if (type == MedalTypePraise && self.praiseMedals) {
        completed(nil, self.praiseMedals);
        return;
    }
    
    if (type == MedalTypeCriticism && self.critismMedal) {
        completed(nil, self.critismMedal);
        return;
    }

    [NetworkManager fequentlyUsedMedalForTeacher:[BSLoginManager shareManager].userModel.userId class:classId medalType:@(type) completed:completed];
}

@end
