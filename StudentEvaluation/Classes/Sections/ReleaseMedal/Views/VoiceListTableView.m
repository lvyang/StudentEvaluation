//
//  VoiceListTableView.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/9.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "VoiceListTableView.h"
#import "VoiceListCell.h"
#import "AddVoiceCell.h"
#import "VoiceModel.h"

@interface VoiceListTableView()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,VoiceListCellDelegate>

@end

@implementation VoiceListTableView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.items = [NSMutableArray array];
        [self registerNib:[UINib nibWithNibName:@"VoiceListCell" bundle:nil] forCellReuseIdentifier:@"VoiceListCell"];
        [self registerNib:[UINib nibWithNibName:@"AddVoiceCell" bundle:nil] forCellReuseIdentifier:@"AddVoiceCell"];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        
        self.delegate = self;
        self.dataSource = self;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource method
/** @override */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count + 1;
}

/** @override */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.items.count) {
        NSString *cellId = @"AddVoiceCell";
        AddVoiceCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        NSString *cellId = @"VoiceListCell";
        VoiceListCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        id                  item = self.items[indexPath.row];
        
        if ([cell respondsToSelector:@selector(configureCellWithModel:atIndexPath:)]) {
            [cell configureCellWithModel:item atIndexPath:indexPath];
        }
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate method
/** @override */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.items.count) {
        if (self.addVoiceHandler) {
            self.addVoiceHandler();
        }
    }
}

/** @override */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:self.separatorInset];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:self.separatorInset];
    }
}

#pragma mark - VoiceListCellDelegate
- (void)didClickDeleteButton:(VoiceListCell *)cell
{
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    VoiceModel *model = [self.items objectAtIndex:indexPath.row];
    
    [self.items removeObjectAtIndex:indexPath.row];
    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    [[NSFileManager defaultManager] removeItemAtPath:model.path error:nil];
}

@end
