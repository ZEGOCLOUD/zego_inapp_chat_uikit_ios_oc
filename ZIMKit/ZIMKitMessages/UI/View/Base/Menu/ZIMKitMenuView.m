//
//  ZIMKitMenuView.m
//  ZIMKit_OC
//
//  Created by zego on 2022/9/21.
//

#import "ZIMKitMenuView.h"
#import "UIView+ZIMKitLayout.h"
#import "ZIMKitDefine.h"
#import "ZIMKitMenuItem.h"

@implementation ZIMKitMenuAction

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image callback:(ZIMKitMenuActionCallback)callback
{
    if (self = [super init]) {
        self.title = title;
        self.image = image;
        self.callback = callback;
    }
    return self;
}

@end

@interface ZIMKitMenuView ()

@property (nonatomic, strong) UIView      *backgroundView;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) NSMutableDictionary *menuCallBack;

@end

@implementation ZIMKitMenuView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.backgroundView];
        [self addSubview:self.arrowView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame targetRect:(CGRect)targetRect {
    [super setFrame:frame];
    CGFloat arrowH = kArrowHeight;
    CGFloat arrowW = kArrowWidth;
     
    if (frame.origin.y > targetRect.origin.y) {//arrow up
        self.backgroundView.frame = CGRectMake(0, arrowH, frame.size.width, frame.size.height - arrowH);
        self.arrowView.image = [UIImage zegoImageNamed:@"chat_message_menuitem_arrow_up"];
        self.arrowView.frame = CGRectMake(targetRect.origin.x-frame.origin.x+0.5*targetRect.size.width, 0, arrowW, arrowH);
        
    } else {//arrow down
        self.backgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height-arrowH);
        self.arrowView.image = [UIImage zegoImageNamed:@"chat_message_menuitem_arrow_down"];
        self.arrowView.frame = CGRectMake(targetRect.origin.x-frame.origin.x+0.5*targetRect.size.width-arrowW/2, self.frame.size.height -arrowH, arrowW, arrowH);
    }
}

- (void)setMenuItems:(NSArray<ZIMKitMenuAction *> *)menuItems {
    _menuItems = menuItems;
    
    [self.menuCallBack removeAllObjects];
    
    NSInteger count = menuItems.count;
    for (int i =0; i<count; i++) {
        ZIMKitMenuAction *menuAction = menuItems[i];
        int row = i / maxColumns;
        int column = i % maxColumns;
        CGFloat itemW = kMenuWidth;
        
        CGFloat x = column*itemW+(column+1)*kMargin;
        CGFloat y = row *kMenuHeight + (row +1)*kMargin;
        
        CGRect rect = CGRectMake(x, y, itemW, kMenuHeight);
        ZIMKitMenuItem *btn = [[ZIMKitMenuItem alloc] initWithFrame:rect title:menuAction.title image:menuAction.image];
        btn.tag = i+1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuItemAction:)];
        [btn addGestureRecognizer:tap];
        [self.backgroundView addSubview:btn];
        
        [self.menuCallBack setObject:menuAction.callback forKey:@(btn.tag)];
    }
}

- (void)menuItemAction:(UITapGestureRecognizer *)tap {
    NSInteger tag = tap.view.tag;
    if ([self.menuCallBack.allKeys containsObject:@(tag)]) {
        ZIMKitMenuActionCallback callback = [self.menuCallBack objectForKey:@(tag)];
        callback();
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:UIMenuControllerWillHideMenuNotification object:nil];
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [[UIColor dynamicColor:ZIMKitHexColor(0x000000) lightColor:ZIMKitHexColor(0x000000)] colorWithAlphaComponent:0.8];
        _backgroundView.layer.cornerRadius = 8.0;
        _backgroundView.layer.masksToBounds = true;
    }
    return _backgroundView;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] init];
    }
    return _arrowView;
}


- (NSMutableDictionary *)menuCallBack {
    if (!_menuCallBack) {
        _menuCallBack = [NSMutableDictionary dictionary];
    }
    return _menuCallBack;
}


@end
