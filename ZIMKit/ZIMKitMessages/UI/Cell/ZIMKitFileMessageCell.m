//
//  ZIMKitFileMessageCell.m
//  ZIMKit_OC
//
//  Created by zego on 2022/9/7.
//

#import "ZIMKitFileMessageCell.h"
#import "ZIMKitFileMessage.h"
#import "UIImage+ZIMKitUtil.h"
#import "NSString+ZIMKitUtil.h"
#import "UIColor+ZIMKitUtil.h"
#import "ZIMKitDefine.h"

@interface ZIMKitFileMessageCell ()

@property (nonatomic, strong) ZIMKitFileMessage *message;
@property (nonatomic, strong) UIImageView *fileIcon;
@property (nonatomic, strong) UILabel     *titleL;
@property (nonatomic, strong) UILabel     *subTitleL;

@property (nonatomic, strong) UIActivityIndicatorView *downloadIndicator;
@property (nonatomic, strong) UIView *downloadBg;

@end

@implementation ZIMKitFileMessageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _fileIcon = [[UIImageView alloc] init];
        [self.bubbleView addSubview:_fileIcon];
        
        _titleL = [[UILabel alloc] init];
        _titleL.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleL.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _titleL.textColor = [UIColor dynamicColor:ZIMKitHexColor(0x2A2A2A) lightColor:ZIMKitHexColor(0x2A2A2A)];
        [self.bubbleView addSubview:_titleL];
        
        _subTitleL = [[UILabel alloc] init];
        _subTitleL.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _subTitleL.textColor = [UIColor dynamicColor:ZIMKitHexColor(0x2A2A2A) lightColor:ZIMKitHexColor(0x2A2A2A)];
        [self.bubbleView addSubview:_subTitleL];
        
        _downloadBg = [[UIView alloc] init];
        _downloadBg.backgroundColor = [[UIColor dynamicColor:ZIMKitHexColor(0x000000) lightColor:ZIMKitHexColor(0x000000)] colorWithAlphaComponent:0.5];
        [self.bubbleView addSubview:_downloadBg];
        
        _downloadIndicator = [[UIActivityIndicatorView alloc] init];
        _downloadIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [_downloadBg addSubview:_downloadIndicator];
    }
    return self;
}

- (void)fillWithMessage:(ZIMKitFileMessage *)message {
    [super fillWithMessage:message];
    _message = message;
    
    self.fileIcon.image = [UIImage fileIconWithSuffixIconString:message.fileName.pathExtension];
    self.titleL.text = message.fileName;
    [self.titleL sizeToFit];
    
    self.subTitleL.text = [NSString fileSizeTransformedValue:message.fileSize];
    [self.subTitleL sizeToFit];
}

- (void)fileDownloading:(BOOL)downloading {
    self.downloadBg.hidden = !downloading;
    self.downloadIndicator.hidden = !downloading;
    if (downloading) {
        [self.downloadIndicator startAnimating];
    } else {
        [self.downloadIndicator stopAnimating];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.fileIcon.frame = CGRectMake(self.bubbleView.width - ZIMKitFileMessageCellFileIconW - ZIMKitFileMessageCell_Margin_Left, (self.bubbleView.height - ZIMKitFileMessageCellFileIconH)/2, ZIMKitFileMessageCellFileIconW, ZIMKitFileMessageCellFileIconH);
    
    self.titleL.x = ZIMKitFileMessageCell_Title_Left;
    self.titleL.y = self.fileIcon.y;
    self.titleL.zg_sizeGreaterThanOrEqualTo(self.bubbleView.width - self.titleL.x - ZIMKitFileMessageCellFileIconW  - ZIMKitFileMessageCell_Margin_Left - ZIMKitFileMessageCell_Icon_Title, self.titleL.height);
    
    self.subTitleL.x = self.titleL.x;
    self.subTitleL.y = self.fileIcon.y + ZIMKitFileMessageCellFileIconH - self.subTitleL.height;
    
    self.downloadBg.frame = CGRectMake(self.fileIcon.x, self.fileIcon.y, ZIMKitFileMessageCellFileIconH, ZIMKitFileMessageCellFileIconH);
    
    [self.downloadIndicator sizeToFit];
    self.downloadIndicator.x = (ZIMKitFileMessageCellFileIconH - self.downloadIndicator.width)/2;
    self.downloadIndicator.y = (ZIMKitFileMessageCellFileIconH - self.downloadIndicator.height)/2;
}

@end
