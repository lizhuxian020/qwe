//
//  KMTPayApiObject.h
//  KMTPayDemo
//
//  Created by 123 on 16/2/26.
//  Copyright © 2016年 KMT. All rights reserved.
//

#import <Foundation/Foundation.h>

//使用康美钱包支付时错误码
typedef NS_ENUM(NSInteger, KMTPayErrorCode) {
    KMTPayErrCodeUserCancel     = 0,    /**用户点击取消并返回 */
    KMTPaySuccess               = 1,   /**交易成功*/
    KMTPayErrCodeSentFail       = 2,   /**交易失败*/
    KMTPayErrCodeProcessing     = 3,   /**交易处理中*/
};

#pragma mark - KMTPayReq
/*＊
 *  该类为SDK生成康美支付预订单模型类
 */
@interface KMTPayReq : NSObject
//商户编号
@property (copy, nonatomic) NSString *partner;
//商户异步回调地址
@property (copy, nonatomic) NSString *notifyUrl;
//商户同步跳转地址(选传)
@property (copy, nonatomic) NSString *returnUrl;
//商户订单号
@property (copy, nonatomic) NSString *outTradeNo;
//支付金额
@property (copy, nonatomic) NSString *totalAmount;
//卖方账号
@property (copy, nonatomic) NSString *sellerEmail;
//商品名称
@property (copy, nonatomic) NSString *subject;
//商品描述
@property (copy, nonatomic) NSString *body;
//支付防钓鱼时间戳
@property (copy, nonatomic) NSString *timestamp;
//RSA签名值,需要使用URL编码
@property (copy, nonatomic) NSString *rsaSign;
//签名类型
@property(nonatomic,copy)NSString *signType;

/*以下参数用于康美电商帐号登陆h5时使用,均选传*/
@property (copy, nonatomic) NSString *kmpayAccount;  //康美钱包帐号
@property (copy, nonatomic) NSString *srcAccount;    //平台帐号
@property (copy, nonatomic) NSString *src;           //平台来源标记

@end


#pragma mark - KMTPayResp
/*＊
 *  该类为康美钱包终端SDK响应类
 */
@interface KMTPayResp : NSObject
// 错误码
@property (nonatomic, assign) KMTPayErrorCode errorCode;
// 错误提示字符串
@property (nonatomic, retain) NSString *errorMessage;

@end


