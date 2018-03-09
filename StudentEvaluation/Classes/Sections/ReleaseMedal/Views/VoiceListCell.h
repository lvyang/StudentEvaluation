//
//  VoiceListCell.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/9.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "LYBaseTableViewCell.h"
@class VoiceListCell;

@protocol VoiceListCellDelegate<NSObject>

- (void)didClickDeleteButton:(VoiceListCell *)cell;

@end

@interface VoiceListCell : LYBaseTableViewCell

@property (nonatomic, weak) id <VoiceListCellDelegate> delegate;

@end
