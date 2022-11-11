//
//  ZIMKitBubbleMessageCell.m
//  ZIMKit
//
//  Created by zego on 2022/5/28.
//

#import "ZIMKitBubbleMessageCell.h"
#import "UIView+ZIMKitLayout.h"


@interface ZIMKitBubbleMessageCell ()
@property (nonatomic, strong) ZIMKitMessage *message;
@end

@implementation ZIMKitBubbleMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bubbleView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bubbleView.userInteractionEnabled = true;
        [self.containerView addSubview:_bubbleView];
        _bubbleView.x = 0;
        _bubbleView.y = 0;
        _bubbleView.width = self.containerView.width;
        _bubbleView.height =  self.containerView.height;
        _bubbleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bubbleView.x = 0;
    _bubbleView.y = 0;
    _bubbleView.width = self.containerView.width;
    _bubbleView.height =  self.containerView.height;
}

- (void)fillWithMessage:(ZIMKitMessage *)message  {
    [super fillWithMessage:message];
    
    if (message.direction == ZIMMessageDirectionSend && message.type != ZIMMessageTypeFile) {
        _bubbleView.image = [ZIMKitMessageCellConfig sendBubble];
    } else {
        _bubbleView.image = [ZIMKitMessageCellConfig receiveBubble];
    }
}

@end
