//
//  PADefaultFormView.m
//  haofang
//
//  Created by leo on 14/11/7.
//  Copyright (c) 2014年 平安好房. All rights reserved.
//

#import "PADefaultFormView.h"
#import "UIView+Extra.h"

#define ACCESSORY_STR PAICONFONT_E61F
#define DEFAULT_TEXT_COLOR [UIColor colorWithWhite:88.0/255.0 alpha:1.0]
#define DEFAULT_TEXT_FONT [UIFont systemFontOfSize:14.0]

@implementation PADefaultFormView
{
    
}

- (void)initView
{
    [super initView];
    // TODO: initialize
    _titleLabel = [[UILabel alloc] init];
    
    // TODO: configure
    self.backgroundColor = [UIColor whiteColor];
    self.bottomBorderColor = DEFAULT_FORMVIEW_BORDERCOLOR;
    
    _inPadding = UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0);
    
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = DEFAULT_TEXT_FONT;
    _titleLabel.textColor = DEFAULT_TEXT_COLOR;
    
    // TODO: add subviews
    [self addSubview:_titleLabel];
    
    // TODO: add constriants
}

- (void)update
{
    _titleLabel.text = self.fieldItem.title;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = UIEdgeInsetsInsetRect(self.bounds, _inPadding);
    _titleLabel.frame = frame;
}

@end

@implementation PABlankFormView


@end

@implementation PASelectionFormView

- (void)initView
{
    [super initView];
    // TODO: initialize
    _contentLabel = [[UILabel alloc] init];
    _accessoryLabel = [[UILabel alloc] init];
    
    // TODO: configure
    
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.font = DEFAULT_TEXT_FONT;
    _contentLabel.textColor = DEFAULT_TEXT_COLOR;
    
    _accessoryLabel.font = [UIFont systemFontOfSize:14.0];
    
    // TODO: add subviews
    [self addSubview:_contentLabel];
    [self addSubview:_accessoryLabel];
    
    // TODO: add constriants
}

- (void)update
{
    [super update];
    _contentLabel.text = validValueChanger(self.fieldItem, [NSString class]);
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_titleLabel sizeToFit];
    _titleLabel.left = _inPadding.left;
    _titleLabel.centerY = self.height / 2.0;
    
    [_contentLabel sizeToFit];
    _contentLabel.left = _titleLabel.right + 10.0;
    _contentLabel.centerY = self.height / 2.0;
    
    _accessoryLabel.right = self.width - _inPadding.right;
    _accessoryLabel.centerY = self.height / 2.0;
    _contentLabel.width = _accessoryLabel.left - _contentLabel.left;
}

- (void)onTapped
{
    Class selectionClass = self.fieldItem.selectionClass;
    if (selectionClass != nil) {
        UINavigationController *navi = self.fieldItem.form.ownerController.navigationController;
        if (navi != nil) {
            UIViewController *ctrller = [[selectionClass alloc] initWithField:self.fieldItem];
            [navi pushViewController:ctrller animated:YES];
        }
    }
}

@end

@interface PATextFormView () <UITextFieldDelegate>

@property (nonatomic, assign) UITextFieldViewMode _rightViewMode;
@property (nonatomic, assign) BOOL _userInteractionEnabled;

@end

@implementation PATextFormView

- (void)initView {
    [super initView];
    // TODO: initialize
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0f, 20.0f)];
    _suffixLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0f, 20.0f)];
    
    // TODO: configure
    __rightViewMode = UITextFieldViewModeAlways;
    
    _textField.backgroundColor = [UIColor clearColor];
    _textField.userInteractionEnabled = NO;
    _textField.delegate = self;
    _textField.textColor = DEFAULT_TEXT_COLOR;
    _textField.font = DEFAULT_TEXT_FONT;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 44.0)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(touchUpDone:)];
    [toolBar setItems:@[spaceItem, doneItem]];
    _textField.inputAccessoryView = toolBar;
    
    _suffixLabel.backgroundColor = [UIColor clearColor];
    _suffixLabel.textAlignment = NSTextAlignmentCenter;
    _suffixLabel.textColor = DEFAULT_TEXT_COLOR;
    _suffixLabel.font = DEFAULT_TEXT_FONT;
    
    // TODO: add subviews
    [self.textField setRightView:_suffixLabel];
    [self addSubview:_textField];
    
    // TODO: add constriants
}

- (void)update
{
    [super update];
    _textField.placeholder = self.fieldItem.placeholder;
    _textField.text = validValueChanger(self.fieldItem, [NSString class]);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_titleLabel sizeToFit];
    _titleLabel.left = _inPadding.left;
    _titleLabel.centerY = self.height / 2.0;
    
    _textField.centerY = self.height / 2.0;
    _textField.width = self.width - _titleLabel.right - _inPadding.right - _inPadding.left - 5.0;
    _textField.right = self.width - _inPadding.right;
    if ([_suffixLabel.text length] > 0) {
        [_suffixLabel sizeToFit];
        _textField.rightViewMode = self._rightViewMode;
    } else if (_textField.rightView != nil) {
        _textField.rightViewMode = self._rightViewMode;
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)onTapped
{
    _textField.userInteractionEnabled = YES;
    [self.textField becomeFirstResponder];
}

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath
{
    if ([keyPath isEqualToString:@"textField.keyboardType"]) {
        self.textField.keyboardType = [value unsignedIntegerValue];
    } else if ([keyPath isEqualToString:@"textField.textAlignment"]) {
        self.textField.textAlignment = [value unsignedIntegerValue];
    } else if ([keyPath isEqualToString:@"textField.rightViewMode"]) {
        self._rightViewMode = [value unsignedIntegerValue];
    } else if ([keyPath isEqualToString:@"textField.autocorrectionType"]) {
        self.textField.autocorrectionType = [value unsignedIntegerValue];
    } else if ([keyPath isEqualToString:@"textField.userInteractionEnabled"]) {
        self._userInteractionEnabled = [keyPath boolValue];
    } else {
        [super setValue:value forKeyPath:keyPath];
    }
}

- (void)touchUpDone:(id)sender
{
    self.textField.userInteractionEnabled = NO;
    [self.textField resignFirstResponder];
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *changedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.fieldItem.valueChecker != NULL) {
        return self.fieldItem.valueChecker(changedText);
    } else {
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.fieldItem.reverseValueTrans != NULL) {
        self.fieldItem.value = self.fieldItem.reverseValueTrans(textField.text);
    } else if (self.fieldItem.valueClass == nil ||
        [self.fieldItem.valueClass isSubclassOfClass:[NSString class]]) {
        self.fieldItem.value = textField.text;
    }
    textField.userInteractionEnabled = NO;
}

@end

@interface PAOptionsFormView () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation PAOptionsFormView
{
    NSArray *_optionsCache;
}

- (void)initView
{
    [super initView];
    // TODO: initialize
    _contentLabel = [[UILabel alloc] init];
    CGSize size = [[UIScreen mainScreen] applicationFrame].size;
    _optionsView = [[LEOptionsView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, 240.0)];
    
    // TODO: configure
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.font = DEFAULT_TEXT_FONT;
    _contentLabel.textColor = DEFAULT_TEXT_COLOR;
    _contentLabel.textAlignment = NSTextAlignmentRight;
    
    _optionsView.pickerView.delegate = self;
    _optionsView.pickerView.dataSource = self;
    [_optionsView addDoneItemWithTarget:self action:@selector(touchUpDone:)];
    
    [self refreshDataSource];
    
    // TODO: add subviews
    [self addSubview:_contentLabel];
    
    // TODO: add constriants
}

- (void)update
{
    [super update];
    self.contentLabel.text = validValueChanger(self.fieldItem, [NSString class]) ? : @"";
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_titleLabel sizeToFit];
    _titleLabel.left = _inPadding.left;
    _titleLabel.centerY = self.height / 2.0;
    
    [_contentLabel sizeToFit];
    _contentLabel.left = _titleLabel.right + 10.0;
    _contentLabel.width = self.width - _contentLabel.left - _inPadding.right;
    _contentLabel.centerY = self.height / 2.0;
}

- (void)onTapped
{
    if (self.fieldItem.value != nil) {
        id value = self.fieldItem.value;
        if ([value isKindOfClass:[NSArray class]] && [value count] == [_optionsCache count]) {
            [_optionsCache enumerateObjectsUsingBlock:^(NSArray *option, NSUInteger componnet, BOOL *stopA) {
                [option enumerateObjectsUsingBlock:^(id<LEFormOptionProtocol> obj, NSUInteger idx, BOOL *stopB) {
                    if ([[obj value] isEqual:value]) {
                        [self.optionsView.pickerView selectRow:idx inComponent:componnet animated:NO];
                        *stopB = YES;
                    }
                }];
            }];
        } else if ([value isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = value;
            for (NSUInteger i = 0; i < indexPath.length; i++) {
                [self.optionsView.pickerView selectRow:[indexPath indexAtPosition:i] inComponent:i animated:NO];
            }
        }
    }
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    if (![self isFirstResponder]) {
        _cachePreColor = self.backgroundColor;
        self.backgroundColor = [UIColor colorWithWhite:245.0/255.0 alpha:1.0];
    }
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    if ([self isFirstResponder]) {
        self.backgroundColor = _cachePreColor;
    }
    return [super resignFirstResponder];
}

- (UIView *)inputView
{
    return self.optionsView;
}

- (void)touchUpDone:(id)sender
{
    [self updateValue];
    [self resignFirstResponder];
}

- (void)refreshDataSource
{
    _optionsCache = self.fieldItem.generator();
    [_optionsView.pickerView reloadAllComponents];
}

- (void)updateValue
{
    UIPickerView *pickerView = self.optionsView.pickerView;
    NSObject *valueTmp = [[_optionsCache objectAtIndex:0] objectAtIndex:0];
    if ([valueTmp conformsToProtocol:@protocol(LEFormOptionProtocol)]) {
        NSInteger componentCount = [pickerView numberOfComponents];
        NSMutableArray *valueTmp = [NSMutableArray arrayWithCapacity:componentCount];
        for (NSUInteger i = 0; i < componentCount; i++) {
            NSObject *comp = [[_optionsCache objectAtIndex:i] objectAtIndex:[pickerView selectedRowInComponent:i]];
            if ([comp conformsToProtocol:@protocol(LEFormOptionProtocol)]) {
                [valueTmp addObject:(NSObject<LEFormOptionProtocol> *)comp];
            } else if ([comp isKindOfClass:[NSString class]]) {
                [valueTmp addObject:@([pickerView selectedRowInComponent:i])];
            } else {
                [valueTmp addObject:[NSNull null]];
            }
        }
        if (self.fieldItem.reverseValueTrans != NULL) {
            self.fieldItem.value = self.fieldItem.reverseValueTrans(valueTmp);
        } else {
            self.fieldItem.value = valueTmp;
        }
    } else if ([valueTmp isKindOfClass:[NSString class]]) {
        NSInteger componentCount = [pickerView numberOfComponents];
        NSIndexPath *indexPath = nil;
        for (NSUInteger i = 0; i < componentCount; i++) {
            if (i == 0) {
                indexPath = [NSIndexPath indexPathWithIndex:[pickerView selectedRowInComponent:0]];
            } else {
                indexPath = [indexPath indexPathByAddingIndex:[pickerView selectedRowInComponent:i]];
            }
        }
        if (self.fieldItem.reverseValueTrans != NULL) {
            self.fieldItem.value = self.fieldItem.reverseValueTrans(indexPath);
        } else {
            self.fieldItem.value = indexPath;
        }
    }
}

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath
{
    if ([keyPath isEqualToString:@"contentLabel.textAlignment"]) {
        self.contentLabel.textAlignment = [value unsignedIntegerValue];
    } else {
        [super setValue:value forKeyPath:keyPath];
    }
}

#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSObject *valueTmp = [[_optionsCache objectAtIndex:component] objectAtIndex:row];
    if ([valueTmp conformsToProtocol:@protocol(LEFormOptionProtocol)]) {
        return [(NSObject<LEFormOptionProtocol> *)valueTmp name];
    } else if ([valueTmp isKindOfClass:[NSString class]]) {
        return (NSString *)valueTmp;
    } else {
        return @"Unknown";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self updateValue];
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [_optionsCache count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[_optionsCache objectAtIndex:component] count];
}

@end

@implementation PAButtonFormView
{
    UIEdgeInsets _inPadding;
}

- (void)initView
{
    // TODO: initialize
    _button = [[UIButton alloc] init];
    
    // TODO: configure
    _inPadding = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    
    self.backgroundColor = [UIColor clearColor];
    
    _button.backgroundColor = [UIColor colorWithRed:0xFC/255.0 green:0x8D/255.0 blue:0x2A/255.0 alpha:1.0];
    _button.userInteractionEnabled = NO;
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button.layer.cornerRadius = 3.0;
    
    // TODO: add subviews
    [self addSubview:_button];
    
    // TODO: add constriants
}

- (void)update
{
    [_button setTitle:self.fieldItem.title forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    CGRect rect = UIEdgeInsetsInsetRect(self.bounds, _inPadding);
    _button.frame = rect;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint buttonPoint = [self convertPoint:point toView:_button];
    return [_button pointInside:buttonPoint withEvent:event];
}

@end
