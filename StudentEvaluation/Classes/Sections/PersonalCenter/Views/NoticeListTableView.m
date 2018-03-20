//
//  NoticeListTableView.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/16.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "NoticeListTableView.h"
#import "NoticeListCell.h"

@interface NoticeListTableView()

@end

@implementation NoticeListTableView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame style:UITableViewStylePlain cellNibClass:NSStringFromClass([NoticeListCell class])]) {
        self.backgroundColor = [UIColor clearColor];
        self.tableFooterView = [UIView new];
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
