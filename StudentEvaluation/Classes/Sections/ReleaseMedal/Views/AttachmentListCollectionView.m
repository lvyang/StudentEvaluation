//
//  AttachmentListCollectionView.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/6.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "AttachmentListCollectionView.h"
#import "AttachmentListCell.h"
#import "AddAttachmentCell.h"

static NSInteger MAX_ATACHMENT_COUNT = 5;

@interface AttachmentListCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation AttachmentListCollectionView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame collectionViewLayout:[self flowLayout]]) {
        [self registerNib:[UINib nibWithNibName:@"AttachmentListCell" bundle:nil] forCellWithReuseIdentifier:@"AttachmentListCell"];
        [self registerNib:[UINib nibWithNibName:@"AddAttachmentCell" bundle:nil] forCellWithReuseIdentifier:@"AddAttachmentCell"];

        self.dataArray = [NSMutableArray array];
        self.delegate = self;
        self.dataSource = self;
        
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    
    return self;
}

- (UICollectionViewFlowLayout *) flowLayout
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat width = (screenWidth - 5 * 2) / 3 - 1;
    CGFloat height = width;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(width, height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 15;
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    return layout;
}

#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataArray.count <= MAX_ATACHMENT_COUNT - 1) {
        return self.dataArray.count + 1;
    }
    return MAX_ATACHMENT_COUNT;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count <= MAX_ATACHMENT_COUNT - 1 && indexPath.row == self.dataArray.count) {
        NSString *cellId = @"AddAttachmentCell";
        LYBaseCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        return cell;
    } else {
        NSString *cellId = @"AttachmentListCell";
        LYBaseCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        id                  item = self.dataArray[indexPath.row];
        
        if ([cell respondsToSelector:@selector(configureCellWithModel:atIndexPath:)]) {
            [cell configureCellWithModel:item atIndexPath:indexPath];
        }
        
        return cell;
    }
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[AddAttachmentCell class]]) {
        if (self.addAttachmentHandler) {
            self.addAttachmentHandler();
        }
        return;
    }
    
    if (self.cellSelectedHandler) {
        self.cellSelectedHandler(collectionView, indexPath, self.dataArray[indexPath.row]);
    }
}

@end
