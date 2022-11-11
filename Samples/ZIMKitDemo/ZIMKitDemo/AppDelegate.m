//
//  AppDelegate.m
//  ZIMKitDemo
//
//  Created by zego on 2022/5/16.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ZegoTabBarController.h"
#import "KeyCenter.h"
#import "HelpCenter.h"
#import "ConversationController.h"
#import <UserNotifications/UserNotifications.h>

#if !DEBUG
#import <Bugly/Bugly.h>
#endif

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[ZIMKitManager shared] initWith:KeyCenter.appID appSign:KeyCenter.appSign];
    
    LoginViewController *loginVc =  [[LoginViewController alloc] init] ;
    self.window.rootViewController = [[ZIMKitNavigationController alloc] initWithRootViewController:loginVc];
    [self configBugly];
    
    //Registration Notice
    [self registerNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"logout" object:nil];
    return YES;
}

- (void)configBugly {
    #if !DEBUG
    BuglyConfig *config = [BuglyConfig new];
    config.blockMonitorEnable = YES;
    [Bugly setUserValue:ZIM.getVersion forKey:@"ZIM_Version"];
    [Bugly startWithAppId:@"81823fe9a0" config:config];
    #endif
}

- (void)loginSuccess {
    self.window.rootViewController = [[ZegoTabBarController alloc] init];
}

- (void)logout {
    LoginViewController *loginVc =  [[LoginViewController alloc] init] ;
    self.window.rootViewController = [[ZIMKitNavigationController alloc] initWithRootViewController:loginVc];
}

- (void)registerNotification {
    UIApplication *application = [UIApplication sharedApplication];
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (error) {
                NSLog(@"request authorization failed");
                return;
            }
            center.delegate = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [application registerForRemoteNotifications];
            });
            NSLog(@"request authorization success");
        }];
    } else {
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}
#pragma mark - <UNUserNotificationCenterDelegate>
/**
   ios  8-10
 */
 -(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if (application.applicationState == UIApplicationStateInactive ) {
        return;
    } else{
        NSDictionary *userInfo = notification.userInfo;
        NSString *conversationID = userInfo[@"conversationID"];
        NSInteger conversationType = [userInfo[@"conversationType"] integerValue];
        [self didlocalNotificationResponse:conversationID conversationType:conversationType conversationName:nil];
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler __IOS_AVAILABLE(10.0) {
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSString *conversationID = userInfo[@"conversationID"];
    NSInteger conversationType = [userInfo[@"conversationType"] integerValue];
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        // remoteNotification
    } else {
        // localNotification
        [self didlocalNotificationResponse:conversationID conversationType:conversationType conversationName:nil];
    }
    completionHandler();
}

- (void)didlocalNotificationResponse:(NSString *)conversationID conversationType:(ZIMConversationType)conversationType conversationName:(NSString *)conversationName {
    UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
    if (![tab isKindOfClass:UITabBarController.class]) {
        return;
    }
    UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
    if (![nav isKindOfClass:UINavigationController.class]) {
        return;
    }
    
    ConversationController *vc = (ConversationController *)nav.viewControllers.firstObject;
    if (![vc isKindOfClass:ConversationController.class]) {
        return;
    }
    UIViewController *currVc = [HelpCenter currentViewController];
    if ([currVc isKindOfClass:ConversationController.class]) {
        ZIMKitMessagesListVC *chatVc = [[ZIMKitMessagesListVC alloc] initWithConversationID:conversationID conversationType:conversationType];
        [currVc.navigationController pushViewController:chatVc animated:true];
    }
}

@end
