//
//  ZegoTabBarButton.h
//  ZIMKitDemo
//
//  Created by zego on 2022/6/28.
//

#import <UIKit/UIKit.h>

@class ZegoTabBarButton;

NS_ASSUME_NONNULL_BEGIN

@protocol ZegoTabBarButtonDelegate <NSObject>

- (void)tabBarButtonContentChange:(ZegoTabBarButton *)tabBarButton;

@end

@interface ZegoTabBarButton : UIButton
@property (nonatomic, weak) id<ZegoTabBarButtonDelegate> delegate;

@property (nonatomic, strong) UITabBarItem *item;
@end

NS_ASSUME_NONNULL_END
