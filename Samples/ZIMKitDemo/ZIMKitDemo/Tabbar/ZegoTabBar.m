//
//  ZegoTabBar.m
//  ZIMKitDemo
//
//  Created by zego on 2022/6/28.
//

#import "ZegoTabBar.h"
#import "ZegoTabBarButton.h"

@interface ZegoTabBar ()<ZegoTabBarButtonDelegate>

@property (nonatomic, weak) ZegoTabBarButton *selectedButton;
@end

@implementation ZegoTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.shadowColor = [BSRGBColor(0x000000) colorWithAlphaComponent:0.2].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,0.5);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 1;
    }
    return self;
}

- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    ZegoTabBarButton *button = [[ZegoTabBarButton alloc] init];
    button.tag = kTabBarButtonTag + self.subviews.count;
    button.delegate = self;
    [self addSubview:button];
    
    button.item = item;
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    if (self.subviews.count == 1) {
        [self buttonClick:button];
    }
}

- (void)buttonClick:(ZegoTabBarButton *)button
{
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:(int)self.selectedButton.tag to:(int)button.tag];
    }
    
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //button frame
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonW = self.frame.size.width / self.subviews.count;
    CGFloat buttonY = 6;
    
    NSMutableArray *subViews = [NSMutableArray arrayWithArray:self.subviews];
    [subViews removeObjectAtIndex:0];
    for (int index = 0; index<self.subviews.count; index++){
        ZegoTabBarButton *button = self.subviews[index];
        if ([button isKindOfClass:[ZegoTabBarButton class]]) {
            CGFloat buttonX = index * buttonW;
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            button.tag = index;
        }
        
    }
}

- (void)pushChat:(NSNotification *)noti {
    
    ZegoTabBarButton *btn = nil;
    for (UIView *tem in self.subviews) {
        if ([tem isKindOfClass:[ZegoTabBarButton class]]) {
            btn = (ZegoTabBarButton *)tem;
            break;
        }
    }
    if (btn) {
        [self buttonClick:btn];
    }
}

#pragma mark ZegoTabBarButtonDelegate
-(void)tabBarButtonContentChange:(ZegoTabBarButton *)tabBarButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:tabBarButtonContentChange:)]) {
        [self.delegate tabBar:self tabBarButtonContentChange:tabBarButton];
    }
}


@end
