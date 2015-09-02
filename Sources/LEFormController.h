//
//  PAFormController.h
//  haofang
//
//  Created by leo on 14/11/7.
//  Copyright (c) 2014年 平安好房. All rights reserved.
//

#import "LEForm.h"


extern const NSInteger PAFormControllerSaveAlertTag;

@protocol LEFormControllerEvents <NSObject>

@optional
- (void)didLoadViewWithField:(LEFormField *)field;
- (void)didSelectField:(LEFormField *)field;

@end

@interface LEFormController : UIViewController <LEFormControllerEvents, UIScrollViewDelegate, UIAlertViewDelegate>

// form
@property (nonatomic, readonly) LEForm *form;
// valid 相关
// 遇到验证错误时是否停止，默认是YES
@property (nonatomic, assign) BOOL encounterErrorStop;
// 遇到验证出错时，显示效果处理
@property (nonatomic, copy) void (^errorDisplayHandler)(LEFormField *field, NSError *err);

// UI
@property (nonatomic, readonly) MGScrollView *scrollView;

// 覆盖这个方法来定制form, 覆盖时不必要调用super
- (LEForm *)loadForm;

- (void)refreshFormView;

// 进行表单值的检查，依赖PAFormField的validChecker
- (BOOL)checkFormValid;

// 显示loading提示
- (void)showLoadingMessage:(NSString *)message;
- (void)hideLoadingMessage;

@end
