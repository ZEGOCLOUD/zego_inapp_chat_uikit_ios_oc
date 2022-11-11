//
//  ZIMKitConversationListVC.m
//  ZIMKit
//
//  Created by zego on 2022/5/19.
//

#import "ZIMKitConversationListVC.h"
#import "ZIMKitConversationCell.h"
#import "ZIMKitConversationListNoDataView.h"
#import "ZIMKitConversationVM.h"
#import "ZegoRefreshAutoFooter.h"

#define kConversationCell_ReuseId @"ZIMKitConversationCell"

@interface ZIMKitConversationListVC ()<UITableViewDelegate, UITableViewDataSource,ZIMKitConversationVMDelegate>

/// nodata view
@property (nonatomic, strong) ZIMKitConversationListNoDataView *noDataView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZIMKitConversationVM *conversationVM;

/// Failed to load data for the first time
@property (nonatomic, assign) BOOL isFirstLoadDataFail;

@end

@implementation ZIMKitConversationListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self loadData];
    [[ZIMKitLocalAPNS shared] setupLocalAPNS];
}

- (ZIMKitConversationVM *)conversationVM {
    if (!_conversationVM) {
        _conversationVM = [[ZIMKitConversationVM alloc] init];
        _conversationVM.delegate = self;
    }
    return _conversationVM;
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
    CGRect rect = self.view.bounds;
    _tableView = [[UITableView alloc] initWithFrame:rect];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    [_tableView registerClass:[ZIMKitConversationCell class] forCellReuseIdentifier:kConversationCell_ReuseId];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = ZIMKitConversationCell_Height;
    _tableView.rowHeight = ZIMKitConversationCell_Height;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delaysContentTouches = NO;
    [self.view addSubview:_tableView];
    
    _noDataView = [[ZIMKitConversationListNoDataView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _noDataView.hidden = YES;
    [self.view addSubview:_noDataView];
    
    /// Pull up to load more
    [self initUpLoadMore];
}

- (void)initUpLoadMore {
    @weakify(self);
    ZegoRefreshAutoFooter *footer = [ZegoRefreshAutoFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadData];
    }];
    self.tableView.mj_footer = footer;
}

- (void)loadData {
    @weakify(self);
    [self.conversationVM loadConversation:^(NSArray<ZIMKitConversationModel *> * _Nullable dataList, BOOL isFirstLoad, BOOL isFinished ,ZIMError * _Nullable errorInfo) {
        if (self.isFirstLoadDataFail) {
            self.isFirstLoadDataFail = isFirstLoad;
        }
        
        [self.tableView.mj_footer endRefreshing];
        if (isFinished) {
            self.tableView.mj_footer = nil;
        }
        
        @strongify(self);
        if (errorInfo.code == ZIMErrorCodeSuccess) {
            NSLog(@"---------------dataList is %@", dataList);
            [self.tableView reloadData];
        } else {
            NSLog(@"--------------- error mesage is %@", errorInfo.message);
            self.isFirstLoadDataFail = isFirstLoad;
            if (isFirstLoad) {
                
            } else {
                [self.view makeToast:errorInfo.message];
            }
        }
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.conversationVM.coversationList.count;
    self.noDataView.hidden = self.conversationVM.coversationList.count;
    if (self.isFirstLoadDataFail) {
        self.noDataView.hidden = NO;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIMKitConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:kConversationCell_ReuseId];
    ZIMKitConversationModel *data = self.conversationVM.coversationList[indexPath.row];
    [cell fillWithData:data];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ZIMKitConversationModel *data = self.conversationVM.coversationList[indexPath.row];
    
    NSDictionary *param = @{@"conversationID" : data.conversationID, @"conversationType" : @(data.type), @"conversationName" : data.conversationName ?:@""};

    self.router.openUrlWithParam(router_chatListUrl, param);
    
    [self runInMainThreadAsync:^{
        [self.conversationVM clearConversationUnreadMessageCount:data.conversationID conversationType:data.type completeBlock:^(ZIMError * _Nullable errorInfo) {
            NSLog(@"clearConversationUnreadMessageCount -%lu", (unsigned long)errorInfo.code);
        }];
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *rowActions = [NSMutableArray array];
    ZIMKitConversationModel *data = self.conversationVM.coversationList[indexPath.row];
    __weak typeof(self) weakSelf = self;
    {
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:[NSBundle ZIMKitlocalizedStringForKey:@"conversation_delete"] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [tableView beginUpdates];
            [weakSelf.conversationVM removeData:data completeBlock:^(ZIMError * _Nullable errorInfo) {
                if (!errorInfo.code) {
                    [self.view makeToast:errorInfo.message];
                }
            }];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            [tableView endUpdates];
        }];
        action.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFF4A50) lightColor:ZIMKitHexColor(0xFF4A50)];;
        [rowActions addObject:action];
    }
    return rowActions;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) {
    __weak typeof(self) weakSelf = self;
    ZIMKitConversationModel *data = self.conversationVM.coversationList[indexPath.row];
    NSMutableArray *arrayM = [NSMutableArray array];
    [arrayM addObject:({
        UIContextualAction *action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:[NSBundle ZIMKitlocalizedStringForKey:@"conversation_delete"] handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [tableView beginUpdates];
            [weakSelf.conversationVM removeData:data completeBlock:^(ZIMError * _Nullable errorInfo) {
                if (!errorInfo.code) {
                    [self.view makeToast:errorInfo.message];
                }
            }];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            [tableView endUpdates];
        }];
        action.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFF4A50) lightColor:ZIMKitHexColor(0xFF4A50)];
        action;
    })];
    
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:[NSArray arrayWithArray:arrayM]];
    configuration.performsFirstActionWithFullSwipe = NO;
    return configuration;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark ZIMKitConversationVMDelegate
- (void)onConversationListChange:(NSArray<ZIMKitConversationModel *> *_Nullable)conversationList {
    [self.tableView reloadData];
}

- (void)dealloc {
    [_conversationVM clearAllCacheData];
    _conversationVM = nil;
    NSLog(@"ZIMKitConversationListVC delloc");
}

@end
