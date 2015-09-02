//
//  UIView+Extra.h
//  LEGears
//
//  Created by leo on 14-9-23.
//  Copyright (c) 2014年 LGear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extra)

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

- (UIImage *)screenshot;

@end

@interface UIView (Layout)

/*!
 @method setInsets
 @abstract 添加上左下右边距
 @params insets
 @return NSArray //上左下右 constraints
 */
- (NSArray *)setInsets:(UIEdgeInsets)insets;

/*!
 @method setBottomInset
 @abstract 添加下边距
 @params inset
 @return NSLayoutConstraint
 */
- (NSLayoutConstraint *)setBottomInset:(CGFloat)inset;

/*!
 @method setTopInset
 @abstract 添加上边距
 @params inset
 @return NSLayoutConstraint
 */
- (NSLayoutConstraint *)setTopInset:(CGFloat)inset;

/*!
 @method setRightInset
 @abstract 添加右边距
 @params inset
 @return NSLayoutConstraint
 */
- (NSLayoutConstraint *)setRightInset:(CGFloat)inset;

/*!
 @method setLeftInset
 @abstract 添加左边距
 @params inset
 @return NSLayoutConstraint
 */
- (NSLayoutConstraint *)setLeftInset:(CGFloat)inset;

/*!
 @method setWidthConstraint
 @abstract 添加宽度固定约束
 @params width
 @return NSLayoutConstraint
 */
- (NSLayoutConstraint *)setWidthConstraint:(CGFloat)width;

/*!
 @method setHeightConstraint
 @abstract 添加高度固定约束
 @params height
 @return NSLayoutConstraint
 */
- (NSLayoutConstraint *)setHeightConstraint:(CGFloat)height;

/*!
 @method setEdge:(NSLayoutAttribute)attr1 toView:(UIView*)view edge:(NSLayoutAttribute)attr2 withOffset:(CGFloat)offset;
 @abstract 添加同级view与view之间边距约束
 @params attr1 自身边设定
 @params view 另一个view
 @params attr2 另一个view边设定
 @params offset 边之间的偏移
 @return NSLayoutConstraint
 */
- (NSLayoutConstraint *)setEdge:(NSLayoutAttribute)attr1
                         toView:(UIView*)view
                           edge:(NSLayoutAttribute)attr2
                     withOffset:(CGFloat)offset;

/*!
 @method setAspectRatio
 @abstract 添加宽比高固定约束
 @params ratio
 @return NSLayoutConstraint
 */
- (NSLayoutConstraint *)setAspectRatio:(CGFloat)ratio;

@end