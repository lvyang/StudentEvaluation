//
//  MedalLibraryViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/2.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "MedalLibraryViewController.h"
#import "BSMedalTableViewCell.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
#import "UIView+LayoutMethods.h"
#import "MJRefresh.h"
#import "BSMedalModel.h"
#import "NetworkManager.h"
#import "BSLoginManager.h"
#import "DataManager.h"

@interface MedalLibraryViewController ()<UITableViewDelegate, UITableViewDataSource, BSMedalTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray       *medalArray;
@property (nonatomic, strong) UITableView   *tableView;

@property (nonatomic, strong) NSIndexPath   *selectedIndexPath;
@property (nonatomic, strong) BSMedalModel  *selectedMedal;

@end

@implementation MedalLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"勋章库";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.medalArray = [NSMutableArray array];
    
    // separator view
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 14)];
        view.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(0);
            make.height.equalTo(@14);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
        }];
    }
    
    // table view
    {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSMedalTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"BSMedalTableViewCell"];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.tableFooterView = [UIView new];
        [self.view addSubview:self.tableView];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
        }];
    }
    
    // right bar button item
    {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm:)];
        self.navigationItem.rightBarButtonItem = rightItem;
        NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:17],
                                    NSForegroundColorAttributeName : [UIColor whiteColor]};
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:attribute forState:UIControlStateNormal];
    }
    
    [self loadMedalList];
}

- (void)loadMedalList
{
    [self showLoadingProgress:nil];
    BSClassModel *currentClass = [DataManager shareManager].currentClass;
    [NetworkManager loadMedalLibraryForTeacher:[BSLoginManager shareManager].userModel.userId class:currentClass.classId medalType:@(self.medalType) completed:^(NSError *error, NSArray *result) {
        [self hideLoadingProgress];
        
        if (error) {
            [self showPrompt:error.localizedDescription];
            return;
        }
        
        [self.medalArray setArray:result];
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.medalArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString         *identifier = @"BSMedalTableViewCell";
    BSMedalTableViewCell    *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell configureCellWithData:self.medalArray[indexPath.section] atIndexPath:indexPath];
    
    if ([indexPath isEqual:self.selectedIndexPath]) {
        [cell didSelectMedal:self.selectedMedal];
    }
    
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.medalArray[indexPath.section] count] == 0) {
        return 0;
    }
    
    return [BSMedalTableViewCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.medalArray[section] count] == 0) {
        return 0;
    }
    
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
    
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view.frame.size.width - 10, view.frame.size.height)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithHexString:@"5a5a5a"];
    
    BSMedalModel *model = [self.medalArray[section] firstObject];
    label.text = model.medalFieldName;
    [view addSubview:label];
    
    UIView *topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 0.5)];
    topSeparator.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
    [view addSubview:topSeparator];
    
    UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 0.5, view.frame.size.width, 0.5)];
    bottomSeparator.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
    [view addSubview:bottomSeparator];
    
    return view;
}

/** @override */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets inset = (indexPath.section == self.medalArray.count - 1) ? UIEdgeInsetsZero : UIEdgeInsetsMake(0, self.tableView.width, 0, 0);
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:inset];
    }
}

- (void)confirm:(id)sender
{
    if (!self.selectedMedal) {
        [self showPrompt:@"请选择勋章"];
        return;
    }
    
    [self showLoadingProgress:nil];
    [NetworkManager addMedalToFrequent:self.selectedMedal.identifier teacherId:[BSLoginManager shareManager].userModel.userId completed:^(NSError *error) {
        NSString *message = error ? error.localizedDescription : @"添加成功";
        [self showPrompt:message HideDelay:2 withCompletionBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
            if ([self.delegate respondsToSelector:@selector(frequentMedalChanged:)]) {
                [self.delegate frequentMedalChanged:self.medalType];
            }
        }];
    }];
}

#pragma mark - BSMedalTableViewCellDelegate
- (void)medalTableViewCellAtIndexPath:(NSIndexPath *)indexPath didSelectedMedal:(BSMedalModel *)medal
{
    BSMedalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    [cell didDeselectMedal:self.selectedMedal];
    
    self.selectedIndexPath = indexPath;
    self.selectedMedal = medal;
}

@end
