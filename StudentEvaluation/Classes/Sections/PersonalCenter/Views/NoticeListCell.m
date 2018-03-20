//
//  NoticeListCell.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/16.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "NoticeListCell.h"
#import "NoticeModel.h"

@interface NoticeListCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *readLabel;

@end

@implementation NoticeListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.readLabel.layer.cornerRadius = 3;
    self.readLabel.layer.masksToBounds = YES;
}

- (void)configureCellWithModel:(NoticeModel *)aModel atIndexPath:(NSIndexPath *)indexPath
{
    self.nameLabel.text = aModel.studentName;
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@",aModel.day,aModel.dayTime];
    self.descriptionLabel.text = [NSString stringWithFormat:@"上传了自证材料:%@",aModel.title];
    
    if (aModel.readStatus.integerValue == 0) {
        self.readLabel.text = @"未读";
        self.readLabel.backgroundColor = [UIColor colorWithRed:240/255.0 green:178/255.0 blue:178/255.0 alpha:1];
    } else {
        self.readLabel.text = @"已读";
        self.readLabel.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    }
}


@end
