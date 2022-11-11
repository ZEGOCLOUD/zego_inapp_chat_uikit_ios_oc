//
//  ZIMKitGroupdetailView.h
//  ZIMKit
//
//  Created by zego on 2022/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitGroupdetailView : UIView

@property (nonatomic, copy) void (^copyBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame groupID:(NSString *)groupID;
@end

NS_ASSUME_NONNULL_END
