//
//  SelectMedalCollectionView.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/2.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "SelectMedalCollectionView.h"
#import "MedalCollectionViewCell.h"
#import "AddMedalCollectionViewCell.h"

@interface SelectMedalCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation SelectMedalCollectionView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame collectionViewLayout:[self flowLayout]]) {
        [self registerNib:[UINib nibWithNibName:@"MedalCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MedalCollectionViewCell"];
        [self registerNib:[UINib nibWithNibName:@"AddMedalCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AddMedalCollectionViewCell"];

        self.dataArray = [NSMutableArray array];
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    
    return self;
}

- (UICollectionViewFlowLayout *) flowLayout
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat width = (screenWidth - 5 * 2) / 4 - 1;
    CGFloat height = 188 * width / 144;
    
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
    return self.dataArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArray.count) {
        NSString *cellId = @"AddMedalCollectionViewCell";
        LYBaseCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        return cell;
    } else {
        NSString *cellId = @"MedalCollectionViewCell";
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
    if (indexPath.row == self.dataArray.count) {
        return;
    }
    
    if (self.cellSelectedHandler) {
        self.cellSelectedHandler(collectionView, indexPath, self.dataArray[indexPath.row]);
    }
}

@end
