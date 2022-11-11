//
//  ZIMKitRefreshAutoHeader.m
//  ZIMKit
//
//  Created by zego on 2022/5/31.
//

#import "ZIMKitRefreshAutoHeader.h"
#import "ZIMKitDefine.h"

@interface ZIMKitRefreshAutoHeader()
@property (weak, nonatomic) UILabel *label;

@property (weak, nonatomic) UIActivityIndicatorView *loading;
@end

@implementation ZIMKitRefreshAutoHeader

- (void)prepare
{
    [super prepare];
    
    self.mj_h = 50;
    
    // add label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor dynamicColor:ZIMKitHexColor(0x394256) lightColor:ZIMKitHexColor(0x394256)];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;

    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark
- (void)placeSubviews
{
    [super placeSubviews];

    self.loading.center = CGPointMake(self.mj_w/2 - 20, self.mj_h * 0.5);
    self.label.centerY = self.loading.centerY;
    self.label.x = self.loading.x + self.loading.width;
    self.label.height = self.loading.height;
    self.label.width = 90;
}

#pragma mark scrollView contentOffset change
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];

}

#pragma mark scrollView contentSize change
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark scrollView state
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];

}

#pragma mark Refresh state
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;

    switch (state) {
        case MJRefreshStateIdle:
            [self.loading stopAnimating];
            self.label.text = @"";
            break;
        case MJRefreshStatePulling:
            [self.loading startAnimating];
            break;
        case MJRefreshStateRefreshing:
            self.label.text = [NSBundle ZIMKitlocalizedStringForKey:@"common_loading"];
            [self.loading startAnimating];
            break;
        default:
            break;
    }
}

@end
