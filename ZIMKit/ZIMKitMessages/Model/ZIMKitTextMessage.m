//
//  ZIMKitTextMessage.m
//  ZIMKit
//
//  Created by zego on 2022/5/24.
//

#import "ZIMKitTextMessage.h"
#import "NSString+ZIMKitUtil.h"
#import "ZIMKitDefine.h"

@implementation ZIMKitTextMessage

- (instancetype)initWith:(NSString *)text {
    self = [super init];
    if (self) {
        self.message = text;
        self.type = ZIMMessageTypeText;
        self.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    }
    return self;
}

- (void)fromZIMMessage:(ZIMTextMessage *)message {
    [super fromZIMMessage:message];
    self.message = message.message;
}

- (ZIMTextMessage *)toZIMTextMessageModel {
    ZIMTextMessage *textMessage = [[ZIMTextMessage alloc] init];
    textMessage.message = self.message;
    return textMessage;
}

- (CGSize)contentSize {
    CGSize size = [super contentSize];
    
    size = [self sizeAttributedWithFont:[UIFont systemFontOfSize:[ZIMKitMessageCellConfig messageTextFontSize]] width:ZIMKitMessageCell_Text_MaxW wordWap:NSLineBreakByCharWrapping string:self.message];
    return size;
}
@end
