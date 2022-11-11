//
//  ZIMKitInputBar.m
//  ZIMKit
//
//  Created by zego on 2022/6/1.
//

#import "ZIMKitInputBar.h"
#import "ZIMKitDefine.h"

#define ZIMKitFaceKeybordH 250
#define inputViewH 44
#define inputButtonH 34
#define inputMargin 12

@interface ZIMKitInputBar ()<ZIMKitInputTextViewDelegate>
/// 最右边的按钮为发送状态
@property (nonatomic, assign) BOOL isSend;

@end

@implementation ZIMKitInputBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupToolbar];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupToolbar];
    }
    return self;
}

- (void)setupToolbar {
    self.backgroundColor = self.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
    self.layer.shadowOffset = CGSizeMake(0, -2);
    self.layer.shadowColor = [[UIColor dynamicColor:ZIMKitHexColor(0x212329) lightColor:ZIMKitHexColor(0x212329)] colorWithAlphaComponent:0.04].CGColor;
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowRadius = 8.0;
    
    CGFloat buttonTop = (ZIMKitChatToolBarHeight - inputButtonH)*0.5;
    
    self.voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voiceButton.frame = CGRectMake(inputMargin, buttonTop, inputButtonH, inputButtonH);
    self.voiceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.voiceButton addTarget:self action:@selector(switchButtonClcick:) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceButton setImage:[UIImage zegoImageNamed:@"chat_face_voiceIcon"] forState:UIControlStateNormal];
    [self.voiceButton setImage:[UIImage zegoImageNamed:@"chat_face_keybordIcon"] forState:UIControlStateSelected];
    [self addSubview:self.voiceButton];
    
    self.voiceControl = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voiceControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.voiceControl.frame = CGRectMake(inputMargin*2+inputButtonH, (ZIMKitChatToolBarHeight - inputViewH)*0.5, (Screen_Width - inputMargin - inputButtonH*3 - inputMargin*4), inputViewH);
    self.voiceControl.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
    self.voiceControl.layer.masksToBounds = YES;
    self.voiceControl.layer.cornerRadius = 12;
    [self.voiceControl setTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_voice_touch_normal"] forState:UIControlStateNormal];
    [self.voiceControl setTitleColor:[UIColor dynamicColor:ZIMKitHexColor(0x2A2A2A) lightColor:ZIMKitHexColor(0x2A2A2A)] forState:UIControlStateNormal];
    self.voiceControl.titleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
    
    [self.voiceControl addTarget:self
                          action:@selector(voiceControlTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.voiceControl addTarget:self
                          action:@selector(voiceControlTouchDragInside:) forControlEvents:UIControlEventTouchDragEnter];
    [self.voiceControl addTarget:self
                          action:@selector(voiceControlTouchDragOutside:) forControlEvents:UIControlEventTouchDragExit];
    [self.voiceControl addTarget:self
                          action:@selector(voiceControlTouchUpInside:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.voiceControl addTarget:self
                          action:@selector(voiceControlTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:self.voiceControl];
    self.voiceControl.hidden = YES;
    
    self.inputTextView = [[ZIMKitInputTextView alloc] initWithFrame:CGRectMake(inputMargin*2+inputButtonH, (ZIMKitChatToolBarHeight - inputViewH)*0.5, (Screen_Width - inputMargin - inputButtonH*3 - inputMargin*4), inputViewH)];
    self.inputTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.inputTextView.delegate = self;
    self.inputTextView.layer.cornerRadius = 12.0;
    self.inputTextView.font = [UIFont systemFontOfSize:15];
    self.inputTextView.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xF2F2F2) lightColor:ZIMKitHexColor(0xF2F2F2)];
    [self addSubview:self.inputTextView];
    self.inputTextView.hidden = NO;
    
    self.emotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.emotionButton.frame = CGRectMake(self.bounds.size.width - inputButtonH*2 - inputMargin*2, buttonTop, inputButtonH, inputButtonH);
    self.emotionButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.emotionButton addTarget:self action:@selector(switchButtonClcick:) forControlEvents:UIControlEventTouchUpInside];
    [self.emotionButton setImage:[UIImage zegoImageNamed:@"chat_faceIcon"] forState:UIControlStateNormal];
    [self.emotionButton setImage:[UIImage zegoImageNamed:@"chat_face_keybordIcon"] forState:UIControlStateSelected];
    [self addSubview:self.emotionButton];
    
    self.funcButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.funcButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    self.funcButton.frame = CGRectMake(self.bounds.size.width - inputButtonH - inputMargin, buttonTop, inputButtonH, inputButtonH);
    [self.funcButton addTarget:self action:@selector(switchButtonClcick:) forControlEvents:UIControlEventTouchUpInside];
    [self.funcButton setImage:[UIImage zegoImageNamed:@"chat_face_functionIcon"] forState:UIControlStateNormal];
    [self.funcButton setImage:[UIImage zegoImageNamed:@"chat_face_functionIcon"] forState:UIControlStateSelected];
    [self addSubview:self.funcButton];
}

- (void)switchVoiceInput:(BOOL)hidden {
    self.voiceControl.hidden = hidden;
    self.inputTextView.hidden = !hidden;

    if (!hidden) {
        [self reSetEmotionAndFuction];
    }
    
    [self changeInputBarbackgroundColor];
}

- (void)switchButtonClcick:(UIButton *)switchButton {
    if (switchButton != self.funcButton) {
        self.funcButton.selected = NO;
    }
    
    if (switchButton != self.emotionButton) {
        self.emotionButton.selected = NO;
    }
    
    if (switchButton == self.voiceButton){//voice
        switchButton.selected  = !switchButton.isSelected;
        
        [self switchVoiceInput:!switchButton.selected];
        if (!switchButton.selected){//text
            [self.inputTextView.internalTextView becomeFirstResponder];
            
        }else{//voice input
            [self.inputTextView.internalTextView resignFirstResponder];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewVoiceButtonClick:)])
        {
            [self.delegate inputViewVoiceButtonClick:(switchButton.selected?Kit_VoiceInput:Kit_Default)];
        }
    } else if (switchButton == self.emotionButton) {
        self.emotionButton.selected = !self.emotionButton.isSelected;
        [self switchToTextInput];
        if (!self.emotionButton.selected) {//Keyboard
            self.inputKBType = Kit_Keyboard;
            [self.inputTextView.internalTextView becomeFirstResponder];
        } else {// emo
            self.inputKBType = Kit_Emotion;
            [self.inputTextView.internalTextView resignFirstResponder];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewEmotionButtonClick:)]) {
            [self.delegate inputViewEmotionButtonClick:self.emotionButton.selected ? Kit_Emotion : Kit_Keyboard];
        }
    } else {
        if (self.isSend) { //send message
            if (self.delegate && [self.delegate respondsToSelector:@selector(sendMessageAction:)]) {
                [self.delegate sendMessageAction:self.inputTextView.internalTextView.text];
                self.inputTextView.internalTextView.text = @"";
                [self changSendButtonIcon:NO];
                return;
            }
        }
        
        self.funcButton.selected = !self.funcButton.isSelected;
        [self switchToTextInput];
        if (!self.funcButton.selected) {// Keyboard
            self.inputKBType = Kit_Keyboard;
            [self.inputTextView.internalTextView becomeFirstResponder];
        } else {// emo
            self.inputKBType = Kit_Function;
            [self.inputTextView.internalTextView resignFirstResponder];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewFunctionButtonClick:)]) {// 功能点击
            [self.delegate inputViewFunctionButtonClick:self.funcButton.selected ? Kit_Function : Kit_Keyboard];
        }
    }
}
    
- (void)changSendButtonIcon:(BOOL)isSend {
    self.isSend = isSend;
    if (isSend) {
        [self.funcButton setImage:[UIImage zegoImageNamed:@"sendMessage_icon"] forState:UIControlStateNormal];
        [self.funcButton setImage:[UIImage zegoImageNamed:@"sendMessage_icon"] forState:UIControlStateSelected];
    } else {
        [self.funcButton setImage:[UIImage zegoImageNamed:@"chat_face_functionIcon"] forState:UIControlStateNormal];
        [self.funcButton setImage:[UIImage zegoImageNamed:@"chat_face_functionIcon"] forState:UIControlStateSelected];
    }
}

- (void)switchToTextInput {
    if (self.voiceButton.selected) {//switch text input
        self.voiceButton.selected = NO;
        
        self.voiceControl.hidden = YES;
        
        self.inputTextView.hidden = NO;
    }
    
    [self changeInputBarbackgroundColor];
}

#pragma mark public

- (void)reSetEmotionAndFuction {
    self.emotionButton.selected = NO;
    self.funcButton.selected = NO;
}

- (void)updateButtonEnabled:(BOOL)enabled {
    self.voiceButton.enabled = enabled;
    self.emotionButton.enabled = enabled;
    self.funcButton.enabled = enabled;
}

- (void)changeInputBarbackgroundColor {
    if (self.voiceControl.hidden) {
        self.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
        self.voiceControl.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xC9CACC) lightColor:ZIMKitHexColor(0xC9CACC)];
    } else {
        self.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xF2F2F2) lightColor:ZIMKitHexColor(0xF2F2F2)];
        self.voiceControl.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
    }
}


#pragma mark - Event triggered when the voice box is clicked
/// Long press the voice button with your finger
- (void)voiceControlTouchDragInside:(UIButton *)sender{
    [sender setTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_voice_touch_release_to_send"] forState:UIControlStateNormal];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceControlTouchType:)]) {
        [self.delegate voiceControlTouchType:KitVoiceControlTouch_DragInside];
    }
}

///Long press the voice button with your finger
- (void)voiceControlTouchDragOutside:(UIButton *)sender{
    [sender setTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_voice_touch_release_to_cancel"] forState:UIControlStateNormal];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceControlTouchType:)]) {
        [self.delegate voiceControlTouchType:KitVoiceControlTouch_DragOutside];
    }
}

/// Lift your finger from the long press button
- (void)voiceControlTouchUpInside:(UIButton *)sender{
    self.voiceControl.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
    [sender setTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_voice_touch_normal"] forState:UIControlStateNormal];
    [self changeInputBarbackgroundColor];
    [self updateButtonEnabled:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceControlTouchType:)]) {
        [self.delegate voiceControlTouchType:KitVoiceControlTouch_upInside];
    }
}

// Finger on the button
- (void)voiceControlTouchDown:(UIButton *)sender{
    self.voiceControl.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xC9CACC) lightColor:ZIMKitHexColor(0xC9CACC)];
    [sender setTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_voice_touch_release_to_send"] forState:UIControlStateNormal];
    [self updateButtonEnabled:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceControlTouchType:)]) {
        [self.delegate voiceControlTouchType:KitVoiceControlTouch_down];
    }
}

// Lift the finger from the outside of the long press button
- (void)voiceControlTouchUpOutside:(UIButton *)sender{
    self.voiceControl.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
    [sender setTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_voice_touch_normal"] forState:UIControlStateNormal];
    [self updateButtonEnabled:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceControlTouchType:)]) {
        [self.delegate voiceControlTouchType:KitVoiceControlTouch_outInside];
    }
}

 
#pragma mark UIExpandingTextView delegate
- (BOOL)expandingTextViewShouldBeginEditing:(ZIMKitInputTextView *)expandingTextView {
    return YES;
}

- (void)expandingTextViewDidBeginEditing:(ZIMKitInputTextView *)expandingTextView{
    [self reSetEmotionAndFuction];
}

- (void)expandingTextViewDidEndEditing:(ZIMKitInputTextView *)expandingTextView{

}

- (void)expandingTextViewDidChange:(ZIMKitInputTextView *)expandingTextView  deleteChar:(BOOL)isDeleteChar {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewTextDidChange:deleteChar:)]) {
        [self.delegate inputViewTextDidChange:self deleteChar:isDeleteChar];
    }

    [self changSendButtonIcon:expandingTextView.text.length];
}

- (void)expandingTextViewDeleteBackward:(ZIMKitInputTextView *)expandingTextView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewDeleteBackward:)]) {
        [self.delegate inputViewDeleteBackward:self];
    }
}

@end
