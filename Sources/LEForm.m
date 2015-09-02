//
//  PAForm.m
//  haofang
//
//  Created by leo on 14/11/7.
//  Copyright (c) 2014年 平安好房. All rights reserved.
//

#import <objc/runtime.h>
#import <objc/message.h>

#import "LEForm.h"
#import "PADefaultFormView.h"

static NSMutableDictionary *defaultTypeViewClassDictionary;
static void *PAFormPropertiesKey = &PAFormPropertiesKey;

static inline NSArray *PAFormProperties(LEForm * form)
{
    if (!form) return nil;
    
    NSMutableArray *properties = objc_getAssociatedObject(form, PAFormPropertiesKey);
    if (!properties)
    {
        properties = [NSMutableArray array];
        Class subclass = [form class];
        while (subclass != [NSObject class])
        {
            unsigned int propertyCount;
            objc_property_t *propertyList = class_copyPropertyList(subclass, &propertyCount);
            for (unsigned int i = 0; i < propertyCount; i++)
            {
                //get property name
                objc_property_t property = propertyList[i];
                const char *propertyName = property_getName(property);
                NSString *key = @(propertyName); //这用法真神奇...
                
                id propertyObj = objc_msgSend(form, NSSelectorFromString(key));
                if ([propertyObj isKindOfClass:[LEFormField class]]) {
                    [propertyObj setValue:form forKey:@"form"];
                    [properties addObject:propertyObj];
                }
            }
            free(propertyList);
            subclass = [subclass superclass];
        }
        objc_setAssociatedObject(form, PAFormPropertiesKey, properties, OBJC_ASSOCIATION_RETAIN);
    }
    return properties;
}


@interface LEForm ()

@end

@implementation LEForm

+ (NSMutableDictionary *)defaultTypeViewClassDictionary
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultTypeViewClassDictionary = [@{
                                            kPADefaultFormField : [PADefaultFormView class],
                                            kPABlankFormField : [PABlankFormView class], 
                                            kPASelectionFormField : [PASelectionFormView class],
                                            kPATextFormField : [PATextFormView class],
                                            kPAOptionsFormField : [PAOptionsFormView class],
                                            kPAButtonFormField : [PAButtonFormView class],
                                            } mutableCopy];
    });
    return defaultTypeViewClassDictionary;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSArray *properties = PAFormProperties(self);
        NSLog(@"form properties \n===>%@<===", properties);
    }
    return self;
}

- (void)genrateViewsWithHandler:(void (^)(UIView *))handler
{
    if (handler != NULL) {
        for (LEFormField *field in objc_getAssociatedObject(self, PAFormPropertiesKey)) {
            UIView *formView = [self getFormViewWithField:field];
            handler(formView);
        }
    }
}

- (UIView *)getFormViewWithField:(LEFormField *)field
{
    Class viewClass = field.viewClass;
    if (viewClass == nil) {
        viewClass = [LEForm defaultTypeViewClassDictionary][field.type];
    }
    if (viewClass != nil) {
        @try {
            LEFormView *formView = [[viewClass alloc] initWithField:field];
            return formView;
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:@"init view class error" reason:[NSString stringWithFormat:@"%@", exception] userInfo:@{@"uperror": exception}];
        }
    } else {
        @throw [NSException exceptionWithName:@"view class error" reason:@"must need a view class in form field" userInfo:nil];
        return nil;
    }
}

- (NSMutableDictionary *)exportData
{
    return [self exportDataWithExcludeKeys:nil];
}

- (NSMutableDictionary *)exportDataWithExcludeKeys:(NSArray *)excludeKeys
{
    NSArray *properties = objc_getAssociatedObject(self, PAFormPropertiesKey);
    NSMutableDictionary *exportData = [NSMutableDictionary dictionary];
    for (LEFormField *field in properties) {
        if (![excludeKeys containsObject:field.key] &&
            field.value != nil &&
            field.key != nil) {
            [exportData setObject:field.value forKey:field.key];
        }
    }
    return exportData;
}

- (NSDictionary *)exportDataWithBlock:(id (^)(NSString *, id))processor
{
    NSArray *properties = objc_getAssociatedObject(self, PAFormPropertiesKey);
    NSMutableDictionary *exportData = [NSMutableDictionary dictionary];
    for (LEFormField *field in properties) {
        if (field.key != nil && field.value != nil) {
            id transValue = processor(field.key, field.value);
            if (transValue != nil) {
                [exportData setObject:transValue forKey:field.key];
            }
        }
    }
    return exportData;
}

- (void)enumerateFormFieldWithBlock:(void (^)(LEFormField *, BOOL *stop))block
{
    BOOL stop = NO;
    NSArray *properties = objc_getAssociatedObject(self, PAFormPropertiesKey);
    for (LEFormField *field in properties) {
        if (block) {
            block(field, &stop);
            if (stop == YES) {
                break;
            }
        }
    }
}

@end

@interface LEFormField ()

@property (nonatomic, weak) LEFormView *instanceView;

@end

@implementation LEFormField

static NSArray *observerKeys;

+ (void)initialize
{
    if (observerKeys == nil) {
        observerKeys = @[@"title", @"value", @"defaultValue", @"viewOptions", @"viewSize", @"margin"];
    }
}

- (void)dealloc
{
    [self removeObservers];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.type = kPADefaultFormField;
        [self _initialzieInternal];
        [self configureObservers];
    }
    return self;
}

- (instancetype)initWithType:(NSString *)type
{
    if (self = [super init]) {
        self.type = type;
        [self _initialzieInternal];
        [self configureObservers];
    }
    return self;
}

- (void)_initialzieInternal
{
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    self.viewSize = CGSizeMake(CGRectGetWidth(appFrame), 45.0);
    self.margin = UIEdgeInsetsZero;
}

- (void)configureObservers
{
    for (NSString *key in observerKeys) {
        [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)removeObservers
{
    @try {
        for (NSString *key in observerKeys) {
            [self removeObserver:self forKeyPath:key];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@ remove observer exception %@", self, exception);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([observerKeys containsObject:keyPath]) {
        if ([keyPath isEqualToString:@"value"]) {
            self.form.dirty = YES;
            
            if (self.valueChangedBlock) {
                self.valueChangedBlock();
            }
        }
        else if ([keyPath isEqualToString:@"viewSize"]) {
            self.instanceView.size = self.viewSize;
            [self refreshLayout];
        } else if ([keyPath isEqualToString:@"margin"]) {
            self.instanceView.margin = self.margin;
            [self refreshLayout];
        }
        [self.instanceView update];
    }
}

- (void)refreshLayout
{
    if ([self.instanceView respondsToSelector:@selector(parentBox)]) {
//        [(MGScrollView *)self.instanceView.parentBox layoutWithDuration:0.1 completion:NULL];
        [(MGScrollView *)self.instanceView.parentBox layout];
    }
}

@end


@implementation LEFormView

- (void)dealloc
{
    
}

- (instancetype)initWithField:(LEFormField *)field
{
    if (self = [super init]) {
        _fieldItem = field;
        field.instanceView = self;
        
        self.size = self.fieldItem.viewSize;
        self.padding = UIEdgeInsetsZero;
        self.margin = self.fieldItem.margin;
        self.clipsToBounds = YES;
        
        [self initView];
        [self update];
        
        for (id key in [_fieldItem.viewOptions allKeys]) {
            [_fieldItem.instanceView setValue:_fieldItem.viewOptions[key] forKeyPath:key];
        }
    }
    return self;
}

- (void)initView
{
    // TODO: let descendant implement
}

- (void)update
{
    // TODO: let descendant implement
}

- (void)onTapped
{
    // TODO: let descendant implement
}


- (UIViewController *)ownerViewController {
    return self.fieldItem.form.ownerController;
}

+ (CGSize)defaultSize {
    CGSize size = [[UIScreen mainScreen] applicationFrame].size;
    return CGSizeMake(size.width, 45.0);
}

@end
