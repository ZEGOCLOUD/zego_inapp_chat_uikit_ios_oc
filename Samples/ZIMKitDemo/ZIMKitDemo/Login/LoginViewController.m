//
//  LoginViewController.m
//  ZIMKitDemo
//
//  Created by zego on 2022/5/18.
//

#import "LoginViewController.h"
#import "KeyCenter.h"
#import "HelpCenter.h"
#import <Objc/runtime.h>

#define inputMaxLenth 12
#define inputMinLenth 6

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *topBgView;       //Top background view
@property (nonatomic, strong) UILabel *topWelcomL;          //Top prompt

@property (nonatomic, strong) UIView *btBgview;             //Bottom background view
@property (nonatomic, strong) UILabel *btTipL;              //Mobile number login
@property (nonatomic, strong) UITextField *btPhoneField;    //Mobile number input box
@property (nonatomic, strong) UILabel *phoneTipL;           //Mobile number input error promp
@property (nonatomic, strong) UILabel *btUserNameLabel;     //username input
@property (nonatomic, strong) UIButton *btLoginBtn;         //login button

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setui];
    [self layout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:animated];
        
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setui {
    [self.view addSubview:self.topBgView];
    [self.view addSubview:self.btBgview];
    
    [self.topBgView addSubview:self.topWelcomL];
    [self.btBgview addSubview:self.btTipL];
    [self.btBgview addSubview:self.btPhoneField];
    [self.btBgview addSubview:self.phoneTipL];
    [self.btBgview addSubview:self.btUserNameLabel];
    [self.btBgview addSubview:self.btLoginBtn];
}

- (void)layout {
    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top);
        make.height.mas_equalTo(212);
    }];
    
    [self.topWelcomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topBgView.mas_left).offset(16.0);
        make.bottom.mas_equalTo(self.topBgView.mas_bottom).offset(-55.0);
        make.right.mas_equalTo(self.topBgView.mas_right).offset(-16.0);
    }];
    
    [self.btBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topBgView.mas_bottom).offset(-24.0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    [self.btTipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.btBgview.mas_left).offset(37.0);
        make.right.mas_equalTo(self.btBgview.mas_right).offset(-37.0);
        make.top.mas_equalTo(self.btBgview.mas_top).offset(40);
    }];

    [self.btPhoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.btBgview.mas_left).offset(37.0);
        make.right.mas_equalTo(self.btBgview.mas_right).offset(-37.0);
        make.top.mas_equalTo(self.btTipL.mas_bottom).offset(12.0);
        make.height.mas_equalTo(50.0);
    }];
    
    [self resetLayout];
    
    [self.btUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.btBgview.mas_left).offset(37.0);
        make.right.mas_equalTo(self.btBgview.mas_right).offset(-37.0);
        make.top.mas_equalTo(self.phoneTipL.mas_bottom).offset(8.0);
    }];

    [self.btLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.btBgview.mas_left).offset(37.0);
        make.right.mas_equalTo(self.btBgview.mas_right).offset(-37.0);
        make.top.mas_equalTo(self.btUserNameLabel.mas_bottom).offset(28.0);
        make.height.mas_equalTo(50.0);
    }];
}

- (void)resetLayout{
    if (self.phoneTipL.hidden) {
        [self.phoneTipL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.btPhoneField);
            make.right.mas_equalTo(self.btPhoneField);
            make.top.mas_equalTo(self.btPhoneField.mas_bottom).offset(8.0);
            make.height.mas_equalTo(0);
        }];
    } else {
        [self.phoneTipL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.btPhoneField);
            make.right.mas_equalTo(self.btPhoneField);
            make.top.mas_equalTo(self.btPhoneField.mas_bottom).offset(8.0);
        }];
    }
    
}

- (void)loginAction {
    [self.btPhoneField resignFirstResponder];
    self.btLoginBtn.enabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //IM login
        [self connectUser:self.btPhoneField.text userName:[HelpCenter getUserNameWith:self.btPhoneField.text]];
    });
}

#pragma mark
- (void)connectUser:(NSString *)userId userName:(NSString *)userName {
    
    NSString *avatarUrl = [HelpCenter getUserAvatar:userId];
    
    ZIMKitUserInfo *userinfo = [[ZIMKitUserInfo alloc] init];
    userinfo.userID = userId;
    userinfo.userName = userName;
    userinfo.userAvatarUrl = avatarUrl;
    
    __weak typeof(self) weakSelf = self;
    
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ZIMKitManager shared] connectUser:userinfo callback:^(ZIMError * _Nonnull errorInfo) {
        [weakSelf.view hideToastActivity];
        weakSelf.btLoginBtn.enabled = YES;
        if (errorInfo.code == 6000104) {
            [weakSelf resetLayout];
            [weakSelf.view makeToast:KitDemoLocalizedString(@"demo_user_login_tip1", LocalizedDemoKey, nil)];
        } else if (errorInfo.code) {
            weakSelf.phoneTipL.hidden = NO;
            [weakSelf resetLayout];
            [weakSelf.view makeToast:errorInfo.message];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
            weakSelf.btUserNameLabel.text = KitDemoLocalizedString(@"demo_user_name", LocalizedDemoKey, nil);
            weakSelf.btPhoneField.text = @"";
        }
    }];
}

- (void)textFieldChanged:(NSNotification *)noti {
    UITextField *textField = noti.object;
    
    if (textField.text.length >= inputMinLenth ) {
        _btLoginBtn.enabled = YES;
        _btLoginBtn.backgroundColor = BSRGBColor(0x3478FC);
        
    } else {
        _btLoginBtn.enabled = NO;
        _btLoginBtn.backgroundColor = [BSRGBColor(0x3478FC) colorWithAlphaComponent:0.5];
        
    }
    
    if (textField.text.length > inputMaxLenth) {
        textField.text = [textField.text substringToIndex:inputMaxLenth];
    }
    
    if (textField.text.length > inputMaxLenth ||
        (textField.text.length < inputMinLenth && textField.text.length !=0)
        ) {
        self.phoneTipL.hidden = NO;
        
    } else {
        self.phoneTipL.hidden = YES;
        self.btUserNameLabel.text = [NSString stringWithFormat:@"%@ %@", KitDemoLocalizedString(@"demo_user_name", LocalizedDemoKey, nil), [HelpCenter getUserNameWith:textField.text]];
    }
    [self resetLayout];
    
}

- (void)tapTop {
    [self.btPhoneField resignFirstResponder];
}

- (void)tapBottom {
    [self.btPhoneField resignFirstResponder];
}

#pragma mark control UI

- (UIImageView *)topBgView {
    if (!_topBgView) {
        _topBgView = [[UIImageView alloc] init];
        _topBgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTop)];
        [_topBgView addGestureRecognizer:tap];
        _topBgView.image = [UIImage kitDemo_imageName:@"img_background"];
    }
    return _topBgView;
}

- (UILabel *)topWelcomL {
    if (!_topWelcomL) {
        _topWelcomL = [[UILabel alloc] init];
        _topWelcomL.text = KitDemoLocalizedString(@"demo_welcome", LocalizedDemoKey, nil);
        _topWelcomL.textColor = BSRGBColor(0xFFFFFF);
        _topWelcomL.numberOfLines = 0;
        _topWelcomL.font = [UIFont systemFontOfSize:23.0 weight:UIFontWeightMedium];
    }
    return _topWelcomL;
}

- (UIView *)btBgview {
    if (!_btBgview) {
        _btBgview = [[UIView alloc] init];
        _btBgview.backgroundColor = BSRGBColor(0xFFFFFF);
        _btBgview.frame = CGRectMake(0, 212-24 , kSCREEN_WIDTH, kSCREEN_HEIGHT-212+24);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBottom)];
        [_btBgview addGestureRecognizer:tap];
            
        // Top left and top right corner
        UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:_btBgview.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(24, 24)];
        CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ]  init];
        cornerRadiusLayer.frame = _btBgview.bounds;
        cornerRadiusLayer.path = cornerRadiusPath.CGPath;
        _btBgview.layer.mask = cornerRadiusLayer;
    }
    return _btBgview;
}

- (UILabel *)btTipL {
    if (!_btTipL) {
        _btTipL = [[UILabel alloc] init];
        _btTipL.text = KitDemoLocalizedString(@"demo_user_id_login", LocalizedDemoKey, nil);
        _btTipL.textColor = BSRGBColor(0x2A2A2A);
        _btTipL.font = [UIFont systemFontOfSize:16.0];
    }
    return _btTipL;
}

- (UITextField *)btPhoneField {
    if (!_btPhoneField) {
        _btPhoneField = [[UITextField alloc] init];
        _btPhoneField.backgroundColor = BSRGBColor(0xF2F2F2);
        _btPhoneField.placeholder = KitDemoLocalizedString(@"demo_input_user_id_error_tips", LocalizedDemoKey, nil);
        _btPhoneField.textColor = BSRGBColor(0x2A2A2A);
        _btPhoneField.font = [UIFont systemFontOfSize:16.0];
        _btPhoneField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _btPhoneField.layer.cornerRadius = 8;
        Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel = object_getIvar(_btPhoneField, ivar);
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.textColor = BSRGBColor(0xA4A4A4);
        placeholderLabel.font = [UIFont systemFontOfSize:15.0];

        _btPhoneField.delegate = self;
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
        _btPhoneField.leftView = paddingView;
        _btPhoneField.leftViewMode = UITextFieldViewModeAlways;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_btPhoneField];
    }
    return _btPhoneField;
}

- (UILabel *)phoneTipL {
    if (!_phoneTipL) {
        _phoneTipL = [[UILabel alloc] init];
        _phoneTipL.text =KitDemoLocalizedString(@"demo_login_error_tips", LocalizedDemoKey, nil);
        _phoneTipL.textColor = BSRGBColor(0xFF4A50);
        _phoneTipL.numberOfLines = 0;
        _phoneTipL.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
        _phoneTipL.hidden = YES;
    }
    return _phoneTipL;
}

- (UILabel *)btUserNameLabel {
    if (!_btUserNameLabel) {
        _btUserNameLabel = [[UILabel alloc] init];
        _btUserNameLabel.text = KitDemoLocalizedString(@"demo_user_name", LocalizedDemoKey, nil);
        _btUserNameLabel.textColor = BSRGBColor(0x2A2A2A);
        _btUserNameLabel.numberOfLines = 0;
        _btUserNameLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _btUserNameLabel;
}

- (UIButton *)btLoginBtn {
    if (!_btLoginBtn) {
        _btLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btLoginBtn setTitle:KitDemoLocalizedString(@"demo_login", LocalizedDemoKey, nil) forState:UIControlStateNormal];
        _btLoginBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_btLoginBtn setTitleColor:BSRGBColor(0xFFFFFF) forState:UIControlStateNormal];
        _btLoginBtn.backgroundColor = [BSRGBColor(0x3478FC) colorWithAlphaComponent:0.5];
        _btLoginBtn.enabled = NO;
        _btLoginBtn.layer.cornerRadius = 8.0;
        [_btLoginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btLoginBtn;
}

@end
