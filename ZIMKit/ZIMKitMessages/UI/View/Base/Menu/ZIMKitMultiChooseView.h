//
//  ZIMKitMultiChooseView.h
//  ZIMKit_OC
//
//  Created by zego on 2022/9/26.
//

#import <UIKit/UIKit.h>

@protocol ZIMKitMultiChooseViewDelegate <NSObject>

- (void)multiChooseDelete;
@end

@interface ZIMKitMultiChooseView : UIView

@property (nonatomic, weak) id<ZIMKitMultiChooseViewDelegate> delegate;

@end

