//
//  ZIMKitMessageSendToolbar.m
//  ZIMKit
//
//  Created by zego on 2022/8/11.
//

#import "ZIMKitMessageSendToolbar.h"
#import "ZIMKitDefine.h"
#import "NSString+ZIMKitUtil.h"
#import "ZIMKitRecordView.h"
#import "ZIMKitTool.h"
#import "ZIMKitVoiceRecorder.h"
#import "ZIMKitChatTostView.h"
#import <AVFoundation/AVFoundation.h>

@interface ZIMKitMessageSendToolbar ()<ZIMKitInputBarDelegate, ZIMKitFaceManagerViewDelegate, ZIMKitChatBarMoreViewDelegate,ZIMKitVoiceRecorderDelegate, ZIMKitMultiChooseViewDelegate>

/// Keyboard rect
@property (nonatomic, assign) CGRect                keyboardRect;

///show keyboard
@property (nonatomic, assign) BOOL                  isShowKeybord;

/// keyboard animation duratioin
@property (nonatomic, assign) double                animationDuration;

/// Keyboard status type
@property (nonatomic, assign) ZIMKitKeyboardStatusType type;

/// super view
@property (nonatomic, strong) UIView                *fatherView;

/// Record view
@property (nonatomic, strong) ZIMKitRecordView      *recordView;
@property (nonatomic, strong) ZIMKitVoiceRecorder   *recorder;
@end

@implementation ZIMKitMessageSendToolbar

- (instancetype)initWithSuperView:(UIView *)fatherView {
    self = [super init];
    if (self) {
        _fatherView = fatherView;
        [self.fatherView addSubview:self.inputBar];
        [self addObserver];
    }
    return self;
}

- (void)addObserver {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    self.keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.isShowKeybord = YES;
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    self.keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.isShowKeybord = NO;
}

- (void)keyboardChange:(NSNotification *)notification
{
    if ([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y < CGRectGetHeight(self.fatherView.frame)) {
        [self keyboardWithMessageRect:[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                        inputViewRect:self.inputBar.frame
                             duration:self.animationDuration
                                state:ZIMKitKeyboardStatus_Keyboard];
        self.type = ZIMKitKeyboardStatus_Keyboard;
    } else {
        if (self.isShowKeybord) {
            if (self.type == ZIMKitKeyboardStatus_Keyboard) {
                CGRect finalRect = CGRectZero;
                
                if (self.inputBar.inputKBType == Kit_Emotion) {
                    finalRect = self.faceKeyBoard.bounds;
                }else if (self.inputBar.inputKBType == Kit_Function) {
                    finalRect = self.moreFunctionView.bounds;
                }
                
                [self keyboardWithMessageRect:finalRect
                                inputViewRect:self.inputBar.frame
                                     duration:self.animationDuration
                                        state:ZIMKitKeyboardStatus_None];
                self.type = ZIMKitKeyboardStatus_None;
            }
        }
    }
}

- (void)hiddeKeyborad
{
    if ([self.inputBar.inputTextView.internalTextView isFirstResponder] || self.type == ZIMKitKeyboardStatus_Keyboard) {
        self.inputBar.inputKBType = Kit_Keyboard;
        [self.inputBar.inputTextView.internalTextView resignFirstResponder];
        
        [self keyboardWithMessageRect:CGRectZero
                        inputViewRect:self.inputBar.bounds
                             duration:self.animationDuration != 0?self.animationDuration:0.25
                                state:ZIMKitKeyboardStatus_None];
    }
    
    if (self.type  == ZIMKitKeyboardStatus_Emotion || self.type == ZIMKitKeyboardStatus_Function) {
        [self keyboardWithMessageRect:CGRectZero
                        inputViewRect:self.inputBar.bounds
                             duration:self.animationDuration != 0?self.animationDuration:0.25
                                state:ZIMKitKeyboardStatus_None];
    }
    
    self.type = ZIMKitKeyboardStatus_None;
    [self.inputBar reSetEmotionAndFuction];
}

- (void)willResignActive:(NSNotification *)noti {
    [self cancelVoiceRecorder];
}
#pragma mark ZIMKitInputBarDelegate
//voice
- (void)inputViewVoiceButtonClick:(ZIMKitInputKeyboardType)type {
    if(type == Kit_VoiceInput) {
        [self keyboardWithMessageRect:CGRectZero
                        inputViewRect:self.inputBar.frame
                             duration:self.animationDuration != 0?self.animationDuration:0.25 state:ZIMKitKeyboardStatus_None];
        self.type = ZIMKitKeyboardStatus_None;
    } else {
        [self keyboardWithMessageRect:self.keyboardRect
                        inputViewRect:self.inputBar.frame
                             duration:self.animationDuration != 0?self.animationDuration:0.25 state:ZIMKitKeyboardStatus_Keyboard];
        self.type = ZIMKitKeyboardStatus_Keyboard;
    }
}

// Emo/Keyboard
- (void)inputViewEmotionButtonClick:(ZIMKitInputKeyboardType)type {
    self.faceKeyBoard.hidden = NO;
    if (type == Kit_Keyboard) {
        [self keyboardWithMessageRect:self.keyboardRect
                        inputViewRect:self.inputBar.frame
                             duration:self.animationDuration
                                state:ZIMKitKeyboardStatus_Keyboard];
        self.type = ZIMKitKeyboardStatus_Keyboard;
    }else{
        [self keyboardWithMessageRect:self.faceKeyBoard.frame
                        inputViewRect:self.inputBar.frame
                             duration:self.animationDuration != 0?self.animationDuration:0.25 state:ZIMKitKeyboardStatus_Emotion];
        self.type = ZIMKitKeyboardStatus_Emotion;
    }
}

// Function/Keyboard
- (void)inputViewFunctionButtonClick:(ZIMKitInputKeyboardType)type {
    if (type == Kit_Keyboard) {
        [self keyboardWithMessageRect:self.keyboardRect
                        inputViewRect:self.inputBar.frame
                             duration:self.animationDuration
                                state:ZIMKitKeyboardStatus_Keyboard];
        self.type = ZIMKitKeyboardStatus_Keyboard;
    } else {
        [self keyboardWithMessageRect:self.moreFunctionView.frame
                        inputViewRect:self.inputBar.frame
                             duration:self.animationDuration != 0 ? self.animationDuration:0.25 state:ZIMKitKeyboardStatus_Function];
        self.type = ZIMKitKeyboardStatus_Function;
    }
}
//voice touchtype
- (void)voiceControlTouchType:(KitVoiceControlTouchType)touchType {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIMenuControllerWillHideMenuNotification object:nil];
    
    if (touchType == KitVoiceControlTouch_down) {
        AVAudioSessionRecordPermission permission = AVAudioSession.sharedInstance.recordPermission;
        if (permission == AVAudioSessionRecordPermissionDenied ||
            permission == AVAudioSessionRecordPermissionUndetermined) {
            [AVAudioSession.sharedInstance requestRecordPermission:^(BOOL granted) {
                if (!granted) {
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_micphone_permission_title"] message:[NSBundle ZIMKitlocalizedStringForKey:@"message_micphone_permission_desc"] preferredStyle:UIAlertControllerStyleAlert];
                    [ac addAction:[UIAlertAction actionWithTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_access_later"] style:UIAlertActionStyleCancel handler:nil]];
                    [ac addAction:[UIAlertAction actionWithTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_go_setting"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        UIApplication *app = [UIApplication sharedApplication];
                        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([app canOpenURL:settingsURL]) {
                            [app openURL:settingsURL];
                        }
                    }]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[ZIMKitTool currentViewController] presentViewController:ac animated:YES completion:nil];
                    });
                }
            }];
            return;
        }
        
        if(permission == AVAudioSessionRecordPermissionGranted){
            [ZIMKitTool.kit_keyWindow addSubview:self.recordView];
            [self.recordView setStatus:ZIMKitRecord_Status_Recording];
            [self.recorder startRecord];
        }
    } else if (touchType == KitVoiceControlTouch_DragInside ) {
        [self.recordView setStatus:ZIMKitRecord_Status_Recording];
        
    } else if (touchType == KitVoiceControlTouch_DragOutside) {
       [self.recordView setStatus:ZIMKitRecord_Status_Cancel];
        
   } else if (touchType == KitVoiceControlTouch_outInside) {
       [self cancelVoiceRecorder];
       
    } else if (touchType == KitVoiceControlTouch_upInside) {
        if (AVAudioSession.sharedInstance.recordPermission == AVAudioSessionRecordPermissionDenied ||
            AVAudioSession.sharedInstance.recordPermission == AVAudioSessionRecordPermissionUndetermined) {
            [self cancelVoiceRecorder];
            return;
        }
        
        NSTimeInterval interval = [self.recorder getVoiceCurrentTime];
        if (interval == 0) {
            [self cancelVoiceRecorder];
        } else if(interval < 1 && interval > 0) {
            [self cancelVoiceRecorder];
            [[ZIMKitTool kit_keyWindow] showToast:[[ZIMKitChatTostView alloc] initWithFrame:CGRectMake(0, 0, 130, 130) icon:[UIImage zegoImageNamed:@"chat_message_abnormal_icon"] text:[NSBundle ZIMKitlocalizedStringForKey:@"message_voice_record_too_short"]]];
        } else if(interval > ZIMKitAudioMessageTimeLength) {
            [self cancelVoiceRecorder];
        } else{
            NSString *path = [self.recorder getVoiceCurrentpath];
            [self cancelVoiceRecorder];
            if (path) {
                if(self.delegate && [self.delegate respondsToSelector:@selector(messageToolbarDidSendVoice:duration:)]) {
                    [self.delegate messageToolbarDidSendVoice:path duration:(int)interval];
                }
            }
        }
    }
}

- (void)cancelVoiceRecorder {
    [self.recorder stopRecord];
    [self.recordView removeFromSuperview];
    _recordView = nil;
    
    [self.inputBar changeInputBarbackgroundColor];
    [self.inputBar updateButtonEnabled:YES];
}

- (void)switchMessageToolbarMultiChoose:(BOOL)isMultiChoose {
    if (isMultiChoose) {
        [self.fatherView addSubview:self.multiChooseView];
        self.inputBar.hidden = YES;
    } else {
        if (_multiChooseView) {
            [_multiChooseView removeFromSuperview];
            _multiChooseView = nil;
        }
        self.inputBar.hidden = NO;
    }
}

#pragma mark ZIMKitVoiceRecorderDelegate
- (void)voiceRecorderPowerChange:(float)power {
    
}

- (void)voiceRecorderTimeLength:(NSTimeInterval)time {
    [self.recordView setRecordTimeL:time];
}

- (void)voiceRecorderDidEnd:(NSString *)path duration:(int)duration {
    [self.recordView removeFromSuperview];
    _recordView = nil;
    if (path) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(messageToolbarDidSendVoice:duration:)]) {
            [self.delegate messageToolbarDidSendVoice:path duration:(int)duration];
        }
    }
}

- (void)voiceRecorderDidBegin:(NSString *)path {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageToolbarVoiceRecorderDidBegin:)]) {
        [self.delegate messageToolbarVoiceRecorderDidBegin:path];
    }
}

#pragma mark ZIMKitMultiChooseViewDelegate
- (void)multiChooseDelete {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageToolbarMultiChooseDelete)]) {
        [self.delegate messageToolbarMultiChooseDelete];
    }
}

#pragma mark private
- (void)keyboardWithMessageRect:(CGRect)rect inputViewRect:(CGRect)inputViewRect duration:(double)duration state:(ZIMKitKeyboardStatusType)state {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIMenuControllerWillHideMenuNotification object:nil];
    [UIView animateWithDuration:duration animations:^
     {
         CGRect keyboardRect = rect;
         CGRect inputRect = inputViewRect;
         switch (state)
         {
             case ZIMKitKeyboardStatus_Emotion:
             {
                 if (Bottom_SafeHeight) {
                     inputRect.size.height = ZIMKitChatToolBarHeight;
                 }
                 self.faceKeyBoard.frame = CGRectMake(0.0f, CGRectGetHeight(self.fatherView.frame) - CGRectGetHeight(rect), CGRectGetWidth(self.fatherView.frame), CGRectGetHeight(rect));
                 self.moreFunctionView.frame = CGRectMake(0.0f, CGRectGetHeight(self.fatherView.frame) + Bottom_SafeHeight, CGRectGetWidth(self.fatherView.frame), CGRectGetHeight(self.moreFunctionView.frame));
             }
                 break;
             case ZIMKitKeyboardStatus_Keyboard://系统键盘
             {
                 if (Bottom_SafeHeight) {
                     inputRect.size.height = ZIMKitChatToolBarHeight;
                 }
                 self.faceKeyBoard.frame = CGRectMake(0.0f, CGRectGetHeight(self.fatherView.frame) + Bottom_SafeHeight, CGRectGetWidth(self.fatherView.frame), CGRectGetHeight(self.faceKeyBoard.frame));
                 self.moreFunctionView.frame = CGRectMake(0.0f, CGRectGetHeight(self.fatherView.frame), CGRectGetWidth(self.fatherView.frame), CGRectGetHeight(self.moreFunctionView.frame));
             }
                 break;
             case ZIMKitKeyboardStatus_Function:
             {
                 if (Bottom_SafeHeight) {
                     inputRect.size.height = ZIMKitChatToolBarHeight;
                 }
                 self.moreFunctionView.frame = CGRectMake(0.0f, CGRectGetHeight(self.fatherView.frame) - CGRectGetHeight(rect), CGRectGetWidth(self.fatherView.frame), CGRectGetHeight(rect));
                 
                 self.faceKeyBoard.frame = CGRectMake(0.0f, CGRectGetHeight(self.fatherView.frame) + Bottom_SafeHeight, CGRectGetWidth(self.fatherView.frame), CGRectGetHeight(self.faceKeyBoard.frame));
             }
                 break;
                 
             case ZIMKitKeyboardStatus_None:
             {
                 if (Bottom_SafeHeight) {
                     inputRect.size.height = ZIMKitChatToolBarHeight +Bottom_SafeHeight;
                 }
                 self.faceKeyBoard.frame = CGRectMake(0.0f, CGRectGetHeight(self.fatherView.frame) + Bottom_SafeHeight, CGRectGetWidth(self.fatherView.frame), CGRectGetHeight(self.faceKeyBoard.frame));
                 self.moreFunctionView.frame = CGRectMake(0.0f, CGRectGetHeight(self.fatherView.frame) + Bottom_SafeHeight, CGRectGetWidth(self.fatherView.frame), CGRectGetHeight(self.moreFunctionView.frame));
             }
                 break;
             default:
                 break;
         }
         
        self.inputBar.frame = CGRectMake(0.0f,
                                         CGRectGetHeight(self.fatherView.frame)-CGRectGetHeight(keyboardRect)-CGRectGetHeight(inputRect),
                                         CGRectGetWidth(self.fatherView.frame),
                                         CGRectGetHeight(inputRect));
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageToolbarInputFrameChange)]) {
            [self.delegate messageToolbarInputFrameChange];
        }
     } completion:^(BOOL finished) {
     }];
}

- (void)sendMessageAction:(NSString *)text {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageToolbarSendTextMessage:)]) {
        [self.delegate messageToolbarSendTextMessage:text];
    }
}

#pragma mark ZIMKitFaceManagerViewDelegate
- (void)didSelectItem:(NSString *_Nullable)emojiString {
    NSString *content = [NSString stringWithFormat:@"%@", self.inputBar.inputTextView.text];
    NSMutableString *muContent = [NSMutableString stringWithString:content];
    NSRange range = self.inputBar.inputTextView.selectedRange;
    [muContent insertString:emojiString atIndex:range.location];
    self.inputBar.inputTextView.text = muContent;
    //Record the position. The user may move the cursor to a certain position and input the expression
    self.inputBar.inputTextView.selectedRange = NSMakeRange(range.location+emojiString.length, 0);
}

- (void)deleteInputItemAction {
    [self.inputBar.inputTextView.internalTextView deleteBackward];
}

#pragma mark ZIMKitChatBarMoreViewDelegate
- (void)didSelectedMoreViewItemAction:(ZIMKitFunctionType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageToolbarDidSelectedMoreViewItemAction:)]) {
        [self.delegate messageToolbarDidSelectedMoreViewItemAction:type];
    }
}

#pragma mark lazy
- (ZIMKitInputBar *)inputBar {
    if (!_inputBar) {
        _inputBar = [[ZIMKitInputBar alloc] initWithFrame:CGRectMake(0, self.fatherView.height - ZIMKitChatToolBarHeight-Bottom_SafeHeight, self.fatherView.width, ZIMKitChatToolBarHeight+Bottom_SafeHeight)];
        _inputBar.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
        _inputBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _inputBar.delegate = self;
    }
    return _inputBar;
}

- (ZIMKitFaceManagerView *)faceKeyBoard {
    if (!_faceKeyBoard) {
        _faceKeyBoard = [[ZIMKitFaceManagerView alloc] initWithFrame:CGRectMake(0.0f, self.fatherView.bounds.size.height + Bottom_SafeHeight, CGRectGetWidth(self.fatherView.frame), kMessageFaceViewHeight)];
        _faceKeyBoard.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        _faceKeyBoard.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
        _faceKeyBoard.delegate = self;
        [self.fatherView addSubview:_faceKeyBoard];
    }
    return _faceKeyBoard;
}

- (ZIMKitChatBarMoreView *)moreFunctionView {
    if (!_moreFunctionView) {
        _moreFunctionView = [[ZIMKitChatBarMoreView alloc] initWithFrame:CGRectMake(0.0f, self.fatherView.bounds.size.height + Bottom_SafeHeight, CGRectGetWidth(self.fatherView.frame), kChatBarMoreView)];
        _moreFunctionView.delegate = self;
        _moreFunctionView.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
        [self.fatherView addSubview:_moreFunctionView];
    }
    
    return _moreFunctionView;
}

- (ZIMKitVoiceRecorder *)recorder {
    if (!_recorder) {
        _recorder = [[ZIMKitVoiceRecorder alloc] init];
        _recorder.delegate = self;
    }
    return _recorder;
}

- (ZIMKitRecordView *)recordView {
    if (!_recordView) {
        CGRect rect = [ZIMKitTool kit_keyWindow].bounds;
        _recordView = [[ZIMKitRecordView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - ZIMKitChatToolBarHeight-Bottom_SafeHeight)];
    }
    return _recordView;
}

- (ZIMKitMultiChooseView *)multiChooseView {
    if (!_multiChooseView) {
        _multiChooseView = [[ZIMKitMultiChooseView alloc] initWithFrame:CGRectMake(0, self.fatherView.height - ZIMKitChatToolBarHeight-Bottom_SafeHeight, self.fatherView.width, ZIMKitChatToolBarHeight+Bottom_SafeHeight)];
        _multiChooseView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _multiChooseView.delegate = self;
    }
    return _multiChooseView;
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

}

- (void)dealloc {
    [self removeObserver];
}

@end
