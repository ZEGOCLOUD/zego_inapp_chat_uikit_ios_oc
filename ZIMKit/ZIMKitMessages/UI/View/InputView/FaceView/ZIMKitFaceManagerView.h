//
//  ZIMKitFaceManagerView.h
//  ZIMKit
//
//  Created by zego on 2022/7/11.
//

#import <UIKit/UIKit.h>

@protocol ZIMKitFaceManagerViewDelegate <NSObject>

- (void)didSelectItem:(NSString *_Nullable)emojiString;

- (void)deleteInputItemAction;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitFaceManagerView : UIView

@property (nonatomic, weak) id<ZIMKitFaceManagerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
