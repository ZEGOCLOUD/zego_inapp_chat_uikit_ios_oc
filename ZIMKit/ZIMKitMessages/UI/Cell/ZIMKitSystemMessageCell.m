//
//  ZIMKitSystemMessageCell.m
//  ZIMKit
//
//  Created by zego on 2022/6/9.
//

#import "ZIMKitSystemMessageCell.h"
#import "NSString+ZIMKitUtil.h"
#import "ZIMKitDefine.h"

@interface ZIMKitSystemMessageCell ()

@property (nonatomic, strong) ZIMKitMessage *message;
@end

@implementation ZIMKitSystemMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _messageLabel = [[YYLabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:13];
        _messageLabel.textColor = [UIColor dynamicColor:ZIMKitHexColor(0xB8B8B8) lightColor:ZIMKitHexColor(0xB8B8B8)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.layer.cornerRadius = 3;
        [_messageLabel.layer setMasksToBounds:YES];
        [self.contentView addSubview:_messageLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor dynamicColor:ZIMKitHexColor(0xB8B8B8) lightColor:ZIMKitHexColor(0xB8B8B8)];
        [self.contentView addSubview:_timeLabel];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)fillWithMessage:(ZIMKitSystemMessage *)message {
    _message = message;
    
    _messageLabel.text = message.content;
    
    if (message.needShowTime) {
        _timeLabel.text = [NSString convertDateToStr:message.timestamp];
        _timeLabel.hidden = NO;
    } else {
        _timeLabel.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.message.needShowTime) {
        _timeLabel.hidden = NO;
        _timeLabel.x = ZIMKitMessageCell_Avatar_Screen_Margin;
        _timeLabel.y = 0;
        _timeLabel.width = Screen_Width - 2*ZIMKitMessageCell_Avatar_Screen_Margin;
        _timeLabel.height = ZIMKitMessageCell_Time_H;
    } else {
        _timeLabel.hidden = YES;
        _timeLabel.height = 0;
    }
    
    CGSize contentSize = [self.message contentSize];
    _messageLabel.frame = CGRectMake(ZIMKitMessageCell_Sys_Margin, _timeLabel.height+ ZIMKitMessageCell_Time_Avatar_Margin, contentSize.width, contentSize.height);
    _messageLabel.centerX = self.centerX;
}
@end
