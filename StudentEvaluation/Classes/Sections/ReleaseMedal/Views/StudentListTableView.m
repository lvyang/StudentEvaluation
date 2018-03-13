//
//  StudengListTableView.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/12.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "StudentListTableView.h"
#import "StudentListCell.h"
#import "StudentModel.h"

static NSInteger STUDENT_LIST_CELL_HEIGHT = 30;

@implementation StudentListTableView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame style:UITableViewStylePlain cellNibClass:NSStringFromClass([StudentListCell class])]) {
        self.selectedItems = [NSMutableSet set];
        self.keys = [NSMutableArray array];
        self.tableFooterView = [UIView new];
        self.allowsMultipleSelection = YES;
        self.multiSections = YES;
        
        self.sectionIndexColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
        self.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudentListCell *cell = (StudentListCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    StudentModel *model = [self itemAtIndexPath:indexPath];
    BOOL hidden = ![self.selectedItems containsObject:model];
    [cell indicatorHidden:hidden];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, STUDENT_LIST_CELL_HEIGHT)];
    view.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
    
    NSString *key = [self.keys objectAtIndex:section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view.frame.size.width - 10, STUDENT_LIST_CELL_HEIGHT)];
    label.textColor = [UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1];
    label.text = key;
    [view addSubview:label];
    
    return view;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keys;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return STUDENT_LIST_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudentModel *model = [self itemAtIndexPath:indexPath];
    if ([self.selectedItems containsObject:model]) {
        [self.selectedItems removeObject:model];
    } else {
        [self.selectedItems addObject:model];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
