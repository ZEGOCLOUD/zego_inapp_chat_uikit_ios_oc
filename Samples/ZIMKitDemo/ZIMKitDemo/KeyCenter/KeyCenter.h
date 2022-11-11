//
//  KeyCenter.h
//  ZIMKitDemo
//
//  Created by zego on 2022/5/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyCenter : NSObject

@property (class, assign, readonly) unsigned int appID;

@property (class, copy, readonly,nonnull) NSString *appSign;

@end

NS_ASSUME_NONNULL_END
