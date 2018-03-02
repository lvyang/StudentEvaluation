//
//  MedalCollectionViewCell.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/1.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "MedalCollectionViewCell.h"
#import "BSMedalModel.h"
#import <UIImageView+WebCache.h>

@interface MedalCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIImageView *medalIcon;
@property (weak, nonatomic) IBOutlet UILabel *mdealName;
@property (weak, nonatomic) IBOutlet UIImageView *selectIndicator;

@end

@implementation MedalCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configureCellWithModel:(BSMedalModel *)aModel atIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = [NSURL URLWithString:aModel.medalIcon ? : @""];
    [self.medalIcon sd_setImageWithURL:url];
    
    self.mdealName.text = aModel.medalName;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.selectIndicator.hidden = !selected;
    self.container.layer.borderColor = selected ? [UIColor colorWithRed:83/255.0 green:193/255.0 blue:205/255.0 alpha:1].CGColor : [UIColor clearColor].CGColor;
    self.container.layer.borderWidth = selected ? 1 : 0;
    
}

@end
