//
//  ZIMKitRecordView.m
//  ZIMKit_OC
//
//  Created by zego on 2022/8/29.
//

#import "ZIMKitRecordView.h"
#import "ZIMKitDefine.h"
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>

@interface ZIMKitRecordView ()

@property (nonatomic, strong) UIImageView *contentView;
@property (nonatomic, strong) UILabel     *topTimeL;
@property (nonatomic, strong) UIImageView *midImageView;
@property (nonatomic, strong) UILabel     *bottomTipL;

@end

@implementation ZIMKitRecordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor dynamicColor:ZIMKitHexColor(0x000000) lightColor:ZIMKitHexColor(0x000000)] colorWithAlphaComponent:0.5];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.image = [UIImage zegoImageNamed:@"chat_message_record_bg"];
    imageview.alpha = 0.9;
    imageview.frame = CGRectMake(100,self.frame.size.height-118-32,Screen_Width - 100*2,118);
    _contentView = imageview;
    [self addSubview:imageview];
    
    _bottomTipL = [[UILabel alloc] init];
    _bottomTipL.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
    _bottomTipL.textColor = [UIColor dynamicColor:ZIMKitHexColor(0xA4A4A4) lightColor:ZIMKitHexColor(0xA4A4A4)];
    _bottomTipL.textAlignment = NSTextAlignmentCenter;
    _bottomTipL.numberOfLines = 0;
    [_contentView addSubview:_bottomTipL];
    [_bottomTipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-24.0);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.left.mas_equalTo(self.contentView.mas_left).offset(24.0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-24.0);
    }];
    
    _topTimeL = [[UILabel alloc] init];
    _topTimeL.text = [NSString stringWithFormat:[NSBundle ZIMKitlocalizedStringForKey:@"message_voice_touch_tip_timeout"], 10];
    _topTimeL.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
    _topTimeL.textColor = [UIColor dynamicColor:ZIMKitHexColor(0x2A2A2A) lightColor:ZIMKitHexColor(0x2A2A2A)];
    _topTimeL.textAlignment = NSTextAlignmentCenter;
    _topTimeL.numberOfLines = 0;
    _topTimeL.hidden = YES;
    [_contentView addSubview:_topTimeL];
    [_topTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomTipL.mas_top).offset(-17.0);
        make.left.mas_equalTo(self.contentView.mas_left).offset(12.0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-12.0);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    _midImageView = [[UIImageView alloc] init];
    NSString *path = [[UIImage ZIMKitChatBundle] pathForResource:@"chat_message_record_blue.gif" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_imageWithGIFData:data];
    _midImageView.image = image;
    [_midImageView sizeToFit];
    [_contentView addSubview:_midImageView];
    [_midImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(38);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-38);
        make.bottom.mas_equalTo(self.bottomTipL.mas_top).offset(-12.0);
        make.height.mas_equalTo(29.0);
    }];
}

- (void)setStatus:(RecordStatus)status {
    NSString *path = [[UIImage ZIMKitChatBundle] pathForResource:@"chat_message_record_blue.gif" ofType:nil];
    if (status == ZIMKitRecord_Status_Cancel) {
        path = [[UIImage ZIMKitChatBundle] pathForResource:@"chat_message_record_red.gif" ofType:nil];
        self.bottomTipL.text = [NSBundle ZIMKitlocalizedStringForKey:@"message_voice_touch_tip_cancel"];
    } else if (status == ZIMKitRecord_Status_Recording) {
        self.bottomTipL.text = [NSBundle ZIMKitlocalizedStringForKey:@"message_voice_touch_tip_normal"];
    } else if (status == ZIMKitRecord_Status_Timeout) {
        
    }
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_imageWithGIFData:data];
    _midImageView.image = image;
}

- (void)setRecordTimeL:(NSTimeInterval)time {
    if (time >= 50) {
        self.topTimeL.hidden = NO;
        self.midImageView.hidden = YES;
        int seconds = ZIMKitAudioMessageTimeLength - (int)time;
        [self setStatus:ZIMKitRecord_Status_Timeout];
        self.topTimeL.text = [NSString stringWithFormat:[NSBundle ZIMKitlocalizedStringForKey:@"message_voice_touch_tip_timeout"], seconds];
    } else {
        self.topTimeL.hidden = YES;
        self.midImageView.hidden = NO;
    }
    
    if (time >ZIMKitAudioMessageTimeLength) {
        time = ZIMKitAudioMessageTimeLength;
    }
}

- (void)setVoiceValue:(CGFloat)value {
    
}
@end
