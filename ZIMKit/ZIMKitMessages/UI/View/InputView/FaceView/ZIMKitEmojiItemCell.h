//
//  ZIMKitEmojiItemCell.h
//  ZIMKit
//
//  Created by zego on 2022/7/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitEmojiItemCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *emojiL;

@property (nonatomic, copy) void (^tapEmoji)(NSString *emo);

- (void)filldata:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
