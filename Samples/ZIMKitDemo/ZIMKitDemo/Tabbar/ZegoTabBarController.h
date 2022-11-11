//
//  ZegoTabBarController.h
//  ZIMKitDemo
//
//  Created by zego on 2022/6/7.
//

#import <UIKit/UIKit.h>
#import "ZegoBadgeView.h"

@interface ZegoTabBarItem : NSObject
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) ZegoBadgeView *badgeView;
@end

@interface ZegoTabBarController : UITabBarController

@property (nonatomic, strong) NSMutableArray *tabBarItems;
@end

