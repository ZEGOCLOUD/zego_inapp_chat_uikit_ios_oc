//
//  ZIMKitMessagesListVC+Meida.m
//  ZIMKit_OC
//
//  Created by zego on 2022/8/31.
//

#import "ZIMKitMessagesListVC+Meida.h"
#import "ZIMKitDefine.h"
#import "NSObject+ZIMKitUtil.h"
#import "ZIMKitMessageTool.h"
#import "ZIMKitTool.h"
#import <SDWebImage/SDWebImage.h>
#import <AVKit/AVKit.h>

@implementation ZIMKitMessagesListVC (Meida)
- (void)browseImage:(ZIMKitImageMessage*)message sourceView:(UIImageView *)sourceView {
    if (message.sentStatus == ZIMMessageSentStatusSendSuccess) {
        NSMutableArray *photos = [NSMutableArray new];
        
        GKPhoto *photo = [GKPhoto new];
        photo.url = [NSURL URLWithString:message.largeImageDownloadUrl];
        photo.originUrl = [NSURL URLWithString:message.fileDownloadUrl];
        photo.sourceImageView = sourceView;
        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:message.largeImageDownloadUrl];
        photo.placeholderImage = image ? image : [UIImage zegoImageNamed:@"chat_image_fail_bg"];
        [photos addObject:photo];
        
        GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:0];
        browser.showStyle = GKPhotoBrowserShowStyleZoom;
        browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
        browser.failStyle = GKPhotoBrowserFailStyleOnlyImage;
        browser.loadStyle = GKPhotoBrowserLoadStyleKit;
        browser.failureImage = [UIImage zegoImageNamed:@"chat_image_fail_bg"];
        browser.delegate = self;
        
        [browser showFromVC:self];
    }
}

#pragma mark GKPhotoBrowserDelegate
- (void)photoBrowser:(GKPhotoBrowser *)browser onDwonloadBtnClick:(NSInteger)index image:(UIImage *)image photo:(id)photo {
    GKPhoto *temPhoto = (GKPhoto *)photo;
    
    browser.loadingImageView.hidden = NO;
    browser.loadingImageView.loadingLabel.text = [NSBundle ZIMKitlocalizedStringForKey:@"message_album_downloading_txt"];
    __typeof(browser) __weak weakbrowser = browser;
    @weakify(self);
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:temPhoto.originUrl completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        @strongify(self);
        weakbrowser.loadingImageView.hidden = YES;
        if (finished && !error) {
            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            if (status == PHAuthorizationStatusAuthorized) {
                [[ZIMKitTool kit_keyWindow] makeToast:[NSBundle ZIMKitlocalizedStringForKey:@"message_album_save_success"]];
                NSError *error = nil;
                [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                    PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
                    [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
                } error:&error];
            } else {
                if (@available(iOS 14, *)) {
                    [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
                        [self photoAuthorization];
                    }];
                } else {
                    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                        [self photoAuthorization];
                    }];
                }
            }
            
            
        } else {
            [[ZIMKitTool kit_keyWindow] makeToast:[NSBundle ZIMKitlocalizedStringForKey:@"message_album_save_fail"]];
        }
    }];
}

- (void)photoAuthorization {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_photolibrary_permission_title"] message:[NSBundle ZIMKitlocalizedStringForKey:@"message_photolibrary_permission_desc"] preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_access_later"] style:UIAlertActionStyleCancel handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_go_setting"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIApplication *app = [UIApplication sharedApplication];
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([app canOpenURL:settingsURL]) {
            [app openURL:settingsURL];
        }
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ZIMKitTool currentViewController] presentViewController:ac animated:YES completion:nil];
    });
}

- (void)playVoice:(ZIMKitAudioMessage *)message cell:(ZIMKitAudioMessageCell *)cell {
    NSString *filepath = message.fileLocalPath;
    
    BOOL isDirectory = NO;
    if (filepath.length && [[NSFileManager defaultManager] fileExistsAtPath:filepath isDirectory:&isDirectory]) {
        if (self.curPlayVoiceMessage) {
            NSString *tempPath = self.curPlayVoiceMessage.fileLocalPath;
            
            [self playVoiceEnd];
            
            if([tempPath isEqualToString:message.fileLocalPath]) {
                return;
            }
        }
        
        self.curPlayVoiceMessage = message;
        cell.isPlaying = YES;
        message.isPlaying = YES;
        AVAudioSessionCategory cateory = [[NSUserDefaults standardUserDefaults] objectForKey:ZIMKitSessionCategory(ZIMKitManager.shared.userInfo.userID)];
        [self.voicePlay startPlay:filepath category:cateory];
    } else {
        [self downloadMediaMessage:message complete:nil];
    }
}

- (void)playVoiceEnd {
    if (self.curPlayVoiceMessage) {
        NSInteger index = [self.messageVM.messageList indexOfObject:self.curPlayVoiceMessage];
        if (index != NSNotFound) {
            self.curPlayVoiceMessage.isPlaying = NO;
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
            UITableViewCell *temcell = [self.messageTableView cellForRowAtIndexPath:indexpath];
            if ([temcell isKindOfClass:[ZIMKitAudioMessageCell class]]) {
                ZIMKitAudioMessageCell *audioCell = (ZIMKitAudioMessageCell *)temcell;
                audioCell.isPlaying = NO;
            }
            
            [self.voicePlay stopPlay];
            self.curPlayVoiceMessage = nil;
        }
    }
}

- (void)voicePlayerFinish:(NSString *)path {
    [self playVoiceEnd];
    self.curPlayVoiceMessage = nil;
}

- (void)checkLocalMediaWithMessae:(ZIMKitMessage *)message {
    if (message.type == ZIMMessageTypeAudio || message.type == ZIMMessageTypeFile) {
        ZIMKitMediaMessage *meidaMessage = (ZIMKitMediaMessage *)message;
        
        if (!meidaMessage.isExistLocal && !meidaMessage.downloading) {
            NSString *localFilepath = meidaMessage.fileLocalPath;
            
            BOOL isDirectory = NO;
            if ([[NSFileManager defaultManager] fileExistsAtPath:localFilepath isDirectory:&isDirectory]
                && meidaMessage.fileLocalPath.length ) {
                meidaMessage.isExistLocal = YES;
            } else {
                if (meidaMessage.type == ZIMMessageTypeFile && meidaMessage.fileSize > ZIMKitFileSizeMax) {
                    //Files can only be downloaded less than 10M
                    meidaMessage.isExistLocal = YES;
                    return;
                }
                [self downloadMediaMessage:meidaMessage complete:nil];
            }
        }
    }
}

- (void)playVieoWithUrl:(ZIMKitVideoMessage *)message {
    if (message.sentStatus == ZIMMessageSentStatusSendSuccess) {
        [self playVoiceEnd];
        
        NSURL *playUrl = nil;
        NSString *filepath = message.fileLocalPath;
        if (filepath) {
            playUrl = [NSURL fileURLWithPath:filepath];
        } else {
            playUrl = [NSURL URLWithString:message.fileDownloadUrl];
        }
        
        self.curPlayVideoMessage = message;
        
        AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:playUrl];
        self.avPlayerVC = [[AVPlayerViewController alloc] init];
        self.avPlayerVC.player = avPlayer;
        [self.avPlayerVC.player play];
        [self presentViewController:self.avPlayerVC animated:true completion:^{}];
    }
}

- (void)longPressVideo:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        ZIMKitVideoMessage *videoMessage = self.curPlayVideoMessage;
        
        BOOL isDirectory = NO;
        NSString *filepath =  videoMessage.fileLocalPath;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filepath isDirectory:&isDirectory]
            && filepath.length) {
            [self saveVideoToPhotosAlbum:filepath];
        } else {
            @weakify(self);
            [self.messageVM downloadMediaFileWithMessage:videoMessage progress:^(ZIMMediaMessage * _Nonnull message, unsigned long long currentFileSize, unsigned long long totalFileSize) {
                
            } callback:^(ZIMMediaMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
                @strongify(self);
                if (errorInfo.code == ZIMErrorCodeSuccess) {
                    [self saveVideoToPhotosAlbum:message.fileLocalPath];
                }
            }];
        }
    }
}

- (void)saveVideoToPhotosAlbum:(NSString *)videoFilePath {
    @weakify(self);
    PHPhotoLibrary *photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
    [photoLibrary performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:videoFilePath]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        @strongify(self);
        if (success) {
            [self runInMainThreadSync:^{
                [[ZIMKitTool kit_keyWindow] makeToast:[NSBundle ZIMKitlocalizedStringForKey:@"message_album_save_success"]];
            }];
        } else {
//            [self.view makeToast:[NSBundle ZIMKitlocalizedStringForKey:@"message_album_save_success"]];
        }
    }];
}

- (void)openFileWith:(ZIMKitFileMessage *)fileMessage {
    self.curPreviewFileMessage = fileMessage;
    
    BOOL isDirectory = NO;
    NSString *filepath =  fileMessage.fileLocalPath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath isDirectory:&isDirectory] && filepath.length) {
        [self previewFile:filepath];
    } else {
        @weakify(self);
        [self downloadMediaMessage:fileMessage complete:^(ZIMMediaMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
            @strongify(self);
            if (errorInfo.code == ZIMErrorCodeSuccess) {
                BOOL isDirectory = NO;
                if ([[NSFileManager defaultManager] fileExistsAtPath:message.fileLocalPath isDirectory:&isDirectory] &&
                    self.curPreviewFileMessage.fileLocalPath &&
                    [self.curPreviewFileMessage.fileDownloadUrl isEqualToString:message.fileDownloadUrl]) {
                    [self previewFile:message.fileLocalPath];
                }
            }
            self.curPreviewFileMessage = nil;
        }];
        
        NSInteger index = [self.messageVM.messageList indexOfObject:fileMessage];
        if (index == NSNotFound) {
            return;
        }
        [self.messageTableView beginUpdates];
        [self.messageTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.messageTableView endUpdates];
    }

}

- (void)previewFile:(NSString *)filepath {
    if (self.isSelectMore) { return;}
    
    NSURL *url = [NSURL fileURLWithPath:filepath];
    self.document = [UIDocumentInteractionController interactionControllerWithURL:url];
    self.document.delegate = self;
    [self.document presentPreviewAnimated:NO];
    [self.document presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
    self.curPreviewFileMessage = nil;
}

- (void)downloadMediaMessage:(ZIMKitMediaMessage *)meidaMessage complete:(void(^)(ZIMMediaMessage * _Nonnull message, ZIMError * _Nonnull errorInfo))complete {
    if (!meidaMessage.fileDownloadUrl.length || meidaMessage.downloading) {
        return;
    }
    meidaMessage.downloading = YES;
    
    @weakify(self);
    [self.messageVM downloadMediaFileWithMessage:meidaMessage progress:^(ZIMMediaMessage * _Nonnull message, unsigned long long currentFileSize, unsigned long long totalFileSize) {
        
    } callback:^(ZIMMediaMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
        @strongify(self);
        meidaMessage.downloading = NO;
        NSLog(@"end======================%lld", message.messageID);
        if (errorInfo.code == ZIMErrorCodeSuccess) {
            NSInteger index = [self.messageVM.messageList indexOfObject:meidaMessage];
            if (index == NSNotFound) {
                return;
            }
            [meidaMessage fromZIMMessage:message];
            meidaMessage.isExistLocal = YES;
            [self.messageTableView reloadData];
        }
        
        if (complete) {
            complete(message, errorInfo);
        }
    }];
}


- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller {
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller {
    return self.view.frame;
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}
@end
