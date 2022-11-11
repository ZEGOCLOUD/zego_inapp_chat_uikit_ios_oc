//
//  ZIMKitGroupdetailView.m
//  ZIMKit
//
//  Created by zego on 2022/6/9.
//

#import "ZIMKitGroupdetailView.h"
#import "ZIMKitDefine.h"

@interface ZIMKitGroupdetailView ()

@property (nonatomic, copy) NSString *groupID;
@end

@implementation ZIMKitGroupdetailView

- (instancetype)initWithFrame:(CGRect)frame groupID:(NSString *)groupID {
    self = [super initWithFrame:frame];
    if (self) {
        self.groupID = groupID;
        self.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UILabel *labelLeft = [[UILabel alloc] init];
    labelLeft.text = [NSBundle ZIMKitlocalizedStringForKey:@"group_group_id"];
    labelLeft.textColor = [UIColor dynamicColor:ZIMKitHexColor(0x2A2A2A) lightColor:ZIMKitHexColor(0x2A2A2A)];
    labelLeft.font = [UIFont systemFontOfSize:15.0];
    labelLeft.textAlignment = NSTextAlignmentLeft;
    [labelLeft sizeToFit];
    labelLeft.frame = CGRectMake(16, (self.height - labelLeft.height)/2, labelLeft.width, labelLeft.height);
    [self addSubview:labelLeft];
    
    UILabel *labelCopy = [[UILabel alloc] init];
    labelCopy.text = [NSBundle ZIMKitlocalizedStringForKey:@"group_copy"];
    labelCopy.textColor = [UIColor dynamicColor:ZIMKitHexColor(0x666666) lightColor:ZIMKitHexColor(0x666666)];
    labelCopy.font = [UIFont systemFontOfSize:15.0];
    labelCopy.textAlignment = NSTextAlignmentCenter;
    [labelCopy sizeToFit];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCopy)];
    [labelCopy addGestureRecognizer:tap];
    labelCopy.userInteractionEnabled = YES;
    labelCopy.frame = CGRectMake(self.width - 16 -labelCopy.width - 16 , 0, labelCopy.width + 16, self.height);
    [self addSubview:labelCopy];
    
    UILabel *labelID = [[UILabel alloc] init];
    labelID.text = self.groupID;
    labelID.textColor = [UIColor dynamicColor:ZIMKitHexColor(0x9FA1A2) lightColor:ZIMKitHexColor(0x9FA1A2)];
    labelID.font = [UIFont systemFontOfSize:15.0];
    labelID.textAlignment = NSTextAlignmentRight;
    labelID.numberOfLines = 1;
    [labelID sizeToFit];
    labelID.frame = CGRectMake(CGRectGetMaxX(labelLeft.frame) + 16, (self.height - labelID.height)/2, self.width - labelLeft.width - labelCopy.width - 16*4, labelID.height);
    [self addSubview:labelID];
    
}

- (void)tapCopy {
    UIPasteboard *past = [UIPasteboard generalPasteboard];
    [past setString:self.groupID];
    if (self.copyBlock) {
        self.copyBlock();
    }
}
@end
