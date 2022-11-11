//
//  ZIMKitAudioMessageCell.h
//  ZIMKit_OC
//
//  Created by zego on 2022/8/30.
//

#import "ZIMKitBubbleMessageCell.h"

NS_ASSUME_NONNULL_BEGIN

@class ZIMKitAudioMessage;
@interface ZIMKitAudioMessageCell : ZIMKitBubbleMessageCell

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, assign) BOOL isBubbleViewPlaying;

@end

NS_ASSUME_NONNULL_END
