//
//  ReleaseRecordViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/2/28.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "ReleaseRecordViewController.h"
#import <Masonry.h>
#import <MJRefresh.h>
#import "MedalRecordTableView.h"
#import "NetworkManager.h"
#import "DataManager.h"
#import "BSLoginManager.h"
#import "NetworkManager.h"
#import "MedalRecordDetailViewController.h"

static NSInteger MEDAL_RECORD_PAGE_COUNT = 10;

@interface ReleaseRecordViewController ()

@property (nonatomic, strong) MedalRecordTableView *tableView;
@property (nonatomic, assign) NSInteger page;

@end

@implementation ReleaseRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"颁发记录";
    
    __weak typeof(self) weakSelf = self;
    {
        self.tableView = [[MedalRecordTableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
        }];
        
        self.tableView.cellSelectedHandler = ^(UITableView *collectionView, NSIndexPath *indexPath, id dataModel) {
            [weakSelf recordDetail:dataModel];
        };
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadData:YES];
        }];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadData:NO];
        }];
        
        self.tableView.revokeMedalHandler = ^(MedalRecordModel *model) {
            [weakSelf revokeMedalRecord:model];
        };
    }
    
    [self reloadData];
}

- (void)reloadData
{
    self.tableView.mj_header.state = MJRefreshStateRefreshing;
}

- (void)loadData:(BOOL)reload
{
    BSClassModel *class = [DataManager shareManager].currentClass;
    NSString *teacherId = [BSLoginManager shareManager].userModel.userId;
    self.page = reload ? 1 : self.page;

    [NetworkManager medalRecordForClass:class.classId teacher:teacherId page:@(self.page++) count:@(MEDAL_RECORD_PAGE_COUNT) completed:^(NSError *error, NSArray *result) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        if (error) {
            [self showPrompt:error.localizedDescription];
            return ;
        }
        
        if (reload) {
            [self.tableView.items removeAllObjects];
        }
        [self.tableView.items addObjectsFromArray:result];
        [self.tableView reloadData];
        
        if (result.count < MEDAL_RECORD_PAGE_COUNT) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)recordDetail:(MedalRecordModel *)model
{
    MedalRecordDetailViewController *vc = [[MedalRecordDetailViewController alloc] init];
    vc.medalRecordId = model.medalScoreId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)revokeMedalRecord:(MedalRecordModel *)medalRecord
{
    [self showLoadingProgress:nil];
    [NetworkManager revokeMedalRecord:medalRecord.medalScoreId teacherId:medalRecord.teacherId completed:^(NSError *error) {
        [self hideLoadingProgress];
        
        if (error) {
            [self showPrompt:error.localizedDescription];
            return ;
        }
        
        [self reloadData];
    }];
}

@end
