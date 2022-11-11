//
//  ZIMKitMessageModule.m
//  ZIMKit
//
//  Created by zego on 2022/6/30.
//

#import "ZIMKitMessageModule.h"
#import "ZIMKitMessagesListVC.h"
#import "ZIMKitDefine.h"

@implementation ZIMKitMessageModule

+ (void)load {
    [self registerURL];
}

+ (void)registerURL {
    [[ZIMKitRouter shareInstance] registerURLPattern:router_chatListUrl Class:[ZIMKitMessagesListVC class] toHandler:^(id param, UINavigationController *nav, JumpType type, UIViewController *fromVC) {
        
        NSString *conversationID = param[@"conversationID"];
        NSInteger conversationType = [param[@"conversationType"] integerValue];
        NSString *conversationName = param[@"conversationName"];
        ZIMKitMessagesListVC *chatVc = [[ZIMKitMessagesListVC alloc] initWithConversationID:conversationID conversationType:conversationType conversationName:conversationName];

        [self jumpTovc:type nav:nav fromeV:fromVC toVC:chatVc];
    }];
}

@end
