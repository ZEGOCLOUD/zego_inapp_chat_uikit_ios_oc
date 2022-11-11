//
//  ZIMKitMediaMessage.m
//  ZIMKit
//
//  Created by zego on 2022/7/18.
//

#import "ZIMKitMediaMessage.h"
#import "ZIMKitManager.h"
#import "ZIMKitDefine.h"

@implementation ZIMKitMediaMessage

- (void)fromZIMMessage:(ZIMMediaMessage *)message {
    [super fromZIMMessage:message];
    self.fileLocalPath = [ZIMKitMediaMessage getCurrentMediaLocalPath:message];
    self.fileDownloadUrl = message.fileDownloadUrl;
    self.fileUID = message.fileUID;
    self.fileName = message.fileName;
    self.fileSize = message.fileSize;
}

- (ZIMMediaMessage *)toZIMMeidaMessageModel {
    ZIMMediaMessage *mediaMessage = [[ZIMMediaMessage alloc] init];
    mediaMessage.fileLocalPath = self.fileLocalPath;
    mediaMessage.fileDownloadUrl = self.fileDownloadUrl;
    return mediaMessage;
}

+ (NSString *)getCurrentMediaLocalPath:(ZIMMediaMessage *)message {
    NSString *mediaLocalPath;
    
    NSString *filepath = message.fileLocalPath;
    if (message.direction == ZIMMessageDirectionSend && filepath.length) {
        NSString *tempath;
        if (message.type == ZIMMessageTypeVideo) {
            tempath = [[ZIMKitManager shared].getVideoPath stringByAppendingPathComponent:filepath.lastPathComponent];
        } else if (message.type == ZIMMessageTypeAudio) {
            tempath = [[ZIMKitManager shared].getVoicePath stringByAppendingPathComponent:filepath.lastPathComponent];
        } else if (message.type == ZIMMessageTypeFile) {
            tempath = [[ZIMKitManager shared].getFilePath stringByAppendingPathComponent:filepath.lastPathComponent];
        } else if (message.type == ZIMMessageTypeImage) {
            tempath = [[ZIMKitManager shared].getImagepath stringByAppendingPathComponent:filepath.lastPathComponent];
        }
        BOOL isDirectory = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:tempath isDirectory:&isDirectory] && tempath.length) {
            mediaLocalPath = tempath;
        }
    }
    
    if (!mediaLocalPath && filepath.length) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
        NSString *libraryCaches = [paths objectAtIndex:0];
        NSArray *components = [filepath componentsSeparatedByString:@"Library/Caches"];
        NSString *sdkCaches = components.lastObject;
        filepath = [libraryCaches stringByAppendingPathComponent:sdkCaches];
        
        BOOL isDirectory = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filepath isDirectory:&isDirectory] && sdkCaches.length) {
            mediaLocalPath = filepath;
        }
    }
    
    return mediaLocalPath;
}


- (CGSize)contentSize {
    CGSize size = [super contentSize];
    return size;
}

- (CGSize)getSizeImage:(CGFloat)w h:(CGFloat)h {
    
    CGFloat maxW = ZIMKitMaxImageWH;
    CGFloat maxH = ZIMKitMaxImageWH;
    
    CGFloat minW = ZIMKitMinImageWH;
    CGFloat minH = ZIMKitMinImageWH;
    
    if (w == 0 && h == 0) {
        return CGSizeMake(maxW, maxH);
    }
    
    if(w > h) {
        h = h/w * maxH;
        h = MAX(h, minH);
        w = maxW;
    } else {
        w = w/h *maxW;
        w = MAX(w, minW);
        h = maxH;
    }
    return CGSizeMake(w, h);
}

@end
