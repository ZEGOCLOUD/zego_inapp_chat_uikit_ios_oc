//
//  ZIMKitGroupInfo.m
//  ZIMKit
//
//  Created by zego on 2022/5/23.
//

#import "ZIMKitGroupInfo.h"

@implementation ZIMKitGroupInfo

- (void)fromZIMGroupFullInfo:(ZIMGroupFullInfo*)info {
    self.groupID = info.baseInfo.groupID;
    self.groupName = info.baseInfo.groupName;
    self.groupAvatarUrl = info.baseInfo.groupAvatarUrl;
}

@end
