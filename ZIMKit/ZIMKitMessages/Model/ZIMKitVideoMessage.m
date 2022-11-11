//
//  ZIMKitVideoMessage.m
//  ZIMKit_OC
//
//  Created by zego on 2022/8/25.
//

#import "ZIMKitVideoMessage.h"
#import "ZIMKitDefine.h"

@implementation ZIMKitVideoMessage

- (instancetype)initWithFileLocalPath:(NSString *)fileLocalPath
                        audioDuration:(unsigned int)videoDuration {
    ZIMKitVideoMessage *message = [[ZIMKitVideoMessage alloc] init];
    message.type = ZIMMessageTypeVideo;
    message.fileLocalPath = fileLocalPath;
    message.videoDuration = videoDuration;
    message.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    return message;
}

- (void)fromZIMMessage:(ZIMVideoMessage *)message {
    [super fromZIMMessage:message];
    self.videoDuration = message.videoDuration;
    self.videoFirstFrameDownloadUrl = message.videoFirstFrameDownloadUrl;
    self.videoFirstFrameLocalPath = message.videoFirstFrameLocalPath.length ? message.videoFirstFrameLocalPath : self.videoFirstFrameLocalPath;
    //There is a problem with the w and h returned by the server for the first video frame, which may cause problems in both horizontal and vertical directions
    self.videoFirstFrameSize = CGSizeEqualToSize(self.videoFirstFrameSize, CGSizeZero) ? message.videoFirstFrameSize : self.videoFirstFrameSize;
}

- (ZIMVideoMessage *)toZIMVideoMessageModel {
    ZIMVideoMessage *videoMessage = [[ZIMVideoMessage alloc] initWithFileLocalPath:self.fileLocalPath videoDuration:self.videoDuration];
    return videoMessage;
}

- (CGSize)contentSize {
    CGSize size = [super contentSize];
    size = [self getSizeImage:self.videoFirstFrameSize.width h:self.videoFirstFrameSize.height];
    size.width = size.width ;
    size.height = size.height;
    return size;
}
@end
