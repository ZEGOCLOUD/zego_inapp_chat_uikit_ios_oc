//
//  UIColor+ZIMKitUtil.m
//  ZIMKit
//
//  Created by zego on 2022/5/21.
//

#import "UIColor+ZIMKitUtil.h"

@implementation UIColor (ZIMKitUtil)

+ (UIColor *)dynamicColor:(UIColor *)darkColor  lightColor:(UIColor *)lightColor
{
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            switch (traitCollection.userInterfaceStyle) {
                case UIUserInterfaceStyleDark:
                    // Load dark. If no dark night theme is configured, use the default value
                    return darkColor;
                case UIUserInterfaceStyleLight:
                case UIUserInterfaceStyleUnspecified:
                default:
                    return lightColor;
            }
        }];
    } else {
        return lightColor;
    }
}
@end
