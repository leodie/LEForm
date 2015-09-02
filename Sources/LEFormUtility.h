//
//  PAFormUtility.h
//  haofang
//
//  Created by leo on 14/11/12.
//  Copyright (c) 2014年 平安好房. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEForm.h"

/*!
 @class PAFormUtility
 @abstract 生成常用检查block
 */
@interface LEFormUtility : NSObject

// value checker generator

+ (BOOL(^)(id value))valueCheckerWithMinValue:(CGFloat)min maxValue:(CGFloat)max;
+ (BOOL(^)(id value))valueCheckerWithLength:(NSUInteger)length;
+ (BOOL(^)(id value))valueCheckerWithMaxInteger:(NSInteger)max;

// valid checker generator

+ (NSError *(^)(id value))validCheckerNilWithErrorDesc:(NSString *)errDesc;
+ (NSError *(^)(id value))validCheckerTextLengthMin:(NSUInteger)min max:(NSUInteger)max errorDesc:(NSString *)errDesc;

+ (NSError *(^)(id value))validCheckerMinValue:(CGFloat)min maxValue:(CGFloat)max errorDesc:(NSString *)errDesc;

+ (NSError *(^)(id value))validCheckerWithCountLimit:(NSUInteger) countLimit errorDesc:(NSString *)errDesc;

+ (NSError *(^)(id value))validCheckerWithMinimumCountLimit:(NSUInteger) countLimit errorDesc:(NSString *)errDesc;

+ (NSError *(^)(id value))validCheckerNonNilFields: (NSArray *)fields errorDescs: (NSArray *)errDescs;
// 判断文字不超过当前年份
+ (NSError *(^)(id value))validCheckerNotGreatThanCurrentYearWithErroDesc:(NSString *)errDesc;

// value trans
+ (id (^)(id value))valueTransOptionsWithHyphenString:(NSString *)hyphenString;

@end
