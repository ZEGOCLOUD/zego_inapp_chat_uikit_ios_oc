//
//  ZIMKitConversationModel.m
//  ZIMKit
//
//  Created by zego on 2022/5/19.
//

#import "ZIMKitConversationModel.h"

@implementation ZIMKitConversationModel

- (void)fromZIMConversationWith:(ZIMConversation *)con {
    self.conversationID = con.conversationID;
    self.conversationName = con.conversationName;
    self.conversationAvatar = con.conversationAvatarUrl;
    self.type = con.type;
    self.unreadMessageCount = con.unreadMessageCount;
    self.lastMessage = con.lastMessage;
    self.orderKey = con.orderKey;
    self.notificationStatus = con.notificationStatus;
}

- (ZIMConversation *)toZIMConversationModel {
    ZIMConversation *con = [[ZIMConversation alloc] init];
    con.conversationID = self.conversationID;
    con.conversationName = self.conversationName;
    con.conversationAvatarUrl = self.conversationAvatar;
    con.type = self.type;
    con.unreadMessageCount = self.unreadMessageCount;
    con.lastMessage = self.lastMessage;
    con.orderKey = self.orderKey;
    con.notificationStatus = self.notificationStatus;
    return con;
}
@end
