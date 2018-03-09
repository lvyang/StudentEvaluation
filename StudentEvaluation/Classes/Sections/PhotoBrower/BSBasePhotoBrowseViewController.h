//
//  BasePhotoBrowseViewController.h
//  dodoedu
//
//  Created by Yang.Lv on 16/8/24.
//  Copyright © 2016年 bosu. All rights reserved.
//

#import "MWPhotoBrowser/MWPhotoBrowser.h"
#import "BSPhotoModel.h"
#import "MBProgressHUD.h"
#import "ALAssetsLibrary+BSAssetsHelper.h"
#import "UIView+LayoutMethods.h"
#import "UIImage+ImageAddition.h"

/**
 * 图片浏览 view controller
 */
@interface BSBasePhotoBrowseViewController : MWPhotoBrowser<MWPhotoBrowserDelegate>

@property (nonatomic, strong) UIToolbar *bottomToolBar;

@property (nonatomic, strong) NSMutableArray *photosArray;

/** 浏览是起始索引 */
@property (nonatomic, assign) NSInteger startIndex;

// 返回按钮标题
@property (nonatomic, strong) NSString *backTitle;


- (void)showPrompt:(NSString *)title;
- (void)showPrompt:(NSString *)title inView:(UIView *)view;

- (void)downloadImage:(id)sender;

- (id)initWithImageUrlArray:(NSArray *)imageUrl;
- (id)initWithImageInfoArray:(NSArray *)imageModelArray;
- (id)initWithImages:(NSArray *)images;


@end
