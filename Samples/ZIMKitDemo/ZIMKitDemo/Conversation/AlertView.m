//
// AlertView.m
//  ZIMKit
//
//  Created by zego on 2022/7/5.
//

#import "AlertView.h"
#import "ZIMKitDefine.h"
#import "ZIMKitTool.h"

#define itemH 50
#define topMargin 12
#define bottomMargin 20
#define lineH 1
#define lineW 24

@interface AlertView ()

/// super view
@property (nonatomic, strong) UIView *parentview;

/// content size
@property (nonatomic, assign) CGSize contentSize;

/// background view
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation AlertView

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superview contentSize:(CGSize)size titles:(NSArray<NSString *> *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor dynamicColor:ZIMKitHexColor(0x000000) lightColor:ZIMKitHexColor(0x000000)] colorWithAlphaComponent:0.2];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
        self.parentview = superview;
        self.contentSize = size;
        self.titles = titles;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    CGFloat height = self.titles.count * itemH + topMargin + bottomMargin;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
    _bgView.frame = CGRectMake(0, self.frame.size.height - height, self.frame.size.width, height);
    
    UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ]  init];
    cornerRadiusLayer.frame = _bgView.bounds;
    cornerRadiusLayer.path = cornerRadiusPath.CGPath;
    _bgView.layer.mask = cornerRadiusLayer;
    [self addSubview:_bgView];
    
    int i = 0;
    for (NSString *title in self.titles) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor dynamicColor:ZIMKitHexColor(0x2A2A2A) lightColor:ZIMKitHexColor(0x2A2A2A)] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:btn];
        btn.frame = CGRectMake(0, i*(itemH + lineH) + topMargin, self.frame.size.width, itemH);
        
        if (i<self.titles.count -1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(lineW, (i+1)*itemH + (i)*lineH + topMargin, self.frame.size.width - lineW*2, lineH)];
            line.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xE6E6E6) lightColor:ZIMKitHexColor(0xE6E6E6)];
            [self.bgView addSubview:line];
        }
        i++;
    }
}

- (void)tap {
    [self dismiss];
}

- (void)btnAction:(UIButton *)sender {
    [self dismiss];
    if (self.actionBlock) {
        self.actionBlock(sender.tag);
    }
}

- (void)show {
    [[ZIMKitTool kit_keyWindow] addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
        self.bgView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
