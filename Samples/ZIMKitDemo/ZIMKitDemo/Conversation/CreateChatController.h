//
//  CreateChatController.h
//  ZIMKit
//
//  Created by zego on 2022/5/23.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZIMKitCreateChatType) {
    ZIMKitCreateChatTypeUnknow = 0,
    /// Create single chat
    ZIMKitCreateChatTypeSingle = 1,
    /// Create group chat
    ZIMKitCreateChatTypeGroup = 2,
    /// Join the group chat
    ZIMKitCreateChatTypeJoin = 3,
};

NS_ASSUME_NONNULL_BEGIN


@interface CreateChatController : UIViewController

@property (nonatomic, assign) ZIMKitCreateChatType createType;

@end

NS_ASSUME_NONNULL_END
