//
//  ZIMKitMessageCellConfig.m
//  ZIMKit
//
//  Created by zego on 2022/5/26.
//

#import "ZIMKitMessageCellConfig.h"
#import "ZIMKitMessage.h"
#import "ZIMKitDefine.h"

@interface ZIMKitMessageCellConfig ()

@property (nonatomic, strong) ZIMKitMessage *message;
@end

@implementation ZIMKitMessageCellConfig

- (instancetype)initWithMessage:(ZIMKitMessage *)message {
    self = [super init];
    if (self) {
        _message = message;
    }
    
    return self;
}

- (CGSize)avatarSize {
    return CGSizeMake(43.0, 43.0);
}

+ (CGFloat)messageTextFontSize {
    return 15.0;
}

- (CGFloat)userNameFontSize {
    return 11.0;
}

- (UIColor *)messageTextColor {
    
    if (_message.direction == ZIMMessageDirectionSend) {
        return [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
    } else {
        return [UIColor dynamicColor:ZIMKitHexColor(0x2A2A2A) lightColor:ZIMKitHexColor(0x2A2A2A)];
    }
}

- (UIColor *)userNameColor {
    return [UIColor dynamicColor:ZIMKitHexColor(0x666666) lightColor:ZIMKitHexColor(0x666666)];
}

- (UIEdgeInsets)contentViewInsets {
    
    if (self.message.type == ZIMMessageTypeText || self.message.type == ZIMMessageTypeUnknown) {
        return UIEdgeInsetsMake(11, 12, 11, 12);
    } else {
        return UIEdgeInsetsZero;
    }
}

static UIImage *sRecevieBubble;
+ (UIImage *)receiveBubble
{
    if (!sRecevieBubble) {
        UIImage *image = [UIImage zegoImageNamed:@"receve_bubble"];
        sRecevieBubble = [image resizableImageWithCapInsets:UIEdgeInsetsMake(11, 12, 11, 12) resizingMode:UIImageResizingModeStretch];
    }
    return sRecevieBubble;
}

static UIImage *sRecevieBubble2;
+ (UIImage *)receiveBubble2
{
    if (!sRecevieBubble2) {
        UIImage *image = [UIImage zegoImageNamed:@"receve_bubble_2"];
        sRecevieBubble2 = [image resizableImageWithCapInsets:UIEdgeInsetsMake(11, 12, 11, 12) resizingMode:UIImageResizingModeStretch];
    }
    return sRecevieBubble2;
}

static UIImage *sRecevieBubbleClicked;
+ (UIImage *)recevieBubbleClicked
{
    if (!sRecevieBubbleClicked) {
        UIImage *image = [UIImage zegoImageNamed:@"receve_bubble_clicked"];
        sRecevieBubbleClicked = [image resizableImageWithCapInsets:UIEdgeInsetsMake(11, 12, 11, 12) resizingMode:UIImageResizingModeStretch];
    }
    return sRecevieBubbleClicked;
}

static UIImage *sSendBubble;
+ (UIImage *)sendBubble
{
    if (!sSendBubble) {
        UIImage *image = [UIImage zegoImageNamed:@"send_bubble"];
        sSendBubble = [image resizableImageWithCapInsets:UIEdgeInsetsMake(11, 12, 11, 12) resizingMode:UIImageResizingModeStretch];
    }
    return sSendBubble;
}

static UIImage *sSendBubble2;
+ (UIImage *)sendBubble2
{
    if (!sSendBubble2) {
        UIImage *image = [UIImage zegoImageNamed:@"send_bubble_2"];
        sSendBubble2 = [image resizableImageWithCapInsets:UIEdgeInsetsMake(11, 12, 11, 12) resizingMode:UIImageResizingModeStretch];
    }
    return sSendBubble2;
}

static UIImage *sSendBubbleClicked;
+ (UIImage *)sendBubbleClicked
{
    if (!sSendBubbleClicked) {
        UIImage *image = [UIImage zegoImageNamed:@"send_bubble_clicked"];
        sSendBubbleClicked = [image resizableImageWithCapInsets:UIEdgeInsetsMake(11, 12, 11, 12) resizingMode:UIImageResizingModeStretch];
    }
    return sSendBubbleClicked;
}
@end
