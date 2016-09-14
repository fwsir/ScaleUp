//
//  NSObject+Extension.m
//  ScaleUp
//
//  Created by BOOM on 16/9/12.
//  Copyright © 2016年 DEVIL. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>

@implementation NSObject (Extension)

+ (id)dictToModel:(NSDictionary *)dict
{
    // 创建调用对象
    id per = [self new];
    
    unsigned int outCount;
    Ivar *vars = class_copyIvarList([self class], &outCount);
    
    // 遍历数组
    for (id var in dict.allKeys)
    {
        NSString *name = [NSString stringWithFormat:@"_%@", var];
        for (int i = 0; i < outCount; ++i)
        {
            const char *varName = ivar_getName(vars[i]);
            NSString *runName = [NSString stringWithUTF8String:varName];
            if ([runName isEqualToString:name])
            {
                [per setValue:[dict valueForKey:var] forKey:name];
            }
        }
    }
    
    return per;
}

@end
