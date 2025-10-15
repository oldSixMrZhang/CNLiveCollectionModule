//
//  CNLiveCollectionController.m
//  CNLiveCollectionModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright (c) 2019 153993236@qq.com. All rights reserved.
//

#import "CNLiveCollectionController.h"

#import "QMUIKit.h"
#import "CNLiveCategory.h"
#import "CNLiveBaseKit.h"

#import "CNLiveRefreshHeader.h"
#import "CNLiveRefreshFooter.h"

#import "CNLiveNavigationBar.h"
#import "CNLiveCollectionCell.h"
#import "CNLiveCollectionModel.h"

#import "CNLiveCollectionRequest.h"

@interface CNLiveCollectionController ()<UITableViewDelegate, UITableViewDataSource, CNLiveCollectionCellDelegate>
@property (nonatomic, strong) CNLiveNavigationBar *navigationBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) BOOL isRefreshing;

@end

@implementation CNLiveCollectionController
static const CGFloat timeValue = 1.5;

#pragma mark - 数据
- (void)loadData{
    __weak typeof(self) weakSelf = self;
    [CNLiveCollectionRequest getCollectionList:[NSString stringWithFormat:@"%ld",_pageNo] pageSize:[NSString stringWithFormat:@"%ld",_pageSize] block:^(BOOL isSuccess, NSArray * _Nonnull array, NSError * _Nonnull error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(!strongSelf) return ;
        [QMUITips hideAllTipsInView:strongSelf.view];
        [strongSelf hideEmptyView];
        
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        strongSelf.isRefreshing = NO;

        if (error) {
            [strongSelf.data removeAllObjects];
            [strongSelf.tableView reloadData];
            if (error.code == -1001||error.code == -1003||error.code == -1009) {
                [strongSelf.tableView showEmptyViewWithType:CNLiveCustomTipsTypeNoNet noData:strongSelf.data.count == 0 block:^{
                    [strongSelf.tableView.mj_header beginRefreshing];
                
                }];
            }else{
                [strongSelf.tableView showEmptyViewWithType:CNLiveCustomTipsTypeLoadFail noData:strongSelf.data.count == 0 block:^{
                    [strongSelf.tableView.mj_header beginRefreshing];
                
                }];
            }
            strongSelf.tableView.emptyView.top = 0;
            strongSelf.tableView.mj_footer.hidden = self.data.count == 0;
            return;
        }
        
        if (isSuccess) {
            if(strongSelf.pageNo == 1 && strongSelf.data.count > 0){
                 [strongSelf.data removeAllObjects];
             }
            strongSelf.pageNo++;
            [strongSelf.data addObjectsFromArray:array];
            if (array.count < strongSelf.pageSize) {
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                
            } else {
                [strongSelf.tableView.mj_footer endRefreshing];
                
            }
        }
        
        [strongSelf.tableView showEmptyViewWithType:CNLiveCustomTipsTypeNoData noData:self.data.count == 0 block:nil];
        strongSelf.tableView.emptyView.top = 0;
        
        strongSelf.tableView.mj_footer.hidden = self.data.count == 0;
        [strongSelf.tableView reloadData];
        
    }];
    
}

- (void)loadMoreData{
    if(!_isRefreshing){
        _isRefreshing = YES;
        [self loadData];
    }
}

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11, *)) {
    }
    else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _isRefreshing = NO;
    _pageNo = 1;
    _pageSize = 10;

    [self.tableView.mj_header beginRefreshing];
    [self createSubViews];    
}

- (void)dealloc {
    NSLog(@"CNLiveCollectionController -- dealloc");
    
}

- (void)createSubViews {
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.tableView];
}

#pragma mark - 响应方法
- (void)goBack {
    if (self.presentingViewController != nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CNLiveCollectionModel *model = self.data[indexPath.row];
    return model.height;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CNLiveCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNLiveCollectionCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CNLiveCollectionModel *model = self.data[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - CNLiveCollectionCellDelegate
- (void)cancelCollection:(CNLiveCollectionCell *)cell{
    [QMUITips showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [CNLiveCollectionRequest cancelCollection:cell.model.collectionId block:^(BOOL isSuccess, NSError * _Nonnull error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(!strongSelf) return ;
        [QMUITips hideAllToastInView:strongSelf.view animated:YES];
        if (error) {
            [QMUITips showError:error.localizedDescription inView:strongSelf.view hideAfterDelay:timeValue];
            return;
        }
        if (isSuccess) {
            [strongSelf.data removeObject:cell.model];
            [strongSelf.tableView reloadData];
            [QMUITips showSucceed:@"取消收藏成功" inView:strongSelf.view hideAfterDelay:timeValue];
            [strongSelf.tableView showEmptyViewWithType:CNLiveCustomTipsTypeNoData noData:self.data.count == 0 block:nil];
            strongSelf.tableView.emptyView.top = 0;
            strongSelf.tableView.mj_footer.hidden = strongSelf.data.count == 0;
        }
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:[CNLiveCollectionCell class] forCellReuseIdentifier:kCNLiveCollectionCell];
        __weak __typeof(self)weakSelf = self;
        _tableView.mj_header = [CNLiveRefreshHeader headerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if(!strongSelf) return ;
            strongSelf.pageNo = 1;
            [strongSelf loadMoreData];

        }];
        CNLiveRefreshFooter *footer = [CNLiveRefreshFooter footerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if(!strongSelf) return ;
            [strongSelf loadMoreData];
            
        }];
        footer.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        footer.hidden = YES;
        _tableView.mj_footer = footer;
    }
    return _tableView;
}
- (CNLiveNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [CNLiveNavigationBar navigationBar];
        _navigationBar.title.text = @"我的收藏";
        __weak __typeof(self)weakSelf = self;
        _navigationBar.onClickLeftButton = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if(!strongSelf) return ;
            [strongSelf goBack];
        };
    }
    return _navigationBar;
}

@end
