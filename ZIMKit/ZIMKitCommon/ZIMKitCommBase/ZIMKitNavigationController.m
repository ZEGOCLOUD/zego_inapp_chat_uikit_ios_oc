//
//  ZIMKitNavigationController.m
//  ZIMKit
//
//  Created by zego on 2022/5/22.
//

#import "ZIMKitNavigationController.h"
#import "ZIMKitDefine.h"

@interface ZIMKitNavigationController ()

@end

@implementation ZIMKitNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = self;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithDefaultBackground];
        appearance.backgroundEffect = nil;
        appearance.backgroundColor =  self.tintColor;

        self.navigationBar.backgroundColor = self.tintColor;
        self.navigationBar.barTintColor = self.tintColor;
        self.navigationBar.barStyle = UIBarStyleDefault;
        self.navigationBar.standardAppearance = appearance;
        
        self.navigationBar.scrollEdgeAppearance = appearance;
    }
    else {
        self.navigationBar.backgroundColor = self.tintColor;
        self.navigationBar.barTintColor = self.tintColor;
        self.navigationBar.barStyle = UIBarStyleDefault;
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xE6E6E6) lightColor:ZIMKitHexColor(0xE6E6E6)];
    [self.navigationBar addSubview:view];
    view.frame = CGRectMake(0, self.navigationBar.bounds.size.height -1, self.navigationBar.bounds.size.width, 1);

    self.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (UIColor *)tintColor {
    return [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
}


- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    //When there is only one controller, gesture is prohibited to prevent jamming
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    if (self.childViewControllers.count > 1) {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
    return YES;
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {
    if (self.childViewControllers.count == 1) {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    if (viewControllers.count > 1) {
        UIViewController *viewController = viewControllers.lastObject;
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super setViewControllers:viewControllers animated:animated];
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count > 1) {
        self.topViewController.hidesBottomBarWhenPushed = NO;
    }

    NSArray<UIViewController *> *viewControllers = [super popToRootViewControllerAnimated:animated];
    return viewControllers;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }

    return YES;
}

@end
