//
//  ZIMKitChatTostView.m
//  ZIMKit_OC
//
//  Created by zego on 2022/9/9.
//

#import "ZIMKitChatTostView.h"
#import "ZIMKitDefine.h"
#import <Masonry/Masonry.h>

@interface ZIMKitChatTostView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel     *textLabel;

@end

@implementation ZIMKitChatTostView

- (instancetype)initWithFrame:(CGRect)frame icon:(UIImage *)icon text:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor dynamicColor:ZIMKitHexColor(0x000000) lightColor:ZIMKitHexColor(0x000000)] colorWithAlphaComponent:0.8];
        self.layer.cornerRadius = 16.0;
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = icon;
        [self addSubview:_iconImageView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
        _textLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        [_textLabel setTextColor:[UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)]];
        _textLabel.text = text;
        [self addSubview:_textLabel];
        
        [self layout];
    }
    return self;
}

- (void)layout {
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40.0);
        make.top.mas_equalTo(self.mas_top).offset(30);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(8.0);
        make.left.mas_equalTo(self.mas_left).offset(25.0);
        make.right.mas_equalTo(self.mas_right).offset(-25.0);
    }];
}

@end
