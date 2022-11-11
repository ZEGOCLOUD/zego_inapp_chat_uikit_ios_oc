//
//  ZIMKitDefaultEmojiCollectionView.h
//  ZIMKit
//
//  Created by zego on 2022/7/11.
//

#import <UIKit/UIKit.h>

@protocol ZIMKitDefaultEmojiCollectionViewDelegate <NSObject>

- (void)didSelectItem:(NSString *_Nullable)emojiString;

- (void)deleteItemAction;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitDefaultEmojiCollectionView : UICollectionViewCell

@property (nonatomic, weak) id<ZIMKitDefaultEmojiCollectionViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
