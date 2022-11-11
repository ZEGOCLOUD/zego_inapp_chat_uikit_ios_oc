//
//  ZIMKitInputBar.h
//  ZIMKit
//
//  Created by zego on 2022/6/1.
//

#import <UIKit/UIKit.h>
#import "ZIMKitInputTextView.h"

typedef enum {
    Kit_Emotion,
    Kit_Keyboard,
    Kit_Function,
    Kit_VoiceInput,
    Kit_Default,// input box
} ZIMKitInputKeyboardType;//Input box keyboard type

typedef enum {
    ZIMKitKeyboardStatus_Emotion,
    ZIMKitKeyboardStatus_Keyboard,
    ZIMKitKeyboardStatus_Function,
    ZIMKitKeyboardStatus_None,
} ZIMKitKeyboardStatusType;

typedef enum {
    KitVoiceControlTouch_down,
    KitVoiceControlTouch_upInside,
    KitVoiceControlTouch_outInside,
    KitVoiceControlTouch_DragInside,
    KitVoiceControlTouch_DragOutside,
} KitVoiceControlTouchType;

@class ZIMKitInputBar;
@protocol ZIMKitInputBarDelegate <NSObject>

/// Voice/keyboard button click
- (void)inputViewVoiceButtonClick:(ZIMKitInputKeyboardType)type;

/// Emo/keyboard button click
- (void)inputViewEmotionButtonClick:(ZIMKitInputKeyboardType)type;

/// func/keyboard button click
- (void)inputViewFunctionButtonClick:(ZIMKitInputKeyboardType)type;

/// InputView text Changed
- (void)inputViewTextDidChange:(ZIMKitInputBar *_Nullable)inputToolBar deleteChar:(BOOL)isDeleteChar;

- (void)inputViewDeleteBackward:(ZIMKitInputBar *_Nullable)inputToolBar;

///voice touch type
- (void)voiceControlTouchType:(KitVoiceControlTouchType)touchType;

- (void)sendMessageAction:(NSString *_Nullable)text;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitInputBar : UIView <ZIMKitInputBarDelegate>

@property (nonatomic, weak) id<ZIMKitInputBarDelegate>delegate;

@property (nonatomic, strong) ZIMKitInputTextView *inputTextView;

@property (nonatomic, strong) UIButton  *voiceButton;

@property (nonatomic, strong) UIButton  *voiceControl;

@property (nonatomic, strong) UIButton *emotionButton;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) UIButton  *funcButton;

@property (nonatomic, assign) ZIMKitInputKeyboardType  inputKBType;

- (void)reSetEmotionAndFuction;

- (void)changeInputBarbackgroundColor;

- (void)updateButtonEnabled:(BOOL)enabled;
@end

NS_ASSUME_NONNULL_END
