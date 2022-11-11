//
//  ZegoTabBar.h
//  ZIMKitDemo
//
//  Created by zego on 2022/6/28.
//

#import <UIKit/UIKit.h>

@class ZegoTabBar,ZegoTabBarButton;

#define kTabBarH (IS_iPhoneX ? 85.0f : 61.0f)
#define kTabBarButtonTag 1100

NS_ASSUME_NONNULL_BEGIN

@protocol ZegoTabBarDelegate <NSObject>

- (void)tabBar:(ZegoTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to;

- (void)tabBar:(ZegoTabBar *)tabBar tabBarButtonContentChange:(ZegoTabBarButton *)tabBarButton;


@end

@interface ZegoTabBar : UIView

- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@property (nonatomic, weak) id<ZegoTabBarDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
