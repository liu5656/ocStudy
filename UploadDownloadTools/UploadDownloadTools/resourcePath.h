//
//  resourcePath.h
//  chezhilian
//
//  Created by lj on 16/3/2.
//  Copyright © 2016年 Chengdu Chezhilian Technology Co., Ltd. All rights reserved.
//

#ifndef resourcePath_h
#define resourcePath_h


static NSString *const  RPLoginByIDFA       = @"rest/register/?";            // get 取得非注册用户的标识
static NSString *const  RPBindUser          = @"rest/register";              // post 绑定用户
static NSString *const  RPLogin             = @"rest/auth/authorize/?";      // get 登录
static NSString *const  RPCheckCodeLogin    = @"rest/auth/validcode";        // get 验证码
static NSString *const  RPLogout            = @"rest/auth/logout";           // post 退出登录
static NSString *const  RPUserInfo          = @"rest/user/?";                // get 用户信息
static NSString *const  RPUserDetailInfo    = @"rest/user/detail?";          // get 用于获取用户信息，和上面的获取用户公开信息的接口相比，增加了是否自己好友、极光ID这个属性
static NSString *const  RPNickname          = @"rest/user/nickname?";        // put 修改好友备注
static NSString *const  RPUserInfoDetail    = @"rest/user/detail";           // get 用户详细信息（频道成员）
static NSString *const  RPUserUpdate        = @"rest/user/update";           // put 更新用户信息
static NSString *const  RPVerifyCode        = @"rest/register/sms/?";        // get 发送验证码
static NSString *const  RPCheckPhoneIsExist = @"rest/register/existmobile";  // get 判断手机是否已经注册
static NSString *const  RPCompareCheckCode  = @"rest/register/validcode";    // get 判断验证码是否正确
static NSString *const  RPUpdateBLEState    = @"rest/user/bluetooth?";       // put 更新蓝牙绑定状态

static NSString *const  RPFriendApply       = @"rest/friend/apply?";         // put 申请好友
static NSString *const  RPFriendQRCodeApply = @"rest/friend/qrcode?";        // put 扫描二维码的方式添加好友
static NSString *const  RPChannelQRCodeJoin = @"rest/channel/qrcode?";       // put 扫描二维码的方式进入频道
static NSString *const  RPGoodFriendList    = @"rest/friend/my/?";           // put 好友列表
static NSString *const  RPGoodFriendSearch  = @"rest/friend/search?";        // put 好友搜索

static NSString *const  RPFriendInvite      = @"rest/friend/applytome/?";    // get 收到的好友申请F
static NSString *const  RPFriendAdd         = @"rest/friend/add/?";          // put 加指定用户成为当前用户的好友 互加好友
static NSString *const  RPDeleteGoodFriend  = @"rest/friend/delete/?";       // delete 删除好友 互删
static NSString *const  RPFuzzySearch       = @"rest/user/find";             // get 模糊搜索,用户id，用户昵称，手机号，三个信息的模糊匹配
static NSString *const  RejectFreiend       = @"rest/friend/refuse";         // 拒绝好友请求
static NSString *const  RPUploadContact     = @"rest/contacts";              // post 上传手机通讯录
static NSString *const  RPDownloadContact   = @"rest/contacts?";             // get 下载手机通讯录
static NSString *const  RPFriendSMS         = @"rest/friend/sms";            // get 用户邀请手机联系人中的非领域用户使用领域app的对讲功能
static NSString *const  RPFriendRecommend   = @"rest/friend/recommend?";      // get 好友推荐
static NSString *const  RPCommonUpload      = @"rest/file/dfs";                  // post 错误日志普通上传
static NSString *const  RPCollectPic         = @"rest/collect/pic";              //记录仪截取图片
static NSString *const  RPChatRobot         = @"rest/robot/chat?";            // get 聊天机器人接口

#pragma mark channel
static NSString *const  createChinnel       = @"rest/channel/new";                 // 创建频道
static NSString *const  updateChannel       = @"rest/channel/update";              // 更新频道
static NSString *const  upNicnameInchnel    = @"rest/channel/nickname?";            // 修改自己在频道内的昵称
static NSString *const  RPAddToChinnel      = @"rest/channel/apply?";               // PUT 申请加入channel
static NSString *const  RPAddToChannelWithoutRequest = @"rest/channel/add?";        // PUT 不通过申请直接加入频道
static NSString *const  RPAggreeAddInChinnel= @"rest/channel/agreeapply?";          // PUT 同意申请加入频道
static NSString *const  rejectAddInChinnel  = @"rest/channel/refuseapply";          // 拒绝申请加入频道
static NSString *const  inviteToChinnel     = @"rest/channel/invite";              // 邀请加入频道
static NSString *const  agreeInviteChinnel  = @"rest/channel/agreeinvite";         // 同意邀请加入频道
static NSString *const  RPExitChinnel       = @"rest/channel/exit?";                  // delete 退出频道
static NSString *const  kickOutChinnel      = @"rest/channel/kick";                  // 踢出频道
static NSString *const  RPDismissChinnel    = @"rest/channel/dismiss?";               // delete 解散频道
static NSString *const  myChinnelList       = @"rest/channel/my?";                  // 获取频道列表
static NSString *const  RPAllChlMem         = @"rest/channel/allmember?";           // 获取所有的频道成员
static NSString *const  myChinnelInfo       = @"rest/channel/myinfo";               //频道设置界面数据
static NSString *const  alllyChinnelList    = @"rest/channel/applylist";             // 频道申请记录
static NSString *const  inviteChinnel       = @"rest/channel/invitelist";           // 邀请我的记录
static NSString *const  mysysnotice         = @"rest/channel/message/mysysnotice";  // 获取非实时消息
static NSString *const  memberOfChinnel     = @"rest/channel/member";               // 获取频道成员
static NSString *const  searchChannel       = @"rest/channel/find";                 // 搜索频道
static NSString *const  rejInviteChinnel    = @"rest/channel/refuseinvite";         // 拒绝邀请
static NSString *const  channelStatus       = @"rest/channel/status";               // 频道在线人数
static NSString *const  RPChannelRecommend  = @"rest/channel/recommend?";            // get 频道推荐
static NSString *const  RPChannelInfo       = @"rest/channel/info?";                // get 频道信息
static NSString *const  RPFriendNewmessage  = @"rest/friend/newmessage?";            // get 好友新消息
static NSString *const  RPChannelNewmessage = @"rest/channel/newmessage?";           // get 频道新消息
static NSString *const  channelBatchAdFnd   = @"rest/channel/batchadd";             // get 邀请好友到频道
static NSString *const  channelBatchDltMbr  = @"rest/channel/batchkick";             // get 踢出频道成员
static NSString *const  ChangechannelRemark = @"rest/channel/channelremark?";
static NSString *const  ChangechannelName   = @"rest/channel/channelname?";
static NSString *const  ChangechannelAhth   = @"rest/channel/ispublic?";            //改变频道认证权限
static NSString *const  RPConverHistory     = @"rest/user/chatrecord?";             // put 上传/获取聊天记录

static NSString *const  RadioStationList  = @"rest/radio/list?";        // get  电台列表
static NSString *const  RadioStationDetail  = @"rest/radio/detail?";        // get  电台详细

static NSString *const  UploadNavigationCollection  = @"rest/user/oftenplace?";        // put  上传导航收藏
static NSString *const  DownloadNavigationCollection  = @"rest/user/oftenplace?";        // get  电台详细

#pragma mark channel end

#pragma mark upgrade
static NSString *const  upGrade             = @"rest/version";                  // 版本升级

#pragma mark message
static NSString *const  RPJPRegist             = @"rest/interphone/register";      // 极光推送ID
static NSString *const  Message             = @"rest/message";                  //各种message 用户之间交互

static NSString *const  MyNotice            = @"rest/message/mynotice";         //各种待处理的消息
static NSString *const  inviteMemberOnline  = @"rest/message/channel";          // 邀请好友上线

static NSString *const  EnterConversaton    = @"rest/interphone/enter";         //put 进入会话 同时也是随机对讲入口,channel字段为sametime
static NSString *const  ExitConversaton     = @"rest/interphone/leave";         //退出会话

static NSString *const  File                = @"rest/file";

static NSString *const  GetRecordCOnfig     = @"rest/config/recorder?";         //从服务器取得行车记录仪的配置参数

#pragma mark tactics
static NSString *const RPTrafficBytes       = @"rest/collect/networkflow";              // post 上传用户数据流量使用情况

/**
 *  一些Notifications
 */
static NSString *const  RemoteKeyCode       = @"RemoteKeyCode";
static NSString *const  friendNotePlist     = @"friendNote.plist";//存储好友备注plist列表

// 获取好友列表
//static NSString *const
#endif /* resourcePath_h */
