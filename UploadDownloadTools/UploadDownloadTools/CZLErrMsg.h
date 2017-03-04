//
//  CZLErrMsg.h
//  chezhilian
//
//  Created by 王凡 on 16/5/4.
//  Copyright © 2016年 Chengdu Chezhilian Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CZLNetWorkErrors) {
    NET_CAN_NOT_USE         = -1001, //当前网络环境较差,请稍后再试  超时
    DB_EXCEPTION            = 10001, //"数据库异常"),
    DATA_ENCRYPT            = 10002, //"数据加密异常"),
    TOKEN_INVALID           = 10111, //"用户token验证失效"),
    PASSWORD_ERROR          = 10112, //"密码不正确"),
    PASSWORD_NOTNULL        = 10114, //"密码不正确"),
    TOKEN_SAVE              = 10116, //"token保存失败"),
    HANDLER_ERROR           = 10130, //"操作失败"),
    SAVE_FAILURE            = 10131, //"系统保存失败"),
    QUERY_ERROR             = 10132, //"查询失败"),
    USER_NOTEXIST           = 10304, //"用户不存在"),
    USER_NOTEXIST_APPLY     = 10305, //"该用户不存在，不能申请成为好友"),
    FRIEND_NOTEXIST         = 10306, //"好友不存在"),
    APPLIER_NOTEXIST        = 10307, //"申请者不存在"),
    USER_NICKNAME           = 10308, //"nickname只能使用2-15位中文、日文、数字、字母、以及-_@#等字符"),
    USER_MOBILE             = 10309, //"用户手机号码不正确"),
    USER_MOBILE_REG         = 10350, //"该手机已经注册"),
    USER_MOBILE_NOREG       = 10351, //"该手机未注册"),
    MOBILE_SMS_ERROR        = 10360, //"短信服务异常"),
    USER_NICKNAME_UPDATE    = 10320, //"更新昵称失败"),
    INPUT_NOTNULL           = 10401, //"输入参数不能为空"),
    SEARCH_NOTNULL          = 10402, //"搜索关键字不能为空"),
    USERID_NOTNULL          = 10403, //"用户标识不能为空"),
    MOBILE_NOTNULL          = 10404, //"手机号码不能为空"),
    PHONEID_NOTNULL         = 10405, //"手机设备号不能为空"),
    USERID_MOBILE_NOTNULL   = 10406, //"用户标识和用户手机号吗不能同时为空"),
    PAGE_RANGE              = 10410, //"分页的range值不正确"),
    CHANNEL_CREATE          = 10501, //"新频道创建失败"),
    CHANNEL_NOTNULL         = 10502, //"频道号不能为空"),
    CHANNEL_TYPE_NOTNULL    = 10509, //"频道类型不能为空"),
    CHANNEL_UPDATE          = 10503, //"更新频道失败"),
    CHANNEL_NO_USER         = 10504, //"没有搜索到相关用户"),
    SHARE_POSITION          = 10505, //"共享位置只能取值0和1"),
    CHANNEL_DISMISS         = 10506, //"只有管理员才可以解散频道"),
    CHANNEL_KICK            = 10507, //"只有管理员才可以移除成员"),
    CHANNEL_KICK_SELF       = 10508, //"管理员不能移出自己，如需退出，请使用解散频道的功能"),
    
    INVITEE_NOTNULL         = 10510, //"被邀请人不能为空"),
    ADMIN_CAN_INVITE        = 10511, //"只有频道的所有者才能邀请人加入"),
    INVITE_FAILUER          = 10512, //"发出邀请失败"),
    
    CHANNEL_EXIST           = 10515, //"你已经在该频道中了"),
    CHANNEL_APPLY           = 10516, //"申请加入失败"),
    CHANNEL_NOT_EXIST       = 10518, //"该频道号不存在"
    CONFIG_UPDATE           = 10520, //"更新配置失败"),
    
    FILENAME_NOTNULL        = 10600, //"输入filename不能为空"),
    FILE_RANGE              = 10602, //"输入range的值错误"),
    FILESIZE_NOTNULL        = 10604, //"输入filesize不能为空"),
    FILEID_NOTNULL          = 10606, //"输入fileid不能为空"),
    CONTENT_RANGE           = 10610, //"Content和range不匹配"),
    
    JPUSH_RECEIVER          = 10700, //"接收者不能为空"),
    JPUSH_SENDER            = 10701, //"发送者不能为空"),
    JPUSH_NO_ID             = 10702, //"该用户没有极光ID"),
    JPUSH_FAILURE           = 10704, //"极光发送失败"),
    JPUSH_EEROR             = 10706, //"极光发送错误"),
    JPUSH_REG_NOTNULL       = 10710, //"注册号不能为空"),
    JPUSH_REG_UPDATE        = 10712, //"更新注册号失败"),
    CHAT_CHANNEL_NOTNULL    = 10714, //"对讲频道不能为空"),
    CHAT_ENTER_FAILURE      = 10716, //"进入对讲失败"),
    CHAT_LEAVE_FAILURE      = 10718, //"离开对讲失败"),
    CHAT_NOT_SELF           = 10770, //"不允许和自己聊天");
    LOG_OUT_FAILED          = 10780, //"退出登录失败"
};


@interface CZLErrMsg : NSObject

@property (assign,nonatomic)CZLNetWorkErrors errorCode;//错误码
@property (strong,nonatomic)NSString *errorMessage; //错误消息
@property (strong,nonatomic)CZLErrMsg *netWorkErr;
@property (strong,nonatomic)CZLErrMsg *serverReturnErr;

@end
