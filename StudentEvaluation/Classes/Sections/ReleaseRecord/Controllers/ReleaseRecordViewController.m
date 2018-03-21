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
#import "QRCodeViewController.h"
#import "ClassListViewController.h"
#import "UIImage+ImageAddition.h"
#import "BSWebviewViewController.h"
#import "BSSettings.h"

static NSInteger MEDAL_RECORD_PAGE_COUNT = 10;

@interface ReleaseRecordViewController ()<QRCodeViewControllerDelegate>

@property (nonatomic, strong) MedalRecordTableView *tableView;
@property (nonatomic, assign) NSInteger page;

@end

@implementation ReleaseRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"颁发记录";
    
    // add bar button item
    {
        UIImage *image = [[UIImage imageNamed:@"class_icon_sweep_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(scan:)];
        self.navigationItem.leftBarButtonItem = leftItem;
        NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:17],
                                    NSForegroundColorAttributeName : [UIColor whiteColor]};
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:attribute forState:UIControlStateNormal];
        
        [self addRightBarButtonItem];
    }
    
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
        
        self.tableView.revokeMedalHandler = ^(MedalRecordModel *model, NSIndexPath *indexPath) {
            [weakSelf revokeMedalRecord:model atIndexPath:indexPath];
        };
    }
    
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"didReleaseMedal" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedClassChanged:) name:SELECTED_CLASS_CHANGED object:nil];
    }
    
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHexString:@"54bfca"]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:18],
                                NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:attribute];
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

- (void)revokeMedalRecord:(MedalRecordModel *)medalRecord atIndexPath:(NSIndexPath *)indexPath
{
    [self showLoadingProgress:nil];
    [NetworkManager revokeMedalRecord:medalRecord.medalScoreId teacherId:medalRecord.teacherId completed:^(NSError *error) {
        [self hideLoadingProgress];
        
        if (error) {
            [self showPrompt:error.localizedDescription];
            return ;
        }
        
        [self.tableView.items removeObject:medalRecord];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }];
}

- (void)addRightBarButtonItem
{
    NSString *className = [DataManager shareManager].currentClass.className;
    if (!className) {
        className = @"选择班级";
    }
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:className style:UIBarButtonItemStylePlain target:self action:@selector(classList)];
    self.navigationItem.rightBarButtonItem = rightItem;
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:17],
                                NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:attribute forState:UIControlStateNormal];
}

- (void)scan:(id)sender
{
    QRCodeViewController *vc = [[QRCodeViewController alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectedClassChanged:(NSNotification *)notification
{
    [self addRightBarButtonItem];
    [self reloadData];
}

- (void)classList
{
    ClassListViewController *vc = [[ClassListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - QRCodeViewControllerDelegate
- (void)didScanCode:(NSString *)code
{
    NSString *userId = [BSLoginManager shareManager].userModel.userId;
    [NetworkManager scanQrCode:code userId:userId completed:^(NSError *error) {
        if (error) {
            [self showPrompt:error.localizedDescription];
            return ;
        }
        
        [self showPrompt:@"调用扫码成功"];
    }];
}

@end
