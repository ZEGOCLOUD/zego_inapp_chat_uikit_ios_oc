//
//  ZIMKitGroupMember.h
//  ZIMKit
//
//  Created by zego on 2022/5/23.
//

#import <Foundation/Foundation.h>
#import <ZIM/ZIM.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitGroupMember : NSObject

@property (nonatomic, copy) NSString *memberNickname;

@property (nonatomic, assign) int memberRole;

@property (nonatomic, copy) NSString *userID;

@property (nonatomic, copy) NSString *userName;

/// 从SDKZIMGroupMemberInfo->ZIMKitGroupMember
- (void)fromZIMGroupMemberInfo:(ZIMGroupMemberInfo*)info;
@end

NS_ASSUME_NONNULL_END
