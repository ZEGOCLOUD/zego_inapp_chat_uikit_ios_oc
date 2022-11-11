//
//  ZIMKitLocalAPNS.m
//  ZIMKit
//
//  Created by zego on 2022/7/22.
//

#import "ZIMKitLocalAPNS.h"
#import "ZIMKitEventHandler.h"
#import <UserNotifications/UserNotifications.h>
#import "ZIMMessage+Extension.h"
#import "ZIMKitDefine.h"

@interface ZIMKitLocalAPNS ()
{
    UIBackgroundTaskIdentifier _keepAliveTask;
}

@end


@implementation ZIMKitLocalAPNS

+ (instancetype)shared {
    static ZIMKitLocalAPNS *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZIMKitLocalAPNS alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterForground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)setupLocalAPNS {
    [self removeMessageEventHadle];
    [self addMessageEventHadle];
    
}

- (void)didEnterBackground:(NSNotification *)noti {
    [self startBackgroundTask];
}

/**
 *  Start background delay
 */
- (void)startBackgroundTask {
    UIApplication *application = [UIApplication sharedApplication];
     _keepAliveTask = [application beginBackgroundTaskWithExpirationHandler:^{
         [application endBackgroundTask:self->_keepAliveTask];
    }];
    
    if (_keepAliveTask == UIBackgroundTaskInvalid) {
        return;
    }
}

- (void)didEnterForground:(NSNotification *)noti {
    [[UIApplication sharedApplication] endBackgroundTask: _keepAliveTask];
    _keepAliveTask = UIBackgroundTaskInvalid;
}

- (void)addMessageEventHadle {
    /// Receive single chat message
    @weakify(self);
    [[ZIMKitEventHandler shared] addEventListener:KEY_RECEIVE_PEER_MESSAGE
                                         listener:self
                                         callBack:^(NSDictionary * _Nullable param) {
        @strongify(self);
        NSArray<ZIMMessage *>* messageLlist = param[PARAM_MESSAGE_LIST];
        NSString *fromUserID = param[PARAM_FROM_USER_ID];
        
        [self receiveMessages:messageLlist fromID:fromUserID];
    }];
    
    [[ZIMKitEventHandler shared] addEventListener:KEY_RECEIVE_GROUP_MESSAGE
                                         listener:self
                                         callBack:^(NSDictionary * _Nullable param) {
        @strongify(self);
        NSArray<ZIMMessage *>* messageLlist = param[PARAM_MESSAGE_LIST];
        NSString *fromGroupID = param[PARAM_FROM_GROUP_ID];
        
        [self receiveMessages:messageLlist fromID:fromGroupID];
    }];
    
    [[ZIMKitEventHandler shared] addEventListener:KEY_RECEIVE_ROOM_MESSAGE
                                         listener:self
                                         callBack:^(NSDictionary * _Nullable param) {
        @strongify(self);
        NSArray<ZIMMessage *>* messageLlist = param[PARAM_MESSAGE_LIST];
        NSString *fromRoomID = param[PARAM_FROM_ROOM_ID];
        
        [self receiveMessages:messageLlist fromID:fromRoomID];
    }];
}

- (void)receiveMessages:(NSArray <ZIMMessage *>*)messageLlist fromID:(NSString *)fromID {
    BOOL background = [UIApplication sharedApplication].applicationState == UIApplicationStateBackground;
    
    if (background) {
        //Messages need to be sorted first
        NSArray *list = [messageLlist sortedArrayUsingComparator:^NSComparisonResult(ZIMMessage *obj1, ZIMMessage *obj2) {
            return obj1.timestamp > obj2.timestamp;
        }];
        
        for (ZIMMessage *message in list) {
            [self addLocalNotice:message];
        }
    }
}

- (void)addLocalNotice:(ZIMMessage *)message {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        
        content.body = [message getMessageTypeShorStr];
        content.sound = [UNNotificationSound defaultSound];

        NSString *identifier = @"noticeId";
        content.userInfo = @{@"conversationID" : message.conversationID ?:@"", @"conversationType" : @(message.conversationType)};
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:nil];
        
        [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
            NSLog(@"Successfully added push");
        }];
    }else {
        UILocalNotification *notif = [[UILocalNotification alloc] init];
        notif.alertBody = [message getMessageTypeShorStr];
        notif.userInfo = @{@"conversationID" : message.conversationID ?:@"", @"conversationType" : @(message.conversationType)};
        notif.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    }
}

- (void)removeMessageEventHadle {
    [[ZIMKitEventHandler shared] removeEventListener:KEY_RECEIVE_PEER_MESSAGE listener:self];
    [[ZIMKitEventHandler shared] removeEventListener:KEY_RECEIVE_GROUP_MESSAGE listener:self];
    [[ZIMKitEventHandler shared] removeEventListener:KEY_RECEIVE_ROOM_MESSAGE listener:self];
}
@end
