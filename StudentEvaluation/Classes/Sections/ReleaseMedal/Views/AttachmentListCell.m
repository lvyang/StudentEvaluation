//
//  AttachmentListCell.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/6.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "AttachmentListCell.h"
#import "BSAttachmentModel.h"
#import <UIImageView+WebCache.h>
#import "BSStringUtil.h"

@interface AttachmentListCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *videoBanner;
@property (weak, nonatomic) IBOutlet UILabel *videoLengthLabel;

@end

@implementation AttachmentListCell

- (void)configureCellWithModel:(BSAttachmentModel *)aModel atIndexPath:(NSIndexPath *)indexPath
{
    self.iconImageView.image = aModel.image;
    
    if (aModel.isVideo) {
        self.videoBanner.hidden = NO;
        self.videoLengthLabel.text = [BSStringUtil timeStringFromInterval:aModel.videoDuration.floatValue];
    } else {
        self.videoBanner.hidden = YES;
    }
}

- (IBAction)delete:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(deleteAttachment:)]) {
        [self.delegate deleteAttachment:self];
    }
}
@end
