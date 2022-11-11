//
//  ZIMKitSystemMessageCell.h
//  ZIMKit
//
//  Created by zego on 2022/6/9.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>
#import "ZIMKitSystemMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitSystemMessageCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;

/// Prompt message
@property (nonatomic, strong) YYLabel *messageLabel;

- (void)fillWithMessage:(ZIMKitSystemMessage *)message;
@end

NS_ASSUME_NONNULL_END
