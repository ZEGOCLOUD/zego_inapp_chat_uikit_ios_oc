//
//  ZIMKitMessageCellConfig.h
//  ZIMKit
//
//  Created by zego on 2022/5/26.
//

#import <Foundation/Foundation.h>
@class ZIMKitMessage;

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitMessageCellConfig : NSObject

- (instancetype)initWithMessage:(ZIMKitMessage *)message;

/// Head size
- (CGSize)avatarSize;

/// Text message font size
+ (CGFloat)messageTextFontSize;

/// Username fount size
- (CGFloat)userNameFontSize;

/// Text messae textcolor
- (UIColor *)messageTextColor;

/// Username textcolor
- (UIColor *)userNameColor;

/// Content insets
- (UIEdgeInsets)contentViewInsets;

+ (UIImage *)receiveBubble;

+ (UIImage *)receiveBubble2;

+ (UIImage *)recevieBubbleClicked;

+ (UIImage *)sendBubble;

+ (UIImage *)sendBubble2;

+ (UIImage *)sendBubbleClicked;
@end

NS_ASSUME_NONNULL_END
