//
//  ZIMKitMessagesListVC+MessageAction.h
//  ZIMKit_OC
//
//  Created by zego on 2022/9/22.
//

#import "ZIMKitMessagesListVC.h"
#import "ZIMKitMessageCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitMessagesListVC (MessageAction)

- (void)longPressCellMessage:(ZIMKitMessage *)msg
                        cell:(ZIMKitMessageCell *)cell
                    menuType:(ZIMKitMenuType)menuType;

- (void)deleteMessages:(NSArray *)messaegs;

- (void)cancelMultiChoose;
@end

NS_ASSUME_NONNULL_END
