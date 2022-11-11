//
//  ZIMKitManager.m
//  ZIMKit
//
//  Created by zego on 2022/5/18.
//

#import "ZIMKitManager.h"
#import "ZIMKitEventHandler.h"
#import "ZIMKitDefine.h"

@interface ZIMKitManager ()

@property (nonatomic, strong, readwrite) ZIM *zim;
@property (nonatomic, strong, readwrite) ZIMKitUserInfo *userInfo;
@end

@implementation ZIMKitManager

+ (instancetype)shared {
    static ZIMKitManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZIMKitManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addManagerEventHadle];
    }
    return self;
}

- (void)initWith:(int)appID appSign:(nonnull NSString *)appSign {
    ZIMAppConfig *config = [ZIMAppConfig new];
    config.appID = appID;
    config.appSign = appSign;
    self.zim = ZIM.getInstance ? ZIM.getInstance : [ZIM createWithAppConfig:config];
    [self.zim setEventHandler:[ZIMKitEventHandler shared]];
    NSLog(@"ZIM 已经初始化了-----");
}

- (void)destroy {
    [self.zim destroy];
}

- (void)connectUser:(ZIMKitUserInfo *)userInfo
     callback:(ZIMKitConnectUserCallBlock)callback {
    self.userInfo = userInfo;
    
    ZIMUserInfo *zimInfo = [[ZIMUserInfo alloc] init];
    zimInfo.userID = userInfo.userID;
    zimInfo.userName = userInfo.userName;
    @weakify(self);
    [self.zim loginWithUserInfo:zimInfo token:@"" callback:^(ZIMError * _Nonnull errorInfo) {
        @strongify(self);
        [self createCachePath];
        if (callback) {
            callback(errorInfo);
        }
        if (errorInfo.code == ZIMErrorCodeSuccess) {
            [ZIMKitManager.shared updateUserAvatarUrl:userInfo.userAvatarUrl callback:^(NSString * _Nonnull userAvatarUrl, ZIMError * _Nonnull errorInfo) {}];
        }
    }];
}

- (void)addManagerEventHadle {
    @weakify(self);
    [ZIMKitEventHandler.shared addEventListener:KEY_CONNECTION_STATE_CHANGED listener:self callBack:^(NSDictionary * _Nullable param) {
        @strongify(self);
        ZIMConnectionState state = [param[PARAM_STATE] intValue];
        ZIMConnectionEvent event = [param[PARAM_EVENT] intValue];
        if (self.delegate && [self.delegate respondsToSelector:@selector(onConnectionStateChange:event:)]) {
            [self.delegate onConnectionStateChange:state event:event];
        }
    }];
    
    /// Update Total Unread
    [[ZIMKitEventHandler shared] addEventListener:KEY_CONVERSATION_TOTALUNREADMESSAGECOUNT_UPDATED
                                         listener:self
                                         callBack:^(NSDictionary * _Nullable param) {
        @strongify(self);
        int totalUnreadCount = [param[PARAM_CONVERSATION_TOTALUNREADMESSAGECOUNT] intValue];
        if (self.delegate && [self.delegate respondsToSelector:@selector(onTotalUnreadMessageCountChange:)]) {
            [self.delegate onTotalUnreadMessageCountChange:totalUnreadCount];
        }
    }];
}

- (void)removeManagerEventHadle {
    [[ZIMKitEventHandler shared] removeEventListener:KEY_CONNECTION_STATE_CHANGED listener:self];
}

- (void)queryUsersInfo:(NSArray<NSString *>*)userIDs callback:(ZIMUsersInfoQueriedCallback)callback {
    ZIMUsersInfoQueryConfig *config = [ZIMUsersInfoQueryConfig new];
    config.isQueryFromServer = YES;
    [self.zim queryUsersInfo:userIDs config:config callback:callback];
}

- (void)updateUserAvatarUrl:(NSString *)avatarUrl callback:(ZIMUserAvatarUrlUpdatedCallback)callback {
    self.userInfo.userAvatarUrl = avatarUrl;
    [self.zim updateUserAvatarUrl:avatarUrl callback:callback];
}

- (void)disconnectUser {
    [self.zim logout];
}

- (void)createGroup:(NSString *)groupName
         userIDList:(NSArray <NSString *>*)userIDList
           callBack:(ZIMKitCreateGroupCallback)callBack {
    ZIMGroupInfo *info = [[ZIMGroupInfo alloc] init];
    info.groupName = groupName;
    
    [ZIMKitManagerZIM createGroup:info userIDs:userIDList callback:^(ZIMGroupFullInfo * _Nonnull groupInfo, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
        if (callBack) {
            ZIMKitGroupInfo *info = [[ZIMKitGroupInfo alloc] init];
            [info fromZIMGroupFullInfo:groupInfo];
            callBack(info, errorUserList, errorInfo);
        }
    }];
}

- (void)joinGroup:(NSString *)groupID
         callBack:(ZIMKitJoinGroupCallback)callBack {
    [ZIMKitManagerZIM joinGroup:groupID callback:^(ZIMGroupFullInfo * _Nonnull groupInfo, ZIMError * _Nonnull errorInfo) {
        if (callBack) {
            ZIMKitGroupInfo *info = [[ZIMKitGroupInfo alloc] init];
            [info fromZIMGroupFullInfo:groupInfo];
            callBack(info, errorInfo);
        }
    }];
}

- (void)createCachePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imagePath = [self getImagepath];
    if(![fileManager fileExistsAtPath:imagePath]){
        [fileManager createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *voicePath = [self getVoicePath];
    if(![fileManager fileExistsAtPath:voicePath]){
        [fileManager createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *videoPath = [self getVideoPath];
    if(![fileManager fileExistsAtPath:videoPath]){
        [fileManager createDirectoryAtPath:videoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [self getFilePath];
    if(![fileManager fileExistsAtPath:filePath]){
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSString *)getImagepath {
    return [ZIMKit_Image_Path stringByAppendingString:self.userInfo.userID];
}

- (NSString *)getVoicePath{
    return [ZIMKit_Voice_Path stringByAppendingPathComponent:self.userInfo.userID];;
}

- (NSString *)getVideoPath {
    return [ZIMKit_Video_Path stringByAppendingPathComponent:self.userInfo.userID];;
}

- (NSString *)getFilePath {
    return [ZIMKit_File_Path stringByAppendingPathComponent:self.userInfo.userID];;
}

- (ZIMKitUserInfo *)userInfo {
    if (!_userInfo) {
        _userInfo = [[ZIMKitUserInfo alloc] init];
    }
    return _userInfo;
}

- (void)dealloc {
    [self removeManagerEventHadle];
}
@end
