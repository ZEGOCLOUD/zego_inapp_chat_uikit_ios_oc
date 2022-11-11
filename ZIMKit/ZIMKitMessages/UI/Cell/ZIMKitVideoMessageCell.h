//
//  ZIMKitVideoMessageCell.h
//  ZIMKit_OC
//
//  Created by zego on 2022/9/1.
//

#import "ZIMKitMessageCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitVideoMessageCell : ZIMKitMessageCell

@property (nonatomic, strong) UIImageView *thumbnailImageView;

@property (nonatomic, strong) UIImageView *playIcon;

@property (nonatomic, strong) UILabel     *timeL;

@end

NS_ASSUME_NONNULL_END
