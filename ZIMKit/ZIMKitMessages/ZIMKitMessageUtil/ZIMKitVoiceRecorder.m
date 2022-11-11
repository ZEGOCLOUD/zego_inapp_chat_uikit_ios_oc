//
//  ZIMKitVoiceRecorder.m
//  ZIMKit_OC
//
//  Created by zego on 2022/8/31.
//

#import "ZIMKitVoiceRecorder.h"
#import "ZIMKitDefine.h"
#import "NSString+ZIMKitUtil.h"
#import "ZIMKitTool.h"
#import <AVFoundation/AVFoundation.h>

@interface ZIMKitVoiceRecorder ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder       *recorder;
@property (nonatomic, strong) NSTimer               *recordTimer;
@property (nonatomic, strong) NSDate                *recordStartTime;

@end

@implementation ZIMKitVoiceRecorder

- (void)startRecord
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [session setActive:YES error:&error];

    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                  
                                   [NSNumber numberWithInt: kAudioFormatMPEG4AAC],AVFormatIDKey,
                                  
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];

    NSString *path = [[ZIMKitManager shared].getVoicePath stringByAppendingPathComponent:[NSString getCurrentVoiceFileName:@"m4a"]];
    NSURL *url = [NSURL fileURLWithPath:path];
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:nil];
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
    _recorder.delegate = self;
    [_recorder record];
    [_recorder updateMeters];

    _recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(recordTimerAction:) userInfo:nil repeats:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRecorderDidBegin:)]) {
        [self.delegate voiceRecorderDidBegin:path];
    }
}

- (void)recordTimerAction:(NSTimer *)timer {
    [_recorder updateMeters];
    float power = [_recorder averagePowerForChannel:0];
    if(self.delegate && [self.delegate respondsToSelector:@selector(voiceRecorderPowerChange:)]) {
        [self.delegate voiceRecorderPowerChange:power];
    }
    
    NSTimeInterval interval = _recorder.currentTime;
    if(self.delegate && [self.delegate respondsToSelector:@selector(voiceRecorderTimeLength:)]) {
        [self.delegate voiceRecorderTimeLength:interval];
    }
    
    if(interval >= ZIMKitAudioMessageTimeLength) {
        NSString *path = _recorder.url.path;
        [self stopRecord];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(voiceRecorderDidEnd:duration:)]) {
            [self.delegate voiceRecorderDidEnd:path duration:(int)interval];
        }
    }
}

- (NSTimeInterval)getVoiceCurrentTime {
    return _recorder.currentTime;
}

- (NSString *)getVoiceCurrentpath {
    return _recorder.url.path;
}

- (void)stopRecord
{
    if(_recordTimer){
        [_recordTimer invalidate];
        _recordTimer = nil;
    }
    if([_recorder isRecording]){
        [_recorder stop];
    }
}

- (void)cancelRecord
{
    if(_recordTimer){
        [_recordTimer invalidate];
        _recordTimer = nil;
    }
    if([_recorder isRecording]){
        [_recorder stop];
    }
    NSString *path = _recorder.url.path;
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

@end
