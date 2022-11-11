//
//  UIImage+ZIMKitUtil.m
//  ZIMKit
//
//  Created by zego on 2022/5/22.
//

#import "UIImage+ZIMKitUtil.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define kExcelArray @[@"xlsx", @"xlsm", @"xlsb", @"xltx", @"xltm", @"xls", @"xlt", @"xls", @"xml", @"xlr", @"xlw", @"xla", @"xlam"]
#define kZipArray   @[@"rar", @"zip", @"arj", @"gz", @"arj", @"z"]
#define kWordArray  @[@"doc", @"docx", @"rtf", @"dot", @"html", @"tmp", @"wps"]
#define kPptArray   @[@"ppt", @"pptx", @"pptm"]
#define kPdfArray   @[@"pdf"]
#define kTxtArray   @[@"txt"]
#define kVideoArray @[@"mp4", @"m4v", @"mov", @"qt", @"avi", @"flv", @"wmv", @"asf", @"mpeg", @"mpg", @"vob", @"mkv", @"asf", @"rm", @"rmvb", @"vob", @"ts", @"dat",@"3gp",@"3gpp",@"3g2",@"3gpp2",@"webm"]
#define kAudioArray @[@"mp3", @"wma", @"wav", @"mid", @"ape", @"flac", @"ape", @"alac",@"m4a"]
#define kImageArray @[@"tiff", @"heif", @"heic", @"jpg", @"jpeg", @"png", @"gif", @"bmp",@"webp"]

@implementation UIImage (ZIMKitUtil)

+ (NSBundle *)ZIMKitChatBundle
{
    static NSBundle *commonBundle = nil;
    if (commonBundle == nil) {
        commonBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:NSClassFromString(@"ZIMKitNavigationController")] pathForResource:@"ChatResources" ofType:@"bundle"]];
    }
    return commonBundle;
}

+ (nullable instancetype)zegoImageNamed:(nullable NSString *)name
{
    if (name == nil || name.length == 0) {
        return nil;
    }
    
    NSBundle *bundle = [self ZIMKitChatBundle];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

+ (NSBundle *)ZIMKitConversationBundle {
    static NSBundle *conversationBundle = nil;
    if (conversationBundle == nil) {
        conversationBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:NSClassFromString(@"ZIMKitNavigationController")] pathForResource:@"ConversationResources" ofType:@"bundle"]];
    }
    return conversationBundle;
}

+ (UIImage *)ZIMKitConversationImage:(NSString *)imageName {
    if (imageName == nil || imageName.length == 0) {
        return nil;
    }
    NSBundle *bundle = [self ZIMKitConversationBundle];
    UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

+ (NSBundle *)ZIMKitGruopBundle {
    static NSBundle *groupBundle = nil;
    if (groupBundle == nil) {
        groupBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:NSClassFromString(@"ZIMKitNavigationController")] pathForResource:@"GroupResources" ofType:@"bundle"]];
    }
    return groupBundle;
}

+ (UIImage *)ZIMKitGroupImage:(NSString *)imageName {
    if (imageName == nil || imageName.length == 0) {
        return nil;
    }
    NSBundle *bundle = [self ZIMKitGruopBundle];
    UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}


+ (UIImage *)fileIconWithSuffixIconString:(NSString *)suffix
{
    if (!suffix || ![suffix isKindOfClass:[NSString class]]) {
        return [UIImage zegoImageNamed:@"chat_message_file_unknow"];
    }
    
    if ([kExcelArray containsObject:suffix.lowercaseString]) {
        return [UIImage zegoImageNamed:@"chat_message_file_excel"];
    }else if ([kWordArray containsObject:suffix.lowercaseString]) {
        return [UIImage zegoImageNamed:@"chat_message_file_word"];
    }else if ([kPptArray containsObject:suffix.lowercaseString]) {
        return [UIImage zegoImageNamed:@"chat_message_file_ppt"];
    }else if ([kPdfArray containsObject:suffix.lowercaseString]) {
        return [UIImage zegoImageNamed:@"chat_message_file_pdf"];
    }else if ([kZipArray containsObject:suffix.lowercaseString]) {
        return [UIImage zegoImageNamed:@"chat_message_file_compressed"];
    } else if ([kVideoArray containsObject:suffix.lowercaseString]) {
        return [UIImage zegoImageNamed:@"chat_message_file_video"];
    } else if ([kAudioArray containsObject:suffix.lowercaseString]) {
        return [UIImage zegoImageNamed:@"chat_message_file_audio"];
    } else if ([kImageArray containsObject:suffix.lowercaseString]) {
        return [UIImage zegoImageNamed:@"chat_message_file_image"];
    } else if ([kTxtArray containsObject:suffix.lowercaseString]) {
        return [UIImage zegoImageNamed:@"chat_message_file_txt"];
    } else {
        return [UIImage zegoImageNamed:@"chat_message_file_unknow"];
    }
}
@end
