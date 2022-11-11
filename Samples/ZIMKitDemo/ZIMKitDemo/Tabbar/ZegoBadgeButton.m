//
//  ZegoBadgeButton.m
//  ZIMKitDemo
//
//  Created by zego on 2022/6/28.
//

#import "ZegoBadgeButton.h"

@implementation ZegoBadgeButton

- (id)init
{
    self = [super init];
    if(self){
        [self setupViews];
        [self defaultLayout];
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    _unReadLabel.text = badgeValue;
    self.hidden = (badgeValue ? NO : YES);
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

    self.layer.cornerRadius = (_unReadLabel.frame.size.height + UnReadView_Margin * 2)/2.0;
    self.layer.masksToBounds = true;
    self.backgroundColor = BSRGBColor(0xFF4A50);
    self.hidden = YES;
}

- (void)defaultLayout
{
    [_unReadLabel sizeToFit];
    CGFloat width = _unReadLabel.frame.size.width + 2 * UnReadView_Margin;
    CGFloat height =  _unReadLabel.frame.size.height + 2 * UnReadView_Margin;
    if(width < height){
        width = height;
    }
    self.bounds = CGRectMake(0, 0, width, height);
    _unReadLabel.frame = self.bounds;
}

@end
