//
//  ClassListTableView.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/5.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "LYBaseTableView.h"
#import "BSClassModel.h"

@interface ClassListTableView : LYBaseTableView

@property (nonatomic, strong) BSClassModel *selectedClass;

@end
