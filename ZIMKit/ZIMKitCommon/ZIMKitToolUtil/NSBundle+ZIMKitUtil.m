//
//  NSBundle+ZIMKitUtil.m
//  ZIMKit
//
//  Created by zego on 2022/5/23.
//

#import "NSBundle+ZIMKitUtil.h"

@implementation NSBundle (ZIMKitUtil)

+ (instancetype)ZIMKitCommonBundle
{
    static NSBundle *commonBundle = nil;
    if (commonBundle == nil) {
        commonBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:NSClassFromString(@"ZIMKitNavigationController")] pathForResource:@"CommonResources" ofType:@"bundle"]];
    }
    return commonBundle;
}

+ (NSString *)ZIMKitlocalizedStringForKey:(NSString *)key {
    return [self localizedStringForKey:key value:@""];
}


+ (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *language = [NSLocale preferredLanguages].firstObject;;
        // 如果配置中没有配置语言
        
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans";
            } else { // zh-Hant\zh-HK\zh-TW
                language = @"zh-Hant";
            }
        } else if ([language hasPrefix:@"ko"]) {
            language = @"ko";
        } else if ([language hasPrefix:@"ru"]) {
            language = @"ru";
        } else if ([language hasPrefix:@"uk"]) {
            language = @"uk";
        } else {
            language = @"en";
        }
        bundle = [NSBundle bundleWithPath:[[NSBundle ZIMKitCommonBundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key ?:@"" value:value ?:@"" table:nil];
}
@end
