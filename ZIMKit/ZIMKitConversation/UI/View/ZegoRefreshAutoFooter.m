//
//  ZegoRefreshAutoFooter.m
//  ZIMKit
//
//  Created by zego on 2022/6/10.
//

#import "ZegoRefreshAutoFooter.h"


@interface ZegoRefreshAutoFooter ()

@property (strong, nonatomic) UIActivityIndicatorView *loading;

@end

@implementation ZegoRefreshAutoFooter

- (void)prepare
{
    [super prepare];
    self.mj_h = 30;
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}

- (void)placeSubviews
{
    [super placeSubviews];
    self.loading.center = CGPointMake(self.mj_w/2, self.mj_h * 0.5);
}

#pragma mark RefreshState
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            [self.loading stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            [self.loading startAnimating];
            break;
        case MJRefreshStateNoMoreData:
            [self.loading stopAnimating];
            break;
        default:
            break;
    }
}

@end
