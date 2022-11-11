//
//  ZIMKitLoadingView.m
//  ZIMKit
//
//  Created by zego on 2022/7/21.
//

#import "ZIMKitLoadingView.h"
#import "ZIMKitDefine.h"
#import <Masonry/Masonry.h>

@implementation ZIMKitImageDownload

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)] colorWithAlphaComponent:0.1];
        [self addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(16.0);
            make.right.mas_equalTo(self.mas_right).offset(-16.0);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(44.0);
        }];
    }
    return self;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_album_download_image"] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)] forState:UIControlStateNormal];
//        _button.hidden = YES;
        _button.layer.cornerRadius = 12.0;
        _button.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0x3478FC) lightColor:ZIMKitHexColor(0x3478FC)];
        _button.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];
        [_button addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _button;
}

- (void)downloadAction {
    if (self.downloadActionBlock) {
        self.downloadActionBlock();
    }
}

@end

@implementation ZIMKitLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.loadingImageView];
        [self addSubview:self.loadingLabel];
        
        [self.loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.loadingImageView.mas_bottom).offset(15.0);
            make.centerX.mas_equalTo(self.loadingImageView.mas_centerX);
        }];
    }
    return self;
}


- (UIImageView *)loadingImageView {
    if (!_loadingImageView) {
        _loadingImageView = [UIImageView new];
        _loadingImageView.image = [UIImage zegoImageNamed:@"chat_loading"];
        [_loadingImageView sizeToFit];
        _loadingImageView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        
        CABasicAnimation *rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
        rotationAnimation.duration = 1;
        rotationAnimation.repeatCount = HUGE_VALF;
        rotationAnimation.removedOnCompletion = NO;
        [_loadingImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
    return _loadingImageView;
}

- (UILabel *)loadingLabel {
    if (!_loadingLabel) {
        _loadingLabel           = [UILabel new];
        _loadingLabel.font      = [UIFont systemFontOfSize:13.0f];
        _loadingLabel.textColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
        _loadingLabel.text      = [NSBundle ZIMKitlocalizedStringForKey:@"message_album_loading_txt"];;
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        [_loadingLabel sizeToFit];
        
    }
    return _loadingLabel;
}
@end
