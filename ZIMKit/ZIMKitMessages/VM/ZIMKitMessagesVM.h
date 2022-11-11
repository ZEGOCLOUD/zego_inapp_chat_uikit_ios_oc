//
//  ZIMKitMessagesVM.h
//  ZIMKit
//
//  Created by zego on 2022/5/24.
//

#import <Foundation/Foundation.h>
#import <ZIM/ZIM.h>

@class ZIMKitMessage,ZIMKitMediaMessage, ZIMKitMessagesVM;

typedef void (^ZIMKitMessageCallback)(ZIMKitMessage * _Nullable message, ZIMError * _Nullable errorInfo);
typedef void (^ZIMKitLoadMessagesCallback)(NSArray<ZIMKitMessage *> * _Nullable messageList, ZIMError * _Nullable errorInfo);
typedef void(^ZIMKitCallBlock) (ZIMError * _Nullable errorInfo);

NS_ASSUME_NONNULL_BEGIN
@protocol ZIMKitMessagesVMDelegate <NSObject>
@optional
- (void)onDataSourceChange:(NSString *)conversationID;

/// Receive single chat message
- (void)onReceivePeerMessage:(NSArray<ZIMKitMessage *> *)messageList fromUserID:(NSString *)fromUserID;

/// Receive group chat message
- (void)onReceiveGroupMessage:(NSArray<ZIMKitMessage *> *)messageList fromGroupID:(NSString *)fromGroupID;

/// Receive room chat message
- (void)onReceiveRoomMessage:(NSArray<ZIMKitMessage *> *)messageList fromRoomID:(NSString *)fromRoomID;

/// Group member  change
- (void)onGroupMemberStateChanged:(ZIMGroupMemberState)state event:(ZIMGroupMemberEvent)event userList:(NSArray<ZIMGroupMemberInfo *> *)userList operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo groupID:(NSString *)groupID;

- (void)onConnectionStateChange:(ZIMConnectionState)state event:(ZIMConnectionEvent)event extendedData:(NSDictionary *)extendedData;

#pragma mark update datasource
/// Insert datasource
- (void)dataSourceInsert:(ZIMKitMessagesVM *)VM index:(int)index animation:(BOOL)animation;
@end

@interface ZIMKitMessagesVM : NSObject

@property (nonatomic, weak) id<ZIMKitMessagesVMDelegate> delegate;

@property (nonatomic, readonly) NSArray<ZIMKitMessage *> *messageList;

/// init messageVM
///
/// @param conversationID  current conversationID
- (instancetype)initWith:(NSString *)conversationID;

/// Send text message
///
/// Send ordinary messages (single chat, group chat, room)
///
/// @param message messae
/// @param conversationID conversationID
/// @param conversationType conversationType
/// @param config  config
/// @param onMessageAttached Callbacks in message sending
/// @param callBack Send result callback
- (void)sendMessage:(ZIMKitMessage *)message
     conversationID:(NSString *)conversationID
   conversationType:(ZIMConversationType)conversationType
             config:(ZIMMessageSendConfig *)config
  onMessageAttached:(nullable ZIMMessageAttachedCallback)onMessageAttached
           callBack:(ZIMKitMessageCallback)callBack;

/// Send media message
///
/// Include (picture, voice, video, file) messages
///
/// @param message message
/// @param conversationID conversationID
/// @param conversationType conversationType
/// @param config config
/// @param onMessageAttached Callbacks in message sending
/// @param progress progress
/// @param callBack Send result callback
- (void)sendMeidaMessage:(ZIMKitMediaMessage *)message
          conversationID:(NSString *)conversationID
        conversationType:(ZIMConversationType)conversationType
                  config:(ZIMMessageSendConfig *)config
       onMessageAttached:(nullable ZIMMessageAttachedCallback)onMessageAttached
                progress:(ZIMMediaUploadingProgress)progress
                callBack:(ZIMKitMessageCallback)callBack;

/// Media message download
///
/// Include (picture, voice, video, file) messages
///
/// @param message message
/// @param progress progress
/// @param callback callback
- (void)downloadMediaFileWithMessage:(ZIMKitMediaMessage *)message
                            progress:(ZIMMediaDownloadingProgress)progress
                            callback:(ZIMMediaDownloadedCallback)callback ;

/// Query history message
///
///  The [config]nextMessage is' null 'when querying for the first time. For subsequent paging queries, [config]nextMessage is the last message in the currently queried message list
///
/// @param conversationID ID
/// @param type conversation type
/// @param config config
/// @param callBack callBack
- (void)queryHistoryMessage:(NSString *)conversationID
                       type:(ZIMConversationType)type
                     config:(ZIMMessageQueryConfig *)config
                   callBack:(ZIMKitLoadMessagesCallback)callBack;


/// Delete message
///
/// Configurable (config.isAlsoDeleteServerMessage) whether to delete the server at the same time
///
/// @param conversationID conversationID
/// @param conversationType conversation type
/// @param config  config
/// @param messageList message list
/// @param callBack callBack
- (void)deleteMessage:(NSString *)conversationID
     conversationType:(ZIMConversationType)conversationType
               config:(ZIMMessageDeleteConfig *)config
          messageList:(NSArray <ZIMKitMessage *>*)messageList
             callBack:(ZIMKitCallBlock)callBack;


/// Delete all message
///
/// Configurable (config.isAlsoDeleteServerMessage) whether to delete the server at the same time
///
/// @param conversationID ID
/// @param conversationType  conversation type
/// @param config config
/// @param callBack callBack
- (void)deleteAllMessage:(NSString *)conversationID
        conversationType:(ZIMConversationType)conversationType
                  config:(ZIMMessageDeleteConfig *)config
                callBack:(ZIMKitCallBlock)callBack;

/// Query groupmember list
///
/// @param groupID ID
/// @param config config
/// @param callback callback
- (void)queryGroupMemberListByGroupID:(NSString *)groupID
                               config:(ZIMGroupMemberQueryConfig *)config
                             callback:(ZIMGroupMemberListQueriedCallback)callback;


/// Query groupInfo
///
/// @param groupID ID
/// @param callback callback
- (void)queryGroupInfoWithGroupID:(NSString *)groupID callback:(ZIMGroupInfoQueriedCallback)callback;


/// Clear conversation unread count
- (void)clearConversationUnreadMessageCount:(NSString *)coversationID
                           conversationType:(ZIMConversationType)conversationType
                              completeBlock:(nullable ZIMKitCallBlock)completeBlock;

/// Clear the data (the external VC holds the VM and needs to call it when destroying it, otherwise the VM cannot be released)
- (void)clearAllCacheData;

- (NSString *)getImagepath;
@end

NS_ASSUME_NONNULL_END
