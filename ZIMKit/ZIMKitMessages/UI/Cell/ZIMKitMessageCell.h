//
//  ZIMKitMessageCell.h
//  ZIMKit
//
//  Created by zego on 2022/5/25.
//

#import <UIKit/UIKit.h>
#import "ZIMKitMessage.h"

typedef NS_ENUM(NSUInteger, ZIMKitMenuType) {
    ZIMKitMenuTypeDelete,
    ZIMKitMenuTypeMuteplay,
    ZIMKitMenuTypeSpeakerplay,
    ZIMKitMenuTypeMultiselect,
    ZIMKitMenuTypeCopy,
};

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitMessageCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) UIButton *retryButton;

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, assign) BOOL isSelectMore;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) void (^tapCellBlock)(ZIMKitMessage *msg, ZIMKitMessageCell *cell);

@property (nonatomic, copy) void (^longPressCallback)(ZIMKitMessage *msg, ZIMKitMessageCell *cell, ZIMKitMenuType menuType);

- (void)fillWithMessage:(ZIMKitMessage *)message;

@end

NS_ASSUME_NONNULL_END
