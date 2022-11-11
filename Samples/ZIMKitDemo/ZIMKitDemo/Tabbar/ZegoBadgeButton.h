//
//  ZegoBadgeButton.h
//  ZIMKitDemo
//
//  Created by zego on 2022/6/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZegoBadgeButton : UIView

@property (nonatomic, copy) NSString *badgeValue;

@property (nonatomic, strong) UILabel *unReadLabel;
@end

NS_ASSUME_NONNULL_END
