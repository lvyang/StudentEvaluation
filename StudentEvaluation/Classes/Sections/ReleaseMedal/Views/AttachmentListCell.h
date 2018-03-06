//
//  AttachmentListCell.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/6.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LYBaseCollectionCell.h>
@class AttachmentListCell;

@protocol AttachmentListCellDelegate<NSObject>

- (void)deleteAttachment:(AttachmentListCell *)cell;

@end

@interface AttachmentListCell : LYBaseCollectionCell

@property (nonatomic, assign) id <AttachmentListCellDelegate> delegate;

@end
