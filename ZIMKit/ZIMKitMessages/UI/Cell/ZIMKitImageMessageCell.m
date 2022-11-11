//
//  ZIMKitImageMessageCell.m
//  ZIMKit
//
//  Created by zego on 2022/7/18.
//

#import "ZIMKitImageMessageCell.h"
#import "UIView+ZIMKitLayout.h"
#import "UIImage+ZIMKitUtil.h"

#import <SDWebImage/SDWebImage.h>

@interface ZIMKitImageMessageCell ()

@property (nonatomic, strong) ZIMKitImageMessage *message;

@end

@implementation ZIMKitImageMessageCell

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
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIEdgeInsets edge = [self.message.cellConfig contentViewInsets];
    _thumbnailImageView.frame = CGRectMake(edge.left, edge.top, self.containerView.width - edge.left * 2, self.containerView.height - edge.top * 2);
}

- (void)fillWithMessage:(ZIMKitImageMessage *)message {
    [super fillWithMessage:message];
    self.message = message;
    
    //Send or SendFailed load image
    if (message.direction == ZIMMessageDirectionSend || message.sentStatus == ZIMMessageSentStatusSendFailed) {
        UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:message.fileLocalPath];
        if (message.fileLocalPath.length && !image) {
            NSData *imaeData = [NSData dataWithContentsOfFile:message.fileLocalPath];
            image = [UIImage imageWithData:imaeData];
            [[SDImageCache sharedImageCache] storeImageToMemory:image forKey:message.fileLocalPath];
        }
        if (!image) {
            [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:message.thumbnailDownloadUrl] placeholderImage:[UIImage zegoImageNamed:@"chat_image_fail_bg"]];
        } else {
            self.thumbnailImageView.image = image;
        }
        
    } else {
        [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:message.thumbnailDownloadUrl] placeholderImage:[UIImage zegoImageNamed:@"chat_image_fail_bg"]];
    }
}
@end
