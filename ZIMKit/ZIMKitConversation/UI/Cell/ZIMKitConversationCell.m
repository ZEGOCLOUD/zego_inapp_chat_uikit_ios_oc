//
//  ZIMKitConversationCell.m
//  ZIMKit
//
//  Created by zego on 2022/5/19.
//

#import "ZIMKitConversationCell.h"
#import "ZIMKitDefine.h"
#import "NSString+ZIMKitUtil.h"
#import "ZIMMessage+Extension.h"
#import <SDWebImage/SDWebImage.h>

@implementation ZIMKitConversationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
        _headImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_headImageView];

        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = [UIColor dynamicColor:ZIMKitHexColor(0xB8B8B8) lightColor:ZIMKitHexColor(0xB8B8B8)];;
        _timeLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_timeLabel];
        
        _msgFailImageView = [[UIImageView alloc] initWithImage:[UIImage ZIMKitConversationImage:@"conversation_msg_fail"]];
        _msgFailImageView.hidden = YES;
        [self.contentView addSubview:_msgFailImageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _titleLabel.textColor = [UIColor dynamicColor:ZIMKitHexColor(0x2A2A2A) lightColor:ZIMKitHexColor(0x2A2A2A)];
        _titleLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_titleLabel];

        _unReadView = [[ZIMKitUnReadView alloc] init];
        [self.contentView addSubview:_unReadView];

        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.numberOfLines = 1;
        _subTitleLabel.layer.masksToBounds = YES;
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
        _subTitleLabel.textColor = [UIColor dynamicColor:ZIMKitHexColor(0xA4A4A4) lightColor:ZIMKitHexColor(0xA4A4A4)];
        [self.contentView addSubview:_subTitleLabel];
        
        _sepline = [[UIView alloc] init];
        _sepline.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xE6E6E6) lightColor:ZIMKitHexColor(0xE6E6E6)];
        [self.contentView addSubview:_sepline];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    return self;
}

- (void)fillWithData:(ZIMKitConversationModel *)data {
    self.data = data;
    
    self.headImageView.image = nil;
    
    if (data.type == ZIMConversationTypePeer) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:data.conversationAvatar] placeholderImage:[UIImage ZIMKitConversationImage:@"conversation_avatar_default"]];
    } else {
        self.headImageView.image = [UIImage ZIMKitConversationImage:@"conversation_groupAvatar_default"];
    }
    
    self.titleLabel.text = data.conversationName;
    
    if (data.lastMessage.timestamp == 0) {
        self.timeLabel.text = @" ";
    } else {
        NSString *time = [NSString conversationConvertDateToStr:data.lastMessage.timestamp];
        self.timeLabel.hidden = time.length ? NO : YES;
        self.timeLabel.text = time;
    }
    
    self.subTitleLabel.text = [data.lastMessage getMessageTypeShorStr];
    
    [self.unReadView setNum:data.unreadMessageCount];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = ZIMKitConversationCell_Height;
    self.height = height;
    CGFloat headImageWH = height - 2*ZIMKitConversationCell_Margin;
    
    self.headImageView.width = headImageWH;
    self.headImageView.height = headImageWH;
    self.headImageView.x = ZIMKitConversationCell_Margin;
    self.headImageView.y = ZIMKitConversationCell_Margin;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 4;
    
    self.titleLabel.zg_sizeToFitThan(ZIMKitConversationCell_TitleMaxW, 26);
    self.titleLabel.x = self.headImageView.maxX+ZIMKitConversationCell_Title_Margin;
    self.titleLabel.y = ZIMKitConversationCell_Margin;
    
    [self.timeLabel sizeToFit];
    self.timeLabel.centerY = self.titleLabel.centerY;
    self.timeLabel.x = self.width - self.timeLabel.width - ZIMKitConversationCell_Margin;
    
    if (self.data.lastMessage.sentStatus == ZIMMessageSentStatusSendFailed ||
        self.data.conversationEvent == ZIMConversationEventDisabled) {
        
        self.msgFailImageView.hidden = NO;
        self.msgFailImageView.x = self.titleLabel.x;
        self.msgFailImageView.height = 16;
        self.msgFailImageView.width = 16;
        self.msgFailImageView.y = self.height - self.msgFailImageView.height - ZIMKitConversationCell_Margin;
        
        self.subTitleLabel.x = self.titleLabel.x + 16 + 4;
        self.subTitleLabel.height = 16;
        self.subTitleLabel.width = self.width - ZIMKitConversationCell_Margin - headImageWH - ZIMKitConversationCell_Title_Margin - 16-4 - ZIMKitConversationCell_Margin*2;
        self.subTitleLabel.centerY = self.msgFailImageView.centerY;
    } else {
        self.msgFailImageView.hidden = YES;
        self.subTitleLabel.x = self.titleLabel.x;
        self.subTitleLabel.height = 16;
        self.subTitleLabel.width = self.width - ZIMKitConversationCell_Margin - headImageWH - ZIMKitConversationCell_Title_Margin - ZIMKitConversationCell_Margin*2;
        self.subTitleLabel.y = self.height - self.subTitleLabel.height - ZIMKitConversationCell_Margin;
    }
    
    self.unReadView.y = self.headImageView.y - 6;
    self.unReadView.x = self.headImageView.x + self.headImageView.width - self.unReadView.width/2 - 4;
    
    self.sepline.x = self.titleLabel.x;
    self.sepline.y = self.height - 0.5;
    self.sepline.height = 0.5;
    self.sepline.width = self.width -  self.sepline.x;
}


@end
