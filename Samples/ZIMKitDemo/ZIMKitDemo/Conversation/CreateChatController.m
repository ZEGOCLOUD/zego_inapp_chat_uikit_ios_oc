//
//  CreateChatController.m
//  ZIMKit
//
//  Created by zego on 2022/5/23.
//

#import "CreateChatController.h"
#import "ZIMKitGroupInfo.h"
#import "ZIMKitDefine.h"
#import <Masonry/Masonry.h>
#import <Objc/runtime.h>

@interface CreateChatController ()<UITextFieldDelegate>

/// input  userID/groupID
@property (nonatomic, strong) UITextField *userIDFiled;

/// Group chat name input.
@property (nonatomic, strong) UITextField *chatNameFiled;

/// Input exception reminder label
@property (nonatomic, strong) UILabel *tiplabel;

/// create button
@property (nonatomic, strong) UIButton *createBtn;

@end

@implementation CreateChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
    [self setupNav];
    [self setupViews];
}

/// Start a chat
- (void)createChatAction {
    if (self.createType == ZIMKitCreateChatTypeSingle) {

        NSDictionary *param = @{@"conversationID" : self.userIDFiled.text, @"conversationType" : @(ZIMConversationTypePeer), @"conversationName" : @""};
        self.router.openUrlWithParam(router_chatListUrl, param);
        [self removeSelfVCFromNav];
    } else if (self.createType == ZIMKitCreateChatTypeGroup) {
        
        NSString *groupName = self.userIDFiled.text;
        NSArray *userIDList = [self.chatNameFiled.text componentsSeparatedByString:@";"];
        
        @weakify(self);
        [ZIMKitManager.shared createGroup:groupName userIDList:userIDList callBack:^(ZIMKitGroupInfo * _Nullable groupInfo, NSArray<ZIMErrorUserInfo *> * _Nullable errorUserList, ZIMError * _Nullable errorInfo) {
            @strongify(self);
            if (errorInfo.code == ZIMErrorCodeSuccess) {
                if (errorUserList.count> 0) {
                    NSMutableString *message = [NSMutableString stringWithFormat:@"%@ ",[NSBundle ZIMKitlocalizedStringForKey:@"group_group_user_id_not_exit_w_1"]];
                    
                    NSInteger count = errorUserList.count;
                    if (count == 1) {
                        ZIMErrorUserInfo *info = errorUserList.firstObject;
                        [message appendFormat:@"%@", info.userID];
                    } else {
                        for (int i=0; i<errorUserList.count; i++) {
                            ZIMErrorUserInfo *info = errorUserList[i];
                            if (i<3) {///最多拼接4个ID
                                if (i == count -1 || i == 2) {
                                    [message appendFormat:@"%@", info.userID];
                                } else{
                                    [message appendFormat:@"%@,", info.userID];
                                }
                                
                            } else {
                                [message appendFormat:@"%@", @"..."];
                                break;
                            }
                        }
                    }
                    
                    [message appendString:[NSBundle ZIMKitlocalizedStringForKey:@"group_group_user_id_not_exit_w_2"]];
                    
                    UIAlertController *alter = [UIAlertController alertControllerWithTitle:[NSBundle ZIMKitlocalizedStringForKey:@"group_user_not_exit"] message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *sure = [UIAlertAction actionWithTitle:[NSBundle ZIMKitlocalizedStringForKey:@"common_sure"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alter addAction:sure];
                    [self presentViewController:alter animated:true completion:nil];
                } else {
                    
                    NSDictionary *param = @{@"conversationID" : groupInfo.groupID, @"conversationType" : @(ZIMConversationTypeGroup), @"conversationName" : groupInfo.groupName ?:@""};
                    self.router.openUrlWithParam(router_chatListUrl, param);
                    
                    [self removeSelfVCFromNav];
                }
                
            } else {
                [self.view makeToast:errorInfo.message];
            }
        }];
    } else if (self.createType == ZIMKitCreateChatTypeJoin) {
        NSString *groupID = self.userIDFiled.text;
        
        @weakify(self);
        [ZIMKitManager.shared joinGroup:groupID callBack:^(ZIMKitGroupInfo * _Nullable groupInfo, ZIMError * _Nullable errorInfo) {
            @strongify(self);
            if (errorInfo.code == ZIMErrorCodeSuccess) {
                
                NSDictionary *param = @{@"conversationID" : groupInfo.groupID, @"conversationType" : @(ZIMConversationTypeGroup), @"conversationName" : groupInfo.groupName ?:@""};
                self.router.openUrlWithParam(router_chatListUrl, param);
                
                [self removeSelfVCFromNav];
            } else if (errorInfo.code ==  ZIMErrorCodeGroupModuleGroupDoseNotExist) {
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:[NSBundle ZIMKitlocalizedStringForKey:@"group_group_not_exit"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:[NSBundle ZIMKitlocalizedStringForKey:@"common_sure"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alter addAction:sure];
                [self presentViewController:alter animated:true completion:nil];
            } else {
                [self showErrorinfo:errorInfo];
            }
        }];
    }
}

- (void)showErrorinfo:(ZIMError *)errorInfo {
    if (errorInfo.code == 6000522) {
        [self.view makeToast:[NSBundle ZIMKitlocalizedStringForKey:@"group_join_error_tip"]];
    } else {
        [self.view makeToast:errorInfo.message];
    }
}

- (void)removeSelfVCFromNav {
    NSMutableArray *vcArr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in vcArr) {
       if ([vc isKindOfClass:[CreateChatController class]]) {
           [vcArr removeObject:vc];
           break;
       }
    }
    self.navigationController.viewControllers = vcArr;
}

- (void)setupViews {
    if (self.createType == ZIMKitCreateChatTypeSingle) {
        self.title = [NSBundle ZIMKitlocalizedStringForKey:@"message_create_single_chat"];
        [self.view addSubview:self.userIDFiled];
        [self.view addSubview:self.tiplabel];
        [self.view addSubview:self.createBtn];
        
    } else if (self.createType == ZIMKitCreateChatTypeGroup) {
        self.title = [NSBundle ZIMKitlocalizedStringForKey:@"group_create_group_chat_title"];
        
        [self.view addSubview:self.chatNameFiled];
        [self.view addSubview:self.userIDFiled];
        [self.view addSubview:self.tiplabel];
        [self.view addSubview:self.createBtn];
        _userIDFiled.placeholder = [NSBundle ZIMKitlocalizedStringForKey:@"group_input_group_name"];
        
    } else if (self.createType == ZIMKitCreateChatTypeJoin) {
        self.title = [NSBundle ZIMKitlocalizedStringForKey:@"group_join_group_chat"];

        [self.view addSubview:self.userIDFiled];
        [self.view addSubview:self.createBtn];
        
    }
    
    [self layout];
}

- (void)layout {
    CGFloat topMargin = GetNavAndStatusHight;
    if (self.createType == ZIMKitCreateChatTypeSingle) {
        [self.userIDFiled mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(64.0+topMargin);
            make.left.equalTo(self.view.mas_left).offset(32.0);
            make.right.equalTo(self.view.mas_right).offset(-32.0);
            make.height.mas_equalTo(50.0);
        }];
        if (self.tiplabel.hidden) {
            [self.createBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.userIDFiled.mas_left);
                make.right.mas_equalTo(self.userIDFiled.mas_right);
                make.top.mas_equalTo(self.userIDFiled.mas_bottom).offset(28.0);
                make.height.mas_equalTo(50.0);
            }];
        } else {
            [self.tiplabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.userIDFiled.mas_left).offset(12.0);
                make.right.mas_equalTo(self.userIDFiled.mas_right).offset(-12.0);
                make.top.mas_equalTo(self.userIDFiled.mas_bottom).offset(8.0);
            }];
            
            [self.createBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.userIDFiled.mas_left);
                make.right.mas_equalTo(self.userIDFiled.mas_right);
                make.top.mas_equalTo(self.tiplabel.mas_bottom).offset(28.0);
                make.height.mas_equalTo(50.0);
            }];
        }
        
    } else if (self.createType == ZIMKitCreateChatTypeGroup) {
        [self.userIDFiled mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(44.0+topMargin);
            make.left.equalTo(self.view.mas_left).offset(32.0);
            make.right.equalTo(self.view.mas_right).offset(-32.0);
            make.height.mas_equalTo(50.0);
        }];
        
        [self.chatNameFiled mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.userIDFiled.mas_bottom).offset(12.0);
            make.left.equalTo(self.view.mas_left).offset(32.0);
            make.right.equalTo(self.view.mas_right).offset(-32.0);
            make.height.mas_equalTo(50.0);
        }];
        if (self.tiplabel.hidden) {
            [self.createBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.chatNameFiled.mas_left);
                make.right.mas_equalTo(self.chatNameFiled.mas_right);
                make.top.mas_equalTo(self.chatNameFiled.mas_bottom).offset(41.0);
                make.height.mas_equalTo(50.0);
            }];
        } else {
            
            [self.tiplabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.chatNameFiled.mas_left).offset(12.0);
                make.right.mas_equalTo(self.chatNameFiled.mas_right).offset(-12.0);
                make.top.mas_equalTo(self.chatNameFiled.mas_bottom).offset(8.0);
            }];
            
            [self.createBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.chatNameFiled.mas_left);
                make.right.mas_equalTo(self.chatNameFiled.mas_right);
                make.top.mas_equalTo(self.tiplabel.mas_bottom).offset(28.0);
                make.height.mas_equalTo(50.0);
            }];
        }
        
    } else if (self.createType == ZIMKitCreateChatTypeJoin) {
        [self.userIDFiled mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(64.0+topMargin);
            make.left.equalTo(self.view.mas_left).offset(32.0);
            make.right.equalTo(self.view.mas_right).offset(-32.0);
            make.height.mas_equalTo(50.0);
        }];
        
        [self.createBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.userIDFiled.mas_left);
            make.right.mas_equalTo(self.userIDFiled.mas_right);
            make.top.mas_equalTo(self.userIDFiled.mas_bottom).offset(28.0);
            make.height.mas_equalTo(50.0);
        }];
    }
}

- (void)setupNav {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage ZIMKitGroupImage:@"group_bar_close"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    leftButton.frame = CGRectMake(-15, 0, 44, 44);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [view addSubview:leftButton];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)leftBarButtonClick:(UIButton *)left {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)textFieldChanged:(NSNotification *)noti {
    
    if (self.createType == ZIMKitCreateChatTypeSingle ) {
        if (self.userIDFiled.text.length >= 6 &&  self.userIDFiled.text.length <= 12) {
            _createBtn.enabled = YES;
            _createBtn.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0x3478FC) lightColor:ZIMKitHexColor(0x3478FC)];
            self.tiplabel.hidden = YES;
        } else {
            _createBtn.enabled = NO;
            _createBtn.backgroundColor = [[UIColor dynamicColor:ZIMKitHexColor(0x3478FC) lightColor:ZIMKitHexColor(0x3478FC)] colorWithAlphaComponent:0.5];
             
            self.tiplabel.hidden = !self.userIDFiled.text.length;
        }
        [self layout];
    } else if (self.createType == ZIMKitCreateChatTypeGroup) {
        
        if (self.userIDFiled.text.length > 12) {
            self.userIDFiled.text = [self.userIDFiled.text substringToIndex:12];
        }
        
        BOOL invalid = NO;
        NSArray *userIDList = [self.chatNameFiled.text componentsSeparatedByString:@";"];
        for (NSString *userID in userIDList) {
            if (userID.length <6 || userID.length > 12) {
                invalid = YES;
                break;
            }
        }
        
        if (self.chatNameFiled.text.length >= 6 && !invalid) {
            self.tiplabel.hidden = YES;
        } else {
            self.tiplabel.hidden = !self.chatNameFiled.text.length;
        }
        
        if (self.userIDFiled.text.length > 0 && (self.chatNameFiled.text.length >= 6 && !invalid)) {
            _createBtn.enabled = YES;
            _createBtn.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0x3478FC) lightColor:ZIMKitHexColor(0x3478FC)];
        } else {
            _createBtn.enabled = NO;
            _createBtn.backgroundColor = [[UIColor dynamicColor:ZIMKitHexColor(0x3478FC) lightColor:ZIMKitHexColor(0x3478FC)] colorWithAlphaComponent:0.5];
        }
        [self layout];
    } else if (self.createType == ZIMKitCreateChatTypeJoin) {
        if (self.userIDFiled.text.length > 0) {
            _createBtn.enabled = YES;
            _createBtn.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0x3478FC) lightColor:ZIMKitHexColor(0x3478FC)];
        } else {
            _createBtn.enabled = NO;
            _createBtn.backgroundColor = [[UIColor dynamicColor:ZIMKitHexColor(0x3478FC) lightColor:ZIMKitHexColor(0x3478FC)] colorWithAlphaComponent:0.5];
        }
    }
    
}

- (UITextField *)userIDFiled {
    if (!_userIDFiled) {
        _userIDFiled = [[UITextField alloc] init];
        _userIDFiled.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xF2F2F2) lightColor:ZIMKitHexColor(0xF2F2F2)];
        NSString *plStr = [NSBundle ZIMKitlocalizedStringForKey:@"message_input_user_id"];
        if (self.createType == ZIMKitCreateChatTypeJoin) {
            plStr = [NSBundle ZIMKitlocalizedStringForKey:@"group_input_group_id"];
        }
        _userIDFiled.placeholder = plStr;
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:plStr attributes:@{NSForegroundColorAttributeName : [UIColor dynamicColor:ZIMKitHexColor(0xA4A4A4) lightColor:ZIMKitHexColor(0xA4A4A4)]}];
        _userIDFiled.attributedPlaceholder = placeholderString;
        _userIDFiled.textColor = [UIColor dynamicColor:ZIMKitHexColor(0x2A2A2A) lightColor:ZIMKitHexColor(0x2A2A2A)];
        _userIDFiled.font = [UIFont systemFontOfSize:16.0];
        _userIDFiled.keyboardType = UIKeyboardTypeDefault;
        _userIDFiled.layer.cornerRadius = 8;
        _userIDFiled.delegate = self;
        Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel = object_getIvar(_userIDFiled, ivar);
        placeholderLabel.numberOfLines = 0;
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
        _userIDFiled.leftView = paddingView;
        _userIDFiled.leftViewMode = UITextFieldViewModeAlways;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_userIDFiled];
    }
    return _userIDFiled;
}

- (UITextField *)chatNameFiled {
    if (!_chatNameFiled) {
        _chatNameFiled = [[UITextField alloc] init];
        _chatNameFiled.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xF2F2F2) lightColor:ZIMKitHexColor(0xF2F2F2)];
        _chatNameFiled.placeholder = [NSBundle ZIMKitlocalizedStringForKey:@"group_input_user_id_of_group"];
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:[NSBundle ZIMKitlocalizedStringForKey:@"group_input_user_id_of_group"] attributes:@{NSForegroundColorAttributeName : [UIColor dynamicColor:ZIMKitHexColor(0xA4A4A4) lightColor:ZIMKitHexColor(0xA4A4A4)]}];
        _chatNameFiled.attributedPlaceholder = placeholderString;
        _chatNameFiled.textColor = [UIColor dynamicColor:ZIMKitHexColor(0xF2A2A2A) lightColor:ZIMKitHexColor(0x2A2A2A)];
        _chatNameFiled.font = [UIFont systemFontOfSize:16.0];
        _chatNameFiled.keyboardType = UIKeyboardTypeDefault;
        _chatNameFiled.layer.cornerRadius = 8;
        _chatNameFiled.delegate = self;
        Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel = object_getIvar(_chatNameFiled, ivar);
        placeholderLabel.numberOfLines = 0;
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
        _chatNameFiled.leftView = paddingView;
        _chatNameFiled.leftViewMode = UITextFieldViewModeAlways;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_chatNameFiled];
    }
    return _chatNameFiled;
}

- (UILabel *)tiplabel {
    if (!_tiplabel) {
        _tiplabel = [[UILabel alloc] init];
        _tiplabel.text = [NSBundle ZIMKitlocalizedStringForKey:@"group_input_user_id_error_tip"];
        _tiplabel.textColor = [UIColor dynamicColor:ZIMKitHexColor(0xFF4A50) lightColor:ZIMKitHexColor(0xFF4A50)];;
        _tiplabel.font = [UIFont systemFontOfSize:12.0];
        _tiplabel.numberOfLines = 0;
        _tiplabel.hidden = YES;
    }
    return _tiplabel;
}

- (UIButton *)createBtn {
    if (!_createBtn) {
        _createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_createBtn setTitle:[NSBundle ZIMKitlocalizedStringForKey:@"group_create_chat"] forState:UIControlStateNormal];
        _createBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_createBtn setTitleColor:[UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)] forState:UIControlStateNormal];
        _createBtn.backgroundColor = [[UIColor dynamicColor:ZIMKitHexColor(0x3478FC) lightColor:ZIMKitHexColor(0x3478FC)] colorWithAlphaComponent:0.5];
        _createBtn.enabled = NO;
        _createBtn.layer.cornerRadius = 16.0;
        [_createBtn addTarget:self action:@selector(createChatAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createBtn;
}
@end
