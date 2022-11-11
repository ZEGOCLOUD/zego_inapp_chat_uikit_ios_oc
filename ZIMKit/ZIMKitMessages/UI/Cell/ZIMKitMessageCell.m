//
//  ZIMKitMessageCell.m
//  ZIMKit
//
//  Created by zego on 2022/5/25.
//

#import "ZIMKitMessageCell.h"
#import "NSString+ZIMKitUtil.h"
#import "ZIMKitDefine.h"
#import "ZIMKitMenuView.h"
#import "ZIMKitTool.h"
#import <AVKit/AVKit.h>
#import <SDWebImage/SDWebImage.h>

@interface ZIMKitMessageCell ()

@property (nonatomic, strong) ZIMKitMessage *message;
@property (nonatomic, strong) ZIMKitMenuView *menuView;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@end

@implementation ZIMKitMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        
        UILongPressGestureRecognizer *longtap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longtapAction:)];
        longtap.minimumPressDuration = 0.5;
        [self.containerView addGestureRecognizer:longtap];
    }
    
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor clearColor];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor dynamicColor:ZIMKitHexColor(0xB8B8B8) lightColor:ZIMKitHexColor(0xB8B8B8)];
    [self.contentView addSubview:_timeLabel];
    
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    _avatarImageView.image = [UIImage zegoImageNamed:@"chat_avatar_default"];
    _avatarImageView.layer.cornerRadius = 8.0;
    _avatarImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:11];
    _nameLabel.textColor = [UIColor dynamicColor:ZIMKitHexColor(0x666666) lightColor:ZIMKitHexColor(0x666666)];
    [self.contentView addSubview:_nameLabel];
    
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_containerView];
    
    _indicator = [[UIActivityIndicatorView alloc] init];
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.contentView addSubview:_indicator];
    
    _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_retryButton setImage:[UIImage zegoImageNamed:@"chat_message_send_fail"] forState:UIControlStateNormal];
    [self.contentView addSubview:_retryButton];
    
    _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectedButton.userInteractionEnabled = NO;
    [_selectedButton setImage:[UIImage zegoImageNamed:@"chat_message_unselected"] forState:UIControlStateNormal];
    [self.contentView addSubview:_selectedButton];
}

- (void)fillWithMessage:(ZIMKitMessage *)message {
    _message = message;
    
    if (message.direction == ZIMMessageDirectionReceive) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:message.senderUserAvatar] placeholderImage:[UIImage zegoImageNamed:@"chat_avatar_default"]];
    } else {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[ZIMKitManager shared].userInfo.userAvatarUrl] placeholderImage:[UIImage zegoImageNamed:@"chat_avatar_default"]];
    }
    
    if (message.sentStatus == ZIMMessageSentStatusSending) {
        [self.indicator startAnimating];
    } else {
        [self.indicator stopAnimating];
    }
    
    if (message.needShowTime) {
        _timeLabel.text = [NSString convertDateToStr:message.timestamp];
        _timeLabel.hidden = NO;
    } else {
        _timeLabel.hidden = YES;
    }

    if (message.needShowName) {
        _nameLabel.hidden = NO;
        if (message.senderUsername.length) {
            _nameLabel.text = message.senderUsername;
        } else {
            _nameLabel.text = message.senderUserID;
        }
        
    } else {
        _nameLabel.hidden = YES;
    }
    
    if (message.sentStatus == ZIMMessageSentStatusSending && message.direction == ZIMMessageDirectionSend) {
        _indicator.hidden = NO;
    } else {
        _indicator.hidden = YES;
    }
    
    if (message.sentStatus == ZIMMessageSentStatusSendFailed && message.direction == ZIMMessageDirectionSend) {
        _retryButton.hidden = NO;
    } else {
        _retryButton.hidden = YES;
    }
}

- (void)setIsSelectMore:(BOOL)isSelectMore {
    _isSelectMore = isSelectMore;
    if (isSelectMore) {
        self.selectedButton.hidden = NO;
        [self.containerView removeGestureRecognizer:self.tapRecognizer];
    } else {
        self.selectedButton.hidden = YES;
        [self.containerView addGestureRecognizer:self.tapRecognizer];
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        [_selectedButton setImage:[UIImage zegoImageNamed:@"chat_message_selected"] forState:UIControlStateNormal];
    } else {
        [_selectedButton setImage:[UIImage zegoImageNamed:@"chat_message_unselected"] forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.message.needShowTime) {
        _timeLabel.hidden = NO;
        _timeLabel.x = 0;
        _timeLabel.width = Screen_Width - 2*ZIMKitMessageCell_Avatar_Screen_Margin;
        _timeLabel.height = ZIMKitMessageCell_Time_H;
        if (self.message.isLastTop) {
            _timeLabel.y = ZIMKitMessageCell_Top_Time_H;
            _avatarImageView.y =  ZIMKitMessageCell_Top_Time_H + _timeLabel.height + ZIMKitMessageCell_Time_Avatar_Margin;
        } else {
            _timeLabel.y = ZIMKitMessageCell_Bottom_Time_H;
            _avatarImageView.y = ZIMKitMessageCell_Bottom_Time_H + _timeLabel.height + ZIMKitMessageCell_Time_Avatar_Margin;
        }
       
    } else {
        _timeLabel.hidden = YES;
        _timeLabel.height = 0;
        _avatarImageView.y = _timeLabel.height;
    }
    
    _avatarImageView.width = ZIMKitMessageCell_Avatar_WH;
    _avatarImageView.height = ZIMKitMessageCell_Avatar_WH;
    
    if (self.message.needShowName) {
        [_nameLabel sizeToFit];
        _nameLabel.hidden = NO;
        if (_nameLabel.width > ZIMKitMessageCell_Name_MaxW) {
            _nameLabel.width = ZIMKitMessageCell_Name_MaxW;
        }
        
        if (_nameLabel.height < ZIMKitMessageCell_Name_H) {
            _nameLabel.height = ZIMKitMessageCell_Name_H;
        }
        _nameLabel.height += ZIMKitMessageCell_Name_TO_CON_Margin;
        
    } else {
        _nameLabel.hidden = YES;
        _nameLabel.height = 0;
    }
    
    if (self.isSelectMore) {
        self.selectedButton.frame = CGRectMake(ZIMKitMessageCell_Avatar_Screen_Margin, _avatarImageView.y+ZIMKitMessageCell_Avatar_WH/2 - ZIMKitMessageCell_SelectedButton_WH/2, ZIMKitMessageCell_SelectedButton_WH, ZIMKitMessageCell_SelectedButton_WH);
    }
    
    CGSize contentSize = [self.message contentSize];
    if (_message.direction == ZIMMessageDirectionReceive) {
        _avatarImageView.x = self.isSelectMore ? self.selectedButton.maxX + ZIMKitMessageCell_Avatar_Screen_Margin : ZIMKitMessageCell_Avatar_Screen_Margin;
        
        _nameLabel.y = _avatarImageView.y;
        
        _containerView.x = _avatarImageView.maxX + ZIMKitMessageCell_Avatar_Con_Margin;
        _containerView.y = _nameLabel.y + _nameLabel.height ;
        _containerView.width = contentSize.width + [self.message.cellConfig contentViewInsets].left *2;
        _containerView.height = contentSize.height + [self.message.cellConfig contentViewInsets].top *2;
        _nameLabel.x = _containerView.x;
        
    } else {
        _avatarImageView.right = ZIMKitMessageCell_Avatar_Screen_Margin;
        _nameLabel.y = _avatarImageView.y;
        
        _containerView.y = _nameLabel.y + _nameLabel.height ;
        _containerView.width = contentSize.width + [self.message.cellConfig contentViewInsets].left *2;
        _containerView.height = contentSize.height + [self.message.cellConfig contentViewInsets].top *2;
        _containerView.x = self.contentView.width - ZIMKitMessageCell_Avatar_Screen_Margin - _avatarImageView.width - ZIMKitMessageCell_Avatar_Con_Margin - _containerView.width;
        [_indicator sizeToFit];
        _indicator.centerY = _containerView.centerY;
        _indicator.x = _containerView.x - 8 - _indicator.width;
        
        _retryButton.width = ZIMKitMessageCell_Retry_W;
        _retryButton.height = ZIMKitMessageCell_Retry_W;
        _retryButton.x = _containerView.x - 8 - _retryButton.width;
        _retryButton.centerY = _containerView.centerY;
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (self.tapCellBlock) {
        self.tapCellBlock(self.message, self);
    }
}

- (void)longtapAction:(UILongPressGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateBegan) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UIMenuControllerWillHideMenuNotification object:nil];
        NSArray *menuitems = [self menuItemWithMessage:self.message];
        NSInteger row = (menuitems.count -1)/maxColumns;
        
        UIWindow *keyWindow = [ZIMKitTool kit_keyWindow];
        [keyWindow addSubview:self.menuView];
        CGFloat itemW = kMenuWidth;
        
        CGRect targetRectInWindow = [self.containerView.superview convertRect:self.containerView.frame toView:keyWindow];
        CGFloat targetCenterX = targetRectInWindow.origin.x + targetRectInWindow.size.width/2;
        
        CGFloat menuW = row > 0 ? maxColumns*itemW+(maxColumns+1)*kMargin : menuitems.count * itemW + (menuitems.count+1)*kMargin;
        CGFloat menuH = (row +1)*kMenuHeight + (row +2)*kMargin + kArrowHeight; //kArrowHeight

        CGFloat menuX = targetCenterX - menuW/2 > 0 ? targetCenterX - menuW/2 : ZIMKitMessageCell_Avatar_Screen_Margin;
        menuX = menuX + menuW >= Screen_Width ? Screen_Width - menuW - ZIMKitMessageCell_Avatar_Screen_Margin : menuX;// If it is a message on the right, 8 should be left blank and the avatar should be aligned
        
        CGFloat menuY = targetRectInWindow.origin.y - menuH;
        menuY = menuY < StatusBar_Height ? targetRectInWindow.origin.y + targetRectInWindow.size.height : menuY;
        menuY = menuY > Screen_Height - menuH - 30 ? Screen_Height / 2 : menuY;
        
        CGRect frame = CGRectMake(menuX, menuY, menuW, menuH);
        [self.menuView setFrame:frame targetRect:targetRectInWindow];
        self.menuView.menuItems = menuitems;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(hideMenuNotiAction)
                                                     name:UIMenuControllerWillHideMenuNotification
                                                   object:nil];
        
    }
    
}

- (NSArray *)menuItemWithMessage:(ZIMKitMessage *)message {
    NSMutableArray *menuItems = @[].mutableCopy;
    switch (message.type) {
        case ZIMMessageTypeText:
        case ZIMMessageTypeImage:
        case ZIMMessageTypeVideo:
        case ZIMMessageTypeAudio:
        case ZIMMessageTypeFile:
        {
            if (message.type == ZIMMessageTypeAudio) {
                AVAudioSessionCategory cateory = [[NSUserDefaults standardUserDefaults] objectForKey:ZIMKitSessionCategory(ZIMKitManager.shared.userInfo.userID)];
                if ([cateory isEqualToString:AVAudioSessionCategoryPlayAndRecord]) {
                    [menuItems addObject:[self menuItem:[NSBundle ZIMKitlocalizedStringForKey:@"message_menuitem_speakerplay"] image:[UIImage zegoImageNamed:@"chat_message_menuitem_speakerplay"] callback:^{
                        [self speakerplayMessage:message];
                    }]];
                } else {
                    [menuItems addObject:[self menuItem:[NSBundle ZIMKitlocalizedStringForKey:@"message_menuitem_muteplay"] image:[UIImage zegoImageNamed:@"chat_message_menuitem_muteplay"] callback:^{
                        [self muteplayMessage:message];
                    }]];
                }
            }
            
            if (message.type == ZIMMessageTypeText) {
                [menuItems addObject:[self menuItem:[NSBundle ZIMKitlocalizedStringForKey:@"message_menuitem_copy"] image:[UIImage zegoImageNamed:@"chat_message_menuitem_delete"] callback:^{
                    [self copyMessage:message];
                }]];
            }
            
            [menuItems addObject:[self menuItem:[NSBundle ZIMKitlocalizedStringForKey:@"message_menuitem_delete"] image:[UIImage zegoImageNamed:@"chat_message_menuitem_delete"] callback:^{
                [self deleteMessage:message];
            }]];
            [menuItems addObject:[self menuItem:[NSBundle ZIMKitlocalizedStringForKey:@"message_menuitem_multiselect"] image:[UIImage zegoImageNamed:@"chat_message_menuitem_multiselect"] callback:^{
                [self multiselectMessage:message];
            }]];
        }
            break;
            
        default:
            break;
    }
    
    return menuItems;
}

- (void)muteplayMessage:(ZIMKitMessage *)message {
    if (self.longPressCallback) {
        self.longPressCallback(message, self, ZIMKitMenuTypeMuteplay);
    }
}

- (void)speakerplayMessage:(ZIMKitMessage *)message {
    if (self.longPressCallback) {
        self.longPressCallback(message, self, ZIMKitMenuTypeSpeakerplay);
    }
}

- (void)deleteMessage:(ZIMKitMessage *)message {
    if (self.longPressCallback) {
        self.longPressCallback(message, self, ZIMKitMenuTypeDelete);
    }
}

- (void)multiselectMessage:(ZIMKitMessage *)message {
    if (self.longPressCallback) {
        self.longPressCallback(message, self, ZIMKitMenuTypeMultiselect);
    }
}

- (void)copyMessage:(ZIMKitMessage *)message {
    if (self.longPressCallback) {
        self.longPressCallback(message, self, ZIMKitMenuTypeCopy);
    }
}

- (ZIMKitMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[ZIMKitMenuView alloc] init];
    }
    return _menuView;
}
- (void)hideMenuNotiAction {
    if (_menuView) {
        
        [_menuView removeFromSuperview];
        _menuView = nil;
    }
}

- (ZIMKitMenuAction *)menuItem:(NSString *)title image:(UIImage *)image callback:(ZIMKitMenuActionCallback)callback {
    ZIMKitMenuAction *menuAction = [[ZIMKitMenuAction alloc] initWithTitle:title image:image callback:callback];
    return menuAction;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIMenuControllerWillHideMenuNotification object:nil];
    return [super hitTest:point withEvent:event];
}

- (void)prepareForReuse{
    [super prepareForReuse];
    
}
@end
