//
//  ZIMKitBubbleMessageCell.h
//  ZIMKit
//
//  Created by zego on 2022/5/28.
//

#import "ZIMKitMessageCell.h"
#import "ZIMKitMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitBubbleMessageCell : ZIMKitMessageCell

@property (nonatomic, strong) UIImageView *bubbleView;

- (void)fillWithMessage:(ZIMKitMessage *)message;

@end

NS_ASSUME_NONNULL_END
