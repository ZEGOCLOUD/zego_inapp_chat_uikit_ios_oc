//
//  ZIMKitTextMessageCell.h
//  ZIMKit
//
//  Created by zego on 2022/5/28.
//

#import "ZIMKitBubbleMessageCell.h"
#import "ZIMKitTextMessage.h"
#import <YYText/YYText.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitTextMessageCell : ZIMKitBubbleMessageCell

@property (nonatomic, strong) YYLabel  *yyLabel;

@end

NS_ASSUME_NONNULL_END
