//
//  ZIMKitConversationListNoDataView.m
//  ZIMKit
//
//  Created by zego on 2022/5/21.
//

#import "ZIMKitConversationListNoDataView.h"
#import "ZIMKitDefine.h"
#import <Masonry/Masonry.h>

@interface ZIMKitConversationListNoDataView ()

/// Nodata label
@property (nonatomic, strong) UILabel *noDataLabel;

@end

@implementation ZIMKitConversationListNoDataView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _noDataLabel = [[UILabel alloc] init];
    _noDataLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _noDataLabel.textAlignment = NSTextAlignmentCenter;
    _noDataLabel.text = [NSBundle ZIMKitlocalizedStringForKey:@"conversation_empty"];
    _noDataLabel.numberOfLines = 0;
    _noDataLabel.textColor = [UIColor dynamicColor:ZIMKitHexColor(0xA4A4A4) lightColor:ZIMKitHexColor(0xA4A4A4)];
    _noDataLabel.layer.masksToBounds = YES;
    [self addSubview:_noDataLabel];
    
    [self layout];
}

- (void)layout {
    [_noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(self.height*1/3);
    }];
    
}

@end
