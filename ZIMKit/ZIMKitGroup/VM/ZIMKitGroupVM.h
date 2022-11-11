//
//  ZIMKitGroupVM.h
//  ZIMKit
//
//  Created by zego on 2022/5/23.
//

#import <Foundation/Foundation.h>
#import "ZIMKitDefine.h"
#import <ZIM/ZIM.h>

@class ZIMKitGroupInfo, ZIMKitGroupMember;

typedef void (^ZIMKitGroupCallback)(ZIMKitGroupInfo  *_Nullable groupInfo, ZIMError * _Nullable errorInfo);
//typedef void (^ZIMKitCreateGroupCallback)(ZIMKitGroupInfo  *_Nullable groupInfo,NSArray<ZIMErrorUserInfo *> * _Nullable errorUserList, ZIMError * _Nullable errorInfo);
typedef void (^ZIMKitGroupMemberListQueriedCallback)(NSString *_Nullable groupID,
                                                     NSArray<ZIMKitGroupMember *> * _Nullable userList,
                                                     unsigned int nextFlag, ZIMError * _Nullable errorInfo);

NS_ASSUME_NONNULL_BEGIN

@protocol ZIMKitGroupVMDelegate <NSObject>

@optional
/// Group state changed
- (void)onGroupStatusChange:(NSString *)groupID
                      state:(ZIMGroupState)state
                      event:(ZIMGroupEvent)event
           operatedUserInfo:(ZIMKitGroupMember *)operatedUserInfo;

/// Group member state changed
- (void)onGroupMemberStateChanged:(NSString *)groupID
                            state:(ZIMGroupMemberState)state
                            event:(ZIMGroupMemberEvent)event
                         userList:(NSArray *)userList
                 operatedUserInfo:(ZIMKitGroupMember *)operatedUserInfo;
@end

@interface ZIMKitGroupVM : NSObject

@property (nonatomic, weak) id<ZIMKitGroupVMDelegate>delegate;

/// Query group members
/// 
/// @param groupID groupID
/// @param config Query config
/// @param callback callback
- (void)queryGroupMemberListByGroupID:(NSString *)groupID
                                    config:(ZIMGroupMemberQueryConfig *)config
                                  callback:(ZIMKitGroupMemberListQueriedCallback)callback;
@end

NS_ASSUME_NONNULL_END
