//
//  AlertView.h
//  ZIMKit
//
//  Created by zego on 2022/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertView : UIView

@property (nonatomic, copy) void(^actionBlock)(NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superview contentSize:(CGSize)size titles:(NSArray<NSString *> *)titles;

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
