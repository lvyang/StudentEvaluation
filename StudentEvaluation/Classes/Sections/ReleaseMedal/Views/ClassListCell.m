//
//  ClassListCell.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/5.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "ClassListCell.h"
#import "BSClassModel.h"


@interface ClassListCell()

@property (weak, nonatomic) IBOutlet UIImageView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ClassListCell

- (void)configureCellWithModel:(BSClassModel *)aModel atIndexPath:(NSIndexPath *)indexPath
{
    self.nameLabel.text = aModel.className;
}

- (void)didSelectCell:(BOOL)selected
{
    self.indicator.hidden = !selected;
    self.nameLabel.textColor = selected ? [UIColor colorWithRed:85/255.0 green:193/255.0 blue:205/255.0 alpha:1] : [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
}

@end
