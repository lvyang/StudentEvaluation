//
//  MedalRecordTableView.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/13.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "LYBaseTableView.h"
#import "MedalRecordModel.h"

@interface MedalRecordTableView : LYBaseTableView

@property (nonatomic,copy) void(^revokeMedalHandler)(MedalRecordModel *model, NSIndexPath *indexPath);

@end
