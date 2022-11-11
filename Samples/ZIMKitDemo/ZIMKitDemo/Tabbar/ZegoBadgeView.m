//
//  ZegoBadgeView.m
//  ZIMKitDemo
//
//  Created by zego on 2022/6/7.
//

#import "ZegoBadgeView.h"

@interface ZegoBadgeView ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation ZegoBadgeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    CGPoint point = self.center;
    self.label.text = title;
    self.hidden = (title.length == 0);
    
    [self sizeToFit];
    self.center = point;
}

- (void)setupUI {
    self.backgroundColor = BSRGBColor(0xFF4A50);
    [self addSubview:self.label];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    self.layer.cornerRadius = 0.5 * self.bounds.size.height;
}

- (CGSize)sizeThatFits:(CGSize)size {
    [self.label sizeToFit];
    CGFloat width = self.label.bounds.size.width + 8;
    CGFloat height = self.label.bounds.size.height + 2;
    if (width < height) {
        width = height;
    }
    return CGSizeMake( width, height);
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:9];
    }
    return _label;
}


@end
