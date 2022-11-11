//
//  ZIMKitMessagesListVC.m
//  ZIMKit
//
//  Created by zego on 2022/5/30.
//

#import "ZIMKitMessagesListVC.h"
#import "ZIMKitTextMessageCell.h"
#import "ZIMKitSystemMessageCell.h"
#import "ZIMKitMessageCell.h"
#import "ZIMKitImageMessageCell.h"
#import "ZIMKitAudioMessageCell.h"
#import "ZIMKitVideoMessageCell.h"
#import "ZIMKitFileMessageCell.h"
#import "ZIMKitUnKnowMessageCell.h"
#import "ZIMKitRefreshAutoHeader.h"
#import "ZIMKitGroupDetailController.h"
#import "NSString+ZIMKitUtil.h"
#import "ZIMKitMessagesListVC+InputBar.h"
#import "ZIMKitImageMessage.h"
#import "ZIMKitAudioMessage.h"
#import "ZIMKitVideoMessage.h"
#import "ZIMKitFileMessage.h"
#import "ZIMKitTool.h"
#import "ZIMKitDefine.h"
#import "ZIMKitMessagesListVC+Meida.h"
#import "ZIMKitMessagesListVC+MessageAction.h"

#import <TZImagePickerController/TZImagePickerController.h>
#import <SDWebImage/SDWebImage.h>

@interface ZIMKitMessagesListVC ()
            <ZIMKitMessagesVMDelegate, UITableViewDelegate, UITableViewDataSource,
            UIGestureRecognizerDelegate,TZImagePickerControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, copy)     NSString *conversationID;

@property (nonatomic, copy)     NSString *conversationName;

@property (nonatomic, assign)   ZIMConversationType conversationType;

@property (nonatomic, strong)   ZIMKitMessagesVM *messageVM;

/// 消息展示
@property (nonatomic, strong)   UITableView *messageTableView;

/// 是否为第一次加载数据,
@property (nonatomic, assign)   BOOL isFirstLoad;

/// 记录加载群成员列表的标记
@property (nonatomic, assign)   int nextFlag;

/// 群成员列表
@property (nonatomic, strong)   NSMutableDictionary *memberListDic;

/// 单聊时对方的信息
@property (nonatomic, strong)   ZIMUserFullInfo *otherInfo;

/// 添加到tableview 的手势
@property (nonatomic, strong)   UITapGestureRecognizer *tap;

/// 被踢
@property (nonatomic, assign)   BOOL isKickedOut;

@end

@implementation ZIMKitMessagesListVC

- (instancetype)initWithConversationID:(NSString *)conversationID
                      conversationType:(ZIMKitConversationType)conversationType {
    if (self = [super init]) {
        self.conversationID = conversationID;
        self.conversationType = (ZIMConversationType)conversationType;
    }
    return self;
}

- (instancetype)initWithConversationID:(NSString *)conversationID
                      conversationType:(ZIMKitConversationType)conversationType
                      conversationName:(nullable NSString *)conversationName {
    if (self = [super init]) {
        self.conversationID = conversationID;
        self.conversationName = conversationName;
        self.conversationType = (ZIMConversationType)conversationType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self getChatTitle];
    
    self.view.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xF2F2F2) lightColor:ZIMKitHexColor(0xF2F2F2)];
    [self setupViews];
    [self loadData];
    [self initLoadMoreUI];
    [self loadGroupMember];
    [self loadConversationInfo];
    [self tableviewGestureRecognizerRemove:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIMenuControllerWillHideMenuNotification object:nil];
}

- (UITableView *)messageTableView {
    return _messageTableView;
}

- (NSString *)getChatTitle {
    NSString *title = self.conversationName;
    
    if(self.conversationType == ZIMConversationTypePeer) {
        title = self.conversationName.length ? self.conversationName : [NSBundle ZIMKitlocalizedStringForKey:@"message_title_chat"];
    } else if (self.conversationType == ZIMConversationTypeGroup) {
        title = self.conversationName.length ? self.conversationName : [NSBundle ZIMKitlocalizedStringForKey:@"message_title_group_chat"];
    }
    return title;
}

- (void)setupViews {
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.height - ZIMKitChatToolBarHeight - Bottom_SafeHeight);
    _messageTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _messageTableView.tableFooterView = [[UIView alloc] init];
    _messageTableView.estimatedRowHeight = ZIMKitMessageCell_Default_Height;
    _messageTableView.estimatedSectionFooterHeight = 0.0f;
    _messageTableView.estimatedSectionHeaderHeight = 0.0f;
    _messageTableView.delaysContentTouches = NO;
    _messageTableView.delegate = self;
    _messageTableView.dataSource = self;
    _messageTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _messageTableView.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xF2F2F2) lightColor:ZIMKitHexColor(0xF2F2F2)];

    [_messageTableView registerClass:[ZIMKitTextMessageCell class]
              forCellReuseIdentifier:NSStringFromClass([ZIMKitTextMessageCell class])];
    [_messageTableView registerClass:[ZIMKitImageMessageCell class] forCellReuseIdentifier:NSStringFromClass([ZIMKitImageMessageCell class])];
    [_messageTableView registerClass:[ZIMKitAudioMessageCell class] forCellReuseIdentifier:NSStringFromClass([ZIMKitAudioMessageCell class])];
    [_messageTableView registerClass:[ZIMKitVideoMessageCell class] forCellReuseIdentifier:NSStringFromClass([ZIMKitVideoMessageCell class])];
    [_messageTableView registerClass:[ZIMKitFileMessageCell class] forCellReuseIdentifier:NSStringFromClass([ZIMKitFileMessageCell class])];
    [_messageTableView registerClass:[ZIMKitSystemMessageCell class] forCellReuseIdentifier:NSStringFromClass([ZIMKitSystemMessageCell class])];
    [_messageTableView registerClass:[ZIMKitUnKnowMessageCell class] forCellReuseIdentifier:NSStringFromClass([ZIMKitUnKnowMessageCell class])];
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_messageTableView];
    
    _messageToolbar = [[ZIMKitMessageSendToolbar alloc] initWithSuperView:self.view];
    _messageToolbar.delegate = self;
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage zegoImageNamed:@"chat_nav_left"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton.widthAnchor constraintEqualToConstant:40].active = YES;
    [leftButton.heightAnchor constraintEqualToConstant:40].active = YES;
    [leftButton setContentEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    if (self.conversationType == ZIMConversationTypeGroup) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setImage:[UIImage zegoImageNamed:@"chat_nav_right"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton.widthAnchor constraintEqualToConstant:40].active = YES;
        [rightButton.heightAnchor constraintEqualToConstant:40].active = YES;
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    _memberListDic = [NSMutableDictionary dictionary];
}

- (void)tableviewGestureRecognizerRemove:(BOOL)remove {
    if (remove) {
        [self.messageTableView removeGestureRecognizer:_tap];
    } else {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapViewController)];
        _tap.delegate = self;
        [self.messageTableView addGestureRecognizer:_tap];
    }
}

- (ZIMKitMessagesVM *)messageVM {
    if (!_messageVM) {
        _messageVM = [[ZIMKitMessagesVM alloc] initWith:self.conversationID];
        _messageVM.delegate = self;
    }
    return _messageVM;
}

- (void)leftBarButtonClick:(UIButton *)sender {
    if (self.isSelectMore) {
        [self cancelMultiChoose];
    } else {
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (void)rightBarButtonClick:(UIButton *)sender {
    NSDictionary *param = @{@"conversationID" : self.conversationID, @"conversationName" : self.conversationName ?:@""};
    self.router.openUrlWithParam(router_groupDetailUrl, param);
}

#pragma mark load more
- (void)initLoadMoreUI {
    @weakify(self);
    ZIMKitRefreshAutoHeader *header  = [ZIMKitRefreshAutoHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self loadData];
    }];

    self.messageTableView.mj_header = header;
}

- (void)endRefresh {
    [self.messageTableView.mj_header endRefreshing ];
}

#pragma mark load data
- (void)loadData {
    ZIMMessageQueryConfig *config = [[ZIMMessageQueryConfig alloc] init];
    config.count = 20;
    ZIMKitMessage *lastMessage = self.messageVM.messageList.firstObject;
    config.nextMessage = lastMessage.zimMsg;
    config.reverse = YES;
    
    @weakify(self);
    [self.messageVM queryHistoryMessage:self.conversationID type:self.conversationType config:config callBack:^(NSArray<ZIMKitMessage *> * _Nullable messageList, ZIMError * _Nullable errorInfo) {
        @strongify(self);
        [self endRefresh];
        if (errorInfo.code == ZIMErrorCodeSuccess) {
            if (messageList.count) {
                
                [self.messageTableView reloadData];
                [self.messageTableView layoutIfNeeded];
                
                if (!self.isFirstLoad) {
                    [self scrollToBottom:NO];
                    self.isFirstLoad = YES;
                } else {
                    if (lastMessage) {
                        NSInteger index =  [self.messageVM.messageList indexOfObject:lastMessage];
                        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    }
                }
            }
        } else {
            [self.view makeToast:errorInfo.message];
        }
    }];
}

#pragma mark group Member
- (void)loadGroupMember {
    if (self.conversationType == ZIMConversationTypeGroup) {
        ZIMGroupMemberQueryConfig *config = [[ZIMGroupMemberQueryConfig alloc] init];
        config.nextFlag = self.nextFlag;
        config.count = 100;
        
        @weakify(self);
        [self.messageVM queryGroupMemberListByGroupID:self.conversationID config:config callback:^(NSString * _Nonnull groupID, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, unsigned int nextFlag, ZIMError * _Nonnull errorInfo) {
            @strongify(self);
            if (errorInfo.code == ZIMErrorCodeSuccess) {
                self.nextFlag = nextFlag;
                if (userList.count) {
                    for (ZIMGroupMemberInfo *info in userList) {
                        [self.memberListDic setObject:info forKey:info.userID];
                    }
                }
            } else {
                [self.view makeToast:[NSString stringWithFormat:@"%ld-%@",errorInfo.code, errorInfo.message]];
            }
            /// Get the full data of group members
            if (nextFlag != 0) {
                [self loadGroupMember];
            } else {
                [self.messageTableView reloadData];
            }
        }];
    }
}

- (void)loadConversationInfo {
    if (self.conversationType == ZIMConversationTypePeer) {
        @weakify(self);
        [[ZIMKitManager shared] queryUsersInfo:@[self.conversationID] callback:^(NSArray<ZIMUserFullInfo *> * _Nonnull userList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
            @strongify(self);
            ZIMUserFullInfo *userinfo = userList.firstObject;
            if (userinfo) {
                self.title = userinfo.baseInfo.userName;
                self.otherInfo = userinfo;
                [self.messageTableView reloadData];
            }
        }];
    } else if (self.conversationType == ZIMConversationTypeGroup) {
        @weakify(self);
        [self.messageVM queryGroupInfoWithGroupID:self.conversationID callback:^(ZIMGroupFullInfo * _Nonnull groupInfo, ZIMError * _Nonnull errorInfo) {
            @strongify(self);
            if (groupInfo) {
                self.title = groupInfo.baseInfo.groupName;
                self.conversationName = groupInfo.baseInfo.groupName;
            }
        }];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.messageVM.messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIMKitMessage *message = self.messageVM.messageList[indexPath.row];
    
    if (self.conversationType == ZIMConversationTypeGroup) {
        ZIMGroupMemberInfo *member = [self.memberListDic objectForKey:message.senderUserID];
        message.senderUsername = member.userName;
        message.senderUserAvatar = member.memberAvatarUrl;
    } else if (self.conversationType == ZIMConversationTypePeer) {
        if (message.direction == ZIMMessageDirectionReceive) {
            message.senderUsername = self.conversationName;
            message.senderUserAvatar = self.otherInfo.userAvatarUrl;
        } else {
            message.senderUsername = ZIMKitManager.shared.userInfo.userName;
            message.senderUserAvatar = ZIMKitManager.shared.userInfo.userAvatarUrl;
        }
    }
    
    [self checkLocalMediaWithMessae:message];
    
    ZIMKitMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:message.reuseId];
    [cell fillWithMessage:message];
     
    if (message.type != ZIMKitSystemMessageType) {
        cell.isSelectMore = self.isSelectMore;
        if (self.isSelectMore) {
            cell.isSelected = [self.selectedMessages containsObject:message];
        }
        
        @weakify(self);
        cell.tapCellBlock = ^(ZIMKitMessage * _Nonnull msg, ZIMKitMessageCell * _Nonnull cell) {
            @strongify(self);
            [self tapCellActionMsg:msg cell:cell];
        };
        
        cell.longPressCallback = ^(ZIMKitMessage * _Nonnull msg, ZIMKitMessageCell * _Nonnull cell, ZIMKitMenuType menuType) {
            @strongify(self);
            [self longPressCellMessage:msg cell:cell menuType:menuType];
        };
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIMKitMessage *message = self.messageVM.messageList[indexPath.row];
    if (message.type == ZIMMessageTypeAudio) {
        ZIMKitAudioMessageCell *audioCell = (ZIMKitAudioMessageCell *)cell;
        ZIMKitAudioMessage *audioMessage = (ZIMKitAudioMessage *)message;
        audioCell.isBubbleViewPlaying = !audioMessage.isExistLocal;
    } else if (message.type == ZIMMessageTypeFile) {
        ZIMKitFileMessageCell *fileCell = (ZIMKitFileMessageCell *)cell;
        ZIMKitFileMessage *fileMessage = (ZIMKitFileMessage *)message;
        [fileCell fileDownloading:fileMessage.downloading];
    }
}

- (void)tapCellActionMsg:(ZIMKitMessage *)msg cell:(ZIMKitMessageCell *)cell {
    if (msg.type == ZIMMessageTypeImage) {
        ZIMKitImageMessageCell *cellImage = (ZIMKitImageMessageCell *)cell;
        [self browseImage:(ZIMKitImageMessage *)msg sourceView:cellImage.thumbnailImageView];
    } else if (msg.type == ZIMMessageTypeAudio) {
        ZIMKitAudioMessageCell *audioCell = (ZIMKitAudioMessageCell *)cell;
        [self playVoice:(ZIMKitAudioMessage *)msg cell:audioCell];
    } else if (msg.type == ZIMMessageTypeVideo) {
        ZIMKitVideoMessage *message = (ZIMKitVideoMessage *)msg;
        [self playVieoWithUrl:message];
    } else if (msg.type == ZIMMessageTypeFile) {
        ZIMKitFileMessage *fileMessage = (ZIMKitFileMessage *)msg;
        [self openFileWith:fileMessage];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIMKitMessage *message = self.messageVM.messageList[indexPath.row];
    if (indexPath.row == 0) { // UI The top data needs to be spaced 20 at the top
        message.isLastTop = YES;
    } else {
        message.isLastTop = NO;
    }
    return [message cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isSelectMore) {
        ZIMKitMessage *message = self.messageVM.messageList[indexPath.row];
        ZIMKitMessageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([self.selectedMessages containsObject:message]) {
            [self.selectedMessages removeObject:message];
            cell.isSelected = NO;
        } else {
            [self.selectedMessages addObject:message];
            cell.isSelected = YES;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self didTapViewController];
}


#pragma mark ZIMKitMessagesVMDelegate
- (void)onDataSourceChange:(NSString *)conversationID {
    if ([conversationID isEqualToString:self.conversationID]) {
        [self reloaddataAndScrolltoBottom:NO];
    }
}

- (void)onReceivePeerMessage:(NSArray<ZIMKitMessage *> *)messageList fromUserID:(NSString *)fromUserID {
    if ([fromUserID isEqualToString:self.conversationID]) {
        [self reloaddataAndScrolltoBottom:YES];
        [_messageVM clearConversationUnreadMessageCount:self.conversationID conversationType:self.conversationType completeBlock:nil];
    }
}

- (void)onReceiveGroupMessage:(NSArray<ZIMKitMessage *> *)messageList fromGroupID:(NSString *)fromGroupID {
    if ([fromGroupID isEqualToString:self.conversationID]) {
        [self reloaddataAndScrolltoBottom:YES];
        [_messageVM clearConversationUnreadMessageCount:self.conversationID conversationType:self.conversationType completeBlock:nil];
    }
}

- (void)onReceiveRoomMessage:(NSArray<ZIMKitMessage *> *)messageList fromRoomID:(NSString *)fromRoomID {
    
}

- (void)onGroupMemberStateChanged:(ZIMGroupMemberState)state event:(ZIMGroupMemberEvent)event userList:(NSArray<ZIMGroupMemberInfo *> *)userList operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo groupID:(NSString *)groupID {
    if (self.conversationType == ZIMConversationTypeGroup && [self.conversationID isEqualToString:groupID]) {
        if (state == ZIMGroupMemberStateQuit) {
            for (ZIMGroupMemberInfo *memberInfo in userList) {
                if (memberInfo.userID) {
                    [self.memberListDic removeObjectForKey:memberInfo.userID];
                }
            }
        } else if (state == ZIMGroupMemberStateEnter) {
            for (ZIMGroupMemberInfo *memberInfo in userList) {
                if (memberInfo.userID) {
                    [self.memberListDic setObject:memberInfo forKey:memberInfo.userID];
                }
            }
        }
    }
}

- (void)onConnectionStateChange:(ZIMConnectionState)state event:(ZIMConnectionEvent)event extendedData:(NSDictionary *)extendedData {
    if (event == ZIMConnectionEventKickedOut) {
        self.isKickedOut = YES;
        [self.messageToolbar cancelVoiceRecorder];
        self.avPlayerVC ? [self.avPlayerVC dismissViewControllerAnimated:true completion:nil] : nil;
        self.document ? [self.document dismissPreviewAnimated:NO] : nil;
    }
}

#pragma mark ZIMKitInputBarDelegate
/// Reset Keyboard
- (void)didTapViewController {
    [self.messageToolbar hiddeKeyborad];
}

- (void)sendAction:(NSString *)text {
    if ([NSString isEmpty:text]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:[NSBundle ZIMKitlocalizedStringForKey:@"message_cant_send_empty_msg"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[NSBundle ZIMKitlocalizedStringForKey:@"common_sure"] style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:true completion:nil];
        return;
    }
    
    ZIMKitTextMessage *msg = [[ZIMKitTextMessage alloc] initWith:text];
    ZIMMessageSendConfig *msgConfig = [[ZIMMessageSendConfig alloc] init];

    @weakify(self);
    [self.messageVM sendMessage:msg conversationID:self.conversationID conversationType:self.conversationType config:msgConfig onMessageAttached:^(ZIMMessage * _Nonnull message) {} callBack:^(ZIMKitMessage * _Nullable message, ZIMError * _Nullable errorInfo) {
        @strongify(self);
        [self reloaddataAndScrolltoBottom:NO];
        if (errorInfo.code) {
            [self showErrorinfo:errorInfo type:message.type];
        }
    }];
}

- (void)sendMediaMessage:(ZIMKitMediaMessage *)mediaMessage {
    ZIMMessageSendConfig *msgConfig = [[ZIMMessageSendConfig alloc] init];
    
    @weakify(self);
    [self.messageVM sendMeidaMessage:mediaMessage conversationID:self.conversationID conversationType:self.conversationType config:msgConfig onMessageAttached:^(ZIMMessage * _Nonnull message) {
        NSLog(@"~~~~~~~");
    } progress:^(ZIMMediaMessage * _Nonnull message, unsigned long long currentFileSize, unsigned long long totalFileSize) {
        
    } callBack:^(ZIMKitMessage * _Nullable message, ZIMError * _Nullable errorInfo) {
        @strongify(self);
        [self reloaddataAndScrolltoBottom:NO];
        
        if (errorInfo.code != ZIMErrorCodeSuccess) {
            [self showErrorinfo:errorInfo type:message.type];
        }
    }];
}

- (void)showErrorinfo:(ZIMError *)errorInfo type:(ZIMMessageType)type{
    if (self.isKickedOut) { return; }
    
    UIWindow *keyWindow = [ZIMKitTool kit_keyWindow];
    NSString *tip = errorInfo.message;
    if (errorInfo.code == ZIMErrorCodeNetworkModuleNetworkError) {
        tip = [NSBundle ZIMKitlocalizedStringForKey:@"message_sendMessage_tip1"];
    } else if (errorInfo.code == ZIMErrorCodeMessageModuleFileSizeInvalid) {
        tip = [NSBundle ZIMKitlocalizedStringForKey:@"message_image_size_invalid"];
        if (type == ZIMMessageTypeVideo) {
            tip = [NSBundle ZIMKitlocalizedStringForKey:@"message_video_size_invalid"];
        } else if (type == ZIMMessageTypeFile) {
            tip = [NSBundle ZIMKitlocalizedStringForKey:@"message_file_size_invalid"];
        }
    }
    
    [keyWindow makeToast:tip duration:1.5 position:CSToastPositionCenter];
}

- (void)reloaddataAndScrolltoBottom:(BOOL)isReceve {
    [self.messageTableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateTableViewLayout:isReceve];
    });
}

- (void)scrollToBottom:(BOOL)animate {
    [self scrollToBottomWithAnimated:animate];
}

- (void)scrollToBottomWithAnimated: (BOOL)animated {
    if(self.messageVM.messageList.count > 0){
        NSInteger lastRowIndex = [self.messageTableView numberOfRowsInSection:0] - 1;
//        NSInteger lastRowIndex = self.messageVM.messageList.count - 1;
        if(lastRowIndex > 0){
            NSIndexPath*lastIndexPath = [NSIndexPath indexPathForRow: lastRowIndex inSection: 0];
            [self.messageTableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition: UITableViewScrollPositionBottom animated:animated];
        }
    }
}

- (void)willMoveToParentViewController:(UIViewController*)parent {
    [super willMoveToParentViewController:parent];
    
    if (nil == parent) {
        [_messageVM clearConversationUnreadMessageCount:self.conversationID conversationType:self.conversationType completeBlock:nil];
    }
}

- (void)didEnterBackground:(NSNotification *)noti {
    [self playVoiceEnd];
    [self.messageToolbar cancelVoiceRecorder];
}

- (ZIMKitVoicePlayer *)voicePlay {
    if (!_voicePlay) {
        _voicePlay = [[ZIMKitVoicePlayer alloc] init];
        _voicePlay.delegate = self;
    }
    return _voicePlay;
}

- (NSMutableArray *)selectedMessages {
    if (!_selectedMessages) {
        _selectedMessages = [NSMutableArray array];
    }
    return _selectedMessages;
}

- (void)dealloc {
    
    [_messageVM clearAllCacheData];
    _messageVM = nil;
    NSLog(@"ZIMKitMessagesListVC delloc");
}

@end
