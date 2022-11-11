//
//  ZIMKitGroupDetailController.m
//  ZIMKit
//
//  Created by zego on 2022/6/9.
//

#import "ZIMKitGroupDetailController.h"
#import "ZIMKitGroupdetailView.h"
#import "ZIMKitDefine.h"

@interface ZIMKitGroupDetailController ()

@property (nonatomic, copy) NSString *groupID;

@property (nonatomic, copy) NSString *groupName;

@end

@implementation ZIMKitGroupDetailController

- (instancetype)initWithGroupID:(NSString *)groupID groupName:(NSString *)groupName {
    if (self = [super init]) {
        self.groupID = groupID;
        self.groupName = groupName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.groupName;
    self.view.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xF2F2F2) lightColor:ZIMKitHexColor(0xF2F2F2)];
    
    CGFloat margin = 10;
    if (@available(iOS 16.0, *)) {
        margin = 15;
    }
    CGRect rect = CGRectMake(8, margin+GetNavAndStatusHight, self.view.width - 8*2, 48);

    ZIMKitGroupdetailView *groupdetailView = [[ZIMKitGroupdetailView alloc] initWithFrame:rect groupID:self.groupID];
    groupdetailView.layer.cornerRadius = 8;
    groupdetailView.layer.masksToBounds = true;
    @weakify(self);
    groupdetailView.copyBlock = ^{
        @strongify(self);
        [self.view makeToast:[NSBundle ZIMKitlocalizedStringForKey:@"group_copy_success"]];
    };
    [self.view addSubview:groupdetailView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage zegoImageNamed:@"chat_nav_left"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton.widthAnchor constraintEqualToConstant:40].active = YES;
    [leftButton.heightAnchor constraintEqualToConstant:40].active = YES;
    [leftButton setContentEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)leftBarButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

@end
