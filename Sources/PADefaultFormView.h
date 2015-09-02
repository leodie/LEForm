//
//  PADefaultFormView.h
//  haofang
//
//  Created by leo on 14/11/7.
//  Copyright (c) 2014年 平安好房. All rights reserved.
//

#import "LEForm.h"
#import "LEOptionsView.h"
#import "LEOptionModel.h"

#define DEFAULT_FORMVIEW_BORDERCOLOR [UIColor colorWithWhite:221.0/255.0 alpha:1.0]
// 验证数值
static inline id validValueChanger(LEFormField *field, Class validClass)
{
    id valueTmp = field.value == nil ? field.defaultValue : field.value;
    if (field.valueTrans != NULL) {
        id transValue = field.valueTrans(valueTmp);
        if ([transValue isKindOfClass:validClass]) {
            return transValue;
        }
    } else {
        if ([valueTmp isKindOfClass:validClass]) {
            return valueTmp;
        }
    }

    return nil;
}

// 默认风格 default
@interface PADefaultFormView : LEFormView
{
    UILabel *_titleLabel;
    UIEdgeInsets _inPadding;
    UIColor *_cachePreColor;
}

@property (nonatomic, readonly) UILabel *titleLabel;

@end

@interface PABlankFormView : LEFormView

@end

// 选择风格 selection, 多个accessory
@interface PASelectionFormView : PADefaultFormView

@property (nonatomic, readonly) UILabel *contentLabel;
@property (nonatomic, readonly) UILabel *accessoryLabel;

@end

// 文本风格 text
@interface PATextFormView : PADefaultFormView

@property (nonatomic, readonly) UITextField *textField;
@property (nonatomic, readonly) UILabel *suffixLabel;

@end

// 多选项 options
@interface PAOptionsFormView : PADefaultFormView

@property (nonatomic, readonly) UILabel *contentLabel;

@property (nonatomic, readonly) LEOptionsView *optionsView;

- (void)refreshDataSource;

@end

@interface PAButtonFormView : LEFormView

@property (nonatomic, readonly) UIButton *button;

@end


