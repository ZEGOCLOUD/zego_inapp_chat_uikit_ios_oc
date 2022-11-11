//
//  ZegoTabBarButton.m
//  ZIMKitDemo
//
//  Created by zego on 2022/6/28.
//

#import "ZegoTabBarButton.h"
#import "ZegoBadgeButton.h"

// 图标的比例
#define XWTabBarButtonImageRatio 1.0f

// 按钮的默认文字颜色
#define  XWTabBarButtonTitleColor (iOS7 ? [UIColor blackColor] : [UIColor whiteColor])
// 按钮的选中文字颜色
#define  XWTabBarButtonTitleSelectedColor (iOS7 ? BSColor(234, 103, 7) : BSColor(248, 139, 0))

@interface ZegoTabBarButton ()

// 提醒数字
@property (nonatomic, weak) ZegoBadgeButton *badgeButton;

@end

@implementation ZegoTabBarButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect imageRect = self.imageView.frame;
    CGRect titleRect = self.titleLabel.frame;
    
    imageRect.origin.x = 0.0f;
    imageRect.origin.y = 5.0f;
    imageRect.size.width = self.frame.size.width;

    titleRect.origin.x = 0.0f;
    titleRect.origin.y = imageRect.origin.y + imageRect.size.height+4;
    titleRect.size.width = self.frame.size.width;
    
    self.imageView.frame = imageRect;
    self.titleLabel.frame = titleRect;
    
    CGFloat badgeY = 0;
    CGFloat badgeX = (self.frame.size.width - self.item.image.size.width) / 2.0f + self.item.image.size.width - 6.0f;
    CGRect badgeF = self.badgeButton.frame;
    badgeF.origin.x = badgeX;
    badgeF.origin.y = badgeY;
    self.badgeButton.frame = badgeF;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
        [self setTitleColor:BSRGBColor(0x666666) forState:UIControlStateNormal];
        [self setTitleColor:BSRGBColor(0x666666) forState:UIControlStateSelected];
    
        ZegoBadgeButton *badgeButton = [[ZegoBadgeButton alloc] init];
        badgeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:badgeButton];
        self.badgeButton = badgeButton;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {}

- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    
    // KVO
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

- (void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setTitle:self.item.title forState:UIControlStateSelected];
    [self setTitle:self.item.title forState:UIControlStateNormal];
    
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    
    self.badgeButton.badgeValue = self.item.badgeValue;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarButtonContentChange:)]) {
        [self.delegate tabBarButtonContentChange:self];
    }
}


@end
