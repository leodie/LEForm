//
//  NSString+ValidCheck.m
//  LEForm
//
//  Created by leo on 15/9/2.
//  Copyright (c) 2015年 LGear. All rights reserved.
//

#import "NSString+ValidCheck.h"

@implementation NSString (ValidCheck)

- (BOOL)validNumber
{
    if (self.length==0) {
        return NO;
    }
    NSString *pattern = @"^\\d+$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    
    return [regextestmobile evaluateWithObject:self];
}

@end
