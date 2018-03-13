//
//  StudentListCell.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/9.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "StudentListCell.h"
#import "StudentModel.h"
#import <UIImageView+WebCache.h>

static NSString *SELECTECD_TITLE_COLOR = @"56becc";
static NSString *NORMAL_TITLE_COLOR = @"aaaaaa";

@interface StudentListCell()

@property (weak, nonatomic) IBOutlet UIImageView *indicator;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation StudentListCell

- (void)configureCellWithModel:(StudentModel *)aModel atIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = [NSURL URLWithString:aModel.iconUrl ? : @""];
    [self.iconImageView sd_setImageWithURL:url];
    self.nameLabel.text = aModel.studentName;
}

- (void)indicatorHidden:(BOOL)hidden
{
    self.indicator.hidden = hidden;
}

@end
