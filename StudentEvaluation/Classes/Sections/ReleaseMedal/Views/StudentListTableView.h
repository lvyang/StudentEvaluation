//
//  StudengListTableView.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/12.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "LYBaseTableView.h"

@interface StudentListTableView : LYBaseTableView

@property (nonatomic, strong) NSMutableSet *selectedItems;
@property (nonatomic, strong) NSMutableArray *keys;

@end
