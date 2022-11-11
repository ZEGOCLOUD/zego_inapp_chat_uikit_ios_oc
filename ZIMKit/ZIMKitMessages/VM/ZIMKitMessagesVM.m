//
//  ZIMKitMessagesVM.m
//  ZIMKit
//
//  Created by zego on 2022/5/24.
//

#import "ZIMKitMessagesVM.h"
#import "ZIMKitMessage.h"
#import "ZIMKitTextMessage.h"
#import "ZIMKitMediaMessage.h"
#import "ZIMKitImageMessage.h"
#import "ZIMKitSystemMessage.h"
#import "ZIMKitEventHandler.h"
#import "ZIMKitMessageTool.h"
#import "ZIMKitDefine.h"

@interface ZIMKitMessagesVM ()

@property (nonatomic, strong) NSMutableArray  *messages;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) NSString        *curConversationID;

@end

@implementation ZIMKitMessagesVM

- (instancetype)initWith:(NSString *)conversationID {
    if (self = [super init]) {
        _curConversationID = conversationID;
        [self addMessageEventHadle];
        _messages = [NSMutableArray array];
    }
    return self;
}

- (NSArray<ZIMKitMessage *> *)messageList {
    return _messages;
}

- (void)sendMessage:(ZIMKitMessage *)message
     conversationID:(NSString *)conversationID
   conversationType:(ZIMConversationType)conversationType
             config:(ZIMMessageSendConfig *)config
  onMessageAttached:(ZIMMessageAttachedCallback)onMessageAttached
           callBack:(ZIMKitMessageCallback)callBack {
    NSAssert(conversationID,  @"The conversationID should not be nil.");
    
    [self addKitMessage:message];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDataSourceChange:)]) {
        [self.delegate onDataSourceChange:conversationID];
    }
    
    ZIMMessage *sendMessage = [ZIMKitMessageTool fromZIMKitMessageConvert:message];
    
    @weakify(self);
    ZIMMessageSendNotification *noti = [[ZIMMessageSendNotification alloc] init];
    noti.onMessageAttached = onMessageAttached;
    [ZIMKitManagerZIM sendMessage:sendMessage toConversationID:conversationID conversationType:conversationType config:config notification:noti callback:^(ZIMMessage * _Nonnull message1, ZIMError * _Nonnull errorInfo) {
        @strongify(self);
        if (callBack) {
            ZIMKitMessage *kitMessage = [ZIMKitMessageTool fromZIMMessageUpdate:message1 originMsg:message];
            /// User does not have system message prompt
            if (errorInfo.code == ZIMErrorCodeMessageModuleTargetDoseNotExist && conversationType == ZIMConversationTypePeer) {
                ZIMKitSystemMessage *sysMessage = [[ZIMKitSystemMessage alloc] init];
                sysMessage.type = ZIMKitSystemMessageType;
                sysMessage.timestamp = kitMessage.timestamp;
                sysMessage.content = [NSString stringWithFormat:@"%@ %@ %@",[NSBundle ZIMKitlocalizedStringForKey:@"message_user_not_exit_please_again_w_1"] ,conversationID, [NSBundle ZIMKitlocalizedStringForKey:@"message_user_not_exit_please_again_w_2"]];
                sysMessage.zimMsg = kitMessage.zimMsg;
                [self addKitMessage:sysMessage];
            }
            
            [self findOriginMessage:kitMessage originMessage:message];
                        
            callBack(kitMessage, errorInfo);
        }
    }];
}

- (void)sendMeidaMessage:(ZIMKitMediaMessage *)message
          conversationID:(NSString *)conversationID
        conversationType:(ZIMConversationType)conversationType
                  config:(ZIMMessageSendConfig *)config
       onMessageAttached:(ZIMMessageAttachedCallback)onMessageAttached
                progress:(ZIMMediaUploadingProgress)progress
                callBack:(ZIMKitMessageCallback)callBack  {
    [self addKitMessage:message];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDataSourceChange:)]) {
        [self.delegate onDataSourceChange:conversationID];
    }
    
    ZIMMediaMessage *meidaMessage = (ZIMMediaMessage *) [ZIMKitMessageTool fromZIMKitMessageConvert:message];
    @weakify(self);
    
    ZIMMediaMessageSendNotification *noti = [[ZIMMediaMessageSendNotification alloc] init];
    noti.onMessageAttached = onMessageAttached;
    noti.onMediaUploadingProgress = progress;
    [ZIMKitManagerZIM sendMediaMessage:meidaMessage toConversationID:conversationID conversationType:conversationType config:config notification:noti callback:^(ZIMMessage * _Nonnull message1, ZIMError * _Nonnull errorInfo) {
        @strongify(self);
        if (callBack) {
            ZIMKitMessage *kitMessage = [ZIMKitMessageTool fromZIMMessageUpdate:message1 originMsg:message];
            
            [self findOriginMessage:kitMessage originMessage:message];
            
            callBack(kitMessage, errorInfo);
        }
    }];
}

- (void)queryHistoryMessage:(NSString *)conversationID
                       type:(ZIMConversationType)type
                     config:(ZIMMessageQueryConfig *)config
                   callBack:(ZIMKitLoadMessagesCallback)callBack {
    NSAssert(conversationID,  @"The conversationID should not be nil.");
    
    @weakify(self);
    [ZIMKitManagerZIM queryHistoryMessageByConversationID:conversationID conversationType:type config:config callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, NSArray<ZIMMessage *> * _Nonnull messageList, ZIMError * _Nonnull errorInfo) {
        @strongify(self);
        if (callBack) {
            
            NSMutableArray *msgs = [NSMutableArray array];
            if (messageList.count) {
                ZIMKitMessage *preMessage = nil;
                for (ZIMMessage *msg in messageList) {
                    ZIMKitMessage *kitMessage = [ZIMKitMessageTool fromZIMMessageConvert:msg];
                    BOOL isShowtime = [kitMessage isNeedshowtime:preMessage.timestamp];
                    kitMessage.needShowTime = isShowtime;
                    if (kitMessage) {
                        [msgs addObject:kitMessage];
                        preMessage = kitMessage;
                    }
                }
                
                ZIMKitMessage *oriPreMessage = self.messages.firstObject;
                ZIMKitMessage *lastMsg = msgs.lastObject;
                oriPreMessage.needShowTime = [oriPreMessage isNeedshowtime:lastMsg.timestamp];
                [oriPreMessage resetCellHeight];
                
                NSMutableArray *dataList = [NSMutableArray arrayWithArray:msgs];
                [dataList addObjectsFromArray:self.messages];
                self.messages = dataList;
            }
            
            callBack(msgs, errorInfo);
        }
    }];
}

- (void)deleteMessage:(NSString *)conversationID
     conversationType:(ZIMConversationType)conversationType
               config:(ZIMMessageDeleteConfig *)config
          messageList:(NSArray <ZIMKitMessage *>*)messageList
             callBack:(ZIMKitCallBlock)callBack {
    NSAssert(conversationID,  @"The conversationID should not be nil.");
    NSAssert(messageList.count,  @"messageList.cout should not be 0.");
    
    NSMutableArray *zimMsgs = [[NSMutableArray alloc] init];
    for (ZIMKitMessage *msg in messageList) {
        [self removeKitmessage:msg];
        if (msg.zimMsg) {
            [zimMsgs addObject:msg.zimMsg];
        }
    }
    
    [ZIMKitManagerZIM deleteMessages:zimMsgs conversationID:conversationID conversationType:conversationType config:config callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
        if (callBack) {
            callBack(errorInfo);
        }
    }];
}

- (void)deleteAllMessage:(NSString *)conversationID
        conversationType:(ZIMConversationType)conversationType
                  config:(ZIMMessageDeleteConfig *)config
                callBack:(ZIMKitCallBlock)callBack {
    NSAssert(conversationID,  @"The conversationID should not be nil.");
    
    [ZIMKitManagerZIM deleteAllMessageByConversationID:conversationID conversationType:conversationType config:config callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
        if (callBack) {
            callBack(errorInfo);
        }
    }];
}

- (void)queryGroupMemberListByGroupID:(NSString *)groupID
                                    config:(ZIMGroupMemberQueryConfig *)config
                                  callback:(ZIMGroupMemberListQueriedCallback)callback {
    NSAssert(groupID,  @"queryqueryGroupMemberListByGroupID The groupID should not be nil.");
    
    [ZIMKitManagerZIM queryGroupMemberListByGroupID:groupID config:config callback:callback];
}

- (void)queryGroupInfoWithGroupID:(NSString *)groupID callback:(ZIMGroupInfoQueriedCallback)callback {
    NSAssert(groupID,  @"queryGroupInfoWithGroupID The groupID should not be nil.");
    
    [ZIMKitManagerZIM queryGroupInfoByGroupID:groupID callback:callback];
}

- (void)downloadMediaFileWithMessage:(ZIMKitMediaMessage *)message
                            progress:(ZIMMediaDownloadingProgress)progress
                            callback:(ZIMMediaDownloadedCallback)callback {
    
    ZIMMediaFileType type = ZIMMediaFileTypeOriginalFile;
    ZIMMediaMessage *tem =(ZIMMediaMessage *) message.zimMsg;
    [ZIMKitManagerZIM downloadMediaFileWithMessage:tem fileType:type progress:progress callback:callback];
}

- (void)addMessageEventHadle {
    @weakify(self);
    [[ZIMKitEventHandler shared] addEventListener:KEY_RECEIVE_PEER_MESSAGE
                                         listener:self
                                         callBack:^(NSDictionary * _Nullable param) {
        @strongify(self);
        NSArray<ZIMMessage *>* messageLlist = param[PARAM_MESSAGE_LIST];
        NSString *fromUserID = param[PARAM_FROM_USER_ID];
        if ([self.curConversationID isEqualToString:fromUserID]) {
            //sort
            NSArray *list = [messageLlist sortedArrayUsingComparator:^NSComparisonResult(ZIMMessage *obj1, ZIMMessage *obj2) {
                return obj1.timestamp > obj2.timestamp;
            }];
            
            NSMutableArray *listData = [NSMutableArray array];
            for (ZIMMessage *message in list) {
                ZIMKitMessage *kitMessage = [ZIMKitMessageTool fromZIMMessageConvert:message];
                if (kitMessage) {
                    [listData addObject:kitMessage];
                    [self addKitMessage:kitMessage];
                }
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(onReceivePeerMessage:fromUserID:)]) {
                [self.delegate onReceivePeerMessage:listData fromUserID:fromUserID];
            }
        }
    }];
    
    [[ZIMKitEventHandler shared] addEventListener:KEY_RECEIVE_GROUP_MESSAGE
                                         listener:self
                                         callBack:^(NSDictionary * _Nullable param) {
        @strongify(self);
        NSArray<ZIMMessage *>* messageLlist = param[PARAM_MESSAGE_LIST];
        NSString *fromGroupID = param[PARAM_FROM_GROUP_ID];
        
        if ([self.curConversationID isEqualToString:fromGroupID]) {
            //这里的消息需要先排序
            NSArray *list = [messageLlist sortedArrayUsingComparator:^NSComparisonResult(ZIMMessage *obj1, ZIMMessage *obj2) {
                return obj1.timestamp > obj2.timestamp;
            }];
            NSMutableArray *listData = [NSMutableArray array];
            for (ZIMMessage *message in list) {
                ZIMKitMessage *kitMessage = [ZIMKitMessageTool fromZIMMessageConvert:message];
                if (kitMessage) {
                    [listData addObject:kitMessage];
                    [self addKitMessage:kitMessage];
                }
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(onReceiveGroupMessage:fromGroupID:)]) {
                [self.delegate onReceiveGroupMessage:listData fromGroupID:fromGroupID];
            }
        }
    }];
    
    [[ZIMKitEventHandler shared] addEventListener:KEY_RECEIVE_ROOM_MESSAGE
                                         listener:self
                                         callBack:^(NSDictionary * _Nullable param) {
        @strongify(self);
        NSArray<ZIMMessage *>* messageLlist = param[PARAM_MESSAGE_LIST];
        NSString *fromRoomID = param[PARAM_FROM_ROOM_ID];
        
        if ([self.curConversationID isEqualToString:fromRoomID]) {
            //这里的消息需要先排序
            NSArray *list = [messageLlist sortedArrayUsingComparator:^NSComparisonResult(ZIMMessage *obj1, ZIMMessage *obj2) {
                return obj1.timestamp > obj2.timestamp;
            }];
            
            NSMutableArray *listData = [NSMutableArray array];
            for (ZIMMessage *message in list) {
                ZIMKitMessage *kitMessage = [ZIMKitMessageTool fromZIMMessageConvert:message];
                if (kitMessage) {
                    [listData addObject:kitMessage];
                    [self addKitMessage:kitMessage];
                }
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(onReceiveRoomMessage:fromRoomID:)]) {
                [self.delegate onReceiveRoomMessage:listData fromRoomID:fromRoomID];
            }
        }
    }];
    
    [[ZIMKitEventHandler shared] addEventListener:KEY_GROUP_MEMBER_STATE_CHANGED listener:self callBack:^(NSDictionary * _Nullable param) {
        @strongify(self);
        NSString *groupID = param[PARAM_GROUP_GROUPID];
        
        if ([self.curConversationID isEqualToString:groupID]) {
            ZIMGroupMemberState state = [param[PARAM_GROUP_MEMBER_STATE] intValue];
            ZIMGroupMemberEvent event = [param[PARAM_GROUP_MEMBER_EVENT] intValue];
            NSArray *userList = param[PARAM_GROUP_USER_LIST];
            ZIMGroupOperatedInfo *operatedInfo = param[PARAM_GROUP_OPERATEDINFO];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(onGroupMemberStateChanged:event:userList:operatedInfo:groupID:)]) {
                [self.delegate onGroupMemberStateChanged:state event:event userList:userList operatedInfo:operatedInfo groupID:groupID];
            }
        }
    }];
    
    [[ZIMKitEventHandler shared] addEventListener:KEY_CONNECTION_STATE_CHANGED listener:self callBack:^(NSDictionary * _Nullable param) {
        @strongify(self);
        
        NSDictionary *extendedData = param[PARAM_EXTENDED_DATA];
        ZIMConnectionState state = [param[PARAM_STATE] intValue];
        ZIMConnectionEvent event = [param[PARAM_EVENT] intValue];
        if (self.delegate && [self.delegate respondsToSelector:@selector(onConnectionStateChange:event:extendedData:)]) {
            [self.delegate onConnectionStateChange:state event:event extendedData:extendedData];
        }
    }];
}

- (void)clearConversationUnreadMessageCount:(NSString *)coversationID
                           conversationType:(ZIMConversationType)conversationType
                              completeBlock:(ZIMKitCallBlock)completeBlock {
    [ZIMKitManagerZIM clearConversationUnreadMessageCount:coversationID conversationType:conversationType callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
        if (completeBlock) {
            completeBlock(errorInfo);
        }
    }];
}

- (void)removeMessageEventHadle {
    [[ZIMKitEventHandler shared] removeEventListener:KEY_RECEIVE_GROUP_MESSAGE listener:self];
    [[ZIMKitEventHandler shared] removeEventListener:KEY_RECEIVE_GROUP_MESSAGE listener:self];
    [[ZIMKitEventHandler shared] removeEventListener:KEY_RECEIVE_ROOM_MESSAGE listener:self];
}

- (void)clearAllCacheData {
    [self removeMessageEventHadle];
}

/// 获取本地图片路径
- (NSString *)getImagepath {
    return [[ZIMKitManager shared] getImagepath];
}

#pragma mark private
- (void)addKitMessage:(ZIMKitMessage *)message {
    ZIMKitMessage *preMessage = self.messages.lastObject;
    BOOL isShowTime = [message isNeedshowtime:preMessage.timestamp];
    message.needShowTime = isShowTime;
    [self.messages addObject:message];
}

- (void)removeKitmessage:(ZIMKitMessage *)mesage {
    [self.messages removeObject:mesage];
}

- (void)findOriginMessage:(ZIMKitMessage *)message originMessage:(ZIMKitMessage *)originMessage {
    NSInteger index = [self.messages indexOfObject:originMessage];
    if (index == NSNotFound) {
        return;
    }
    message.needShowName = originMessage.needShowName;
    message.needShowTime = originMessage.needShowTime;
    [self.messages replaceObjectAtIndex:index withObject:message];
    
}
@end
