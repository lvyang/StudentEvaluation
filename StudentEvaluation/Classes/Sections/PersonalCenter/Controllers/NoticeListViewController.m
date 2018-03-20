//
//  NoticeListViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/16.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "NoticeListViewController.h"
#import "NoticeListTableView.h"
#import "NetworkManager.h"
#import "BSLoginManager.h"
#import <MJRefresh.h>
#import <Masonry.h>
#import "NoticeModel.h"
#import "MedalRecordDetailViewController.h"
#import "SelfProveViewController.h"

static NSInteger NOTICE_LIST_PAGE_COUNT = 10;

@interface NoticeListViewController ()

@property (nonatomic, strong) NoticeListTableView *tableView;
@property (nonatomic, assign) NSInteger page;

@end

@implementation NoticeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"通知";

    __weak typeof(self) weakSelf = self;
    {
        self.tableView = [[NoticeListTableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
        }];
        
        self.tableView.cellSelectedHandler = ^(UITableView *collectionView, NSIndexPath *indexPath, id dataModel) {
            [weakSelf detail:dataModel];
        };
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadData:YES];
        }];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadData:NO];
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"didConfirmMedal" object:nil];
    
    [self reloadData];
}

- (void)reloadData
{
    self.tableView.mj_header.state = MJRefreshStateRefreshing;
}

- (void)loadData:(BOOL)reload
{
    self.page = reload ? 1 : self.page;
    NSString *userId = [BSLoginManager shareManager].userModel.userId;
    [NetworkManager loadNoticeListForUser:userId page:@(self.page++) count:@(NOTICE_LIST_PAGE_COUNT) completed:^(NSError *error, NSArray *result) {
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
        
        if (result.count < NOTICE_LIST_PAGE_COUNT) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)detail:(NoticeModel *)model
{
    if (model.wheherEvaluate) {
        MedalRecordDetailViewController *vc = [[MedalRecordDetailViewController alloc] init];
        vc.medalRecordId = model.medalScoreId;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        SelfProveViewController *vc = [[SelfProveViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
