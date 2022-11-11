//
//  ZIMKitMenuView.h
//  ZIMKit_OC
//
//  Created by zego on 2022/9/21.
//

#import <UIKit/UIKit.h>

#define maxColumns 4    // 一排4个
#define kMenuHeight 62
#define kMenuWidth 60
#define kArrowWidth 14
#define kArrowHeight 7
#define kMargin 8

typedef void(^ZIMKitMenuActionCallback)(void);

@interface ZIMKitMenuAction : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) ZIMKitMenuActionCallback callback;

- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
                     callback:(ZIMKitMenuActionCallback)callback;
@end

@interface ZIMKitMenuView : UIView

@property (nonatomic, copy) NSArray<ZIMKitMenuAction *> *menuItems;

- (void)setFrame:(CGRect)frame targetRect:(CGRect)targetRect;


@end

