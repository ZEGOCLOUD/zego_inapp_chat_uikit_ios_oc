//
//  ZIMKitMenuItem.m
//  ZIMKit_OC
//
//  Created by zego on 2022/9/22.
//

#import "ZIMKitMenuItem.h"
#import "ZIMKitDefine.h"

#import <Masonry/Masonry.h>

@interface ZIMKitMenuItem ()

@property (nonatomic, strong) UIImageView    *icon;
@property (nonatomic, strong) UILabel        *titleL;

@end

@implementation ZIMKitMenuItem

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _icon = [[UIImageView alloc] init];
        _icon.image = image;
        _icon.userInteractionEnabled = true;
        [self addSubview:_icon];
        
        _titleL = [[UILabel alloc] init];
        _titleL.textColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
        _titleL.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.numberOfLines = 2;
        _titleL.text = title;
        [self addSubview:_titleL];
        
        [self layout];
    }
    return self;
}

- (void)layout {
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6.5);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.height.mas_equalTo(32.0);
    }];
    
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(self.frame.size.height - 32-6);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
    }];
}

@end
