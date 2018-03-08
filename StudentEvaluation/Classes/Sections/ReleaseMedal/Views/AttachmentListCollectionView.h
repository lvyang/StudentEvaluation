//
//  AttachmentListCollectionView.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/6.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

/* table view cell did selected handler **/
typedef void (^ CollectionViewCellDidSelectedHandler)(UICollectionView *collectionView, NSIndexPath *indexPath, id dataModel);

@interface AttachmentListCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) CollectionViewCellDidSelectedHandler cellSelectedHandler;
@property (nonatomic, copy) void(^addAttachmentHandler)(void);
@property (nonatomic, copy) CollectionViewCellDidSelectedHandler deletAttachmentHandler;

@end
