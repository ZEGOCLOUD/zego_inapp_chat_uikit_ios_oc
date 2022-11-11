//
//  ZIMKitAudioMessageCell.m
//  ZIMKit_OC
//
//  Created by zego on 2022/8/30.
//

#import "ZIMKitAudioMessageCell.h"
#import "ZIMKitAudioMessage.h"
#import "UIImage+ZIMKitUtil.h"
#import "UIColor+ZIMKitUtil.h"
#import "ZIMKitDefine.h"

@interface ZIMKitAudioMessageCell ()

@property (nonatomic, strong) ZIMKitAudioMessage *message;
@property (nonatomic, strong) UIImageView        *voiceImageView;
@property (nonatomic, strong) UILabel            *timeL;
@end

@implementation ZIMKitAudioMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _voiceImageView = [[UIImageView alloc] init];
        _voiceImageView.animationDuration = 1;
        [self.bubbleView addSubview:_voiceImageView];
        
        _timeL = [[UILabel alloc] init];
        _timeL.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _timeL.textColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
        _timeL.layer.masksToBounds = YES;
        [self.bubbleView addSubview:_timeL];
        
        self.bubbleView.animationDuration = 1.0;
        self.bubbleView.animationImages = @[[ZIMKitMessageCellConfig sendBubble] ?: @"",[ZIMKitMessageCellConfig sendBubble2] ?: @""];
    }
    return self;
}

- (void)fillWithMessage:(ZIMKitAudioMessage *)message {
    [super fillWithMessage:message];
    _message = message;
    
    if (message.isExistLocal) {
        if (_message.direction == ZIMMessageDirectionSend) {
            _voiceImageView.image = [UIImage zegoImageNamed:@"chat_message_voice_right_3"];
            _voiceImageView.animationImages = @[[UIImage zegoImageNamed:@"chat_message_voice_right_1"] ?: @"",
                                               [UIImage zegoImageNamed:@"chat_message_voice_right_2"] ?: @"",
                                               [UIImage zegoImageNamed:@"chat_message_voice_right_3"] ?: @""];
            
            _timeL.textColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
        } else {
            _voiceImageView.image = [UIImage zegoImageNamed:@"chat_message_voice_left_3"];
            _voiceImageView.animationImages = @[[UIImage zegoImageNamed:@"chat_message_voice_left_1"] ?: @"",
                                               [UIImage zegoImageNamed:@"chat_message_voice_left_2"] ?: @"",
                                               [UIImage zegoImageNamed:@"chat_message_voice_left_3"] ?: @""];
            
            _timeL.textColor = [UIColor dynamicColor:ZIMKitHexColor(0x2A2A2A) lightColor:ZIMKitHexColor(0x2A2A2A)];
        }
        
        if (message.audioDuration > 1) {
            _timeL.text = [NSString stringWithFormat:@"%u\"", message.audioDuration > ZIMKitAudioMessageTimeLength ? ZIMKitAudioMessageTimeLength : message.audioDuration];
        } else {
            _timeL.text = @"1\"";
        }
        [_timeL sizeToFit];
        
        self.bubbleView.animationImages = nil;
        
    } else {
        
        _voiceImageView.image = nil;
        _voiceImageView.animationImages = nil;
        _timeL.text = @"";
        if (_message.direction == ZIMMessageDirectionSend) {
            self.bubbleView.animationImages = @[[ZIMKitMessageCellConfig sendBubble] ?: @"",[ZIMKitMessageCellConfig sendBubble2] ?: @""];
        } else {
            self.bubbleView.animationImages = @[[ZIMKitMessageCellConfig receiveBubble] ?: @"",[ZIMKitMessageCellConfig receiveBubble2] ?: @""];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_message.direction == ZIMMessageDirectionSend) {
        self.voiceImageView.frame = CGRectMake(self.bubbleView.width - ZIMKitAudioMessageIcon_WH - ZIMKitAudioMessageMargin, (self.bubbleView.height - ZIMKitAudioMessageIcon_WH)/2, ZIMKitAudioMessageIcon_WH, ZIMKitAudioMessageIcon_WH);
        
        self.timeL.x = self.voiceImageView.x - ZIMKitAudioMessageIcon_Text - self.timeL.width;
        self.timeL.y =  (self.bubbleView.height - self.timeL.height)/2;
    } else {
        self.voiceImageView.frame = CGRectMake(ZIMKitAudioMessageMargin, (self.bubbleView.height - ZIMKitAudioMessageIcon_WH)/2, ZIMKitAudioMessageIcon_WH, ZIMKitAudioMessageIcon_WH);
        
        self.timeL.x = self.voiceImageView.x + ZIMKitAudioMessageIcon_WH + ZIMKitAudioMessageIcon_Text;
        self.timeL.y =  (self.bubbleView.height - self.timeL.height)/2;
    }
        
    [self setIsPlaying:_message.isPlaying];
}

- (void)setIsPlaying:(BOOL)isPlaying
{
    _isPlaying = isPlaying;
    
    if (_isPlaying) {
        if (!_voiceImageView.isAnimating) {
            [_voiceImageView startAnimating];
        }
    }else {
        if (_voiceImageView.isAnimating){
            [_voiceImageView stopAnimating];
        }
    }
}

- (void)setIsBubbleViewPlaying:(BOOL)isBubbleViewPlaying {
    _isBubbleViewPlaying = isBubbleViewPlaying;
    
    if (isBubbleViewPlaying) {
        if (!self.bubbleView.isAnimating) {
            [self.bubbleView startAnimating];
        }
    } else {
        if (self.bubbleView.isAnimating) {
            [self.bubbleView stopAnimating];
        }
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.bubbleView stopAnimating];
}
@end
