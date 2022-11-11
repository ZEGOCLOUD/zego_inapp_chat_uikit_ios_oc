//
//  ZIMKitVoiceRecorder.h
//  ZIMKit_OC
//
//  Created by zego on 2022/8/31.
//

#import <Foundation/Foundation.h>

@protocol ZIMKitVoiceRecorderDelegate <NSObject>

- (void)voiceRecorderPowerChange:(float)power;

- (void)voiceRecorderTimeLength:(NSTimeInterval)time;

- (void)voiceRecorderDidEnd:(NSString *_Nullable)path duration:(int)duration;

- (void)voiceRecorderDidBegin:(NSString *_Nullable)path;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitVoiceRecorder : NSObject

@property (nonatomic, weak) id<ZIMKitVoiceRecorderDelegate>delegate;

- (void)startRecord;
- (void)stopRecord;
- (void)cancelRecord;
- (NSTimeInterval)getVoiceCurrentTime;
- (NSString *)getVoiceCurrentpath;
@end

NS_ASSUME_NONNULL_END
