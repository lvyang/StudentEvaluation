//
//  MedalRecordTableView.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/13.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "MedalRecordTableView.h"
#import "MedalRecordCell.h"

@interface MedalRecordTableView() <MedalRecordCellDelegate>
@end

@implementation MedalRecordTableView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame style:UITableViewStylePlain cellNibClass:NSStringFromClass([MedalRecordCell class])]) {
        self.backgroundColor = [UIColor clearColor];
        self.tableFooterView = [UIView new];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MedalRecordCell *cell = (MedalRecordCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma mark -  MedalRecordCellDelegate
- (void)revokeRecord:(MedalRecordCell *)cell
{
    if (self.revokeMedalHandler) {
        NSIndexPath *indexPath = [self indexPathForCell:cell];
        self.revokeMedalHandler([self itemAtIndexPath:indexPath]);
    }
}

@end
