//
//  UIView+Layout.h
//  ZIMKit
//
//  Created by zego on 2022/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZIMKitLayout)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;


@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (readonly) CGFloat maxY;
@property (readonly) CGFloat minY;
@property (readonly) CGFloat maxX;
@property (readonly) CGFloat minX;

- (UIView * (^)(CGFloat w, CGFloat h))zg_sizeToFitThan;

-(UIView *(^)(CGFloat w, CGFloat h))zg_sizeGreaterThanOrEqualTo;

- (UIWindow *)getKeyWindow;
@end

NS_ASSUME_NONNULL_END
