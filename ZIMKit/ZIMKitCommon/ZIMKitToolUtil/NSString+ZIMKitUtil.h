//
//  NSString+ZIMKitUtil.h
//  ZIMKit
//
//  Created by zego on 2022/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZIMKitUtil)

/// Time format conversion
/// @param timestamp ms
+ (NSString *)convertDateToStr:(long long )timestamp;


/// Conversation time format conversion
/// @param timestamp timestamp ms
+ (NSString *)conversationConvertDateToStr:(long long )timestamp;

/// NSString is null
/// @param str str
+ (BOOL) isEmpty:(NSString *)str;

/// Regenerate picture name
/// @param extension Picture suffix
+ (NSString *)getCurrentThumbFileName:(NSString *)extension;


/// Regenerate voice name
/// @param extension voice suffix
+ (NSString *)getCurrentVoiceFileName:(NSString *)extension;


/// Regenerate video name
/// @param extension video suffix
+ (NSString *)getCurrentVideoFileName:(NSString *)extension;


/// File size conversion
/// @param value value 
+ (NSString *)fileSizeTransformedValue:(double)value;

@end

NS_ASSUME_NONNULL_END
