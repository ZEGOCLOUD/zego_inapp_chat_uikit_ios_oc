//
//  ZIMKitFileMessage.h
//  ZIMKit_OC
//
//  Created by zego on 2022/8/25.
//

#import "ZIMKitMediaMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitFileMessage : ZIMKitMediaMessage

- (ZIMFileMessage *)toZIMFileMessageModel;

- (instancetype)initWithFileLocalPath:(NSString *)fileLocalPath;
@end

NS_ASSUME_NONNULL_END
