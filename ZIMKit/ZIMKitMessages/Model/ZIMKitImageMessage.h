//
//  ZIMKitImageMessage.h
//  ZIMKit
//
//  Created by zego on 2022/7/18.
//

#import "ZIMKitMediaMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitImageMessage : ZIMKitMediaMessage

@property (nonatomic, copy) NSString *thumbnailDownloadUrl;

@property (nonatomic, copy) NSString *thumbnailLocalPath;

@property (nonatomic, copy) NSString *largeImageDownloadUrl;

@property (nonatomic, copy) NSString *largeImageLocalPath;

@property (nonatomic, assign) CGSize originalImageSize;

@property (nonatomic, assign) CGSize largeImageSize;

@property (nonatomic, assign) CGSize thumbnailSize;

@property (nonatomic, strong) UIImage *localImage;

- (instancetype)initWithFileLocalPath:(NSString *)fileLocalPath;

- (void)fromZIMMessage:(ZIMImageMessage *)message;

- (ZIMImageMessage *)toZIMIMageMessageModel;

@end

NS_ASSUME_NONNULL_END
