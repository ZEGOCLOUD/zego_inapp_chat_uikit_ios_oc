//
//  ZIMKitMediaMessage.h
//  ZIMKit
//
//  Created by zego on 2022/7/18.
//

#import "ZIMKitMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitMediaMessage : ZIMKitMessage

@property (nonatomic, copy) NSString *fileLocalPath;

@property (nonatomic, copy) NSString *fileDownloadUrl;

@property (nonatomic, copy) NSString *fileUID;

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, assign) long long fileSize;

@property (nonatomic, assign) BOOL isExistLocal;

@property (nonatomic, assign) BOOL downloading;

- (void)fromZIMMessage:(ZIMMediaMessage *)message;

/// to ZIM Model
- (ZIMMediaMessage *)toZIMMeidaMessageModel;

- (CGSize)getSizeImage:(CGFloat)w h:(CGFloat)h;

@end

NS_ASSUME_NONNULL_END
