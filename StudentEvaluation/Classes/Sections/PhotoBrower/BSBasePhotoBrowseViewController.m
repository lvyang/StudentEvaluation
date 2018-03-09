//
//  BasePhotoBrowseViewController.m
//  dodoedu
//
//  Created by Yang.Lv on 16/8/24.
//  Copyright © 2016年 bosu. All rights reserved.
//

#import "BSBasePhotoBrowseViewController.h"

@interface BSBasePhotoBrowseViewController ()

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, strong) UILabel *commentCountLabel;
@property (nonatomic, strong) UIBarButtonItem *commentItem;

@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UIBarButtonItem *likeItem;

@end



@implementation BSBasePhotoBrowseViewController

- (id)initWithImageUrlArray:(NSArray *)imageUrl
{
    NSMutableArray *photos = [NSMutableArray array];
    for (NSURL *url in imageUrl) {
        BSPhotoModel *model = [[BSPhotoModel alloc] init];
        model.url = url;
        [photos addObject:model];
    }

    return [self initWithImageInfoArray:photos];
}

- (id)initWithImageInfoArray:(NSArray *)imageModelArray
{
    if (self = [super init]) {
        self.photosArray = [NSMutableArray array];
        self.zoomPhotosToFill = NO;
        self.enableGrid = YES;
        self.startOnGrid = NO;
        self.enableSwipeToDismiss = NO;
        self.autoPlayOnAppear = YES;
        self.delegate = self;
        
        for (BSPhotoModel *model in imageModelArray) {
            MWPhoto *photo = [MWPhoto photoWithURL:model.url];
            photo.caption = model.desc;
            [self.photosArray addObject:photo];
        }
    }
    return self;
}

- (id)initWithImages:(NSArray *)images
{
    if (self = [super init]) {
        self.photosArray = [NSMutableArray array];
        self.zoomPhotosToFill = NO;
        self.enableGrid = YES;
        self.startOnGrid = NO;
        self.enableSwipeToDismiss = NO;
        self.autoPlayOnAppear = YES;
        self.delegate = self;
        
        for (UIImage *image in images) {
            MWPhoto *photo = [MWPhoto photoWithImage:image];
            [self.photosArray addObject:photo];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    // 下面bar button item
    {
        self.bottomToolBar = [self valueForKey:@"toolbar"];
        UIImage *image = [UIImage imageFromColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
        [self.bottomToolBar setBackgroundImage:image forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        self.bottomToolBar.clipsToBounds = YES;
        
        UIImage *downloadImage = [[UIImage imageNamed:@"pic_icon_download.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *downloadItem = [[UIBarButtonItem alloc] initWithImage:downloadImage style:UIBarButtonItemStylePlain target:self action:@selector(downloadImage:)];
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [self.bottomToolBar setItems:@[downloadItem,flexItem] animated:YES];
    }
     */
    
    self.bottomToolBar = [self valueForKey:@"toolbar"];
    [self.bottomToolBar removeFromSuperview];

    // back button
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 60, 30);
        [button setTitle:self.backTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"arrow_backward_white.png"] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
        [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = back;
    }
    
    [self setCurrentPhotoIndex:self.startIndex];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *image = [UIImage imageFromColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (ALAssetsLibrary *)assetsLibrary
{
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

#pragma mark -  button actions

- (void)back:(id)sender
{
    if (!self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downloadImage:(id)sender
{
    MWPhoto *photo = self.photosArray[self.currentIndex];
    
    if (!photo.underlyingImage) {
        return;
    }
    
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    NSString*appName =[bundleInfo objectForKey:@"CFBundleDisplayName"];
    [self.assetsLibrary saveImage:photo.underlyingImage toAlbum:appName completion:^(NSURL *assetURL, NSError *error) {
        NSString *message = @"照片已成功保存到系统相册！";
        if (error) {
            message = error.description;
        }
        [self showPrompt:message];
    } failure:^(NSError *error) {
        [self showPrompt:error.description];
    }];
}

#pragma mark - MBProgressHUD
- (void)showPrompt:(NSString *)title
{
    [self showPrompt:title inView:self.view];
}

- (void)showPrompt:(NSString *)title inView:(UIView *)view
{
    if (title.length == 0) {
        title = @"操作失败";
    }
    [_hud removeFromSuperview];
    _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = title;
    [_hud hide:YES afterDelay:2];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photosArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photosArray.count) {
        return [_photosArray objectAtIndex:index];
    }
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    return nil;
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    self.title = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)index + 1,(unsigned long)self.photosArray.count];
    return [NSString stringWithFormat:@"%ld/%ld",index+1,_photosArray.count];
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return YES;
}

#pragma mark - MWPhotoBrowserDelegate
- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [_photosArray objectAtIndex:index];
    if (photo.caption.length == 0) {
        return nil;
    }
    
    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:self.photosArray.firstObject];
    captionView.tintColor = nil;
    captionView.barTintColor = nil;
    UIImage *image = [UIImage imageFromColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    [captionView setBackgroundImage:image forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    captionView.barStyle = UIBarStyleBlack;
    captionView.clipsToBounds = YES;
    
    UILabel *label = [captionView valueForKey:@"label"];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:13];
    label.text = photo.caption;
    return captionView;
}


#pragma mark - UIScrollViewDelegate
/** @override */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 覆盖父类方法，滑动时不隐藏tabbar
}

@end
