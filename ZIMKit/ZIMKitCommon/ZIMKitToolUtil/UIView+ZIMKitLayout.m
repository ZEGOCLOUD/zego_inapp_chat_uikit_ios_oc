//
//  UIView+Layout.m
//  ZIMKit
//
//  Created by zego on 2022/5/19.
//  

#import "UIView+ZIMKitLayout.h"
#import "ZIMKitDefine.h"
#import <objc/runtime.h>

@implementation UIView (ZIMKitLayout)

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y {
    return self.frame.origin.y;
}
- (void)setWidth:(CGFloat)w {
    CGRect frame = self.frame;
    frame.size.width = w;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)h {
    CGRect frame = self.frame;
    frame.size.height = h;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

-(CGFloat)centerX {
    return self.center.x;
}

-(CGFloat)centerY {
    return self.center.y;
}

-(void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

-(void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)right {
    return self.superview.width - self.maxX;
}

- (void)setRight:(CGFloat)r {
    self.x += self.right - r;
}

- (CGFloat)bottom {
    return self.superview.height - self.maxY;
}

- (void)setBottom:(CGFloat)b {
    self.y += self.bottom - b;
}

- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}
- (CGFloat)minY {
    return CGRectGetMinY(self.frame);
}
- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)minX {
    return CGRectGetMinX(self.frame);
}

-(UIView *(^)(CGFloat w, CGFloat h))zg_sizeToFitThan {
    @weakify(self);
    return ^(CGFloat w, CGFloat h){
        @strongify(self);
        [self sizeToFit];
        if (self.width < w)
            self.width = w;
        if (self.height < h)
            self.height = h;
        return self;
    };
}

-(UIView *(^)(CGFloat w, CGFloat h))zg_sizeGreaterThanOrEqualTo {
    @weakify(self);
    return ^(CGFloat w, CGFloat h){
        @strongify(self);
        [self sizeToFit];
        if (self.width > w)
            self.width = w;
        if (self.height > h)
            self.height = h;
        return self;
    };
}


- (UIWindow *)getKeyWindow {
    UIWindow* window = nil;
     
    if (@available(iOS 13.0, *))
    {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
        {
            if (windowScene.activationState == UISceneActivationStateForegroundActive)
            {
                window = windowScene.windows.firstObject;

                break;
            }
        }
    }else{
        window = [UIApplication sharedApplication].keyWindow;
    }
    return window;
}
@end
