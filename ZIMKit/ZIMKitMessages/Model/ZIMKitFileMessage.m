//
//  ZIMKitFileMessage.m
//  ZIMKit_OC
//
//  Created by zego on 2022/8/25.
//

#import "ZIMKitFileMessage.h"
#import "ZIMKitDefine.h"

@implementation ZIMKitFileMessage

- (void)fromZIMMessage:(ZIMFileMessage *)message {
    [super fromZIMMessage:message];
}

- (ZIMFileMessage *)toZIMFileMessageModel {
    ZIMFileMessage *fileMessage = [[ZIMFileMessage alloc] initWithFileLocalPath:self.fileLocalPath];
    return fileMessage;
}

- (instancetype)initWithFileLocalPath:(NSString *)fileLocalPath {
    ZIMKitFileMessage *message = [[ZIMKitFileMessage alloc] init];
    message.fileLocalPath = fileLocalPath;
    message.type = ZIMMessageTypeFile;
    message.fileName = fileLocalPath.lastPathComponent;
    message.fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:fileLocalPath error:nil].fileSize;
    message.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    return  message;
}

- (CGSize)contentSize {
    CGSize size = [super contentSize];
    return size = CGSizeMake(ZIMKitFileMessageCellW, ZIMKitFileMessageCellH);
}
@end
