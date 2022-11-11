//
//  ZIMKitInputTextView.h
//  ZIMKit
//
//  Created by zego on 2022/7/13.
//

#import <UIKit/UIKit.h>
#import "ZIMKitInputTextViewInternal.h"
@class ZIMKitInputTextView;

NS_ASSUME_NONNULL_BEGIN

@protocol  ZIMKitInputTextViewDelegate <NSObject>

@optional
- (BOOL)expandingTextViewShouldBeginEditing:(ZIMKitInputTextView *)expandingTextView;
- (BOOL)expandingTextViewShouldEndEditing:(ZIMKitInputTextView *)expandingTextView;

- (void)expandingTextViewDidBeginEditing:(ZIMKitInputTextView *)expandingTextView;
- (void)expandingTextViewDidEndEditing:(ZIMKitInputTextView *)expandingTextView;

- (void)expandingTextViewDidChange:(ZIMKitInputTextView *)expandingTextView deleteChar:(BOOL)isDeleteChar;

- (void)expandingTextViewDidChangeSelection:(ZIMKitInputTextView *)expandingTextView;

- (void)expandingTextViewDeleteBackward:(ZIMKitInputTextView *)expandingTextView;
@end

@interface ZIMKitInputTextView : UIView<UITextViewDelegate, ZIMKitInputTextViewInternalDelegate>

@property (nonatomic, strong) ZIMKitInputTextViewInternal *internalTextView;

@property (nonatomic, weak) id<ZIMKitInputTextViewDelegate> delegate;

@property (nonatomic, strong) NSString            *text;

@property (nonatomic, strong) NSAttributedString  *attributeText;

@property (nonatomic, strong) UIFont              *font;

@property (nonatomic, strong) UIColor             *textColor;

@property(nonatomic) NSRange                     selectedRange;

@property(nonatomic) BOOL          editable;

@property(nonatomic) UIDataDetectorTypes         dataDetectorTypes;

@property(nonatomic) UIReturnKeyType             returnKeyType;

@property(nonatomic,strong) UIImageView         *textViewBackgroundImage;

- (BOOL)hasText;

- (void)scrollRangeToVisible:(NSRange)range;

- (void)textViewDidChange:(UITextView *)textView;

@end

NS_ASSUME_NONNULL_END
