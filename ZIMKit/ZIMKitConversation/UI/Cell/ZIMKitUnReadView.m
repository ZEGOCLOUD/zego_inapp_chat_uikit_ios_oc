//
//  ZIMKitUnReadView.m
//  ZIMKit
//
//  Created by zego on 2022/5/20.
//

#import "ZIMKitUnReadView.h"
#import "ZIMKitDefine.h"

@implementation ZIMKitUnReadView

- (id)init
{
    self = [super init];
    if(self){
        [self setupViews];
        [self defaultLayout];
    }
    return self;
}

- (void)setNum:(NSInteger)num
{
    NSString *unReadStr = [[NSNumber numberWithInteger:num] stringValue];
    if (num > 99){
        unReadStr = @"99+";
    }
    _unReadLabel.text = unReadStr;
    self.hidden = (num == 0? YES: NO);
    [self defaultLayout];
}

- (void)setupViews
{
    _unReadLabel = [[UILabel alloc] init];
    _unReadLabel.text = @"12";
    _unReadLabel.font = [UIFont systemFontOfSize:9];
    _unReadLabel.textColor = [UIColor whiteColor];
    _unReadLabel.textAlignment = NSTextAlignmentCenter;
    [_unReadLabel sizeToFit];
    [self addSubview:_unReadLabel];

    self.layer.cornerRadius = (_unReadLabel.frame.size.height + ZIMKitUnReadView_Margin_LR * 2)/2.0;
    self.layer.masksToBounds = true;
    self.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFF4A50) lightColor:ZIMKitHexColor(0xFF4A50)];
    self.hidden = YES;
}

- (void)defaultLayout
{
    [_unReadLabel sizeToFit];
    CGFloat width = _unReadLabel.frame.size.width + 2 * ZIMKitUnReadView_Margin_LR;
    CGFloat height =  _unReadLabel.frame.size.height + 2 * ZIMKitUnReadView_Margin_LR;
    if(width < height){
        width = height;
    }
    self.bounds = CGRectMake(0, 0, width, height);
    _unReadLabel.frame = self.bounds;
}

@end
