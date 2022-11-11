//
//  ZIMKitTextMessage.h
//  ZIMKit
//
//  Created by zego on 2022/5/24.
//

#import "ZIMKitMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitTextMessage : ZIMKitMessage

@property (nonatomic, copy) NSString *message;

- (instancetype)initWith:(NSString *)text;

- (void)fromZIMMessage:(ZIMTextMessage *)message;

- (ZIMTextMessage *)toZIMTextMessageModel;
@end

NS_ASSUME_NONNULL_END
