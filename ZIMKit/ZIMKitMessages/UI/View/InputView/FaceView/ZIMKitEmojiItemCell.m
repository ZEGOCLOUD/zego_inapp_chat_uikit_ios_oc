//
//  ZIMKitEmojiItemCell.m
//  ZIMKit
//
//  Created by zego on 2022/7/11.
//

#import "ZIMKitEmojiItemCell.h"
#import <Masonry/Masonry.h>

@implementation ZIMKitEmojiItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _emojiL = [[UILabel alloc] init];
    _emojiL.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_emojiL addGestureRecognizer:tap];
    _emojiL.textColor = [UIColor blackColor];
    _emojiL.textAlignment = NSTextAlignmentCenter;
    _emojiL.font = [UIFont systemFontOfSize:30.0];
    [self.contentView addSubview:_emojiL];
    [_emojiL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

- (void)filldata:(NSString *)text {
    _emojiL.text = text;
}

- (void)tap:(UITapGestureRecognizer *)t {
    if (self.tapEmoji) {
        self.tapEmoji(self.emojiL.text);
    }
}
@end
