//
//  ZIMKitGroupModule.m
//  ZIMKit
//
//  Created by zego on 2022/6/30.
//

#import "ZIMKitGroupModule.h"
#import "ZIMKitDefine.h"

@implementation ZIMKitGroupModule

+ (void)load {
    [self registerURL];
}

+ (void)registerURL {
    [[ZIMKitRouter shareInstance] registerURLPattern:router_groupDetailUrl Class:[ZIMKitGroupDetailController class] toHandler:^(id param, UINavigationController *nav, JumpType type, UIViewController *fromVC) {
        
        NSString *groupID = param[@"conversationID"];
        NSString *conversationName = param[@"conversationName"];
        ZIMKitGroupDetailController *groupDetailVC = [[ZIMKitGroupDetailController alloc] initWithGroupID:groupID groupName:conversationName];
        [self jumpTovc:type nav:nav fromeV:fromVC toVC:groupDetailVC];
    }];
}

@end
