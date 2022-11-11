//
//  ZIMKitMessagesListVC+InputBar.h
//  ZIMKit
//
//  Created by zego on 2022/7/13.
//

#import "ZIMKitMessagesListVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitMessagesListVC (InputBar)<ZIMKitMessageSendToolbarDelegate,UIDocumentPickerDelegate>

/// Updat tableview frame
- (void)updateTableViewLayout:(BOOL)isReceve;

@end

NS_ASSUME_NONNULL_END
