//
//  ZegoTabBarController.m
//  ZIMKitDemo
//
//  Created by zego on 2022/6/7.
//

#import "ZegoTabBarController.h"
#import "ZegoBadgeView.h"
#import "ConversationController.h"
#import "ZegoTabBar.h"

#define  IOS_VERSION  [[[UIDevice currentDevice] systemVersion] floatValue]

@interface ZegoTabBarController ()<ZegoTabBarDelegate>

//@property (nonatomic, strong) ZegoBadgeView *badgeView;

@property (nonatomic, weak) ZegoTabBar *customTabBar;
@end

@implementation ZegoTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTabbar];
    [self setupAllChildViewControllers];
}

// Solve the problem of overlapping tabBars after popToViewControlle
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (IOS_VERSION >= 11.0f) {
        [self changeTabbarH];
        [self deleteSystemTabBarButton];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self changeTabbarH];
    [self deleteSystemTabBarButton];
}


//Delete the UITabBarButton that comes with the system
- (void)deleteSystemTabBarButton {
    for (UIView *supView in self.view.subviews) {
        if ([supView isKindOfClass:NSClassFromString(@"UITabBar")]) {
            for (UIView *child in supView.subviews) {
                if ([child isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                    [child removeFromSuperview];
                }
            }
        }
    }
}

- (void)changeTabbarH {
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = kTabBarH;
    tabFrame.origin.y = self.view.frame.size.height - kTabBarH;
    self.tabBar.frame = tabFrame;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //Remove the tabbar background color
    [self.tabBar setBackgroundImage:[UIImage imageFromColor:[UIColor clearColor] rectSize:CGRectMake(0.0f, 0.0f, kSCREEN_WIDTH, kTabBarH)]];

    [self changeTabbarH];
    [self deleteSystemTabBarButton];
}

- (void)setupTabbar
{
    ZegoTabBar *customTabBar = [[ZegoTabBar alloc] init];
    customTabBar.frame = CGRectMake(0.0f, 0.0f, kSCREEN_WIDTH, kTabBarH);
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
    self.tabBarController.tabBar.translucent = NO;
}

#pragma mark ZegoTabBarDelegate

- (void)tabBar:(ZegoTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to {
    self.selectedIndex = to;
}

- (void)tabBar:(ZegoTabBar *)tabBar tabBarButtonContentChange:(ZegoTabBarButton *)tabBarButton {
    //Solve the problem of occasional overlap of tabBarButton
    [self deleteSystemTabBarButton];
}



- (void)setupAllChildViewControllers {

    ConversationController *conversationListVc = [[ConversationController alloc] init];
    [self setupChildViewController:conversationListVc title:KitDemoLocalizedString(@"demo_message", LocalizedDemoKey, nil) imageName:@"tabbar_message" selectedImageName:@"tabbar_message"];
}

- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selectedImage;
    
    ZIMKitNavigationController *nav = [[ZIMKitNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
    
}


- (UIView *)tabBarContentView:(UITabBarItem *)tabBarItem {
    UIView *bottomView = [tabBarItem valueForKeyPath:@"_view"];
    UIView *contentView = bottomView;
    if (bottomView) {
        __block UIView *targetView = bottomView;
        [bottomView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([subview isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                targetView = subview;
                *stop = YES;
            }
        }];
        contentView = targetView;
    }
    return contentView;
}
@end
