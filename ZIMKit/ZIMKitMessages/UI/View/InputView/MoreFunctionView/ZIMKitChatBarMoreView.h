//
//  ZIMKitChatBarMoreView.h
//  ZIMKit
//
//  Created by zego on 2022/7/13.
//

#import <UIKit/UIKit.h>

#define kChatBarMoreView (109 + Bottom_SafeHeight)

typedef NS_ENUM(NSUInteger, ZIMKitFunctionType) {
    ZIMKitFunctionTypePhoto = 1,
    ZIMKitFunctionTypeFile = 2,
};

@protocol ZIMKitChatBarMoreViewDelegate <NSObject>

- (void)didSelectedMoreViewItemAction:(ZIMKitFunctionType)type;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitChatBarMoreView : UIView

@property (nonatomic, weak) id <ZIMKitChatBarMoreViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
