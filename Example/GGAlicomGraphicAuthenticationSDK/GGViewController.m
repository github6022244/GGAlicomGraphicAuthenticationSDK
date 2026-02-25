//
//  GGViewController.m
//  GGAlicomGraphicAuthenticationSDK
//
//  Created by 15991163 on 02/24/2026.
//  Copyright (c) 2026 15991163. All rights reserved.
//

#import "GGViewController.h"

/// 替换为自己的AppID
#define GGAlicomCaptcha4AppID @""

#import <GGGraphicAuthManager.h>

@interface GGViewController ()
@property (strong, nonatomic) UIButton *startBtn;
@property (nonatomic, strong) GGGraphicAuthManager *graphicManager;

@end

@implementation GGViewController

#pragma mark ------------------------- Cycle -------------------------
- (void)dealloc {
    [self.graphicManager cancelVerification];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setUpUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------------------------- UI -------------------------
- (void)setUpUI {
    [self.view addSubview:self.startBtn];
}

- (void)viewDidLayoutSubviews {
    self.startBtn.frame = CGRectMake(0.f, 0.f, 100.f, 50.f);
    
    self.startBtn.center = self.view.center;
}

#pragma mark ------------------------- Actions -------------------------
- (void)test {
    // AppID合法判断
    if (!GGAlicomCaptcha4AppID.length) {
        [self _showAlertWithTitle:nil message:@"请完善GGAlicomCaptcha4AppID宏，\n改为自己的AppID" block:nil];
        return;
    }
    
    // 开始验证
    [self.graphicManager startVerificationWithSuccess:^(BOOL isSuccess, NSDictionary * _Nullable result) {
        if (isSuccess) {
            // 成功
            [self _showAlertWithTitle:@"成功" message:[NSString stringWithFormat:@"success result： %@", result] block:nil];
        } else {
            // 验证失败，如用户选择了错误的顺序，勿吐司，图形会刷新
            NSLog(@"验证失败 failed result：%@", result);
        }
    } failed:^(NSError * _Nullable error) {
        if ([GGGraphicAuthManager isCaptchaErrorCodeValid:error.code]) {
            // 是自己创建的error，例如超过最大次数限制，可以吐司
            [self _showAlertWithTitle:@"失败" message:[NSString stringWithFormat:@"自己创建error：%@", error.localizedDescription] block:nil];
        } else {
            // 阿里检测sdk反馈error，经测试，勿吐司，否则会影响sdk验证view响应点击事件
            NSLog(@"阿里检测sdk反馈error：%@", error.localizedDescription);
        }
    }];
}

#pragma mark ------------------------- Private -------------------------
#pragma mark --- 弹框
- (void)_showAlertWithTitle:(nullable NSString *)title message:(NSString *)message block:(void(^)())block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title ? : @"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block();
        }
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark ------------------------- set / get -------------------------
- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_startBtn setBackgroundColor:[UIColor orangeColor]];
        
        [_startBtn setTitle:@"测试" forState:UIControlStateNormal];
        
        _startBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        
        _startBtn.layer.cornerRadius = 4.f;
        
        [_startBtn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _startBtn;
}

- (GGGraphicAuthManager *)graphicManager {
     if (!_graphicManager) {
         _graphicManager = [[GGGraphicAuthManager alloc] initWithCaptchaID:GGAlicomCaptcha4AppID];
     }
 
     return _graphicManager;
}

@end
