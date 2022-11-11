//
//  ZIMKitMessagesListVC+MessageAction.m
//  ZIMKit_OC
//
//  Created by zego on 2022/9/22.
//

#import "ZIMKitMessagesListVC+MessageAction.h"
#import "ZIMKitMessagesListVC+Meida.h"
#import "ZIMKitTextMessage.h"
#import "ZIMKitChatTostView.h"
#import "UIView+ZIMKitToast.h"
#import "UIImage+ZIMKitUtil.h"
#import "NSBundle+ZIMKitUtil.h"
#import "ZIMKitTool.h"
#import "ZIMKitDefine.h"

@implementation ZIMKitMessagesListVC (MessageAction)

- (void)longPressCellMessage:(ZIMKitMessage *)msg cell:(ZIMKitMessageCell *)cell menuType:(ZIMKitMenuType)menuType {
    if (menuType == ZIMKitMenuTypeDelete) {
        [self.messageToolbar hiddeKeyborad];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_navbar_cancel"]
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_menuitem_delete"]
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction * _Nonnull action)
                                       {
                                            [self deleteMessages:@[msg]];
                                       }];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_delete_tip"] message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (menuType == ZIMKitMenuTypeMuteplay || menuType == ZIMKitMenuTypeSpeakerplay) {
        [self.messageToolbar hiddeKeyborad];
        [self voicePlaySwitchCategory:(ZIMKitAudioMessage *)msg menuType:menuType];
    } else if (menuType == ZIMKitMenuTypeMultiselect) {
        [self multiselect:msg cell:cell];
    } else if (menuType == ZIMKitMenuTypeCopy) {
        if ([msg isKindOfClass:[ZIMKitTextMessage class]]) {
            ZIMKitTextMessage *textMessage = (ZIMKitTextMessage *)msg;
            UIPasteboard *past = [UIPasteboard generalPasteboard];
            [past setString:textMessage.message];
        }
    }
}

- (void)deleteMessages:(NSArray *)messaegs {
    if ([messaegs containsObject:self.curPlayVoiceMessage]) {
        [self playVoiceEnd];
    }
    
    ZIMMessageDeleteConfig *config = [[ZIMMessageDeleteConfig alloc] init];
    config.isAlsoDeleteServerMessage = YES;
    
    [self.messageTableView beginUpdates];
    for (ZIMKitMessage *message in messaegs) {
        NSInteger index = [self.messageVM.messageList indexOfObject:message];
        if (index != NSNotFound) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.messageTableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    [self.messageVM deleteMessage:self.conversationID conversationType:self.conversationType config:config messageList:messaegs callBack:^(ZIMError * _Nullable errorInfo) {}];
    [self.messageTableView endUpdates];
}

- (void)voicePlaySwitchCategory:(ZIMKitAudioMessage*)messsage menuType:(ZIMKitMenuType)menuType {
    UIImage *image;
    NSString *title;
    AVAudioSessionCategory cateory = AVAudioSessionCategoryPlayback;
    
    if (menuType == ZIMKitMenuTypeMuteplay) {
        image = [UIImage zegoImageNamed:@"chat_message_menuitem_muteplay"];
        title = [NSBundle ZIMKitlocalizedStringForKey:@"message_voice_play_switch_mute"];
        cateory = AVAudioSessionCategoryPlayAndRecord;
    } else if (menuType == ZIMKitMenuTypeSpeakerplay) {
        image = [UIImage zegoImageNamed:@"chat_message_menuitem_speakerplay"];
        title = [NSBundle ZIMKitlocalizedStringForKey:@"message_voice_play_switch_playback"];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:cateory forKey:ZIMKitSessionCategory(ZIMKitManager.shared.userInfo.userID)];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[ZIMKitTool kit_keyWindow] showToast:[[ZIMKitChatTostView alloc] initWithFrame:CGRectMake(0, 0, 130, 130) icon:image text:title]];
}

- (void)multiselect:(ZIMKitMessage*)messsage cell:(ZIMKitMessageCell *)cell {
    self.isSelectMore = YES;
    if (![self.selectedMessages containsObject:messsage]) {
        [self.selectedMessages addObject:messsage];
    }
    [self.messageToolbar hiddeKeyborad];
    [self.view endEditing:YES];
    [self.messageToolbar switchMessageToolbarMultiChoose:YES];
    [self tableviewGestureRecognizerRemove:YES];
    [self.messageTableView reloadData];
    
    UIButton *leftButton = self.navigationItem.leftBarButtonItem.customView;
    [leftButton setImage:nil forState:UIControlStateNormal];
    [leftButton setTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_navbar_cancel"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor dynamicColor:ZIMKitHexColor(0x2A2A2A) lightColor:ZIMKitHexColor(0x2A2A2A)] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
}

- (void)cancelMultiChoose {
    self.isSelectMore = NO;
    [self tableviewGestureRecognizerRemove:NO];
    [self.messageToolbar switchMessageToolbarMultiChoose:NO];
    [self.selectedMessages removeAllObjects];

    UIButton *leftButton = self.navigationItem.leftBarButtonItem.customView;
    [leftButton setTitleColor:nil forState:UIControlStateNormal];
    [leftButton setImage:[UIImage zegoImageNamed:@"chat_nav_left"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.messageTableView reloadData];
    });
}
@end
