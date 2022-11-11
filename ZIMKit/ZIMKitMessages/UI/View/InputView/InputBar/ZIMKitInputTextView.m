//
//  ZIMKitInputTextView.m
//  ZIMKit
//
//  Created by zego on 2022/7/13.
//

#import "ZIMKitInputTextView.h"
#import "ZIMKitDefine.h"

#define kTextInsetX 4
#define kTextInsetY 0

#define kTextNumberOfLines 6
#define kMinimumLineHeight 20

@interface ZIMKitInputTextView ()
@property (nonatomic) CGFloat            minimumHeight;//textview min height
@property (nonatomic) CGFloat            maximumHeight;//textview max height
@property (nonatomic, assign) BOOL isDeleteChar;

@end

@implementation ZIMKitInputTextView

@synthesize text = _text;
@synthesize font = _font;
@synthesize textColor = _textColor;


- (void)dealloc
{
    _minimumHeight = 0;
    _maximumHeight = 0;
    _internalTextView = nil;
    _delegate = nil;
    _text = nil;
    _font = nil;
    _textColor = nil;
    _textViewBackgroundImage = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        CGRect backgroundFrame = frame;
        backgroundFrame.origin.y = 0;
        backgroundFrame.origin.x = 0;
        
        CGRect textViewFrame = CGRectInset(backgroundFrame, kTextInsetX, kTextInsetY);
        self.internalTextView = [[ZIMKitInputTextViewInternal alloc] initWithFrame:textViewFrame];
        self.internalTextView.delegate = self;
        self.internalTextView.input_delegate = self;
        self.internalTextView.layer.cornerRadius = 12.0;
        self.internalTextView.layer.masksToBounds = YES;
        self.internalTextView.opaque = NO;
        self.internalTextView.showsHorizontalScrollIndicator = NO;
        self.internalTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.internalTextView.backgroundColor =  [UIColor dynamicColor:ZIMKitHexColor(0xF2F2F2)
                                                            lightColor:ZIMKitHexColor(0xF2F2F2)];
        
        NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle new];
        pStyle.lineBreakMode = NSLineBreakByCharWrapping;
        pStyle.minimumLineHeight = kMinimumLineHeight;
        self.internalTextView.typingAttributes = @{NSParagraphStyleAttributeName:pStyle, NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor blackColor]};
        
        self.textViewBackgroundImage = [[UIImageView alloc] initWithFrame:backgroundFrame];
        [self addSubview:self.textViewBackgroundImage];
        [self addSubview:self.internalTextView];
        
        self.minimumHeight = self.internalTextView.frame.size.height;
        self.maximumHeight = kMinimumLineHeight*(kTextNumberOfLines - 1) + self.minimumHeight;
    }
    return self;
}

- (void)setFrame:(CGRect)aframe
{
    CGRect backgroundFrame   = aframe;
    backgroundFrame.origin.y = 0;
    backgroundFrame.origin.x = 0;
    self.textViewBackgroundImage.frame = backgroundFrame;

    [super setFrame:aframe];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(expandingTextViewDidChange:deleteChar:)])
    {
        [self.delegate expandingTextViewDidChange:self deleteChar:self.isDeleteChar];
    }
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    return [self.internalTextView resignFirstResponder];
}

#pragma mark UITextView properties
- (void)setAttributeText:(NSAttributedString *)attributeText {
    self.internalTextView.attributedText = attributeText;
    [self performSelector:@selector(textViewDidChange:) withObject:self.internalTextView];
}

- (void)setText:(NSString *)atext {
    self.internalTextView.text = atext;
    [self.internalTextView scrollRangeToVisible:NSMakeRange(self.internalTextView.text.length - 1, self.internalTextView.text.length)];
    [self performSelector:@selector(textViewDidChange:) withObject:self.internalTextView];
}

- (NSString*)text {
    return self.internalTextView.text;
}

- (NSAttributedString *)attributeText {
    return self.internalTextView.attributedText;
}

- (void)setFont:(UIFont *)afont {
    self.internalTextView.font= afont;
}

- (UIFont *)font {
    return self.internalTextView.font;
}

- (void)setTextColor:(UIColor *)color {
    self.internalTextView.textColor = color;
}

- (UIColor*)textColor {
    return self.internalTextView.textColor;
}

- (void)setSelectedRange:(NSRange)range {
    self.internalTextView.selectedRange = range;
}

- (NSRange)selectedRange {
    return self.internalTextView.selectedRange;
}

- (void)setEditable:(BOOL)beditable {
    self.internalTextView.editable = beditable;
}

- (BOOL)isEditable {
    return self.internalTextView.editable;
}

- (void)setReturnKeyType:(UIReturnKeyType)keyType {
    self.internalTextView.returnKeyType = keyType;
}

- (UIReturnKeyType)returnKeyType {
    return self.internalTextView.returnKeyType;
}

- (void)setDataDetectorTypes:(UIDataDetectorTypes)datadetector {
    self.internalTextView.dataDetectorTypes = datadetector;
}

- (UIDataDetectorTypes)dataDetectorTypes {
    return self.internalTextView.dataDetectorTypes;
}

- (BOOL)hasText {
    return [self.internalTextView hasText];
}

- (void)scrollRangeToVisible:(NSRange)range {
    [self.internalTextView scrollRangeToVisible:range];
}

#pragma mark UIExpandingTextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(expandingTextViewShouldBeginEditing:)]) {
        return [self.delegate expandingTextViewShouldBeginEditing:self];
    }
    else{
        return YES;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(expandingTextViewShouldEndEditing:)]) {
        return [self.delegate expandingTextViewShouldEndEditing:self];
    } else {
        return YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(expandingTextViewDidBeginEditing:)]){
        [self.delegate expandingTextViewDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(expandingTextViewDidEndEditing:)]){
        [self.delegate expandingTextViewDidEndEditing:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)atext {
    NSString *currentText = textView.text;
    if(![textView hasText] && [atext isEqualToString:@""]) {
        return NO;
    }
    if ([atext isEqualToString:@""]) {
        self.isDeleteChar = YES;
    } else {
        self.isDeleteChar = NO;
    }
    if (range.length+range.location != currentText.length) {
        return YES;
    }
    
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(expandingTextViewDidChangeSelection:)]){
        [self.delegate expandingTextViewDidChangeSelection:self];
    }
}

- (void)textViewDeleteBackward:(ZIMKitInputTextViewInternal *)textView {
    if ([self.delegate respondsToSelector:@selector(expandingTextViewDeleteBackward:)]) {
        [self.delegate expandingTextViewDeleteBackward:self];
    }
}

- (void)textViewChangeLine:(ZIMKitInputTextViewInternal *)textView selectRange:(NSRange)selectRange{
    textView.selectedRange = NSMakeRange(selectRange.location+1, 0);
}

@end
