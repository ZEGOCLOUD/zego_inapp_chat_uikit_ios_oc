//
//  ZIMKitLoadingView.h
//  ZIMKit
//
//  Created by zego on 2022/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitImageDownload : UIView

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, copy)  void(^downloadActionBlock)(void);

@end

@interface ZIMKitLoadingView : UIView

@property (nonatomic, strong) UIImageView   *loadingImageView;
@property (nonatomic, strong) UILabel       *loadingLabel;

@end

NS_ASSUME_NONNULL_END
