//
//  ZIMKitAudioMessage.h
//  ZIMKit_OC
//
//  Created by zego on 2022/8/25.
//

#import "ZIMKitMediaMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitAudioMessage : ZIMKitMediaMessage

@property (nonatomic, assign) unsigned int audioDuration;

@property (nonatomic, assign) BOOL isPlaying;

- (instancetype)initWithFileLocalPath:(NSString *)fileLocalPath
                        audioDuration:(unsigned int)audioDuration;

- (ZIMAudioMessage *)toZIMAudioMessageModel;
@end

NS_ASSUME_NONNULL_END
