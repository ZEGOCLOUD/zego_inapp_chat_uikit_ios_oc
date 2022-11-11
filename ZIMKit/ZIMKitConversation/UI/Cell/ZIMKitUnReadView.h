//
//  ZIMKitUnReadView.h
//  ZIMKit
//
//  Created by zego on 2022/5/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitUnReadView : UIView

@property (nonatomic, strong) UILabel *unReadLabel;

- (void)setNum:(NSInteger)num;

@end

NS_ASSUME_NONNULL_END
