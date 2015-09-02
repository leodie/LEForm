//
//  PAOptionModel.m
//  haofang
//
//  Created by Hui Xu on 12/15/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "LEOptionModel.h"


@interface LEOptionModel ()

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) id value;

@end

@implementation LEOptionModel

@synthesize name = _name;
@synthesize value = _value;

- (instancetype)init {
    if (self = [super init]) {
        [self internalInitialize];
    }
    
    return self;
}


- (instancetype) initWithName:(NSString *)name value:(id) value {
    if (self = [super init]) {
        self.name = name;
        self.value = value;
        [self internalInitialize];
    }
    return self;
}


- (void) internalInitialize {
    self.subOptions = [NSMutableArray array];
}

@end
