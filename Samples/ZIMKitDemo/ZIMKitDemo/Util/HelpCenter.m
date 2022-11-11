//
//  HelpCenter.m
//  ZIMKitDemo
//
//  Created by zego on 2022/5/19.
//

#import "HelpCenter.h"
#import "KeyCenter.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HelpCenter

+ (NSString *)getUserAvatar:(NSString *)userID {
    if(!userID.length) return nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userinfo = [defaults objectForKey:HelperCenterCacheKey(userID)];
    NSString *userAvatar = userinfo[@"userAvatar"];
    if (!userAvatar) {
        
        NSString *firstStr = [userID substringToIndex:1];
        int asciiCode = [firstStr characterAtIndex:0];
        NSInteger index = asciiCode % 9;
        
        userAvatar = [NSString stringWithFormat:@"https://storage.zego.im/IMKit/avatar/avatar-%ld.png", (long)index];
        if (userAvatar) {
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:userinfo];
            info[@"userAvatar"] = userAvatar;
            [defaults setObject:info forKey:HelperCenterCacheKey(userID)];
        }
    }
    
    return userAvatar;
}

+ (NSString *)getUserNameWith:(NSString *)userID {
    NSString *userName;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userinfo = [defaults objectForKey:HelperCenterCacheKey(userID)];
    userName = userinfo[@"userName"];
    
    if (!userName) {
        // get file path
        NSString *path = [[NSBundle mainBundle] pathForResource:@"user_name" ofType:@"txt"];
        NSString *jsonStr  = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSArray *names = [jsonStr componentsSeparatedByString:@"\n"];
        int port = arc4random() % (names.count -1);
        userName = names[port];
        if (userName) {
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:userinfo];
            info[@"userName"] = userName;
            [defaults setObject:info forKey:HelperCenterCacheKey(userID)];
        }
    }
    
    return userName;
}

//get current ViewController
+ (UIViewController *)currentViewController {
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (1) {
    
        if ([vc isKindOfClass:[UITabBarController class]]) {
        
            vc = ((UITabBarController*)vc).selectedViewController;
        }

        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else {
            break;
        }
    }
    return vc;
}


+ (NSString *)md5:(NSString *)string{
  const char *cStr = [string UTF8String];
  unsigned char digest[CC_MD5_DIGEST_LENGTH];
  
  CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
  
  NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
  for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
    [result appendFormat:@"%02X", digest[i]];
  }
  
  return result;
}
@end
