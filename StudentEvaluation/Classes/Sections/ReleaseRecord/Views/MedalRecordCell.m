//
//  MedalRecordCell.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/13.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "MedalRecordCell.h"
#import "MedalRecordModel.h"
#import <UIImageView+WebCache.h>
#import "BSStringUtil.h"
#import "UIColor+Hex.h"

@interface MedalRecordCell()

@property (weak, nonatomic) IBOutlet UIImageView *medalIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *medalName;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreLabelWidth;

@property (weak, nonatomic) IBOutlet UIButton *revokeButton;

@end

@implementation MedalRecordCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.revokeButton.layer.borderWidth = 0.5;
    self.revokeButton.layer.borderColor = [UIColor colorWithHexString:@"444444"].CGColor;
    self.revokeButton.layer.cornerRadius = 5;
}


- (void)configureCellWithModel:(MedalRecordModel *)aModel atIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = [NSURL URLWithString:aModel.imageUrl ? : @""];
    [self.medalIconImageView sd_setImageWithURL:url];
    
    self.medalName.text = aModel.medalName;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld分",(long)aModel.score.integerValue];
    self.scoreLabelWidth.constant = [BSStringUtil sizeForString:self.scoreLabel.text font:self.scoreLabel.font limitWidth:0].width + 3;
    
    NSString *desc = [NSString stringWithFormat:@"给%@ %@",aModel.studentName, aModel.medalName];
    self.descLabel.text = desc;
    
    NSString *timeString = [NSString stringWithFormat:@"%@ %@ 来自%@",aModel.day, aModel.dayTime, aModel.source];
    self.timeLabel.text = timeString;
}

- (IBAction)revoke:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(revokeRecord:)]) {
        [self.delegate revokeRecord:self];
    }
}

@end
