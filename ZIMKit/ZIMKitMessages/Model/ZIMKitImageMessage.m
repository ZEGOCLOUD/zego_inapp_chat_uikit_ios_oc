//
//  ZIMKitImageMessage.m
//  ZIMKit
//
//  Created by zego on 2022/7/18.
//

#import "ZIMKitImageMessage.h"
#import "ZIMKitDefine.h"

@implementation ZIMKitImageMessage

- (void)fromZIMMessage:(ZIMImageMessage *)message {
    [super fromZIMMessage:message];
    self.thumbnailDownloadUrl = message.thumbnailDownloadUrl;
    self.thumbnailLocalPath = message.thumbnailLocalPath;
    self.largeImageDownloadUrl = message.largeImageDownloadUrl;
    self.largeImageLocalPath = message.largeImageLocalPath;
    self.originalImageSize = message.originalImageSize;
    self.largeImageSize = message.largeImageSize;
    self.thumbnailSize = CGSizeEqualToSize(message.thumbnailSize, CGSizeZero ) ? self.thumbnailSize : message.thumbnailSize;
}

- (ZIMImageMessage *)toZIMIMageMessageModel {
    ZIMImageMessage *imageMessage = [[ZIMImageMessage alloc] init];
    imageMessage.largeImageDownloadUrl = self.largeImageDownloadUrl;
    imageMessage.thumbnailDownloadUrl = self.thumbnailDownloadUrl;
    imageMessage.fileLocalPath = self.fileLocalPath;
    imageMessage.fileDownloadUrl = self.fileDownloadUrl;
    return imageMessage;
}

- (instancetype)initWithFileLocalPath:(NSString *)fileLocalPath {
    ZIMKitImageMessage *imageMsg = [[ZIMKitImageMessage alloc] init];
    imageMsg.type = ZIMMessageTypeImage;
    imageMsg.fileLocalPath = fileLocalPath;
    imageMsg.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    return imageMsg;
}

- (CGSize)contentSize {
    CGSize size = [super contentSize];
    
    size = [self getSizeImage:self.thumbnailSize.width h:self.thumbnailSize.height];
    return size;
}

@end
