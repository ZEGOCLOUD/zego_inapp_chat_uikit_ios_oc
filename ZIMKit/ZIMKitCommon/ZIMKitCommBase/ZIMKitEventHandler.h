//
//  ZIMKitEventHandler.h
//  ZIMKit
//
//  Created by zego on 2022/5/19.
//

#import <Foundation/Foundation.h>
#import <ZIM/ZIM.h>

typedef void (^ZIMKitEventCallback)(NSDictionary * _Nullable param);
NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitEventHandler : NSObject<ZIMEventHandler>

+ (instancetype)shared;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// Add event listener
- (void)addEventListener:(NSString *)key listener:(id)listener callBack:(ZIMKitEventCallback)callBack;

/// Remove event listener
- (void)removeEventListener:(NSString *)key listener:(id)listener;
@end

NS_ASSUME_NONNULL_END
