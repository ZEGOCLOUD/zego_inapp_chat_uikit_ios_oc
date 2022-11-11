//
//  ZIMKitInputTextViewInternal.h
//  ZIMKit
//
//  Created by zego on 2022/7/13.
//

#import <UIKit/UIKit.h>

@class ZIMKitInputTextViewInternal;

NS_ASSUME_NONNULL_BEGIN

@protocol ZIMKitInputTextViewInternalDelegate <NSObject>

- (void)textViewDeleteBackward:(ZIMKitInputTextViewInternal *)textView;

@end

@interface ZIMKitInputTextViewInternal : UITextView

@property (nonatomic, weak) UIResponder *inputNextResponder;

@property (nonatomic, weak) id <ZIMKitInputTextViewInternalDelegate> input_delegate;


- (CGFloat)contentHeightWithAtrributeString;

- (void)deleteBackward;

@end

NS_ASSUME_NONNULL_END
