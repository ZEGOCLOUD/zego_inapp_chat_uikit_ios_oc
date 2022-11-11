//
//  ZIMKitMultiChooseView.m
//  ZIMKit_OC
//
//  Created by zego on 2022/9/26.
//

#import "ZIMKitMultiChooseView.h"
#import "ZIMKitDefine.h"

#import <Masonry/Masonry.h>

@interface ZIMKitMultiChooseView ()

@end

@implementation ZIMKitMultiChooseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xF2F2F2) lightColor:ZIMKitHexColor(0xF2F2F2)];
    self.layer.shadowColor = [[UIColor dynamicColor:ZIMKitHexColor(0x212329) lightColor:ZIMKitHexColor(0x212329)] colorWithAlphaComponent:0.04].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,-2);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 8;
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
    [deleteButton setImage:[UIImage zegoImageNamed:@"chat_message_multichoose_delete"] forState:UIControlStateNormal];
    [deleteButton setTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_menuitem_delete"] forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [deleteButton setTitleColor:[UIColor dynamicColor:ZIMKitHexColor(0xFF4A50) lightColor:ZIMKitHexColor(0xFF4A50)] forState:UIControlStateNormal];
    deleteButton.layer.cornerRadius = 12.0;
    deleteButton.layer.masksToBounds = true;
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.right.mas_equalTo(self.mas_right).offset(-16);
        make.top.mas_equalTo(self.mas_top).offset(8.5);
        make.height.mas_equalTo(44.0);
    }];
}

- (void)deleteAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(multiChooseDelete)]) {
        [self.delegate multiChooseDelete];
    }
}
@end
