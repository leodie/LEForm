//
//  PAFormController.m
//  haofang
//
//  Created by leo on 14/11/7.
//  Copyright (c) 2014年 平安好房. All rights reserved.
//

#import "LEFormController.h"

const NSInteger PAFormControllerSaveAlertTag = 9527;

@interface LEFormController ()<UIAlertViewDelegate>

@end

@implementation LEFormController
{
    __weak UIView *_firstRespondView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self _init];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self _init];
    }
    return self;
}

- (void)_init
{
//    __weak typeof(self) weakSelf = self;
    self.encounterErrorStop = YES;
    self.errorDisplayHandler = ^(LEFormField *field, NSError *err) {
//        [PANoticeUtil showNotice:err.localizedDescription inView:[[[UIApplication sharedApplication] delegate] window] duration:1.0];
    };
}

#pragma mark override property

#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _form = [self loadForm];
    _form.ownerController = self;
    [self generateViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.view removeGestureRecognizer:[self tap]];
//    [self registerKeyboardNotification];
    self.scrollView.keepFirstResponderAboveKeyboard = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismissKeyboard];
//    [self breakdown];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    if (_firstRespondView != nil && !iOS7) {
//        [self dismissKeyboard];
//    }
}

#pragma mark self method

- (LEForm *)loadForm
{
    return self.form;
}

- (void)generateViews
{
    // initialize
    _scrollView = [[MGScrollView alloc] initWithFrame:self.view.bounds];
    
    // configure
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _scrollView.contentLayoutMode = MGLayoutGridStyle;
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.alwaysBounceHorizontal = NO;
    
//    if (iOS7) {
//        self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//    }
    
    [self.view addSubview:_scrollView];
    
    [self refreshFormView];
}

- (void)refreshFormView
{
    [_scrollView.boxes removeAllObjects];
    __weak typeof(self) weakSelf = self;
    [self.form genrateViewsWithHandler:^(UIView *formView) {
        LEFormView *view = (LEFormView *)formView;
        __weak typeof(view.fieldItem) weakField = view.fieldItem;
        view.onTap = ^ {
            [weakSelf didSelectField:weakField];
        };
        if ([weakSelf respondsToSelector:@selector(didLoadViewWithField:)]) {
            [weakSelf didLoadViewWithField:weakField];
        }
        [_scrollView.boxes addObject:view];
    }];
    
    [_scrollView layout];
}

- (BOOL)checkFormValid
{
    __block BOOL valid = YES;
    [self.form enumerateFormFieldWithBlock:^(LEFormField *field, BOOL *stop) {
        if (field.validChecker != NULL) {
            NSError *err = field.validChecker(field.value);
            if (err != nil) {
                valid = NO;
                if (self.errorDisplayHandler != NULL) {
                    self.errorDisplayHandler(field, err);
                    if (self.encounterErrorStop == YES) {
                        *stop = YES;
                    }
                }
            }
        }
    }];
    return valid;
}

- (void)dismissKeyboard
{
//    [super dismissKeyboard];
    _firstRespondView = nil;
}

- (void)showLoadingMessage:(NSString *)message
{
//    [MBProgressHUD showHUDAddedTo:self.view text:message animated:YES];
}

- (void)hideLoadingMessage
{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark event respond

- (void)didLoadViewWithField:(LEFormField *)field
{
//    PALogV(@"didLoadField %@", field);
}

- (void)didSelectField:(LEFormField *)field
{
//    PALogV(@"didSelectField %@", field);
//    NSString *type = field.type;
    if ([field.instanceView canBecomeFirstResponder]) {
        _firstRespondView = field.instanceView;
    }
    [field.instanceView onTapped];
}


#pragma mark - Keyboard management

- (void)scrollToView:(UIView *)view keyboardFrame: (CGRect)keyboardFrame{
    CGRect frame = [self.scrollView convertRect:view.frame fromView:view.superview];
    [self.scrollView scrollRectToVisible:CGRectInset(frame, 0, 0) animated:NO];
}


- (void) keyboardWillShow:(NSNotification *)notification {
    UIResponder *first = self.currentFirstResponder;
    if ([first isKindOfClass:UIView.class] && [(id)first isDescendantOfView:self.scrollView]) {
        NSDictionary *keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        keyboardFrame = [self.scrollView.window convertRect:keyboardFrame toView:self.scrollView.superview];
        CGFloat inset = self.scrollView.frame.origin.y + self.scrollView.frame.size.height - keyboardFrame.origin.y;
        
        CGFloat offset = self.scrollView.contentOffset.y;
        CGRect visibleRect = CGRectMake(0, offset, self.scrollView.width, self.scrollView.height - keyboardFrame.size.height);
        CGRect frame = [self.scrollView convertRect:_firstRespondView.frame fromView:_firstRespondView.superview];
        BOOL needsScrolling = !CGRectContainsRect(visibleRect, frame);
        
        UIEdgeInsets scrollContentInset = self.scrollView.contentInset;
        scrollContentInset.bottom = needsScrolling ? inset : MAX(inset, scrollContentInset.bottom);
        
        UIEdgeInsets scrollScrollIndicatorInsets = self.scrollView.scrollIndicatorInsets;
        scrollScrollIndicatorInsets.bottom = inset;//tableContentInset.bottom;
        
        
        
        //animate insets
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:(UIViewAnimationCurve)keyboardInfo[UIKeyboardAnimationCurveUserInfoKey]];
        [UIView setAnimationDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];

        self.scrollView.contentInset = scrollContentInset;
        self.scrollView.scrollIndicatorInsets = scrollScrollIndicatorInsets;
        
        // 只有当_firstRespondView不可见时，才滚动scrollview
        if (needsScrolling) {
            [self scrollToView:_firstRespondView keyboardFrame:keyboardFrame];
        }
        
        [UIView commitAnimations];
    }
}


- (void) keyboardWillHide:(NSNotification *)notification {
    UIResponder *first = self.currentFirstResponder;
    if ([first isKindOfClass:UIView.class] && [(id)first isDescendantOfView:self.scrollView]) {
        UIEdgeInsets contentInsets           = UIEdgeInsetsZero;
        NSDictionary *info                   = notification.userInfo;
        // Prepare for the animation
        CGFloat animationDuration            = ((NSNumber *)[info objectForKey:UIKeyboardAnimationDurationUserInfoKey]).doubleValue;
        NSUInteger animationCurve            = ((NSNumber *)[info objectForKey:UIKeyboardAnimationCurveUserInfoKey]).intValue;
        
        [UIView animateWithDuration:animationDuration
                              delay:0
                            options:animationCurve
                         animations:^{
                             self.scrollView.contentInset          = contentInsets;
                             self.scrollView.scrollIndicatorInsets = contentInsets;
                         }
                         completion:nil];
    }
}

@end
