//
//  ZIMKitVideoMessageCell.m
//  ZIMKit_OC
//
//  Created by zego on 2022/9/1.
//

#import "ZIMKitVideoMessageCell.h"
#import "ZIMKitVideoMessage.h"
#import "UIImage+ZIMKitUtil.h"
#import "UIView+ZIMKitLayout.h"
#import "ZIMKitDefine.h"

#import <SDWebImage/SDWebImage.h>

@interface ZIMKitVideoMessageCell ()

@property (nonatomic, strong) ZIMKitVideoMessage *message;
@end

@implementation ZIMKitVideoMessageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _thumbnailImageView = [[UIImageView alloc] init];
        _thumbnailImageView.userInteractionEnabled = YES;
        _thumbnailImageView.layer.cornerRadius = 5.0;
        [_thumbnailImageView.layer setMasksToBounds:YES];
        _thumbnailImageView.clipsToBounds = YES;
        _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbnailImageView.backgroundColor = [UIColor whiteColor];
        _thumbnailImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.containerView addSubview:_thumbnailImageView];
        
        _playIcon = [[UIImageView alloc] init];
        _playIcon.image = [UIImage zegoImageNamed:@"chat_message_video_playicon"];
        [self.containerView addSubview:_playIcon];
        
        _timeL = [[UILabel alloc] init];
        _timeL.font = [UIFont systemFontOfSize:10.0 weight:UIFontWeightSemibold];
        _timeL.textColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
        [self.containerView addSubview:_timeL];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIEdgeInsets edge = [self.message.cellConfig contentViewInsets];
    _thumbnailImageView.frame = CGRectMake(edge.left, edge.top, self.containerView.width - edge.left * 2, self.containerView.height - edge.top * 2);
    
    _playIcon.frame = CGRectMake((self.containerView.width - 44)/2, (self.containerView.height - 44)/2, 44, 44);
    
    [self.timeL sizeToFit];
    self.timeL.x = self.containerView.width - self.timeL.width - 8;
    self.timeL.y = self.containerView.height - self.timeL.height - 5;

}

- (void)fillWithMessage:(ZIMKitVideoMessage *)message {
    [super fillWithMessage:message];
    _message = message;
    
    if (message.direction == ZIMMessageDirectionSend || message.sentStatus == ZIMMessageSentStatusSendFailed) {
        UIImage *image;
        if (message.videoFirstFrameLocalPath.length) {
            NSData *imaeData = [NSData dataWithContentsOfFile:message.videoFirstFrameLocalPath];
            image = [UIImage imageWithData:imaeData];
        }
        
        if (!image) {
            [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:message.videoFirstFrameDownloadUrl] placeholderImage:[UIImage zegoImageNamed:@"chat_image_fail_bg"]];
        } else {
            self.thumbnailImageView.image = image;
        }
        
    } else {
        [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:message.videoFirstFrameDownloadUrl] placeholderImage:[UIImage zegoImageNamed:@"chat_image_fail_bg"]];
    }
    
    self.timeL.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)message.videoDuration / 60, (long)message.videoDuration % 60];;
}
@end
