//
//  ZIMKitMessageTool.h
//  ZIMKit
//
//  Created by zego on 2022/5/25.
//

#import <Foundation/Foundation.h>
#import "ZIMKitMessage.h"
#import "ZIMKitTextMessage.h"
#import "ZIMKitImageMessage.h"
#import "ZIMKitAudioMessage.h"
#import "ZIMKitVideoMessage.h"
#import "ZIMKitFileMessage.h"
#import "ZIMKitUnknowMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitMessageTool : NSObject

+ (ZIMMessage *)fromZIMKitMessageConvert:(ZIMKitMessage *)message;

+ (ZIMKitMessage *)fromZIMMessageConvert:(ZIMMessage *)message;

+ (ZIMKitMessage *)fromZIMMessageUpdate:(ZIMMessage *)message originMsg:(ZIMKitMessage *)originMsg;
@end

NS_ASSUME_NONNULL_END
