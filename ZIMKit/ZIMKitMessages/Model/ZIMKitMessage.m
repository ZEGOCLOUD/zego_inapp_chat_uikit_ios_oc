//
//  ZIMKitMessage.m
//  ZIMKit
//
//  Created by zego on 2022/5/24.
//

#import "ZIMKitMessage.h"
#import "ZIMKitDefine.h"
#import <YYText/YYText.h>

@interface ZIMKitMessage ()

@end

@implementation ZIMKitMessage

- (void)fromZIMMessage:(ZIMMessage *)message {
    self.type = message.type;
    self.messageID = message.messageID;
    self.localMessageID = message.localMessageID;
    self.senderUserID = message.senderUserID;
    self.conversationID = message.conversationID;
    self.direction = message.direction;
    self.sentStatus = message.sentStatus;
    self.conversationType = message.conversationType;
    self.timestamp = message.timestamp;
    self.orderKey = message.orderKey;
    self.zimMsg = message;
    self.extendData = [NSString stringWithFormat:@"%d%0.0f", arc4random() % 10000,[[NSDate date] timeIntervalSince1970] *1000];
}

- (NSString *)reuseId {
    
    if (self.type == ZIMMessageTypeText) {
        return @"ZIMKitTextMessageCell";
    } else if (self.type == ZIMMessageTypeImage) {
        return @"ZIMKitImageMessageCell";
    } else if (self.type == ZIMMessageTypeAudio) {
        return @"ZIMKitAudioMessageCell";
    } else if (self.type == ZIMMessageTypeVideo) {
        return @"ZIMKitVideoMessageCell";
    } else if (self.type == ZIMMessageTypeFile) {
        return @"ZIMKitFileMessageCell";
    } else if (self.type == ZIMKitSystemMessageType) {
        return @"ZIMKitSystemMessageCell";
    } else {
        return @"ZIMKitUnKnowMessageCell";
    }
}

- (CGFloat)cellHeight {
    CGFloat height = 0;
    
    if (_cellHeight > 0) {
        height = _cellHeight;
    } else {
        if (self.needShowTime) {
            height += self.isLastTop ? ZIMKitMessageCell_Top_Time_H : ZIMKitMessageCell_Bottom_Time_H; //Height from time to top
            height += ZIMKitMessageCell_Time_H; // Time height
            height += ZIMKitMessageCell_Time_Avatar_Margin; // Time to avatar margin
        }

        if (self.needShowName) {
            height += ZIMKitMessageCell_Name_H; //Nickname height
        }
        
        CGSize size = [self contentSize]; // Content height
        
        height += size.height;
        height += [self.cellConfig contentViewInsets].top * 2; // Space between bubbles and content
        height += ZIMKitMessageCell_TO_Cell_Margin; // cell to cell margin
        
        if (height < ZIMKitMessageCell_Default_Height) {
            height = ZIMKitMessageCell_Default_Height;
        }
            
        _cellHeight = height;
    }
    return height;
}

- (CGFloat)resetCellHeight {
    CGFloat height = 0;
    
    if (self.needShowTime) {
        height += self.isLastTop ? ZIMKitMessageCell_Top_Time_H : ZIMKitMessageCell_Bottom_Time_H;
        height += ZIMKitMessageCell_Time_H;
        height += ZIMKitMessageCell_Time_Avatar_Margin;
    }

    if (self.needShowName) {
        height += ZIMKitMessageCell_Name_H;
    }
    
    CGSize size = [self contentSize];
    
    height += size.height;
    height += [self.cellConfig contentViewInsets].top * 2;
    
    if (height < ZIMKitMessageCell_Default_Height) {
        height = ZIMKitMessageCell_Default_Height;
    } else {
        height += ZIMKitMessageCell_TO_Cell_Margin;
    }
        
    _cellHeight = height;
    
    return height;
}

- (CGSize)contentSize {
    
    return CGSizeZero;
}

- (ZIMKitMessageCellConfig *)cellConfig {
    if (!_cellConfig) {
        _cellConfig = [[ZIMKitMessageCellConfig alloc] initWithMessage:self];
    }
    return _cellConfig;
}

- (BOOL)isNeedshowtime:(unsigned long long)timestamp {
    BOOL result = NO;
    result = (self.timestamp/1000.0 - timestamp/1000.0) > ZIMKitMaxTimeCellToCell;
    return result;
}

- (BOOL)needShowName {
    if (self.conversationType == ZIMConversationTypeGroup && self.direction == ZIMMessageDirectionReceive) {
        return YES;
    } else {
        return NO;
    }
}

- (CGSize)sizeAttributedWithFont:(UIFont *)font width:(CGFloat)width  wordWap:(NSLineBreakMode)lineBreadMode string:(NSString *)contentString {
    NSAttributedString *string = [self processCommentContentWithFont:font wordWap:lineBreadMode string:contentString];
    
    // YYTextLayout Calculation Height
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(width, MAXFLOAT)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:string];
    CGSize textSize = textLayout.textBoundingSize;
    CGFloat textWidth = textSize.width;
    CGFloat textHeight = textSize.height;

    return  CGSizeMake(ceil(textWidth), ceil(textHeight));
}

- (NSMutableAttributedString *)processCommentContentWithFont:(UIFont *)font wordWap:(NSLineBreakMode)lineBreadMode string:(NSString *)contentString {
    NSMutableAttributedString *mAttributedString = [[NSMutableAttributedString alloc]init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:2];
//    [paragraphStyle setParagraphSpacing:2];
    paragraphStyle.lineBreakMode = lineBreadMode;
    NSDictionary *attri = [NSDictionary dictionaryWithObjects:@[font, paragraphStyle] forKeys:@[NSFontAttributeName, NSParagraphStyleAttributeName]];
    [mAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:contentString attributes:attri]];
    return mAttributedString;
}
@end
