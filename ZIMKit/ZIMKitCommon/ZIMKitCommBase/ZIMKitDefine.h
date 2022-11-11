//
//  ZIMKitDefine.h
//  ZIMKit
//
//  Created by zego on 2022/5/18.
//

#ifndef ZIMKitDefine_h
#define ZIMKitDefine_h

#import <ZIM/ZIM.h>
#import "ZIMKitManager.h"
#import "ZIMKitConversationListVC.h"
#import "ZIMKitNavigationController.h"
#import "ZIMKitBaseViewController.h"
#import "UIView+ZIMKitToast.h"
#import "UIView+ZIMKitLayout.h"
#import "UIColor+ZIMKitUtil.h"
#import "UIImage+ZIMKitUtil.h"
#import "NSBundle+ZIMKitUtil.h"
#import "NSObject+ZIMKitUtil.h"
#import "ZIMKitUserInfo.h"
#import "ZIMKitGroupInfo.h"

#import "ZIMKitRouter.h"
#import "ZIMKitBaseModule.h"
#import "ZIMKitLocalAPNS.h"

#import "ZIMKitGroupDetailController.h"
#import "ZIMKitMessagesListVC.h"

#define weakify(obj) autoreleasepool{} __weak typeof(obj) obj##Weak = obj;
#define strongify(obj) autoreleasepool{} __strong typeof(obj) obj = obj##Weak;

#define ZIMKitManagerZIM    [ZIMKitManager shared].zim
#define Screen_Width        [UIScreen mainScreen].bounds.size.width
#define Screen_Height       [UIScreen mainScreen].bounds.size.height
#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define Is_IPhoneX (Screen_Width >=375.0f && Screen_Height >=812.0f && Is_Iphone)
#define StatusBar_Height    (Is_IPhoneX ? (44.0):(20.0))
#define TabBar_Height       (Is_IPhoneX ? (49.0 + 34.0):(49.0))
#define NavBar_Height       (44)
#define SearchBar_Height    (55)
#define Bottom_SafeHeight   (Is_IPhoneX ? (34.0):(0))
#define RGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.f]
#define ZIMKitHexColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

#define GetNavAndStatusHight (StatusBar_Height + NavBar_Height)

//conversation cell
#define ZIMKitConversationCell_Height 74
#define ZIMKitConversationCell_Margin 15
#define ZIMKitConversationCell_TitleMaxW 170
#define ZIMKitConversationCell_Title_Margin 11
#define ZIMKitConversationCell_Margin_Text 11
#define ZIMKitConversationCell_Margin_UnReadRedDot 10
#define ZIMKitConversationCell_Margin_DisturbWH 16

//unRead
#define ZIMKitUnReadView_Margin_TB 2
#define ZIMKitUnReadView_Margin_LR 3

#define ZIMKitSystemMessageType 99
// Messagecell
#define ZIMKitMessageCell_Top_Time_H 20 //The interval from the top message time to the top of the UI is 20
#define ZIMKitMessageCell_Bottom_Time_H 9
#define ZIMKitMessageCell_Time_H 18
#define ZIMKitMessageCell_Name_H 16
#define ZIMKitMessageCell_Name_MaxW 160         // Maximum name width
#define ZIMKitMessageCell_Name_TO_CON_Margin 2  // Space between name and content
#define ZIMKitMessageCell_Avatar_WH 43
#define ZIMKitMessageCell_SelectedButton_WH 23
#define ZIMKitMessageCell_Avatar_Screen_Margin 8
#define ZIMKitMessageCell_Time_Avatar_Margin 12
#define ZIMKitMessageCell_Avatar_Con_Margin 12
#define ZIMKitMessageCell_Text_MaxW (Screen_Width - 150)
#define ZIMKitMessageCell_Sys_Margin 30
#define ZIMKitMessageCell_Sys_MaxW (Screen_Width - ZIMKitMessageCell_Sys_Margin *2)
#define ZIMKitMessageCell_Retry_W 24
#define ZIMKitMessageCell_Default_Height 56
#define ZIMKitMessageCell_TO_Cell_Margin 16 //Space between cell and cell
#define ZIMKitMaxTimeCellToCell 5 * 60

#define ZIMKitMaxImageWH (Screen_Width/2.0)
#define ZIMKitMinImageWH (Screen_Width/4.0)

#define ZIMKitAudioMessageMargin 7
#define ZIMKitAudioMessageIcon_Text 10
#define ZIMKitAudioMessageIcon_WH 21
#define ZIMKitAudioMessageCellH 43
#define ZIMKitAudioMessageCellMinW 70
#define ZIMKitAudioMessageCellMxaW (Screen_Width*0.4)
#define ZIMKitAudioMessageTimeLength 60

#define ZIMKitFileMessageCellH 62
#define ZIMKitFileMessageCellW (Screen_Width - 78 - 63)
#define ZIMKitFileMessageCell_Margin_Left 16
#define ZIMKitFileMessageCell_Title_Left 16
#define ZIMKitFileMessageCell_Icon_Title 12
#define ZIMKitFileMessageCellFileIconW 39
#define ZIMKitFileMessageCellFileIconH 39
#define ZIMKitFileSizeMax (10.0*1024*1024)

//inputbar height
#define ZIMKitChatToolBarHeight 61

#define minScaleIphone (([UIScreen mainScreen].bounds.size.height / [UIScreen mainScreen].bounds.size.width)< 2.1)

#define kMessageFaceViewHeight  (minScaleIphone ? [UIScreen mainScreen].bounds.size.height *0.55 - 50.0 -Bottom_SafeHeight : [UIScreen mainScreen].bounds.size.height *0.5 - 50.0 - Bottom_SafeHeight)

/**
 Conversation event key
 */
static NSString *const KEY_CONVERSATION_CHANGED = @"conversationChanged";
static NSString *const KEY_CONVERSATION_TOTALUNREADMESSAGECOUNT_UPDATED = @"conversationTotalUnreadMessageCountUpdated";

/**
 Conversation event param
 */
static NSString *const PARAM_CONVERSATION_CHANGED_LIST = @"conversationChangedList";
static NSString *const PARAM_CONVERSATION_TOTALUNREADMESSAGECOUNT = @"conversationTotalUnreadMessageCount";

/**
 Message event key
 */
static NSString *const KEY_RECEIVE_PEER_MESSAGE = @"receivePeerMessage";
static NSString *const KEY_RECEIVE_GROUP_MESSAGE = @"receiveGroupMessage";
static NSString *const KEY_RECEIVE_ROOM_MESSAGE = @"onReceiveRoomMessage";

/**
Message event param
*/
static NSString *const PARAM_MESSAGE_LIST = @"messageList";
static NSString *const PARAM_FROM_USER_ID = @"fromUserID";
static NSString *const PARAM_FROM_GROUP_ID = @"fromGroupID";
static NSString *const PARAM_FROM_ROOM_ID = @"fromRoomID";
static NSString *const PARAM_EVENT = @"event";
static NSString *const PARAM_EXTENDED_DATA = @"extendedData";

/**
 connect  event key
 */
static NSString *const KEY_CONNECTION_STATE_CHANGED = @"connectionStateChanged";

/**
 connect  event param
 */
static NSString *const PARAM_STATE = @"state";

/**
 group event key
 */
static NSString *const KEY_GROUP_MEMBER_STATE_CHANGED = @"groupMemberStateChanged";

/**
 group  event param
*/
static NSString *const PARAM_GROUP_MEMBER_STATE = @"state";
static NSString *const PARAM_GROUP_MEMBER_EVENT = @"event";
static NSString *const PARAM_GROUP_USER_LIST    = @"userList";
static NSString *const PARAM_GROUP_OPERATEDINFO = @"operatedInfo";
static NSString *const PARAM_GROUP_GROUPID      = @"groupID";

/*
 ZIMKitRouter
 */

static NSString * const router_chatListUrl = @"ZIMKit://ZIMKitMessages/ZIMKitMessageListVC";

static NSString * const router_groupDetailUrl = @"ZIMKit://ZIMKitGroup/ZIMKitGroupDetailController";

#define ZIMKit_Image_Path [NSHomeDirectory() stringByAppendingString:@"/Documents/ZIMKitSDK/image/"]
#define ZIMKit_Voice_Path [NSHomeDirectory() stringByAppendingString:@"/Documents/ZIMKitSDK/voice/"]
#define ZIMKit_Video_Path [NSHomeDirectory() stringByAppendingString:@"/Documents/ZIMKitSDK/Video/"]
#define ZIMKit_File_Path  [NSHomeDirectory() stringByAppendingString:@"/Documents/ZIMKitSDK/File/"]

#define ZIMKitSessionCategory(userId) [NSString stringWithFormat:@"ZIMKitSessionCategory_%@", userId]
#endif /* ZIMKitDefine_h */
