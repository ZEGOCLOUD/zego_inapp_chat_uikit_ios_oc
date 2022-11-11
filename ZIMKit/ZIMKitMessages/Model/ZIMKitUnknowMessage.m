//
//  ZIMKitUnknowMessage.m
//  ZIMKit
//
//  Created by zego on 2022/7/26.
//

#import "ZIMKitUnknowMessage.h"
#import "ZIMKitDefine.h"

@implementation ZIMKitUnknowMessage

- (void)fromZIMMessage:(ZIMTextMessage *)message {
    [super fromZIMMessage:message];
    self.message = [NSBundle ZIMKitlocalizedStringForKey:@"message_unknow_text"];
}

- (CGSize)contentSize {
    CGSize size = [super contentSize];
    
    size = [self sizeAttributedWithFont:[UIFont systemFontOfSize:[ZIMKitMessageCellConfig messageTextFontSize]] width:ZIMKitMessageCell_Text_MaxW wordWap:NSLineBreakByCharWrapping string:self.message];
    
    return size;
}

@end
