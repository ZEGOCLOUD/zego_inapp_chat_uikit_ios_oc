//
//  HelpCenter.h
//  ZIMKitDemo
//
//  Created by zego on 2022/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define HelperCenterCacheKey(userId) [NSString stringWithFormat:@"HelperCenter_%@", userId]


@interface HelpCenter : NSObject

// get username
+ (NSString *)getUserNameWith:(NSString *)userID;

// get userAvatar
+ (NSString *)getUserAvatar:(NSString *)userID;

+ (UIViewController *)currentViewController;
@end

NS_ASSUME_NONNULL_END
