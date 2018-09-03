//
//  KMTUserInforModel.h
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/13.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMModel.h"

@interface KMTUserInforModel : KMModel

/**
 登录账号
 */
@property(nonatomic,copy)NSString*  loginId;

/**
 账户类型
 */
@property(nonatomic,copy)NSString*  memberType;

/**
 登陆令牌
 */
@property(nonatomic,copy)NSString*  token;

/**
 电话
 */
@property(nonatomic,copy)NSString* tel;

/**
 性别
 */
@property(nonatomic,copy)NSString* sex;

/**
 生日
 */
@property(nonatomic,copy)NSString* birthday;

/**
 行业
 */
@property(nonatomic,copy)NSString* industry;

/**
 头像
 */
@property(nonatomic,copy)NSString* head;

/**
 姓名
 */
@property(nonatomic,copy)NSString* name;


/**
 是否实名（快递版）
 */
@property(nonatomic,copy) NSString *  isRealCou;


/**
 身份证正面照
 */
@property(nonatomic,copy) NSString *  idCardPath;

/**
 手持身份证照
 */
@property(nonatomic,copy) NSString *  holdIdCardPath;

/**
 工作证照
 */
@property(nonatomic,copy) NSString *  workcardPath;

/**
 所属公司
 */
@property(nonatomic,copy) NSString *  company;

/**
 驳回原因
 */
@property(nonatomic,copy) NSString *  remark;

/**
 身份证号码
 */
@property(nonatomic,copy) NSString *  certNo;

//是否实名
@property(nonatomic,copy) NSString  *isReal ;

//是否设置支付密码
@property(nonatomic,copy) NSString *isPayPasswd;

+(instancetype)shareUserInforManage;

-(BOOL)isLogin;
- (void)clear;
@end
