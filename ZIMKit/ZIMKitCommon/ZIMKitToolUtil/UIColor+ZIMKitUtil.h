//
//  UIColor+ZIMKitUtil.h
//  ZIMKit
//
//  Created by zego on 2022/5/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ZIMKitUtil)


/// Get color dynamically
/// @param darkColor darkColor
/// @param lightColor lightColor
+ (UIColor *)dynamicColor:(UIColor *)darkColor lightColor:(UIColor *)lightColor;
@end

NS_ASSUME_NONNULL_END
