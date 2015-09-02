//
//  PAFormUtility.m
//  haofang
//
//  Created by leo on 14/11/12.
//  Copyright (c) 2014年 平安好房. All rights reserved.
//

#import "LEFormUtility.h"
#import "NSString+ValidCheck.h"
#import "LEOptionModel.h"

static NSString *ERR_DOMAIN = @"PAForm";

@implementation LEFormUtility

#pragma mark - value checkers

+ (BOOL(^)(id value))valueCheckerWithMinValue:(CGFloat)min maxValue:(CGFloat)max
{
    BOOL(^vc)(id value) = ^(id input) {
        if ([input isKindOfClass:[NSString class]] &&
            [(NSString *)input length] == 0) {
            return YES;
        }
        CGFloat value = [input floatValue];
        if (value <= max && value >= min) {
            return YES;
        } else {
            return NO;
        }
    };
    return vc;
}

+ (BOOL(^)(id value))valueCheckerWithLength:(NSUInteger)length
{
    BOOL(^vc)(id value) = ^(id input) {
        if ([input isKindOfClass:[NSString class]] &&
            [(NSString *)input length] <= length) {
            return YES;
        } else {
            return NO;
        }
    };
    return vc;
}

+ (BOOL (^)(id))valueCheckerWithMaxInteger:(NSInteger)max
{
    BOOL(^vc)(id value) = ^(id input) {
        if ([input isKindOfClass:[NSString class]]) {
            if ([input length] == 0 ||
                ([input validNumber] &&
                [input integerValue] <= max &&
                [input integerValue] > 0)) {
                return YES;
            }
            return NO;
        } else {
            return NO;
        }
    };
    return vc;
}

#pragma mark - valid checkers

+ (NSError *(^)(id))validCheckerNilWithErrorDesc:(NSString *)errDesc
{
    return ^(id value) {
        return (value == nil || ([value isKindOfClass:[NSString class]] && [value length] == 0)) ? [NSError errorWithDomain:ERR_DOMAIN code:0 userInfo:@{NSLocalizedDescriptionKey : errDesc}] : nil;
    };
}

+ (NSError *(^)(id))validCheckerTextLengthMin:(NSUInteger)min max:(NSUInteger)max errorDesc:(NSString *)errDesc
{
    return ^(id value) {
        NSString *text = (NSString *)value;
        NSUInteger length = [text length];
        return length > max || length < min ? [NSError errorWithDomain:ERR_DOMAIN code:0 userInfo:@{NSLocalizedDescriptionKey : errDesc}] : nil;
    };
}

+ (NSError *(^)(id))validCheckerMinValue:(CGFloat)min maxValue:(CGFloat)max errorDesc:(NSString *)errDesc
{
    return ^(id value) {
        if (value == nil || [value length] <= 0) {
            return [NSError errorWithDomain:ERR_DOMAIN code:0 userInfo:@{NSLocalizedDescriptionKey : errDesc}];
        }
        CGFloat fValue = [value floatValue];
        return fValue > max || fValue < min ? [NSError errorWithDomain:ERR_DOMAIN code:0 userInfo:@{NSLocalizedDescriptionKey : errDesc}] : nil;
    };
}

+ (NSError *(^)(id))validCheckerWithCountLimit:(NSUInteger)countLimit errorDesc:(NSString *)errDesc
{
    return ^(id value) {
        NSUInteger count = [value count];
        return count > countLimit ? [NSError errorWithDomain:ERR_DOMAIN code:0 userInfo:@{NSLocalizedDescriptionKey : errDesc}] : nil;
    };
}


+ (NSError *(^)(id value))validCheckerWithMinimumCountLimit:(NSUInteger) countLimit errorDesc:(NSString *)errDesc {
    return ^(id value) {
        NSUInteger count = [value count];
        return count < countLimit ? [NSError errorWithDomain:ERR_DOMAIN code:0 userInfo:@{NSLocalizedDescriptionKey : errDesc}] : nil;
    };
}


+ (NSError *(^)(id value))validCheckerNonNilFields: (NSArray *)fields errorDescs: (NSArray *)errDescs {
    return ^(id value) {
        NSMutableArray *nilArray = [NSMutableArray arrayWithCapacity:[fields count]];
        
        [fields enumerateObjectsUsingBlock:^(LEFormField *field, NSUInteger idx, BOOL *stop) {
            if (field.value == nil ||
                [field.value length] == 0 ||
                [field isKindOfClass:[NSNull class]]) {
                [nilArray addObject:errDescs[idx]];
            }
        }];
        NSUInteger nilCount = [nilArray count];
        if (nilCount < [fields count] &&
            nilCount > 0) {
            return [NSError errorWithDomain:ERR_DOMAIN code:0 userInfo:@{NSLocalizedDescriptionKey : [nilArray objectAtIndex:0]}];
        } else {
            return (NSError *)nil;
        }
    };
}

+ (NSError *(^)(id))validCheckerNotGreatThanCurrentYearWithErroDesc:(NSString *)errDesc
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy"];
    return ^(id value) {
        if (value == nil || ([value isKindOfClass:[NSString class]] && [value length] == 0)) {
            return [NSError errorWithDomain:ERR_DOMAIN code:0 userInfo:@{NSLocalizedDescriptionKey:errDesc}];
        }
        NSInteger yearNumber = [value integerValue];
        NSInteger currentYearNumber = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
        return yearNumber <= currentYearNumber ? nil : [NSError errorWithDomain:ERR_DOMAIN code:0 userInfo:@{NSLocalizedDescriptionKey:errDesc}];
    };
}

#pragma mark - value trans

+ (id (^)(id))valueTransOptionsWithHyphenString:(NSString *)hyphenString
{
    return ^(id value) {
        if ([value isKindOfClass:[NSArray class]]) {
            __block NSMutableString *tempStr = [NSMutableString string];
            [(NSArray *)value enumerateObjectsUsingBlock:^(NSObject<LEFormOptionProtocol> *obj, NSUInteger idx, BOOL *stop) {
                if ([obj conformsToProtocol:@protocol(LEFormOptionProtocol)]) {
                    [tempStr appendFormat:@"%@%@", [obj name], hyphenString];
                }
                if ([tempStr length] > 0 && [hyphenString length] > 0) {
                    [tempStr deleteCharactersInRange:NSMakeRange([tempStr length] - [hyphenString length], [hyphenString length])];
                }
            }];
            return [NSString stringWithString:tempStr];
        }
        return @"";
    };
}

@end
