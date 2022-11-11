//
//  ZIMKitLocalAPNS.h
//  ZIMKit
//
//  Created by zego on 2022/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitLocalAPNS : NSObject

+ (instancetype)shared;

/// setup
- (void)setupLocalAPNS;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
