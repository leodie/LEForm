//
//  PAFormDetailController.h
//
//  Created by leo on 14/11/11.
//

#import "LEForm.h"

/*
 @ LEFormDetailController
 @ selection 之后 detail 的必须遵守的协议
 @ 自动初始化时必定调用 initWithField:
 @ 实例操作结果必定只影响fieldItem
 */
@protocol LEFormDetailController <NSObject>

@property (nonatomic, readonly, weak) LEFormField *fieldItem;

- (instancetype)initWithField:(LEFormField *)field;

@end

@interface LEFormTextDetailController : UIViewController <LEFormDetailController>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, readonly, weak) LEFormField *fieldItem;

- (instancetype)initWithField:(LEFormField *)field;

@end