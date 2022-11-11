//
//  ZIMKitConversationCell.h
//  ZIMKit
//
//  Created by zego on 2022/5/19.
//

#import <UIKit/UIKit.h>
#import "ZIMKitConversationModel.h"
#import "ZIMKitUnReadView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitConversationCell : UITableViewCell

/// avatar view
@property (nonatomic, strong) UIImageView *headImageView;

/// title
@property (nonatomic, strong) UILabel *titleLabel;

/// subtitle
@property (nonatomic, strong) UILabel *subTitleLabel;

/// time
@property (nonatomic, strong) UILabel *timeLabel;

/// NotDisturb red view
@property (nonatomic, strong) UIView *unReadCountRedDot;

/// NotDisturb Icon
@property (nonatomic, strong) UIImageView *notDisturbIcon;

/// unread count view
@property (nonatomic, strong) ZIMKitUnReadView *unReadView;

/// Split line
@property (nonatomic, strong) UIView *sepline;

/// Multiple choice icon
@property (nonatomic, strong) UIImageView *selectedIcon;

/// MsgFail icon
@property (nonatomic, strong) UIImageView *msgFailImageView;

@property (atomic, strong) ZIMKitConversationModel *data;

- (void)fillWithData:(ZIMKitConversationModel *)data;

@end

NS_ASSUME_NONNULL_END
