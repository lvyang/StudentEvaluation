//
//  ReleaseMedalViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/5.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "ReleaseMedalViewController.h"
#import "LYPlaceholderTextView.h"
#import <UIImageView+WebCache.h>
#import "AttachmentListCollectionView.h"
#import <Masonry.h>
#import "TZImagePickerController.h"
#import "WechatShortVideoController.h"
#import "BSAttachmentModel.h"
#import <Photos/Photos.h>
#import "BSVideoUtil.h"
#import "BSRecordView.h"

@interface ReleaseMedalViewController ()<BSRecordViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *medalIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *medalName;
@property (weak, nonatomic) IBOutlet UIButton *selectStudentButton;
@property (weak, nonatomic) IBOutlet UIView *attachmentListBackgroundView;
@property (weak, nonatomic) IBOutlet LYPlaceholderTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *textCountLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *scoreButtons;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (nonatomic, strong) AttachmentListCollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attachmentListHeight;

@end

@implementation ReleaseMedalViewController

- (void)dealloc
{
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.model.medalIcon ? : @""];
    [self.medalIconImageView sd_setImageWithURL:url];
    self.medalName.text = self.model.medalName;
    
    __weak typeof(self) weakSelf = self;
    {
        self.collectionView = [[AttachmentListCollectionView alloc] initWithFrame:self.attachmentListBackgroundView.bounds];
        [self.attachmentListBackgroundView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.attachmentListBackgroundView.mas_top).with.offset(0);
            make.bottom.equalTo(self.attachmentListBackgroundView.mas_bottom).with.offset(0);
            make.left.equalTo(self.attachmentListBackgroundView.mas_left).with.offset(0);
            make.right.equalTo(self.attachmentListBackgroundView.mas_right).with.offset(0);
        }];
        
        self.collectionView.cellSelectedHandler = ^(UICollectionView *collectionView, NSIndexPath *indexPath, id dataModel) {
        };
        
        self.collectionView.addAttachmentHandler = ^{
            [weakSelf addAttachment];
        };
        
        self.collectionView.deletAttachmentHandler = ^(UICollectionView *collectionView, NSIndexPath *indexPath, id dataModel) {
            [weakSelf.collectionView.dataArray removeObjectAtIndex:indexPath.row];
            [weakSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        };
        
        [self.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [self.collectionView reloadData];
    }
    
    self.textView.placeholder = @"请在这里填写事件描述";
}

- (IBAction)selectStudent:(id)sender
{
    
}

- (IBAction)record:(id)sender
{
    BSRecordView *recordView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BSRecordView class]) owner:nil options:nil][0];
    recordView.delegate = self;
    [recordView show];
}

- (IBAction)send:(id)sender
{
    
}

- (void)addAttachment
{
    UIAlertController *alertViewController = [[UIAlertController alloc] init];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self addImage];
    }];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self addVideo];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertViewController addAction:albumAction];
    [alertViewController addAction:cameraAction];
    [alertViewController addAction:cancelAction];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

- (void)addImage
{
    NSInteger videoCount = 0;
    NSMutableArray *selectedAsset = [NSMutableArray array];
    for (BSAttachmentModel *model in self.collectionView.dataArray) {
        if (!model.isVideo) {
            [selectedAsset addObject:model.asset];
        } else {
            videoCount++;
        }
    }
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 delegate:nil];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.maxImagesCount = 5 - videoCount;
    imagePickerVc.selectedAssets = selectedAsset;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        NSMutableArray *items = [NSMutableArray array];
        
        for (int i = 0; i < photos.count; i++) {
            BSAttachmentModel *model = [[BSAttachmentModel alloc] init];
            model.image = photos[i];
            model.asset = assets[i];
            model.isVideo = NO;
            [items addObject:model];
        }
        
        // 去重
        for (BSAttachmentModel *model in self.collectionView.dataArray.copy) {
            if (model.isVideo) {
                continue;
            }
            
            BOOL exist = NO;
            BSAttachmentModel *existAttachment = nil;
            PHAsset *asset = model.asset;
            for (BSAttachmentModel *attachment in items.copy) {
                if ([asset.localIdentifier isEqualToString:attachment.asset.localIdentifier]) {
                    exist = YES;
                    existAttachment = attachment;
                    break;
                }
            }
            
            if (exist) {
                [items removeObject:existAttachment];
            } else {
                [self.collectionView.dataArray removeObject:model];
            }
        }
        
        [self.collectionView.dataArray addObjectsFromArray:items];
        [self.collectionView reloadData];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)addVideo
{
    __weak typeof(self) weakSelf = self;
    WechatShortVideoController *wechatShortVideoController = [[WechatShortVideoController alloc] init];
    wechatShortVideoController.didFinishRecordHandle = ^(NSError *error, NSURL *videoUrl) {
        if (error) {
            return ;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        BSAttachmentModel *model = [[BSAttachmentModel alloc] init];
        model.image = [BSVideoUtil screenShotImageFromVideoPath:videoUrl.absoluteString];
        model.videoDuration = @([BSVideoUtil durationFromVideoPath:videoUrl.absoluteString]);
        model.isVideo = YES;
        [strongSelf.collectionView.dataArray addObject:model];
        [strongSelf.collectionView reloadData];
    };
    
    [self presentViewController:wechatShortVideoController animated:YES completion:nil];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.attachmentListHeight.constant = self.collectionView.contentSize.height;
    }
}

#pragma mark - BSRecordViewDelegate
- (void)recordView:(BSRecordView *)recordView recordFinished:(NSString *)filePath error:(NSError *)error
{
    if (error) {
        NSLog(@"%@",error.localizedDescription);
    }
    NSLog(@"=======");
}

@end
