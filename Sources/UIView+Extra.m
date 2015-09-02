//
//  UIView+Extra.m
//  LEGears
//
//  Created by leo on 14-9-23.
//  Copyright (c) 2014年 LGear. All rights reserved.
//

#import "UIView+Extra.h"

@implementation UIView (Extra)

- (CGFloat)top
{
    return CGRectGetMinY(self.bounds);
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return CGRectGetMaxY(self.bounds);
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - CGRectGetHeight(self.bounds);
    self.frame = frame;
}

- (CGFloat)left
{
    return CGRectGetMinX(self.bounds);
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)right
{
    return CGRectGetMaxX(self.bounds);
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - CGRectGetWidth(self.bounds);
    self.frame = frame;
}

- (CGFloat)width
{
    return CGRectGetWidth(self.bounds);
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return CGRectGetHeight(self.bounds);
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (UIImage *)screenshot
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContext(CGSizeMake(CGRectGetWidth(self.bounds) * scale,
                                           CGRectGetHeight(self.bounds) * scale));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer drawInContext:ctx];
    
    UIImage *shot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return shot;
}

@end

@implementation UIView (Layout)

- (NSArray *)setInsets:(UIEdgeInsets)insets
{
    return @[[self setTopInset:insets.top],
             [self setLeftInset:insets.left],
             [self setBottomInset:insets.bottom],
             [self setRightInset:insets.right]];
}

- (NSLayoutConstraint *)setBottomInset:(CGFloat)inset
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self superview] attribute:NSLayoutAttributeBottom multiplier:0.0 constant:inset];
    [[self superview] addConstraint:c];
    return c;
}

- (NSLayoutConstraint *)setTopInset:(CGFloat)inset
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[self superview] attribute:NSLayoutAttributeTop multiplier:0.0 constant:inset];
    [[self superview] addConstraint:c];
    return c;}

- (NSLayoutConstraint *)setRightInset:(CGFloat)inset
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:[self superview] attribute:NSLayoutAttributeRight multiplier:0.0 constant:inset];
    [[self superview] addConstraint:c];
    return c;}

- (NSLayoutConstraint *)setLeftInset:(CGFloat)inset
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[self superview] attribute:NSLayoutAttributeLeft multiplier:0.0 constant:inset];
    [[self superview] addConstraint:c];
    return c;}

- (NSLayoutConstraint *)setWidthConstraint:(CGFloat)width
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:width];
    [self addConstraint:c];
    return c;
}

- (NSLayoutConstraint *)setHeightConstraint:(CGFloat)height
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:height];
    [self addConstraint:c];
    return c;
}

- (NSLayoutConstraint *)setEdge:(NSLayoutAttribute)attr1 toView:(UIView *)view edge:(NSLayoutAttribute)attr2 withOffset:(CGFloat)offset
{
//    self.translatesAutoresizingMaskIntoConstraints = NO;
//    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:attr1 relatedBy:NSLayoutRelationEqual toItem:view attribute:attr2 multiplier:1.0 constant:offset];
    [self.superview addConstraint:c];
    return c;
}

- (NSLayoutConstraint *)setAspectRatio:(CGFloat)ratio
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:ratio constant:0.0];
    [self.superview addConstraint:c];
    return c;
}

@end