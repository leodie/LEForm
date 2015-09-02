//
//  LEOptionsView.h
//
//  Created by leo on 14/11/10.
//

#import <UIKit/UIKit.h>

@interface LEOptionsView : UIView

@property (nonatomic, readonly) UIToolbar *toolBar;
@property (nonatomic, readonly) UIPickerView *pickerView;

- (void)addDoneItemWithTarget:(id)target action:(SEL)action;

@end
