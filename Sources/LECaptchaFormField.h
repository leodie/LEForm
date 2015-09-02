//
//  LECaptchaFormField.h
//
//  Created by leo on 14/12/26.
//

#import "LEForm.h"
#import "PADefaultFormView.h"

/*!
 @class PACaptchaFormField
 @abstract 对验证码暂时没想到太好的模式，先以继承方式实现
 */
@interface LECaptchaFormField : LEFormField

// 点击获取验证码button, 返回值表示是否开启倒计时
// YES 开始倒计时， NO不用开始倒计时
@property (nonatomic, copy) BOOL(^tapCaptchaButton)(void);
// 默认显示在验证码按钮上的文字
@property (nonatomic, copy) NSString *captchaText;
// 倒计时秒数
@property (nonatomic, assign) NSInteger countDownNum;

- (void) resetStatus;

@end

@interface PACaptchaFormView : PATextFormView

// 获取验证码按钮
@property (nonatomic, strong) UIButton *captchaButton;

// 是否在倒计时
- (BOOL)isCountDowning;
- (void) resetStatus;

@end