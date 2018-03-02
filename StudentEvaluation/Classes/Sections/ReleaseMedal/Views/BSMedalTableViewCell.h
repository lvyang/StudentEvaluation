//
//  MedalTableViewCell.h
//  生命安全教育
//
//  Created by Yang.Lv on 2017/2/10.
//  Copyright © 2017年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSMedalModel;
@class BSMedalTableViewCell;

@protocol BSMedalTableViewCellDelegate <NSObject>

@optional
- (void)medalTableViewCellAtIndexPath:(NSIndexPath *)indexPath didSelectedMedal:(BSMedalModel *)medal;

@end

@interface BSMedalTableViewCell : UITableViewCell

@property (nonatomic, weak) id<BSMedalTableViewCellDelegate> delegate;

- (void)configureCellWithData:(NSArray *)data atIndexPath:(NSIndexPath *)indexPath;

- (void)didSelectMedal:(BSMedalModel *)model;
- (void)didDeselectMedal:(BSMedalModel *)model;

@end
