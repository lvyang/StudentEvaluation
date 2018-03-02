//
//  ReleaseMedalViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/2/28.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "SelectMedalViewController.h"
#import "SelectMedalCollectionView.h"
#import "NetworkManager.h"
#import "BSLoginManager.h"
#import <Masonry.h>
#import "BSMedalModel.h"
#import "BSClassModel.h"
#import "DataManager.h"
#import "MedalLibraryViewController.h"

@interface SelectMedalViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic, strong) SelectMedalCollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *classList;

@end

@implementation SelectMedalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择勋章";
    [self removeBackButtonItem];
    
    self.classList = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    {
        self.collectionView = [[SelectMedalCollectionView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.segment.mas_bottom).with.offset(0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
        }];
        
        self.collectionView.cellSelectedHandler = ^(UICollectionView *collectionView, NSIndexPath *indexPath, id dataModel) {
            [weakSelf medalLibrary];
        };
    }
    
    [self loadClassList];
}

- (void)loadClassList
{
    __weak typeof(self) weakSelf = self;
    [self showLoadingProgress:nil];
    [NetworkManager classListForTeacherId:[BSLoginManager shareManager].userModel.userId completed:^(NSError *error, NSArray *result) {
        typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf hideLoadingProgress];
        
        if (error) {
            [strongSelf showPrompt:error.localizedDescription];
            return ;
        }
        
        [strongSelf.classList setArray:result];
        BSClassModel *model = result.firstObject;
        [DataManager shareManager].currentClass = model;
        [strongSelf loadMedal:(strongSelf.segment.selectedSegmentIndex == 0 ? MedalTypePraise: MedalTypeCriticism) forClass:model.classId];
    }];
}

- (void)loadMedal:(MedalType)type forClass:(NSString *)classId
{
    
    __weak typeof(self) weakSelf = self;
    [self showLoadingProgress:nil];
    [[DataManager shareManager] loadMedal:type forClass:classId completed:^(NSError *error, NSArray *result) {
        typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf hideLoadingProgress];
        
        if(error){
            [strongSelf showPrompt:error.localizedDescription];
            return ;
        }
        
        [strongSelf.collectionView.dataArray setArray:result];
        [strongSelf.collectionView reloadData];
    }];
}

- (IBAction)valueChanged:(id)sender
{
    BSClassModel *model = self.classList.firstObject;
    [self loadMedal:(self.segment.selectedSegmentIndex == 0 ? MedalTypePraise: MedalTypeCriticism) forClass:model.classId];
}

- (void)medalLibrary
{
    MedalLibraryViewController *vc = [[MedalLibraryViewController alloc] init];
    vc.medalType = (self.segment.selectedSegmentIndex == 0 ? MedalTypePraise: MedalTypeCriticism);
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
