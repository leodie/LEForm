//
//  LECaptchaFormField.m
//
//  Created by leo on 14/12/26.
//

#import "LECaptchaFormField.h"
#import "UIView+Extra.h"

@implementation LECaptchaFormField

- (instancetype)init
{
    if (self = [super init]) {
        self.viewClass = [PACaptchaFormView class];
    }
    return self;
}

- (void) resetStatus {
    [(PACaptchaFormView *)(self.instanceView) resetStatus];
}

@end

@implementation PACaptchaFormView
{
    NSTimer *_countDownTimer;
    NSInteger _countDownCount;
}

- (void)initView
{
    [super initView];
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    
    LECaptchaFormField *field = (LECaptchaFormField *)self.fieldItem;
    // TODO: initialize
    self.captchaButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 85.0, 35.0)];
    
    // TODO: configure
    [self.captchaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.captchaButton setBackgroundColor:[UIColor orangeColor]];
    self.captchaButton.clipsToBounds = YES;
    self.captchaButton.layer.cornerRadius = 6.0;
    [self.captchaButton addTarget:self action:@selector(touchUpCaptchaButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.captchaButton setTitle:field.captchaText forState:UIControlStateNormal];
    [self.captchaButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    
    // TODO: add subviews
    [self addSubview:self.captchaButton];
    
    // TODO: add constriants
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.captchaButton.right = CGRectGetWidth(self.bounds) - 10.0;
    self.captchaButton.centerY = CGRectGetHeight(self.bounds)/2.0;
    self.textField.width = self.captchaButton.left - self.textField.left;
}

- (void)_startCountDown
{
    [self.captchaButton setBackgroundColor:[UIColor colorWithWhite:238.0/255.0 alpha:1.0]];
    [self.captchaButton setTitleColor:[UIColor colorWithWhite:128.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.captchaButton.layer setBorderColor:[UIColor colorWithWhite:204.0/255.0 alpha:1.0].CGColor];
    [self.captchaButton.layer setBorderWidth:0.5];
    LECaptchaFormField *field = (LECaptchaFormField *)self.fieldItem;
    _countDownCount = field.countDownNum;
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFire:) userInfo:nil repeats:YES];
    [_countDownTimer fire];
}

- (void)_stopCountDown
{
    [self.captchaButton setBackgroundColor:[UIColor orangeColor]];
    [self.captchaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.captchaButton.layer setBorderWidth:0.0];
    if ([_countDownTimer isValid]) {
        [_countDownTimer invalidate];
    }
    _countDownTimer = nil;
}

- (void) resetStatus {
    [self _stopCountDown];
    
    LECaptchaFormField *field = (LECaptchaFormField *)self.fieldItem;
    [self.captchaButton setTitle:field.captchaText forState:UIControlStateNormal];
}

- (void)timeFire:(NSTimer *)timer
{
    _countDownCount--;
    if (_countDownCount > 0) {
        [self.captchaButton setTitle:[NSString stringWithFormat:@"%zd秒后重发", _countDownCount] forState:UIControlStateNormal];
    } else {
        [self _stopCountDown];
        LECaptchaFormField *field = (LECaptchaFormField *)self.fieldItem;
        [self.captchaButton setTitle:field.captchaText forState:UIControlStateNormal];
    }
}

- (void)touchUpCaptchaButton:(id)sender
{
    if ([self.fieldItem isKindOfClass:[LECaptchaFormField class]] &&
        [(LECaptchaFormField *)self.fieldItem tapCaptchaButton] != NULL) {
        LECaptchaFormField *field = (LECaptchaFormField *)self.fieldItem;
        if (![self isCountDowning]) {
            BOOL res = field.tapCaptchaButton();
            if (res) {
                [self _startCountDown];
            }
        }
    }
}

- (BOOL)isCountDowning
{
    return _countDownTimer == nil ? NO : YES;
}

@end