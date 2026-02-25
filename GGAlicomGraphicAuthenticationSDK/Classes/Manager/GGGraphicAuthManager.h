//
//  GGGraphicAuthManager.h
//  GGAlicomGraphicAuthenticationSDK
//
//  Created by 15991163 on 02/24/2026.
//  Copyright (c) 2026 15991163. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlicomCaptcha4/AlicomCaptcha4.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSInteger GGGraphicAuthCaptchaErrorCode;
//extern const GGGraphicAuthCaptchaErrorCode GGGraphicAuthCaptchaError_Authenticating; // 正在验证
extern const GGGraphicAuthCaptchaErrorCode GGGraphicAuthCaptchaError_MaximumNumberOfVerifications; // 最大验证次数

/**
 图形验证成功回调
 @param result 验证结果数据
 */
typedef void (^GGGraphicAuthSuccessBlock)(BOOL isSuccess, NSDictionary *_Nullable result);

/**
 图形验证失败回调
 @param error 验证结果
 */
typedef void (^GGGraphicAuthFailedBlock)(NSError *_Nullable error);

/**
 图形验证管理器
 支持block方式进行验证，成功、失败回调
 支持配置最大验证数量
 不使用单例，支持多个地方调用互不影响
 */
@interface GGGraphicAuthManager : NSObject

/// 验证码ID
@property (nonatomic, copy, readonly) NSString *captchaID;
/// 最大验证次数
@property (nonatomic, assign, readonly) NSInteger maxAttempts;
/// 当前验证次数
@property (nonatomic, assign, readonly) NSInteger currentAttempt;
/// 是否正在验证
@property (nonatomic, assign, readonly, getter=isVerifying) BOOL verifying;
/// 验证码会话
@property (nonatomic, strong, readonly) AlicomCaptcha4Session *captchaSession;

/**
 初始化方法
 @param captchaID 验证码ID
 @param maxAttempts 最大验证次数，默认为3次
 @param configuration 会话配置
 @return 验证管理器实例
 */
- (instancetype)initWithCaptchaID:(NSString *)captchaID maxAttempts:(NSInteger)maxAttempts configuration:(nullable AlicomCaptcha4SessionConfiguration *)configuration;

- (instancetype)initWithCaptchaID:(NSString *)captchaID maxAttempts:(NSInteger)maxAttempts;

/**
 便捷初始化方法，默认最大验证次数为3次
 @param captchaID 验证码ID
 @return 验证管理器实例
 */
- (instancetype)initWithCaptchaID:(NSString *)captchaID;

/**
 开始验证
 @param success 验证成功回调
 @param failed 验证失败回调
 */
- (void)startVerificationWithSuccess:(GGGraphicAuthSuccessBlock)success failed:(GGGraphicAuthFailedBlock)failed;

/**
 取消验证
 */
- (void)cancelVerification;

/**
 重置验证次数
 */
- (void)resetAttempts;

/**
 方法2：判断指定错误码是否存在于所有错误码数组中
 @param code 要检查的错误码
 @return YES=存在，NO=不存在
 */
+ (BOOL)isCaptchaErrorCodeValid:(GGGraphicAuthCaptchaErrorCode)code;

@end

NS_ASSUME_NONNULL_END
