//
//  ZIMKitVideoMessage.h
//  ZIMKit_OC
//
//  Created by zego on 2022/8/25.
//

#import "ZIMKitMediaMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitVideoMessage : ZIMKitMediaMessage

@property (nonatomic, assign) unsigned int videoDuration;

@property (nonatomic, copy) NSString *videoFirstFrameDownloadUrl;

@property (nonatomic, copy) NSString *videoFirstFrameLocalPath;

@property (nonatomic, assign) CGSize videoFirstFrameSize;

- (instancetype)initWithFileLocalPath:(NSString *)fileLocalPath
                        audioDuration:(unsigned int)videoDuration;

- (ZIMVideoMessage *)toZIMVideoMessageModel;
@end

NS_ASSUME_NONNULL_END
