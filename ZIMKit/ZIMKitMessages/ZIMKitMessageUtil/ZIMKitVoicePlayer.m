//
//  ZIMKitVoicePlayer.m
//  ZIMKit_OC
//
//  Created by zego on 2022/8/31.
//

#import "ZIMKitVoicePlayer.h"

@interface ZIMKitVoicePlayer ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer   *audioPlayer;
@property (nonatomic, assign) BOOL             isPlaying;

@end

@implementation ZIMKitVoicePlayer

- (instancetype)init {
    self = [super init];
    if (self) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    return self;
}

- (void)startPlay:(NSString *)path category:(AVAudioSessionCategory)category {
    if (self.isPlaying) {
        [self stopPlay];
        return;
    }
    self.isPlaying = YES;
    
    [[AVAudioSession sharedInstance] setCategory:category ? category : AVAudioSessionCategoryPlayback error:nil];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    self.audioPlayer.volume = 1.0;
    [self.audioPlayer play];
}

- (void)stopPlay {
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    self.isPlaying = NO;
}

- (void)continuePlay {
    if (self.audioPlayer) {
        [self.audioPlayer play];
    }
}

- (void)pausePlay {
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer pause];
    }
}

#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.isPlaying = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(voicePlayerFinish:)]) {
        [self.delegate voicePlayerFinish:player.url.path];
    }
}

@end
