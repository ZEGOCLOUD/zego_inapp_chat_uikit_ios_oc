//
//  ZIMKitBaseModule.m
//  ZIMKit
//
//  Created by zego on 2022/6/30.
//

#import "ZIMKitBaseModule.h"

@implementation ZIMKitBaseModule

+ (void)registerURL {
    
}

+ (void)jumpTovc:(JumpType)type nav:(UINavigationController *)nav fromeV:(UIViewController *)fromVC toVC:(id)toVC urlString:(NSString *)urlStr {
    callBackBlock block = [[[ZIMKitRouter router].cachDict objectForKey:getCachDictKey(urlStr)] objectForKey:backBlockKey];
    if ([toVC isKindOfClass:[UIViewController class]]) {
        ((UIViewController *)toVC).callBackBlock = block;
    }
    
    if ([toVC isKindOfClass:[UINavigationController class]]) {
        ((UINavigationController *)toVC).visibleViewController.callBackBlock = block;
    }
    
    if (type == Push) {
        handlerBlock completion = [ZIMKitRouter shareInstance].dataDict[routerHandlerKey];
        if (completion) {
            completion();
        }
        [nav pushViewController:toVC animated:YES];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [fromVC presentViewController:toVC animated:YES completion:^{
                handlerBlock completion = [ZIMKitRouter shareInstance].dataDict[routerHandlerKey];
                if (completion) {
                    completion();
                }
            }];
        });
    }
}

+ (void)jumpTovc:(JumpType)type nav:(UINavigationController *)nav fromeV:(UIViewController *)fromVC toVC:(id)toVC {
    
    if (type == Push && nav) {
        handlerBlock completion = [ZIMKitRouter shareInstance].dataDict[routerHandlerKey];
        if (completion) {
            completion();
        }
        [nav pushViewController:toVC animated:YES];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [fromVC presentViewController:toVC animated:YES completion:^{
                handlerBlock completion = [ZIMKitRouter shareInstance].dataDict[routerHandlerKey];
                if (completion) {
                    completion();
                }
            }];
        });
    }
}

@end
