//
//  NSBundle+ZIMKitUtil.h
//  ZIMKit
//
//  Created by zego on 2022/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (ZIMKitUtil)

+ (NSString *)ZIMKitlocalizedStringForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
