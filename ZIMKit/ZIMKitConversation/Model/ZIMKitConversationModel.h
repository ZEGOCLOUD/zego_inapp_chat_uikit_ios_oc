//
//  ZIMKitConversationModel.h
//  ZIMKit
//
//  Created by zego on 2022/5/19.
//

#import <Foundation/Foundation.h>
#import "ZIMKitDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitConversationModel : NSObject
/// ConversationID
@property (nonatomic, copy) NSString *conversationID;

/// conversationName
@property (nonatomic, copy) NSString *conversationName;

/// ConversationAvatarUrl
@property (nonatomic, copy) NSString *conversationAvatar;

/// ConversationType
@property (nonatomic, assign) ZIMConversationType type;

/// Conversation Event
@property (nonatomic, assign) ZIMConversationEvent conversationEvent;

/// Unread count
@property (nonatomic, assign) int unreadMessageCount;

/// last message
@property (nonatomic, strong) ZIMMessage *lastMessage;

/// Sort field
@property (nonatomic, assign) long long orderKey;

/// notification status
@property (nonatomic, assign) ZIMConversationNotificationStatus notificationStatus;

/// ZIM SDK ZIMConversation ->ZIMKitConversationModel
- (void)fromZIMConversationWith:(ZIMConversation *)con;

/// ZIMKitConversationModel->ZIMConversation
- (ZIMConversation *)toZIMConversationModel;
@end

NS_ASSUME_NONNULL_END
