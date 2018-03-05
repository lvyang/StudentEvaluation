//
//  ClassListTableView.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/5.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "ClassListTableView.h"
#import "ClassListCell.h"

@implementation ClassListTableView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame style:UITableViewStylePlain cellNibClass:NSStringFromClass([ClassListCell class])]) {
        self.backgroundColor = [UIColor clearColor];
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
        self.tableFooterView = [UIView new];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassListCell *cell = (ClassListCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    BSClassModel *model = [self itemAtIndexPath:indexPath];
    [cell didSelectCell:[model isEqual:self.selectedClass]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
