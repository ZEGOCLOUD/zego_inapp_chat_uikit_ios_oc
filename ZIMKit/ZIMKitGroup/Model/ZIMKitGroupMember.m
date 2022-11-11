//
//  ZIMKitGroupMember.m
//  ZIMKit
//
//  Created by zego on 2022/5/23.
//

#import "ZIMKitGroupMember.h"

@implementation ZIMKitGroupMember

- (void)fromZIMGroupMemberInfo:(ZIMGroupMemberInfo*)info {
    self.memberRole = info.memberRole;
    self.memberNickname = info.memberNickname;
    self.userID = info.userID;
    self.userName = info.userName;
}
@end
