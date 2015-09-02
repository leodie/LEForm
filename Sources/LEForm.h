//
//  LEForm.h
//  haofang
//
//  Created by leo on 14/11/7.
//

#import <Foundation/Foundation.h>
#import "MGBoxKit/MGBoxKit.h"

typedef id(^valueTransform)(id value);

#define DEFAULT_FIELD_HEIGHT 45.0
#define DEFAULT_SIZE CGSizeMake(APPLICATIONWIDTH, DEFAULT_FIELD_HEIGHT)
#define DEFAULT_FORMVIEW_BORDERCOLOR [UIColor colorWithWhite:221.0/255.0 alpha:1.0]

/**
 表单编辑状态：新建、读取、更新和删除
 */
typedef enum {
    PAFormEditTypeNew,
    PAFormEditTypeRead,
    PAFormEditTypeUpdate,
    PAFormEditTypeDelete,
}PAFormEditType;

// 默认
static NSString * const kPADefaultFormField = @"default";
// 空白
static NSString * const kPABlankFormField = @"blank";
// 选择
static NSString * const kPASelectionFormField = @"selection";
// 文本输入
static NSString * const kPATextFormField = @"text";
// 单项多项选择
static NSString * const kPAOptionsFormField = @"options";
// 按钮 主要是一些Submit
static NSString * const kPAButtonFormField = @"button";

@class LEFormField;
@class LEFormView;
/*
 @ 类似于HTML表单设计，一个form(PAForm)下有多个input(PAFormField)
 */
@interface LEForm : NSObject

// 宿主controller
@property (nonatomic, weak) UIViewController *ownerController;
@property (nonatomic, assign) PAFormEditType editType;

/*!
 标记表单是否被编辑过，初始值为NO，当表单数据被编辑后该字段应当被标记为YES。
 表单数据回填后，应当设置为NO。
 */
@property (nonatomic, assign) BOOL dirty;

// 默认type对应的cell，当然可以覆盖field里的viewClass来替换
+ (NSMutableDictionary *)defaultTypeViewClassDictionary;

- (UIView *)getFormViewWithField:(LEFormField *)field;
- (void)genrateViewsWithHandler:(void (^)(UIView *formView))handler;

/*
 *获取表单的数据，使用NSMutableDictionary方便后期
 *导出数据为所有field的key, value对
 *excludeKeys代表默写不想要的keys
 */
- (NSMutableDictionary *)exportData;
- (NSMutableDictionary *)exportDataWithExcludeKeys:(NSArray *)excludeKeys;
/*
 * 同样用于导出数据，不同的是可用block直接决定是否需要值，顺便转换值，突然感觉函数式编程好Diao
 * 在block里返回nil，就是不需要这个value
 */
- (NSDictionary *)exportDataWithBlock:(id (^)(NSString *key, id value))processor;

/*
 *
 */
- (void)enumerateFormFieldWithBlock:(void (^)(LEFormField *, BOOL *stop))block;

@end

typedef NSArray *(^optionsGenerator)(void);

/*
 @ PAFormField 模型
 */
@interface LEFormField : NSObject

// 所属的form
@property (nonatomic, readonly, weak) LEForm *form;
// 类型 类似 input.type
@property (nonatomic, copy) NSString *type;
// 标题文字
@property (nonatomic, copy) NSString *title;
// viewClass custom
@property (nonatomic, strong) Class viewClass;
// valueClass custom
@property (nonatomic, strong) Class valueClass;
// 对应selection后的controller
@property (nonatomic, strong) Class selectionClass;
// 类似 input.name
@property (nonatomic, copy) NSString *key;
// 类似 input.value
@property (nonatomic, strong) id value;
// default value
@property (nonatomic, strong) id defaultValue;
// placeholder
@property (nonatomic, copy) NSString *placeholder;
// field -> view 数值转换
@property (nonatomic, copy) valueTransform valueTrans;
// view -> field 数值转换
@property (nonatomic, copy) valueTransform reverseValueTrans;
// value checker 在text field类似区域用作数值是否允许输入, before check
@property (nonatomic, copy) BOOL(^valueChecker)(id value);
// valid checker 提交之前检查合法性的checker，after check
@property (nonatomic, copy) NSError *(^validChecker)(id value);
@property (nonatomic, copy) void(^valueChangedBlock)();
// 默认box大小
@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) UIEdgeInsets margin;
// 使用KVC控制subview效果
@property (nonatomic, strong) NSDictionary *viewOptions;
// 定制数据
@property (nonatomic, strong) id userInfo;

// 对应的view实例
@property (nonatomic, readonly, weak) LEFormView *instanceView;
// 对于options类型下得返回定义
@property (nonatomic, copy) optionsGenerator generator;

@property (nonatomic, assign) CGFloat maximumInputs;  // 允许的最大输入数量
@property (nonatomic, assign) CGFloat minimumInputs;  // 允许的最小输入数量

- (instancetype)initWithType:(NSString *)type;

@end


/*
 @ PAFormView 基础View
 */
@interface LEFormView : MGBox

@property (nonatomic, readonly, weak) LEFormField *fieldItem;

- (instancetype)initWithField:(LEFormField *)field;

// 初始化
- (void)initView;

// item更新
- (void)update;

// 控制一些被点击后的效果
- (void)onTapped;


- (UIViewController *)ownerViewController;

+ (CGSize)defaultSize;

@end