//
//  ZIMKitMessagesListVC+Meida.h
//  ZIMKit_OC
//
//  Created by zego on 2022/8/31.
//

#import "ZIMKitMessagesListVC.h"
#import "GKPhotoBrowser.h"
#import "ZIMKitImageMessage.h"
#import "ZIMKitAudioMessageCell.h"
#import "ZIMKitVideoMessage.h"
#import "ZIMKitFileMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitMessagesListVC (Meida)<GKPhotoBrowserDelegate, ZIMKitVoicePlayerDelegate,UIDocumentInteractionControllerDelegate>

- (void)browseImage:(ZIMKitImageMessage *)message sourceView:(UIImageView *)sourceView;
- (void)playVoice:(ZIMKitAudioMessage *)message cell:(ZIMKitAudioMessageCell *)cell;
- (void)playVoiceEnd;
- (void)playVieoWithUrl:(ZIMKitVideoMessage *)message;
- (void)openFileWith:(ZIMKitFileMessage *)message;
- (void)checkLocalMediaWithMessae:(ZIMKitMessage *)message;
@end

NS_ASSUME_NONNULL_END
