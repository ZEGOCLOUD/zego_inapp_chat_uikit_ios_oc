//
//  ZIMKitInputTextViewInternal.m
//  ZIMKit
//
//  Created by zego on 2022/7/13.
//

#import "ZIMKitInputTextViewInternal.h"

@implementation ZIMKitInputTextViewInternal

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGFloat)contentHeightWithAtrributeString
{
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize maximumSize = CGSizeMake(self.frame.size.width - 9, MAXFLOAT);
    CGRect bounds = [self.attributedText boundingRectWithSize:maximumSize options:options  context:nil];
    return floorf(bounds.size.height);
}


#pragma mark -- UIKeyInput
- (void)deleteBackward {
    [super deleteBackward];
    
    if ([self.input_delegate respondsToSelector:@selector(textViewDeleteBackward:)]) {
        [self.input_delegate textViewDeleteBackward:self];
    }
}

@end
