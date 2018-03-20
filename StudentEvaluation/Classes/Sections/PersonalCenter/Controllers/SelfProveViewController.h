//
//  SelfProveViewController.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/16.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BSViewController.h"
#import "NoticeModel.h"
#import "BSMedalModel.h"

@interface SelfProveViewController : BSViewController

@property (nonatomic, strong) NoticeModel *model;
@property (nonatomic, assign) MedalType medalType;

@end
