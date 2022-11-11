//
//  ZIMKitConversationVM.m
//  ZIMKit
//
//  Created by zego on 2022/5/19.
//

#import "ZIMKitConversationVM.h"
#import "ZIMKitEventHandler.h"


@interface ZIMKitConversationVM ()
/// Data loading
@property (nonatomic, assign) uint64_t isLoading;
/// No more data to load
@property (nonatomic, assign) uint64_t isFinished;

/// First load
@property (nonatomic, assign) uint64_t isFirstLoad;

@end

@implementation ZIMKitConversationVM

- (instancetype)init {
    if (self = [super init]) {
        [self addConversationEventHadle];
        self.isFirstLoad = YES;
    }
    return self;
}

- (void)loadConversation:(ZIMKitLoadConversationBlock)completeBlock {
    
    if (self.isFinished) { //Loading, loading completed
        if (completeBlock) {
            completeBlock(self.coversationList, self.isFirstLoad, self.isFinished, nil);
        }
        return;
    }
    
    ZIMConversationQueryConfig *queryCon = [[ZIMConversationQueryConfig alloc] init];
    queryCon.count = 20;
    if (self.coversationList.count) {
        ZIMKitConversationModel *model = self.coversationList.lastObject;
        ZIMConversation *con = [model toZIMConversationModel];
        queryCon.nextConversation = con;
    } else {
        queryCon.nextConversation = nil;
    }
    NSLog(@"------------------loadConversation");
    @weakify(self);
    [[ZIMKitManager shared].zim queryConversationListWithConfig:queryCon callback:^(NSArray<ZIMConversation *> * _Nonnull conversationList, ZIMError * _Nonnull errorInfo) {

        @strongify(self);
        if (errorInfo.code == ZIMErrorCodeSuccess) {
            NSLog(@"------------------loadConversation Success");
            self.isFinished = conversationList.count < queryCon.count ? YES : NO;
            
            NSMutableArray *allData = [NSMutableArray arrayWithArray:self.coversationList];
            for (ZIMConversation *con in conversationList) {
                ZIMKitConversationModel *model = [[ZIMKitConversationModel alloc] init];
                [model fromZIMConversationWith:con];
                if (model && model.conversationID.length) {
                    [allData addObject:model];
                }
            }

            // orderKey resort
            [self sortDataList:allData];
            self.coversationList = allData;
            if (completeBlock) {
                completeBlock(self.coversationList, self.isFirstLoad, self.isFinished, nil);
            }
            
            self.isLoading = NO;
            if (self.isFirstLoad) {
                self.isFirstLoad = NO;
            }
        } else {
            NSLog(@"------------------loadConversation fail %@ code is %ld", errorInfo.message , errorInfo.code);
            if (completeBlock) {
                completeBlock(nil, self.isFirstLoad,self.isFinished, errorInfo);
            }
            
            self.isLoading = NO;
            if (self.isFirstLoad) {
                self.isFirstLoad = NO;
            }
        }
    }];
}

- (void)removeData:(ZIMKitConversationModel *)data
     completeBlock:(ZIMKitConversationBlock)completeBlock {
    NSMutableArray *list = [NSMutableArray arrayWithArray:self.coversationList];
    [list removeObject:data];
    self.coversationList = list;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onConversationListChange:)]) {
        [self.delegate onConversationListChange:self.coversationList];
    }
    
    ZIMConversationDeleteConfig *config = [[ZIMConversationDeleteConfig alloc] init];
    config.isAlsoDeleteServerConversation = YES;
    [ZIMKitManagerZIM deleteConversation:data.conversationID conversationType:data.type config:config callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
        if (completeBlock) {
            completeBlock(errorInfo);
        }
    }];
}

- (void)sortDataList:(NSMutableArray<ZIMKitConversationModel *> *)dataList {
    [dataList sortUsingComparator:^NSComparisonResult(ZIMKitConversationModel *obj1, ZIMKitConversationModel *obj2) {
        return obj1.orderKey < obj2.orderKey;
    }];
}

- (void)clearConversationUnreadMessageCount:(NSString *)conversationID
                           conversationType:(ZIMConversationType)conversationType
                              completeBlock:(ZIMKitConversationBlock)completeBlock {
    [ZIMKitManagerZIM clearConversationUnreadMessageCount:conversationID conversationType:conversationType callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
        if (completeBlock) {
            completeBlock(errorInfo);
        }
    }];
}

- (void)addConversationEventHadle {
    /// Conversation update
    @weakify(self);
    [[ZIMKitEventHandler shared] addEventListener:KEY_CONVERSATION_CHANGED
                                         listener:self
                                         callBack:^(NSDictionary * _Nullable param) {
        @strongify(self);
        NSArray<ZIMConversationChangeInfo *> *conversationChangeInfoList = param[PARAM_CONVERSATION_CHANGED_LIST];
        for (ZIMConversationChangeInfo *changinfo in conversationChangeInfoList) {
            [self conversationChangeWith:changinfo];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(onConversationListChange:)]) {
            [self.delegate onConversationListChange:self.coversationList];
        }
    }];
}

- (void)conversationChangeWith:(ZIMConversationChangeInfo *)changinfo {
    NSMutableArray *list = [NSMutableArray arrayWithArray:self.coversationList];
    
    BOOL isExit = NO;
    ZIMKitConversationModel *temModel = [[ZIMKitConversationModel alloc] init];
    for (ZIMKitConversationModel *mode in list) {
        if ([mode.conversationID isEqualToString:changinfo.conversation.conversationID]) {
            isExit = YES;
            temModel = mode;
            break;
        }
    }
    
    temModel.conversationEvent = changinfo.event;
    
    if (changinfo.event == ZIMConversationEventAdded || changinfo.event == ZIMConversationEventUpdated) {
        
        if (isExit) { /// Updates exist
            [temModel fromZIMConversationWith:changinfo.conversation];
        } else { /// add
            [temModel fromZIMConversationWith:changinfo.conversation];
            [list addObject:temModel];
        }
        
    } else if (changinfo.event == ZIMConversationEventDisabled) {
        
    }
    
    // orderKey sort
    [self sortDataList:list];
    
    self.coversationList = list;
}

- (void)removeConversationEventHadle {
    [[ZIMKitEventHandler shared] removeEventListener:KEY_CONVERSATION_CHANGED listener:self];
}

- (void)clearAllCacheData {
    [self removeConversationEventHadle];
}

- (void)dealloc {
    NSLog(@"ZIMKitConversationVM delloc");
}


@end
