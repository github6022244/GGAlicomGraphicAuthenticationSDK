//
//  GGGraphicAuthManager.m
//  GGAlicomGraphicAuthenticationSDK
//
//  Created by 15991163 on 02/24/2026.
//  Copyright (c) 2026 15991163. All rights reserved.
//

#import "GGGraphicAuthManager.h"

//const GGGraphicAuthCaptchaErrorCode GGGraphicAuthCaptchaError_Authenticating = -99999;
const GGGraphicAuthCaptchaErrorCode GGGraphicAuthCaptchaError_MaximumNumberOfVerifications = -99998;

@interface GGGraphicAuthManager () <AlicomCaptcha4SessionTaskDelegate>

/// 验证码会话
@property (nonatomic, strong) AlicomCaptcha4Session *captchaSession;
/// 最大验证次数
@property (nonatomic, assign) NSInteger maxAttempts;
/// 当前验证次数
@property (nonatomic, assign) NSInteger currentAttempt;
/// 是否正在验证
@property (nonatomic, assign) BOOL verifying;
/// 验证成功回调
@property (nonatomic, copy) GGGraphicAuthSuccessBlock successBlock;
/// 验证失败回调
@property (nonatomic, copy) GGGraphicAuthFailedBlock failedBlock;
/// 验证码ID
@property (nonatomic, copy) NSString *captchaID;

@end

@implementation GGGraphicAuthManager

#pragma mark - Initialization

/**
 初始化方法
 @param captchaID 验证码ID
 @param maxAttempts 最大验证次数
 @return 验证管理器实例
 */
- (instancetype)initWithCaptchaID:(NSString *)captchaID maxAttempts:(NSInteger)maxAttempts configuration:(nullable AlicomCaptcha4SessionConfiguration *)configuration {
    self = [super init];
    if (self) {
        _captchaID = [captchaID copy];
        _maxAttempts = MAX(maxAttempts, 1); // 确保至少有1次验证机会
        _currentAttempt = 0;
        _verifying = NO;
        [self setupCaptchaSessionWithConfiguration:configuration];
    }
    return self;
}

- (instancetype)initWithCaptchaID:(NSString *)captchaID maxAttempts:(NSInteger)maxAttempts {
    return [self initWithCaptchaID:captchaID maxAttempts:maxAttempts configuration:nil];
}

/**
 便捷初始化方法，默认最大验证次数为5次
 @param captchaID 验证码ID
 @return 验证管理器实例
 */
- (instancetype)initWithCaptchaID:(NSString *)captchaID {
    return [self initWithCaptchaID:captchaID maxAttempts:5];
}

/**
 设置验证码会话
 */
- (void)setupCaptchaSessionWithConfiguration:(nullable AlicomCaptcha4SessionConfiguration *)configuration {
    self.captchaSession = [AlicomCaptcha4Session sessionWithCaptchaID:self.captchaID configuration:configuration];
    self.captchaSession.delegate = self;
}

#pragma mark - Public Methods
/**
 方法1：返回所有已定义的验证码错误码数组
 @return 包含所有GGGraphicAuthCaptchaErrorCode的NSArray<NSNumber *>
 */
+ (NSArray<NSNumber *> *)getAllCaptchaErrorCodes {
    return @[
//            @(GGGraphicAuthCaptchaError_Authenticating),          // -99999
            @(GGGraphicAuthCaptchaError_MaximumNumberOfVerifications) // -99998
            // 后续新增错误码，直接在这里追加：@(新常量),
        ];
}

/**
 实现方法2：判断错误码是否在数组中
 */
+ (BOOL)isCaptchaErrorCodeValid:(GGGraphicAuthCaptchaErrorCode)code {
    // 获取所有错误码数组
    NSArray<NSNumber *> *allCodes = [self getAllCaptchaErrorCodes];
    
    // 遍历数组判断是否包含目标code
    for (NSNumber *codeNum in allCodes) {
        if ([codeNum integerValue] == code) {
            return YES;
        }
    }
    return NO;
}

/**
 开始验证
 @param success 验证成功回调
 @param failed 验证失败回调
 */
- (void)startVerificationWithSuccess:(GGGraphicAuthSuccessBlock)success failed:(GGGraphicAuthFailedBlock)failed{
    if (self.isVerifying) {
//        if (completion) {
//            NSError *error = [NSError errorWithDomain:@"GGGraphicAuthErrorDomain" code:GGGraphicAuthCaptchaError_Authenticating userInfo:@{NSLocalizedDescriptionKey: @"正在验证中，请等待"}];
//            completion(NO, nil, error);
//        }
        return;
    }
    
    if (self.currentAttempt >= self.maxAttempts) {
        if (failed) {
            NSError *error = [NSError errorWithDomain:@"GGGraphicAuthErrorDomain" code:GGGraphicAuthCaptchaError_MaximumNumberOfVerifications userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"已达到最大验证次数(%ld次)", (long)self.maxAttempts]}];
            failed(error);
        }
        return;
    }
    
    self.verifying = YES;
    self.successBlock = success;
    self.failedBlock = failed;
    self.currentAttempt++;
    
    [self.captchaSession verify];
}

/**
 取消验证
 */
- (void)cancelVerification {
    if (self.isVerifying) {
        // 这里可以根据AlicomCaptcha4Session的API提供取消方法，如果有的话
        // 例如：[self.captchaSession cancel];
        self.verifying = NO;
        
        [self.captchaSession cancel];
//        if (self.completionBlock) {
//            NSError *error = [NSError errorWithDomain:@"GGGraphicAuthErrorDomain" code:-999999 userInfo:@{NSLocalizedDescriptionKey: @"验证已取消"}];
//            self.completionBlock(NO, nil, error);
//            self.completionBlock = nil;
//        }
    }
}

/**
 重置验证次数
 */
- (void)resetAttempts {
    self.currentAttempt = 0;
}

#pragma mark - AlicomCaptcha4SessionTaskDelegate

/**
 验证码会话结果回调
 @param captchaSession 验证码会话
 @param status 状态
 @param result 结果数据
 */
- (void)alicomCaptchaSession:(AlicomCaptcha4Session *)captchaSession didReceive:(NSString *)status result:(nullable NSDictionary *)result {
    self.verifying = NO;
    
    if (self.successBlock) {
        BOOL success = [status isEqualToString:@"1"];
        self.successBlock(success, result);
        self.successBlock = nil;
    }
}

/**
 验证码会话错误回调
 @param captchaSession 验证码会话
 @param error 错误信息
 */
- (void)alicomCaptchaSession:(AlicomCaptcha4Session *)captchaSession didReceiveError:(nonnull AlicomC4Error *)error {
    self.verifying = NO;
    
    if (self.failedBlock) {
        NSError *nsError = [NSError errorWithDomain:@"GGGraphicAuthErrorDomain" code:error.code.integerValue userInfo:@{NSLocalizedDescriptionKey: error.description}];
        self.failedBlock(nsError);
        self.failedBlock = nil;
    }
}

/**
 获取SDK版本
 @return 版本号
 */
+ (NSString *)alicomCaptcha4SDKVersion {
    return [AlicomCaptcha4Session sdkVersion];
}

#pragma mark - Getters

/**
 获取验证码ID
 @return 验证码ID
 */
- (NSString *)captchaID {
    return _captchaID;
}

/**
 获取最大验证次数
 @return 最大验证次数
 */
- (NSInteger)maxAttempts {
    return _maxAttempts;
}

/**
 获取当前验证次数
 @return 当前验证次数
 */
- (NSInteger)currentAttempt {
    return _currentAttempt;
}

/**
 获取是否正在验证
 @return 是否正在验证
 */
- (BOOL)isVerifying {
    return _verifying;
}

@end
