//
//  ZIMMessage+Extension.m
//  ZIMKit
//
//  Created by zego on 2022/5/20.
//

#import "ZIMMessage+Extension.h"
#import "NSBundle+ZIMKitUtil.h"


@implementation ZIMMessage (Extension)

- (NSString *)getMessageTypeShorStr {
    NSString *shorStr;
    ZIMMessage *msg = self;
    
    switch (self.type) {
        case ZIMMessageTypeText:
        {
            ZIMTextMessage *textMessage = (ZIMTextMessage *)msg;
            shorStr = textMessage.message;
            break;
        }
        case ZIMMessageTypeImage:
        {
            shorStr = [NSBundle ZIMKitlocalizedStringForKey:@"common_message_photo"];
            break;
        }
        case ZIMMessageTypeFile:
        {
            shorStr = [NSBundle ZIMKitlocalizedStringForKey:@"common_message_file"];
            break;
        }
        case ZIMMessageTypeVideo:
        {
            shorStr = [NSBundle ZIMKitlocalizedStringForKey:@"common_message_video"];
            break;
        }
        case ZIMMessageTypeAudio:
        {
            shorStr =[NSBundle ZIMKitlocalizedStringForKey:@"common_message_audio"];
            break;
        }
        case ZIMMessageTypeUnknown:
        {
            shorStr = [NSString stringWithFormat:@"[%@]",[NSBundle ZIMKitlocalizedStringForKey:@"common_message_unknown"]];
            break;
        }
        default:
            break;
    }
    
    return shorStr;
}

@end
