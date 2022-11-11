//
//  ZIMKitConversationVM.h
//  ZIMKit
//
//  Created by zego on 2022/5/19.
//

#import <Foundation/Foundation.h>
#import "ZIMKitConversationModel.h"

typedef void(^ZIMKitLoadConversationBlock) (NSArray<ZIMKitConversationModel *> *_Nullable dataList, BOOL isFirstLoad,                                              BOOL isFinished, ZIMError * _Nullable errorInfo);
typedef void(^ZIMKitConversationBlock) (ZIMError * _Nullable errorInfo);

@protocol ZIMKitConversationVMDelegate <NSObject>

/// Session update
- (void)onConversationListChange:(NSArray<ZIMKitConversationModel *> *_Nullable)conversationList;
@end

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitConversationVM : NSObject

@property (nonatomic, weak) id <ZIMKitConversationVMDelegate>delegate;

/// The number of paged fetches. The default is 100
@property (nonatomic, assign) int pagePullCount;

/// datasource
@property (nonatomic, strong) NSArray<ZIMKitConversationModel *> *coversationList;

- (void)loadConversation:(ZIMKitLoadConversationBlock)completeBlock ;

/// remove data
- (void)removeData:(ZIMKitConversationModel *)data
     completeBlock:(ZIMKitConversationBlock)completeBlock;


/// Clear session unread count
///
/// @param conversationID : session ID.
/// @param conversationType : session type.
/// @param completeBlock : callback
- (void)clearConversationUnreadMessageCount:(NSString *)conversationID
                           conversationType:(ZIMConversationType)conversationType
                              completeBlock:(ZIMKitConversationBlock)completeBlock;

/// Clear the data (the external VC holds the VM and needs to call it when destroying it, otherwise the VM cannot be released)
- (void)clearAllCacheData;
@end

NS_ASSUME_NONNULL_END
