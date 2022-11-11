//
//  ZIMKitGroupVM.m
//  ZIMKit
//
//  Created by zego on 2022/5/23.
//

#import "ZIMKitGroupVM.h"
#import "ZIMKitGroupInfo.h"
#import "ZIMKitGroupMember.h"


@implementation ZIMKitGroupVM

- (void)queryGroupMemberListByGroupID:(NSString *)groupID
                                    config:(ZIMGroupMemberQueryConfig *)config
                                  callback:(ZIMKitGroupMemberListQueriedCallback)callback {
    NSAssert(groupID,  @"queryqueryGroupMemberListByGroupID The groupID should not be nil.");
    
    [ZIMKitManagerZIM queryGroupMemberListByGroupID:groupID config:config callback:^(NSString * _Nonnull groupID, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, unsigned int nextFlag, ZIMError * _Nonnull errorInfo) {
        if (callback) {
            NSMutableArray *members = [NSMutableArray array];
            for (ZIMGroupMemberInfo *user in userList) {
                ZIMKitGroupMember *member = [[ZIMKitGroupMember alloc] init];
                [member fromZIMGroupMemberInfo:user];
                if (member) {
                    [members addObject:member];
                }
            }
            callback(groupID, members, nextFlag, errorInfo);
            
        }
    }];
}
@end
