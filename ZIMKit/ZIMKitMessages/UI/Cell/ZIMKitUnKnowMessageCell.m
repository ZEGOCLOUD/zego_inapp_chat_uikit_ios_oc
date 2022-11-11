//
//  ZIMKitUnKnowMessageCell.m
//  ZIMKit
//
//  Created by zego on 2022/7/26.
//

#import "ZIMKitUnKnowMessageCell.h"
#import "ZIMKitUnKnowMessage.h"
#import <YYText/YYText.h>
#import "UIView+ZIMKitLayout.h"

@interface ZIMKitUnKnowMessageCell ()

@property (nonatomic, strong) YYLabel  *yyLabel;
@property (nonatomic, strong) ZIMKitUnknowMessage *message;

@end

@implementation ZIMKitUnKnowMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _yyLabel = [[YYLabel alloc] init];
        _yyLabel.numberOfLines = 0;
        _yyLabel.textAlignment = NSTextAlignmentLeft;
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

- (void)fillWithMessage:(ZIMKitUnknowMessage *)message {
    [super fillWithMessage:message];
    
    self.message = message;
    self.yyLabel.textColor = [self.message.cellConfig messageTextColor];
    self.yyLabel.text = self.message.message;
}

@end
