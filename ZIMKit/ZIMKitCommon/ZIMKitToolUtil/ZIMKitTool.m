//
//  ZIMKitTool.m
//  ZIMKit_OC
//
//  Created by zego on 2022/8/29.
//

#import "ZIMKitTool.h"

@implementation ZIMKitTool

+ (UIViewController *)currentViewController {
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (1) {
    
        if ([vc isKindOfClass:[UITabBarController class]]) {
        
            vc = ((UITabBarController*)vc).selectedViewController;
        }

        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else {
            break;
        }
    }
    return vc;
}

+ (UIWindow *)kit_keyWindow
{
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *windowScene in UIApplication.sharedApplication.connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
                break;
            }
        }
    } else {
        return UIApplication.sharedApplication.keyWindow;
    }
    
    return nil;
}
@end
