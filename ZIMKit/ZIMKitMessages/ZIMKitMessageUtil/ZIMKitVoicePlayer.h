//
//  ZIMKitVoicePlayer.h
//  ZIMKit_OC
//
//  Created by zego on 2022/8/31.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZIMKitVoicePlayerDelegate <NSObject>

- (void)voicePlayerFinish:(NSString *)path;

@end

@interface ZIMKitVoicePlayer : NSObject

@property (nonatomic, weak) id<ZIMKitVoicePlayerDelegate>delegate;

- (void)startPlay:(NSString *)path category:(AVAudioSessionCategory)category;

- (void)stopPlay ;

- (void)continuePlay;

- (void)pausePlay;
@end

NS_ASSUME_NONNULL_END
