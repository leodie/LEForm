//
//  PAOptionModel.h
//  haofang
//
//  Created by Hui Xu on 12/15/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

// 语法糖
#define PAOPTION(n, v) [[PAOptionModel alloc] initWithName:n value:v]

/**
 *  用于菜单或者单选视图的选项数据模型
 *  定义为protocol
 */
@protocol LEFormOptionProtocol <NSObject>

/**
 * 选项的显示名
 */
@property (nonatomic, strong, readonly) NSString *name;
/**
 * 选项中存储的值
 */
@property (nonatomic, strong, readonly) id value;

@end

/**
 *  用于菜单或者单选视图的选项数据模型
 */
@interface LEOptionModel : NSObject <LEFormOptionProtocol>

/**
 *  子选项
 */
@property (nonatomic, strong) NSMutableArray *subOptions;


- (instancetype)initWithName:(NSString *)name value:(id)value;

@end
