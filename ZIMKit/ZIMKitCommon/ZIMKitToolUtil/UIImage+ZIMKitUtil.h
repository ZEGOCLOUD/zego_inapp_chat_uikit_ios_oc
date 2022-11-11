//
//  UIImage+ZIMKitUtil.h
//  ZIMKit
//
//  Created by zego on 2022/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZIMKitUtil)

+ (NSBundle *)ZIMKitChatBundle;

+ (nullable instancetype)zegoImageNamed:(nullable NSString *)name;

+ (UIImage *)ZIMKitConversationImage:(NSString *)imageName;

+ (UIImage *)ZIMKitGroupImage:(NSString *)imageName;

+ (UIImage *)fileIconWithSuffixIconString:(NSString *)suffix;
@end

NS_ASSUME_NONNULL_END
