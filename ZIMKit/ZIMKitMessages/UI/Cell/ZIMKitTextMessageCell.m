//
//  ZIMKitTextMessageCell.m
//  ZIMKit
//
//  Created by zego on 2022/5/28.
//

#import "ZIMKitTextMessageCell.h"
#import "UIView+ZIMKitLayout.h"

@interface ZIMKitTextMessageCell ()
@property (nonatomic, strong) ZIMKitTextMessage *message;
@end

@implementation ZIMKitTextMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _yyLabel = [[YYLabel alloc] init];
        _yyLabel.numberOfLines = 0;
        _yyLabel.textAlignment = NSTextAlignmentLeft;
        ///NSLineBreakByTruncatingMiddle There is a problem with other value input expressions
        _yyLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _yyLabel.backgroundColor = [UIColor clearColor];
        [_yyLabel setFont:[UIFont systemFontOfSize:[ZIMKitMessageCellConfig messageTextFontSize]]];
        _yyLabel.numberOfLines = 0;
        _yyLabel.textContainerInset = UIEdgeInsetsZero;
        [self.bubbleView addSubview:_yyLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIEdgeInsets edge = [self.message.cellConfig contentViewInsets];
    _yyLabel.frame = CGRectMake(edge.left, edge.top, self.bubbleView.width - edge.left * 2, self.bubbleView.height - edge.top * 2);
}

- (void)fillWithMessage:(ZIMKitTextMessage *)message {
    [super fillWithMessage:message];
    
    self.message = message;
    self.yyLabel.textColor = [self.message.cellConfig messageTextColor];
    self.yyLabel.text = message.message;
}

@end
