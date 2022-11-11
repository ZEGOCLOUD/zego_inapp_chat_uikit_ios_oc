//
//  ZIMKitMessage.h
//  ZIMKit
//
//  Created by zego on 2022/5/24.
//

#import <Foundation/Foundation.h>
#import "ZIMKitMessageCellConfig.h"
#import <ZIM/ZIM.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitMessage : NSObject

@property (nonatomic, assign) ZIMMessageType type;

@property (nonatomic, assign) long long messageID;

@property (nonatomic, assign) long long localMessageID;

@property (nonatomic, copy) NSString *senderUserID;

@property (nonatomic, copy) NSString *senderUsername;

@property (nonatomic, copy) NSString *senderUserAvatar;

/// Description: Session ID. Ids of the same session type are unique.
@property (nonatomic, copy) NSString *conversationID;

/// Description: Used to describe whether a message is sent or received.
@property (nonatomic, assign) ZIMMessageDirection direction;

/// Description: Describes the sending status of a message.
@property (nonatomic, assign) ZIMMessageSentStatus sentStatus;

/// Description: The type of session to which the message belongs.
@property (nonatomic, assign) ZIMConversationType conversationType;

/// Caution: This is a standard UNIX timestamp, in milliseconds.
@property (nonatomic, assign) unsigned long long timestamp;

/// Description:The larger the orderKey, the newer the message, and can be used for ordering messages.
@property (nonatomic, assign) long long orderKey;

@property (nonatomic, strong) ZIMKitMessageCellConfig *cellConfig;

/// display a time
@property (nonatomic, assign) BOOL needShowTime;

/// display a nickname
@property (nonatomic, assign) BOOL needShowName;

/// Is it the top data of the UI
@property (nonatomic, assign) BOOL isLastTop;

/// cell helght
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, copy) NSString *reuseId;

@property (nonatomic, copy) NSString *extendData;

/// ZIMSDK message
@property (nonatomic, strong) ZIMMessage* zimMsg;

/// content size
- (CGSize)contentSize;

/// ZIMMessage ->ZIMKitMessage
- (void)fromZIMMessage:(ZIMMessage *)message;


/// display a time
///
/// @param timestamp message time (ms)
- (BOOL)isNeedshowtime:(unsigned long long)timestamp;

/// Recalculate height
- (CGFloat)resetCellHeight;

/// Calculate text message size
- (CGSize)sizeAttributedWithFont:(UIFont *)font width:(CGFloat)width  wordWap:(NSLineBreakMode)lineBreadMode string:(NSString *)contentString;

@end

NS_ASSUME_NONNULL_END
