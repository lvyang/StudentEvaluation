//
//  MedalRecordCell.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/13.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "LYBaseTableViewCell.h"
@class MedalRecordCell;

@protocol MedalRecordCellDelegate<NSObject>

- (void)revokeRecord:(MedalRecordCell *)cell;

@end

@interface MedalRecordCell : LYBaseTableViewCell

@property (nonatomic, weak) id <MedalRecordCellDelegate> delegate;

@end
