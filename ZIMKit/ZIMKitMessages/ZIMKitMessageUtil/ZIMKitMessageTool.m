//
//  ZIMKitMessageTool.m
//  ZIMKit
//
//  Created by zego on 2022/5/25.
//

#import "ZIMKitMessageTool.h"
#import "ZIMKitManager.h"


@implementation ZIMKitMessageTool

+ (ZIMMessage *)fromZIMKitMessageConvert:(ZIMKitMessage *)message {
    ZIMMessage *msg;
    if (message.type == ZIMMessageTypeText) {
        ZIMKitTextMessage *textMessage =  (ZIMKitTextMessage *)message;
        msg = [textMessage toZIMTextMessageModel];
    } else if (message.type == ZIMMessageTypeImage) {
        ZIMKitImageMessage *imageMessage = (ZIMKitImageMessage *)message;
        msg = [imageMessage toZIMIMageMessageModel];
    } else if (message.type == ZIMMessageTypeAudio) {
        ZIMKitAudioMessage *audioMessage = (ZIMKitAudioMessage *)message;
        msg = [audioMessage toZIMAudioMessageModel];
    } else if (message.type == ZIMMessageTypeVideo) {
        ZIMKitVideoMessage *videoMessage = (ZIMKitVideoMessage *)message;
        msg = [videoMessage toZIMVideoMessageModel];
    } else if (message.type == ZIMMessageTypeFile) {
        ZIMKitFileMessage *fileMessage = (ZIMKitFileMessage *)message;
        msg = [fileMessage toZIMFileMessageModel];
    }
    message.zimMsg = msg;
    
    return msg;
}

+ (ZIMKitMessage *)fromZIMMessageConvert:(ZIMMessage *)message {
    ZIMKitMessage *msg ;
    if (message.type == ZIMMessageTypeText) {
        msg = [[ZIMKitTextMessage alloc] init];
        [msg fromZIMMessage:message];
    } else if (message.type == ZIMMessageTypeImage) {
        msg = [[ZIMKitImageMessage alloc] init];
        [msg fromZIMMessage:message];
    } else if (message.type == ZIMMessageTypeAudio) {
        msg = [[ZIMKitAudioMessage alloc] init];
        [msg fromZIMMessage:message];
    } else if (message.type == ZIMMessageTypeVideo) {
        msg = [[ZIMKitVideoMessage alloc] init];
        [msg fromZIMMessage:message];
    } else if (message.type == ZIMMessageTypeFile) {
        msg = [[ZIMKitFileMessage alloc] init];
        [msg fromZIMMessage:message];
    } else {
        msg = [[ZIMKitUnknowMessage alloc] init];
        [msg fromZIMMessage:message];
        msg.type = ZIMMessageTypeUnknown;
    }
    
    return msg;
}

+ (ZIMKitMessage *)fromZIMMessageUpdate:(ZIMMessage *)message originMsg:(ZIMKitMessage *)originMsg {
    [originMsg fromZIMMessage:message];
    return originMsg;
}

+ (NSString *)getCurrentMediaLocalPath:(ZIMKitMediaMessage *)message {
    NSString *mediaLocalPath;
    
    NSString *filepath = message.fileLocalPath;
    if (message.direction == ZIMMessageDirectionSend && filepath.length) {
        NSString *tempath;
        if (message.type == ZIMMessageTypeVideo) {
            tempath = [[ZIMKitManager shared].getVideoPath stringByAppendingPathComponent:filepath.lastPathComponent];
        } else if (message.type == ZIMMessageTypeAudio) {
            tempath = [[ZIMKitManager shared].getVoicePath stringByAppendingPathComponent:filepath.lastPathComponent];
        } else if (message.type == ZIMMessageTypeFile) {
            tempath = [[ZIMKitManager shared].getFilePath stringByAppendingPathComponent:filepath.lastPathComponent];
        } else if (message.type == ZIMMessageTypeImage) {
            tempath = [[ZIMKitManager shared].getImagepath stringByAppendingPathComponent:filepath.lastPathComponent];
        }
        BOOL isDirectory = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:tempath isDirectory:&isDirectory] && tempath.length) {
            mediaLocalPath = tempath;
        }
    }
    
    if (!mediaLocalPath && filepath.length) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
        NSString *libraryCaches = [paths objectAtIndex:0];
        NSArray *components = [filepath componentsSeparatedByString:@"Library/Caches/ZIMCaches"];
        NSString *sdkCaches = components.lastObject;
        filepath = [libraryCaches stringByAppendingPathComponent:sdkCaches];
        
        BOOL isDirectory = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filepath isDirectory:&isDirectory] && sdkCaches.length) {
            mediaLocalPath = filepath;
        }
    }
    
    return mediaLocalPath;
}

@end
