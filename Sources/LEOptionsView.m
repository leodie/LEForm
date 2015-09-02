//
//  LEOptionsView.m
//
//  Created by leo on 14/11/10.
//

#import "LEOptionsView.h"

#define TOOLBAR_HEIGHT 44.0

@implementation LEOptionsView
{
    UIBarButtonItem *_spaceItem;
    UIBarButtonItem *_doneItem;
}

- (UIBarButtonItem *)spaceItem;
{
    if (_spaceItem == nil) {
        _spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    return _spaceItem;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    // TODO: initialize
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), TOOLBAR_HEIGHT)];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, TOOLBAR_HEIGHT, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - TOOLBAR_HEIGHT)];
    
    // TODO: configure
    _toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _pickerView.showsSelectionIndicator = YES;
    
    // TODO: add subviews
    [self addSubview:_toolBar];
    [self addSubview:_pickerView];
    
    // TODO: add constriants
}

- (void)addDoneItemWithTarget:(id)target action:(SEL)action
{
    _doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:target action:action];
    [_toolBar setItems:@[[self spaceItem], _doneItem]];
}

@end
