//
//  UIImage+KitDemo.h
//  ZIMKitDemo
//
//  Created by zego on 2022/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (KitDemo)

+ (UIImage *)kitDemo_imageName:(NSString *)imageName ;

+(UIImage *)imageFromColor:(UIColor *)color rectSize:(CGRect)Rect;
@end

NS_ASSUME_NONNULL_END
