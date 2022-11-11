//
//  ZIMKitMessageSendToolbar.h
//  ZIMKit
//
//  Created by zego on 2022/8/11.
//

#import <Foundation/Foundation.h>
#import "ZIMKitFaceManagerView.h"
#import "ZIMKitInputBar.h"
#import "ZIMKitChatBarMoreView.h"
#import "ZIMKitMultiChooseView.h"

@protocol ZIMKitMessageSendToolbarDelegate <NSObject>

/// Input box frame change
- (void)messageToolbarInputFrameChange;

/// Send text
- (void)messageToolbarSendTextMessage:(NSString *_Nullable)text;

/// function button clicked
- (void)messageToolbarDidSelectedMoreViewItemAction:(ZIMKitFunctionType)type;

/// Send voice
- (void)messageToolbarDidSendVoice:(NSString *_Nullable)path duration:(int)duration;

/// Start voice recorder
- (void)messageToolbarVoiceRecorderDidBegin:(NSString *_Nullable)path;

/// MultiChoose delete
- (void)messageToolbarMultiChooseDelete;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitMessageSendToolbar : NSObject

@property (nonatomic, weak) id<ZIMKitMessageSendToolbarDelegate>delegate;

/// 消息输入框
@property (nonatomic, strong) ZIMKitInputBar        *inputBar;

/// 表情键盘
@property (nonatomic, strong) ZIMKitFaceManagerView *faceKeyBoard;

/// 更多键盘
@property (nonatomic, strong) ZIMKitChatBarMoreView *moreFunctionView;

/// 多选
@property (nonatomic, strong) ZIMKitMultiChooseView *multiChooseView;;

- (instancetype)initWithSuperView:(UIView *)fatherView ;

/// 隐藏键盘
- (void)hiddeKeyborad;

- (void)cancelVoiceRecorder;

///  多选切换
- (void)switchMessageToolbarMultiChoose:(BOOL)isMultiChoose;
@end

NS_ASSUME_NONNULL_END
