//
//  ZIMKitEventHandler.m
//  ZIMKit
//
//  Created by zego on 2022/5/19.
//

#import "ZIMKitEventHandler.h"
#import "ZIMKitDefine.h"

#define kZIMKitListener @"ZIMKitListener"
#define kZIMKitCallback @"kZIMKitCallback"

@interface ZIMKitEventHandler ()

@property (nonatomic, strong) NSMutableDictionary *eventHandleDic;
@end

@implementation ZIMKitEventHandler

+ (instancetype)shared {
    static ZIMKitEventHandler *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZIMKitEventHandler alloc] init];
    });
    return instance;
}

- (void)addEventListener:(NSString *)key listener:(id)listener callBack:(ZIMKitEventCallback)callBack {
    NSMutableArray *listenerArray = [self.eventHandleDic objectForKey:key];
    if (!listenerArray) {
        if (callBack) {
            listenerArray = [NSMutableArray array];
            NSDictionary *listenerCallBack = @{kZIMKitListener : listener, kZIMKitCallback : callBack};
            [listenerArray addObject:listenerCallBack];
            [self.eventHandleDic setObject:listenerArray forKey:key];
        }
    }else {
        if (callBack) {
            NSDictionary *listenerCallBack = @{kZIMKitListener : listener, kZIMKitCallback : callBack};
            [listenerArray addObject:listenerCallBack];
            [self.eventHandleDic setObject:listenerArray forKey:key];
        }
    }
}

- (void)removeEventListener:(NSString *)key listener:(id)listener {
    NSMutableArray *listenerArray = [self.eventHandleDic objectForKey:key];
    if (!listenerArray) {
        NSLog(@"not found listener with key is %@", key);
    }else {
        for (NSDictionary *dic in listenerArray.reverseObjectEnumerator) {
            if ([dic[kZIMKitListener] isEqual:listener]) {
                [listenerArray removeObject:dic];
            }
        }
    }
}


- (NSMutableDictionary *)eventHandleDic {
    if (!_eventHandleDic) {
        _eventHandleDic = [NSMutableDictionary dictionary];
    }
    return _eventHandleDic;
}

#pragma mark ZIMEventHandler
- (void)zim:(ZIM *)zim connectionStateChanged:(ZIMConnectionState)state event:(ZIMConnectionEvent)event extendedData:(NSDictionary *)extendedData {
    NSLog(@"-----------------connectionStateChanged %ld", state);
    [self eventhandlerWith:KEY_CONNECTION_STATE_CHANGED param:@{PARAM_STATE : @(state),
                                                                PARAM_EVENT : @(event),
                                                                PARAM_EXTENDED_DATA : extendedData ? extendedData : [NSDictionary dictionary]
                                                              }];
}

/**
  conversation
 */
- (void)zim:(ZIM *)zim conversationChanged:(NSArray<ZIMConversationChangeInfo *> *)conversationChangeInfoList {
    
    [self eventhandlerWith:KEY_CONVERSATION_CHANGED
                     param:@{PARAM_CONVERSATION_CHANGED_LIST : conversationChangeInfoList}];
}

- (void)zim:(ZIM *)zim conversationTotalUnreadMessageCountUpdated:(unsigned int)totalUnreadMessageCount {
    
    [self eventhandlerWith:KEY_CONVERSATION_TOTALUNREADMESSAGECOUNT_UPDATED
                     param:@{PARAM_CONVERSATION_TOTALUNREADMESSAGECOUNT : @(totalUnreadMessageCount)}];
}

/**
  message
 */

- (void)zim:(ZIM *)zim receivePeerMessage:(NSArray<ZIMMessage *> *)messageList fromUserID:(NSString *)fromUserID {
    
    [self eventhandlerWith:KEY_RECEIVE_PEER_MESSAGE
                     param:@{PARAM_MESSAGE_LIST : messageList, PARAM_FROM_USER_ID : fromUserID ? :@""}];
}

- (void)zim:(ZIM *)zim receiveGroupMessage:(NSArray<ZIMMessage *> *)messageList fromGroupID:(NSString *)fromGroupID {
    
    [self eventhandlerWith:KEY_RECEIVE_GROUP_MESSAGE
                     param:@{PARAM_MESSAGE_LIST : messageList, PARAM_FROM_GROUP_ID : fromGroupID ? :@""}];
}

- (void)zim:(ZIM *)zim receiveRoomMessage:(NSArray<ZIMMessage *> *)messageList fromRoomID:(nonnull NSString *)fromRoomID {
    
    [self eventhandlerWith:KEY_RECEIVE_ROOM_MESSAGE
                     param:@{PARAM_MESSAGE_LIST : messageList, PARAM_FROM_ROOM_ID : fromRoomID ? :@""}];
}

/**
 group
 */
- (void)zim:(ZIM *)zim groupMemberStateChanged:(ZIMGroupMemberState)state event:(ZIMGroupMemberEvent)event userList:(NSArray<ZIMGroupMemberInfo *> *)userList operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo groupID:(NSString *)groupID {
    [self eventhandlerWith:KEY_GROUP_MEMBER_STATE_CHANGED param:@{PARAM_GROUP_GROUPID : groupID ? :@"",
                                                                  PARAM_GROUP_MEMBER_STATE : @(state),
                                                                  PARAM_GROUP_MEMBER_EVENT : @(event),
                                                                  PARAM_GROUP_USER_LIST : userList ? userList : [NSArray array],
                                                                  PARAM_GROUP_OPERATEDINFO : operatedInfo ? operatedInfo : [[ZIMGroupOperatedInfo alloc]init]}];
}

- (void)eventhandlerWith:(NSString *)key param:(NSDictionary *)param {
    NSMutableArray *listenerArray = [self.eventHandleDic objectForKey:key];
    
    if (listenerArray) {
        for (NSDictionary *dic in listenerArray) {
            ZIMKitEventCallback callBack = dic[kZIMKitCallback];
            if (callBack) {
                callBack(param);
            }
        }
    }
}
@end
