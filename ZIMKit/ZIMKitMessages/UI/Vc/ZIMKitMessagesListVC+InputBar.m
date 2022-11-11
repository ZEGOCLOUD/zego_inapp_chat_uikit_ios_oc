//
//  ZIMKitMessagesListVC+InputBar.m
//  ZIMKit
//
//  Created by zego on 2022/7/13.
//

#import "ZIMKitMessagesListVC+InputBar.h"
#import "ZIMKitMessagesListVC+MessageAction.h"
#import "ZIMKitDefine.h"
#import "NSString+ZIMKitUtil.h"
#import "ZIMKitImageMessage.h"
#import "ZIMKitVideoMessage.h"
#import "ZIMKitFileMessage.h"
#import "ZIMKitMessagesListVC+Meida.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <SDWebImage/SDWebImage.h>
#import <TZImagePickerController/TZImagePickerController.h>

@implementation ZIMKitMessagesListVC (InputBar)

- (void)updateTableViewLayout:(BOOL)isReceve {
    CGRect tRect = self.messageTableView.frame;
    CGFloat heiht = self.messageToolbar.inputBar.y;
    tRect.size.height = heiht;
    
    self.messageTableView.frame = tRect;
    
    [self scrollToBottom:NO];
}

#pragma mark ZIMKitMessageSendToolbarDelegate
- (void)messageToolbarInputFrameChange {
    [self updateTableViewLayout:NO];
}

- (void)messageToolbarSendTextMessage:(NSString *)text {
    [self sendAction:text];
}

- (void)messageToolbarDidSelectedMoreViewItemAction:(ZIMKitFunctionType)type {
    if (type == ZIMKitFunctionTypePhoto) {
        [self imagePicker];
    } else if (type == ZIMKitFunctionTypeFile) {
        [self selectFilePicker];
    }
}

- (void)messageToolbarDidSendVoice:(NSString *)path duration:(int)duration {
    ZIMKitAudioMessage *message = [[ZIMKitAudioMessage alloc] initWithFileLocalPath:path audioDuration:duration];
    [self sendMediaMessage:message];
}

- (void)messageToolbarVoiceRecorderDidBegin:(NSString *)path {
    [self playVoiceEnd];
}

- (void)messageToolbarMultiChooseDelete {
    NSArray *multiChooseMessages = [self.selectedMessages copy];
    if (multiChooseMessages.count == 0) {
        return;
    } else {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_navbar_cancel"]
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_menuitem_delete"]
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction * _Nonnull action)
                                       {
                                            [self deleteMessages:multiChooseMessages];
                                            [self cancelMultiChoose];
                                       }];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSBundle ZIMKitlocalizedStringForKey:@"message_delete_tip"] message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)sendImageMessage:(NSData *)data fileName:(NSString *)fileName{
    NSString *path = [self.messageVM getImagepath];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString getCurrentThumbFileName:fileName]];
    
    UIImage *image;
    if ([NSData sd_imageFormatForImageData:data] == SDImageFormatGIF) {
        [data writeToFile:filePath atomically:YES];
        image = [UIImage sd_imageWithGIFData:data];
        
    } else if ([NSData sd_imageFormatForImageData:data] == SDImageFormatHEIC ||
               [NSData sd_imageFormatForImageData:data] == SDImageFormatHEIF) {
        image = [UIImage imageWithData:data];
        NSData *temData = UIImageJPEGRepresentation(image, 0.75);
        filePath = [NSString stringWithFormat:@"%@.JPG", [filePath stringByDeletingPathExtension]];
        [temData writeToFile:filePath atomically:YES];
    } else  {
       image = [UIImage imageWithData:data];
       [data writeToFile:filePath atomically:YES];
   }
        
    ZIMKitImageMessage *imageMessage = [[ZIMKitImageMessage alloc] initWithFileLocalPath:filePath];
    imageMessage.thumbnailSize = image.size;
    imageMessage.localImage = image;
    
    [self sendMediaMessage:imageMessage];
}

- (void)sendVieoMessage:(UIImage *)coverImage
         coverImageName:(NSString *)coverImageName
              voidepath:(NSString *)videopath
               duration:(int)duration {
    NSString *path = [ZIMKitManager shared].getVideoPath;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *coverImagepath = [path stringByAppendingPathComponent:[NSString getCurrentThumbFileName:coverImageName]];
    [coverImage.sd_imageData writeToFile:coverImagepath atomically:YES];
    
    NSData *videoData = [NSData dataWithContentsOfFile:videopath];
    NSString *videLocalPath = [[ZIMKitManager shared].getVideoPath stringByAppendingPathComponent:[NSString getCurrentVideoFileName:videopath.lastPathComponent.lowercaseString]];
    [[NSFileManager defaultManager] createFileAtPath:videLocalPath contents:videoData attributes:nil];
        
    ZIMKitVideoMessage *videoMessage = [[ZIMKitVideoMessage alloc] initWithFileLocalPath:videLocalPath audioDuration:duration];
    videoMessage.videoFirstFrameSize = coverImage.size;
    videoMessage.videoFirstFrameLocalPath = coverImagepath;
    
    [self sendMediaMessage:videoMessage];
}

- (void)sendFileMessage:(ZIMKitFileMessage *)fileMessage {
    [self sendMediaMessage:fileMessage];
}
#pragma mark select photo
- (void)imagePicker {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:nil pushPhotoPickerVc:YES];

    imagePickerVc.navigationBar.translucent = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPreview = YES;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    imagePickerVc.statusBarStyle = UIStatusBarStyleDefault;
    imagePickerVc.navigationBar.barStyle = UIBarStyleBlack;
    imagePickerVc.navigationBar.barTintColor = UIColor.whiteColor;
    imagePickerVc.navigationBar.tintColor = UIColor.darkGrayColor;
    imagePickerVc.barItemTextColor = UIColor.darkGrayColor;
    imagePickerVc.naviTitleColor = UIColor.darkGrayColor;
    imagePickerVc.navigationItem.backBarButtonItem = [UIBarButtonItem new];
    
    //Theme color
    UIColor *themeColor = [UIColor dynamicColor:ZIMKitHexColor(0x3478FC) lightColor:ZIMKitHexColor(0x3478FC)];
    imagePickerVc.oKButtonTitleColorNormal = themeColor;
    imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    
    imagePickerVc.iconThemeColor = themeColor;
    imagePickerVc.showSelectedIndex = YES;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (int i=0; i<assets.count; i++) {
            PHAsset *asset = assets[i];
            NSArray *resources = [PHAssetResource assetResourcesForAsset:asset];
            NSString *orgFilename = ((PHAssetResource*)resources[0]).originalFilename;
            PHAssetResource * resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];

            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                [self sendImageMessage:imageData fileName:orgFilename];
            }];
        }
    }];
    
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
        PHAssetResource * resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
        // file:///var/mobile/Media/DCIM/165APPLE/IMG_5225.MOV
        NSURL *videoFileURL = [resource valueForKey:@"privateFileURL"];
        NSTimeInterval interval = asset.duration;
        
        NSString *videopath = videoFileURL.path;
        NSString *coverImageName = [NSString stringWithFormat:@"%@.JPG", [videopath.lastPathComponent stringByDeletingPathExtension]];
        
        [self sendVieoMessage:coverImage coverImageName:coverImageName voidepath:videopath duration:round(interval)];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIViewController *vc in imagePickerVc.childViewControllers) {
            vc.navigationItem.backBarButtonItem = [UIBarButtonItem new];
            vc.navigationItem.leftBarButtonItem = [UIBarButtonItem new];
        }
    });
}

- (void)selectFilePicker {
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[(NSString *)kUTTypeData] inMode:UIDocumentPickerModeOpen];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    [url startAccessingSecurityScopedResource];
    NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] init];
    NSError *error;
    @weakify(self)
    [coordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
        @strongify(self)
        
        NSData *fileData = [NSData dataWithContentsOfURL:url];
        if (!fileData.length) {
            [self.view makeToast:[NSBundle ZIMKitlocalizedStringForKey:@"message_file_send_empty_msg"]];
            return;
        }
        NSString *fileName = [url lastPathComponent];
        NSString *filePath = [[ZIMKitManager shared].getFilePath stringByAppendingPathComponent:fileName];
        if ([NSFileManager.defaultManager fileExistsAtPath:filePath]) {
            int i = 0;
            NSArray *arrayM = [NSFileManager.defaultManager subpathsAtPath:[ZIMKitManager shared].getFilePath];
            for (NSString *sub in arrayM) {
                if ([sub.pathExtension isEqualToString:fileName.pathExtension] &&
                    [sub.stringByDeletingPathExtension containsString:fileName.stringByDeletingPathExtension]) {
                    i++;
                }
            }
            
            if (i) {
                fileName = [fileName stringByReplacingOccurrencesOfString:fileName.stringByDeletingPathExtension withString:[NSString stringWithFormat:@"%@(%d)", fileName.stringByDeletingPathExtension, i]];
                filePath = [[ZIMKitManager shared].getFilePath stringByAppendingPathComponent:fileName];
            }
        }
        
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileData attributes:nil];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            ZIMKitFileMessage *fileMessage = [[ZIMKitFileMessage alloc] initWithFileLocalPath:filePath];
            [self sendFileMessage:fileMessage];
        }
    }];
    [url stopAccessingSecurityScopedResource];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
