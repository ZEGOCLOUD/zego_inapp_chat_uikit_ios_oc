//
//  ZIMKitAudioMessage.m
//  ZIMKit_OC
//
//  Created by zego on 2022/8/25.
//

#import "ZIMKitAudioMessage.h"
#import "ZIMKitDefine.h"

@implementation ZIMKitAudioMessage

- (void)fromZIMMessage:(ZIMAudioMessage *)message {
    [super fromZIMMessage:message];
    self.audioDuration = message.audioDuration;
}

- (ZIMAudioMessage *)toZIMAudioMessageModel {
    ZIMAudioMessage *audioMessage = [[ZIMAudioMessage alloc] init];
    audioMessage.fileLocalPath = self.fileLocalPath;
    audioMessage.audioDuration = self.audioDuration;
    audioMessage.fileDownloadUrl = self.fileDownloadUrl;
    return audioMessage;
}

- (instancetype)initWithFileLocalPath:(NSString *)fileLocalPath
                        audioDuration:(unsigned int)audioDuration {
    ZIMKitAudioMessage *message = [[ZIMKitAudioMessage alloc] init];
    message.type = ZIMMessageTypeAudio;
    message.fileLocalPath = fileLocalPath;
    message.audioDuration = audioDuration;
    message.timestamp = [[NSDate date] timeIntervalSince1970] *1000;
    return message;
}

- (CGSize)contentSize {
    CGSize size = [super contentSize];
    CGFloat width = ZIMKitAudioMessageCellMinW + self.audioDuration/60.0 * (ZIMKitAudioMessageCellMxaW - ZIMKitAudioMessageCellMinW);
    if (width > ZIMKitAudioMessageCellMxaW) {
        width = ZIMKitAudioMessageCellMxaW;
    }
    size.width = width;
    size.height = ZIMKitAudioMessageCellH;
    return size;
}
@end
