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
#import <TZImagePickerController.h>

@interface ReleaseMedalViewController ()

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
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 delegate:nil];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)addVideo
{
    
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.attachmentListHeight.constant = self.collectionView.contentSize.height;
    }
}

@end
