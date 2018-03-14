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
#import "BSBasePhotoBrowseViewController.h"
#import "VideoPreviewViewController.h"
#import "VoiceListTableView.h"
#import "SelectStudentViewController.h"
#import "StudentModel.h"
#import "NetworkManager.h"
#import "DataManager.h"
#import "BSLoginManager.h"

static NSInteger TEXT_LIMIT = 150;

@interface ReleaseMedalViewController ()<BSRecordViewDelegate,SelectStudentViewControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottom;

@property (weak, nonatomic) IBOutlet UIImageView *medalIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *medalName;
@property (weak, nonatomic) IBOutlet UIButton *selectStudentButton;
@property (weak, nonatomic) IBOutlet UIView *attachmentListBackgroundView;
@property (weak, nonatomic) IBOutlet LYPlaceholderTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *textCountLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *scoreButtons;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UIView *voiceListBackgroundView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voiceListBackgroundViewHeight;
@property (nonatomic, strong) VoiceListTableView *tableView;

@property (nonatomic, strong) AttachmentListCollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attachmentListHeight;

@property (weak, nonatomic) IBOutlet UIButton *releaseButton;
@property (weak, nonatomic) IBOutlet UILabel *studentsNameLabel;
@property (nonatomic, strong ) NSArray *selectedStudents;

@property (nonatomic, assign) NSInteger score;

@end

@implementation ReleaseMedalViewController

- (void)dealloc
{
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"颁发奖章";
    NSURL *url = [NSURL URLWithString:self.model.medalIcon ? : @""];
    [self.medalIconImageView sd_setImageWithURL:url];
    self.medalName.text = self.model.medalName;
    
    __weak typeof(self) weakSelf = self;
    {
        self.tableView = [[VoiceListTableView alloc] initWithFrame:self.voiceListBackgroundView.bounds];
        [self.voiceListBackgroundView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.voiceListBackgroundView.mas_top).with.offset(0);
            make.bottom.equalTo(self.voiceListBackgroundView.mas_bottom).with.offset(0);
            make.left.equalTo(self.voiceListBackgroundView.mas_left).with.offset(0);
            make.right.equalTo(self.voiceListBackgroundView.mas_right).with.offset(0);
        }];
        
        self.tableView.addVoiceHandler = ^{
            [weakSelf addRecord];
        } ;
        
        [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(self.tableView)];
        [self.tableView reloadData];
    }
    
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
            [weakSelf browseAttachments:dataModel atIndex:indexPath.row];
        };
        
        self.collectionView.addAttachmentHandler = ^{
            [weakSelf addAttachment];
        };
        
        [self.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(self.collectionView)];
        [self.collectionView reloadData];
    }
    
    self.textView.placeholder = @"请在这里填写事件描述";
    self.textView.delegate = self;
    self.textCountLabel.text = [NSString stringWithFormat:@"0/%ld",(long)TEXT_LIMIT];
    
    self.releaseButton.layer.cornerRadius = 5;
    
    [self scoreButtonClick:self.scoreButtons.firstObject];
    
    // Add notifications
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)selectStudent:(id)sender
{
    SelectStudentViewController *vc = [[SelectStudentViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addRecord
{
    if (self.tableView.items.count >= 3) {
        [self showPrompt:@"最多可添加3个录音"];
        return;
    }
    
    BSRecordView *recordView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BSRecordView class]) owner:nil options:nil][0];
    recordView.delegate = self;
    [recordView show];
}

- (IBAction)send:(id)sender
{
    if (!self.selectedStudents.count) {
        [self showPrompt:@"请选择学生"];
        return;
    }
    
    BSClassModel *class = [DataManager shareManager].currentClass;
    NSString *teacherId = [BSLoginManager shareManager].userModel.userId;
    
    [self showLoadingProgress:nil];
    [NetworkManager releaseMedal:self.model.identifier toStudent:self.selectedStudents class:class score:@(self.score) teacher:teacherId desc:self.textView.text voice:self.tableView.items attachments:self.collectionView.dataArray completed:^(NSError *error) {
        [self hideLoadingProgress];
        
        if (error) {
            [self showPrompt:error.localizedDescription];
            return ;
        }
        
        UIView *successView = [[NSBundle mainBundle] loadNibNamed:@"ReleaseSuccessView" owner:nil options:nil][0];
        successView.frame = self.view.bounds;
        [self.view addSubview:successView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [successView removeFromSuperview];
            [self.navigationController popViewControllerAnimated:YES];
            
            for (BSAttachmentModel *model in self.collectionView.dataArray) {
                if (model.isVideo) {
                    [[NSFileManager defaultManager] removeItemAtPath:model.videoPath error:nil];
                }
            }
            
            for (VoiceModel *model in self.tableView.items) {
                [[NSFileManager defaultManager] removeItemAtPath:model.path error:nil];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didReleaseMedal" object:nil userInfo:nil];
        });
    }];
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

- (void)browseAttachments:(BSAttachmentModel *)model atIndex:(NSInteger)index
{
    if (model.isVideo) {
        VideoPreviewViewController *vc = [[VideoPreviewViewController alloc] init];
        vc.url = [NSURL fileURLWithPath:model.videoPath];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSMutableArray *images = [NSMutableArray array];
        for (BSAttachmentModel *model in self.collectionView.dataArray) {
            [images addObject:model.image];
        }
        
        BSBasePhotoBrowseViewController *vc = [[BSBasePhotoBrowseViewController alloc] initWithImages:images];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
        model.videoPath = videoUrl.path;
        model.isVideo = YES;
        [strongSelf.collectionView.dataArray addObject:model];
        [strongSelf.collectionView reloadData];
    };
    
    [self presentViewController:wechatShortVideoController animated:YES completion:nil];
}

- (IBAction)scoreButtonClick:(UIButton *)sender
{
    for (int i = 0; i < self.scoreButtons.count; i++) {
        UIButton *button = self.scoreButtons[i];
        button.selected = (button.tag <= sender.tag);
        if (self.model.medalType == MedalTypePraise) {
            [button setTitle:[NSString stringWithFormat:@"+%ld",(long)button.tag] forState:UIControlStateNormal];
        } else {
            [button setTitle:[NSString stringWithFormat:@"-%ld",(long)button.tag] forState:UIControlStateNormal];
        }
    }
    
    self.score = (self.model.medalType == MedalTypePraise) ? sender.tag: -sender.tag;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == (__bridge void * _Nullable)(self.tableView)) {
        self.voiceListBackgroundViewHeight.constant = self.tableView.contentSize.height;
    } else if (context == (__bridge void * _Nullable)(self.collectionView)) {
        self.attachmentListHeight.constant = self.collectionView.contentSize.height;
    }
}

#pragma mark - BSRecordViewDelegate
- (void)recordView:(BSRecordView *)recordView recordModel:(VoiceModel *)model error:(NSError *)error;
{
    [recordView hide];
    
    if (error) {
        [self showPrompt:error.localizedDescription];
        return;
    }
    
    [self.tableView.items addObject:model];
    [self.tableView reloadData];
}

#pragma mark - SelectStudentViewControllerDelegate
- (void)didSelectedStudent:(NSArray *)students
{
    self.selectedStudents = students;
    NSMutableArray *names = [NSMutableArray array];
    for (int i = 0; i < students.count; i++) {
        StudentModel *model = students[i];
        [names addObject:model.studentName];
    }
    
    self.studentsNameLabel.text = [names componentsJoinedByString:@","];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (str.length > TEXT_LIMIT) {
        return NO;
    }

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSDictionary *defaultAttribute = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"ABABAB"],
                                       NSFontAttributeName : [UIFont systemFontOfSize:13.f]};
    NSDictionary *hightAttribute = @{NSForegroundColorAttributeName : [UIColor redColor],
                                     NSFontAttributeName : [UIFont systemFontOfSize:13.f]};
    NSString *text = [NSString stringWithFormat:@"%ld/%ld", MIN(textView.text.length, TEXT_LIMIT), TEXT_LIMIT];
    NSMutableAttributedString   *attributeString = [[NSMutableAttributedString alloc] initWithString:text attributes:defaultAttribute];
    
    if (textView.text.length >= TEXT_LIMIT) {
        NSString *str = [text componentsSeparatedByString:@"/"].firstObject;
        [attributeString addAttributes:hightAttribute range:NSMakeRange(0, str.length)];
    }
    
    self.textCountLabel.attributedText = attributeString;
}

#pragma mark - NSNotification method
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSTimeInterval animationDuration;
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [animationDurationValue getValue:&animationDuration];
    
    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    endRect = [self.view convertRect:endRect fromView:[UIApplication sharedApplication].keyWindow];
    CGFloat keyboardHeight = endRect.size.height;
    
    self.scrollViewBottom.constant = keyboardHeight;

    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        CGRect rect = [self.scrollView convertRect:self.textView.frame fromView:self.textView.superview];
        [self.scrollView scrollRectToVisible:rect animated:YES];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSTimeInterval animationDuration;
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [animationDurationValue getValue:&animationDuration];
    
    self.scrollViewBottom.constant = 0;

    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
